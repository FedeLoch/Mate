# Expression invariants

A minimal, generic extension of `invariants:` that lets a grammar state relations between any parts of an object graph, not only between two numeric fields of the same object.

Motivation: the rules a Pharo AST must follow to compile relate different parts of the tree (see [ast-invariants.md](ast-invariants.md) for each rule and why the compiler needs it). Instead of one keyword per rule (`same:`, `declares:`, `resolves:`, conditionals), this design adds a single thing: **an expression language inside `invariants:`**, plus three generation strategies recognised from the shape of the expression.

## Today

```
Inv ::= FieldName ('<' | '<=' | '=' | '>=' | '>') FieldName
```

- `MateLanguageParser >> parseInvariant:` reads two identifiers and an operator into a `MateInvariant` (`>` and `>=` are normalised by swapping sides).
- `MateInvariant >> holdsFor:` reads both fields with `instVarNamed:` and compares numbers; it accepts the object when either side is `nil` or not a number is involved.
- Generation: `MateGenerator >> enforceInvariantsOf:on:from:` runs after the whole object is built; `enforce:of:on:from:` regenerates the two fields alternately up to `invariantAttempts` times, then repairs (`=` copies the left value to the right, `<=` swaps them).
- Validation: `MateParser` checks every invariant with `holdsFor:` and raises an error otherwise.

## The language

```
Invariant ::= Relation | Invariant '==>' Invariant
Relation  ::= Operand Rel Operand
Rel       ::= '=' | '<' | '<=' | '>' | '>=' | '==' | 'in'
Operand   ::= Term (',' Term)*                "',' joins collections"
Term      ::= Literal | '(' Operand ')' | Path
Path      ::= Step+
Step      ::= Name                            "a field, or a unary message"
            | '[' '.' Path ']'                "applied to every element of a collection"
            | 'ancestors'                     "the enclosing objects, innermost first"
Literal   ::= Number | String | Symbol | 'nil' | 'true' | 'false'
            | '#(' Literal* ')'               "a literal array"
            | '(' Number 'to:' Number ')'     "an interval"
```

### Paths

A path is a chain of names evaluated left to right on the object. Each name is a field when the current object's declaration has a field of that name, and a unary message otherwise (`size`, `numArgs`, `first`, `value`, …).

- `selector value numArgs`: field `selector`, then field `value` of the selector node, then the message `numArgs`.
- `arguments size`: field `arguments`, then `size`.
- `messages first receiver`: field `messages`, message `first`, field `receiver`.

`[ .path ]` keeps the syntax of `selfReferences:`: it applies the path to every element and answers the collection of results. `messages[ .receiver ]` answers the receivers of all messages.

`ancestors` answers the objects that enclose the current one in the graph, innermost first. Combined with `[ ]` it collects something from all of them: `ancestors[ .temporaries[ .name ] ]` answers the names of the temporaries declared by every enclosing object that has a `temporaries` field (objects without the field contribute nothing).

### Relations

| Relation | Holds when |
|---|---|
| `a = b`, `a < b`, `a <= b`, `a > b`, `a >= b` | the values compare (numbers with `<`, any objects with `=`) |
| `a == b` | `a` and `b` are the same object |
| `a in b` | `b includes: a` |
| `p ==> q` | `p` is false, or `q` holds |

When an operand answers several values through `[ ]`, the relation must hold for each of them: `messages[ .receiver ] == messages first receiver` means every receiver is that one.

### Compatibility

Every current invariant (`start <= stop`) is a relation between two one-step paths and keeps its meaning. The `nil` tolerance of `MateInvariant >> accepts:with:` (a missing value does not break an invariant) is kept for the comparison operators, so nullable fields keep working.

## Examples: the AST rules

```
OCMethodNode -> {
	selector: { oneOf: { #foo . #at:put: . #'+' } },
	arguments: { type: [ OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 3 },
	body: OCSequenceNode,
	…,
	invariants: { selector numArgs = arguments size }
}

OCMessageNode -> {
	receiver: …,
	selector: OCSelectorNode,
	arguments: { type: [ … ], collection: OrderedCollection, sizeBetween: 0 and: 3 },
	…,
	invariants: { selector value numArgs = arguments size }
}

OCCascadeNode -> {
	messages: { type: [ OCMessageNode ], collection: OrderedCollection, sizeBetween: 1 and: 5 },
	…,
	invariants: { messages[ .receiver ] == messages first receiver }
}

OCSequenceNode -> {
	temporaries: { type: [ OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 3 },
	statements: { type: [ … ], collection: OrderedCollection, sizeBetween: 0 and: 5 },
	…
}

OCVariableNode -> {
	name: ByteString,
	…,
	invariants: {
		name in ancestors[ .temporaries[ .name ] ] , ancestors[ .arguments[ .name ] ] , #( 'self' 'thisContext' 'Object' 'Smalltalk' ) }
}

OCAssignmentNode -> {
	variable: OCVariableNode,
	value: …,
	invariants: { variable name in ancestors[ .temporaries[ .name ] ] , #( 'Smalltalk' ) }
}

OCLiteralArrayNode -> {
	isByteArray: Boolean,
	contents: { type: [ OCLiteralValueNode ], … },
	…,
	invariants: { isByteArray ==> (contents[ .value ] in (0 to: 255)) }
}
```

Scopes come from `ancestors` itself: a block's arguments are only ancestors of the nodes inside the block, and the temporaries of a sibling sequence are never ancestors, so the visible names are exactly the ones in scope.

Note that `OCVariableNode` also appears where names are *declared* (temporaries and arguments). There, its `name` invariant would require the name to already exist. Two ways out, to decide during implementation: a separate declaration for declared names (an empty subclass such as `OCDeclaredVariableNode`, or an alias once aliases can carry invariants), or applying an invariant only to the objects reached through the fields that do not declare names.

## Generation

Each invariant is solved with one of four strategies, chosen from its shape. The first three always succeed when their target is admissible; the last one is today's mechanism.

| Shape | Strategy | When it runs |
|---|---|---|
| `X size = e`, `X` a collection field | **Derive**: build `X` with exactly `e` elements | when `X` is generated |
| `p in e`, `p` ending in a field | **Choose**: evaluate `e`, pick the value of `p` among its elements | when that field is generated |
| `p == e`, `p` ending in a field | **Assign**: after building the object, set that field to `e` | after the object is built, like `selfReferences` |
| anything else, `==>` included | **Retry**: regenerate the fields of the invariant, up to `invariantAttempts`, then fail | after the object is built, as today |

Details:

- **Order.** Fields are generated in declaration order, so the fields `e` depends on must be declared before the target: `selector` before `arguments`, `temporaries` before `statements`, method and block `arguments` before `body`. A grammar that breaks this order should be rejected when it is parsed, with a message that names both fields.
- **Derive** checks that `e` is within the collection's `sizeBetween:`. If it is not, it regenerates the fields `e` depends on (for arity: the selector), up to `invariantAttempts`.
- **Choose** evaluates `e` with the ancestors that exist at that moment. They are under construction, but their fields declared before the current one are built, which is exactly what the order rule guarantees. An empty set fails the generation, so the grammar should always offer a fallback (the literal pool).
- **Assign** is a repair that cannot fail; it is applied after the object and its fields are built. The objects it drops (the receivers generated for the other messages) are discarded.
- **Retry** generalises `enforce:of:on:from:` from two fields to all the fields an invariant reads. Today's repairs (`=` copies, `<=` swaps) stay as the last step for the old two-field invariants.
- **Derivation tree.** Derive and choose are ordinary generation choices, so they are recorded in the derivation and keep MCTS feedback working; assign records the shared object in the edge, like `selfReferences` does.

### Depth limit

At `maxDerivationHeight`, `MateGenerator >> sizeOf:from:` sets every collection of composite elements to 0, ignoring `sizeBetween:`. With derived sizes this breaks invariants (a `#at:put:` message with no arguments). The size has to be the derived one when there is one, and otherwise the smallest the declaration accepts. To still stop the recursion, choices that feed a derived size should prefer, at the depth limit, the values that need the fewest elements (a unary selector).

## Validation

`MateParser` evaluates each invariant on the instance being parsed and raises the same error as today when it does not hold. Paths are evaluated on the live object, so there is nothing to solve; `ancestors` uses the parsing context.

## Implementation plan

1. **AST of invariants.** New classes for the expression: path (steps: field-or-message, each, ancestors), literal, union (`,`), relation, implication. `MateInvariant` becomes the relation node; its `left`/`right` become operands. Keep `printOn:`, `=` and `hash` so grammars still print and compare (the writer must print expressions back, since `MateWriter` round-trips grammars).
2. **Parser.** Replace `MateLanguageParser >> parseInvariant:` by a small recursive-descent parser for the grammar above. Two-identifier invariants parse to the same objects as before.
3. **Evaluation.** `holdsFor: anObject in: aContext`: evaluates paths on the object; a step is a field when the object's declaration has it (`instVarNamed:`), a unary message otherwise. `ancestors` walks `context parentNode` (already set by `MateGenerator >> visitInstanceDeclaration:from:` and by `MateParser`), as `MateOGDerivationNode` already does.
4. **Validation.** Call the new `holdsFor:in:` where `MateParser` checks invariants today.
5. **Strategy detection.** When a declaration is created, classify each invariant (derive, choose, assign, retry) and index derive and choose by their target field, so the generator can look them up while generating that field. Check the declaration order there.
6. **Generation.** In `MateGenerator`:
   - `sizeOf:from:` asks for a derived size before choosing a random one, also at the depth limit;
   - generating a field asks for a choose invariant before choosing a value;
   - after the object is built, apply assign invariants, then run retry invariants through a generalised `enforce:of:on:from:`.
7. **Tests**, one per strategy, plus the AST ones: every generated `OCMethodNode` compiles (`OpalCompiler new ast: …; compileOrFail`), and `parse:` rejects an AST that breaks each invariant.

## Open questions

- Whether `super` must be restricted to receivers (not confirmed in the compiler sources; see `ast-invariants.md`). With this design it is one more `in` invariant on the receiver side, or simply leaving `super` out of the pools.
- How declared names are generated: from a pool (`oneOf:`) or by a new built-in identifier generator. Duplicates are accepted by the compiler (only a warning), so a pool is enough to start.
- Whether arity should prefer a mixed selector pool plus derive (this design), or separate pools per arity.
