# Plan: the invariants Mate needs for compilable ASTs

This plan comes from iterating on `MateASTGrammar` (the grammar in `grammars/ast-depth-15.mate` of the paper repository): generate 10 `OCMethodNode`, compile each with `OpalCompiler new ast: ast; compileOrFail`, group the failures by error and stack, and fix the most frequent group, first with the current language and only then with a language extension. It keeps only what the failures showed to be necessary; [ast-invariants.md](ast-invariants.md) lists every rule a compiler could check, and [expression-invariants.md](expression-invariants.md) a general design.

## Iterations

| # | Change | Compiles | Failures |
|---|---|---|---|
| 1 | Inferred grammar | 0 / 10 | 7 empty cascade (`OCCascadeNode >> receiver` → `messages first`), 3 byte array with non-byte contents (`ByteArray >> at:put:`, improper store) |
| 2 | Cascades `sizeBetween: 2 and: 104`; `isByteArray: { oneOf: { false } }` | 0 / 10 | 9 empty cascade, 1 invalid selector (`genSend:numArgs:` with `numArgs` = -1) |
| 3 | Generator: minimum size at the depth limit; pools of valid selectors | 4 / 10 | 4 arity mismatch (`stack underflow in bytecode generator`), 2 `ScaledDecimal` with `nil` scale |
| 4 | Every message and the method take exactly 1 argument; `ScaledDecimal` declared | **10 / 10** | none |
| 5 | Size invariants (`selector value numArgs = arguments size`, same for methods and pragmas) and selector shapes (`matching:` / `except:`) replace every workaround; messages and methods take 0 to 3 arguments | **10 / 10** | none |

Each iteration generated 10 ASTs of about 27,000 nodes, in 22 to 33 s each (compiling takes about 60 ms).

What the failures showed:

- Iteration 2: the empty cascades were all at the depth limit (6 or more AST levels), while every cascade above it respected `sizeBetween: 2`. The generator, not the grammar, produced them.
- Iteration 3: once selectors were valid, the number of arguments not matching the selector's arity broke compilation (`send:` pops as many values as the selector declares).
- No failure came from variable names, assignments to read-only variables, or the receivers of cascade messages in 40 generated ASTs. Compiling a given AST does not seem to stop on the notices of the semantic analysis (undeclared variables and the like are only notices). These rules matter for the AST to be meaningful, not for it to compile.

## Workarounds in the grammar (removed in iteration 5)

Each is marked `"TEMPORARY: …"` in the grammar and is removed by one of the items below.

| Workaround | Lost expressiveness | Removed by |
|---|---|---|
| `OCMessageNode arguments: { …, size: 1 }` | unary and multi-keyword messages | 1 |
| `OCSelectorNode value:` a pool of 1-argument selectors | any other selector | 1 and 2 |
| `OCMethodNode selector: { oneOf: { #fuzzed: } }` and `arguments: { …, size: 1 }` | methods with 0 or several arguments, other selectors | 1 and 2 |
| `OCPragmaNode selector:` a pool of unary pragmas | other pragmas, pragma arguments | 2 (and 1 for arguments) |
| `isByteArray: { oneOf: { false } }` | byte array literals `#[ … ]` | 4 (deferred) |

`ScaledDecimal` is declared in the grammar (`numerator`, `denominator`, `scale`); that is a correct definition, not a workaround.

## 1. Arity invariant (implemented: `MateSizeInvariant`)

**Evidence**: 4 of 10 failures in iteration 3, `stack underflow in bytecode generator`.

**Rule**: a selector takes as many arguments as it declares.

```
OCMessageNode -> { …, invariants: { selector value numArgs = arguments size } }
OCMethodNode  -> { …, invariants: { selector numArgs = arguments size } }
OCPragmaNode  -> { …, invariants: { selector numArgs = arguments size } }   "with an arguments field"
```

**Minimal implementation**: the *derive* strategy of `expression-invariants.md`, restricted to one shape, `Path = Field size`:

1. Language: in `MateLanguageParser >> parseInvariant:`, accept a path of unary messages on the left (`selector value numArgs`) and `field size` on the right. Keep the current two-field invariants as they are.
2. Model: a new invariant class (for example `MateSizeInvariant`) holding the path and the collection field; `holdsFor:` evaluates the path on the object (a step is a field when the declaration has one, a unary message otherwise) and compares it with the size.
3. Generation: when `MateGenerator` builds the collection field, `sizeOf:from:` uses the value of the path instead of a random size. Fields are generated in declaration order, so the grammar must declare `selector` before `arguments`; the parser rejects a grammar where it does not.
4. If the derived size is outside the field's `sizeBetween:`, regenerate the fields the path reads (the selector), up to `invariantAttempts`, then fail the generation as today.
5. At the depth limit, the derived size wins over the minimum size.
6. Validation: `MateParser` checks it like the current invariants.
7. Tests: a grammar with a mixed selector pool always produces matching argument counts; `parse:` rejects a message whose arguments do not match.

## 2. String shapes with a regular expression (implemented: `matching:`, `except:`, `MateRegexGenerator`)

**Evidence**: iteration 2, `genSend:numArgs:` with `numArgs` = -1: `Symbol >> numArgs` answers -1 when a random `ByteSymbol` is not a selector. The pools work, but they hardcode selectors.

**Rule**: a selector is unary (`foo`), binary (`+`, `->`) or keywords (`at:put:`). A selector does not need to exist, only to be well formed.

```
OCSelectorNode -> {
	value: { type: ByteSymbol, matching: '[a-zA-Z_][a-zA-Z0-9_]*|[-+*/\\<>=~@%|&?,]+|([a-zA-Z_][a-zA-Z0-9_]*:)+',
	         except: { #ifTrue: . #ifFalse: . #ifTrue:ifFalse: . #ifFalse:ifTrue: . #and: . #or: . #whileTrue: . #whileFalse: . #to:do: . #timesRepeat: . #ifNil: . #ifNotNil: } }
}
```

**Implementation**:

1. Language: a `matching: 'regex'` property for string and symbol types, and `except: { … }` for values to exclude (Pharo's regular expressions have no negative lookahead). Optionally `maxLength:` to bound `*` and `+`.
2. Generation: parse the pattern with `RxParser` and walk the resulting tree: an alternation chooses a branch, a sequence concatenates, a repetition chooses a count (bounded), a character set chooses a character. Record the choices in the derivation like any other, so MCTS feedback applies. Retry when the result is in `except:`.
3. Validation: `matchesRegex:` and not in `except:`.
4. With item 1, the generator chooses the selector first and derives the number of arguments; no arity-specific regex is needed.
5. `except:` matters because Opal inlines those selectors and then requires literal blocks as arguments.

## 3. Depth limit respects minimum sizes (implemented)

**Evidence**: iterations 1 and 2, empty cascades only at the depth limit.

`MateGenerator >> sizeOf:from:` returned 0 at `maxDerivationHeight` for collections of composite elements, ignoring `sizeBetween:`. It now returns `decl minSize` when the elements can be built with finitely many objects, and 0 otherwise (a type that always needs another instance of itself), and past the limit a union with built-in options takes one of them. A size derived from a size invariant wins over both.

## 4. Deferred

| Rule | Status |
|---|---|
| Byte arrays: when `isByteArray` is true, every element is an integer from 0 to 255 (a conditional invariant) | Avoided with `isByteArray: { oneOf: { false } }`; implement if byte array literals matter |
| Cascade messages share one receiver node | Not observed failing; only the first receiver is compiled |
| Variables declared before use; assignments only to writable variables | Not observed failing; matters for meaning, not for compiling |
| Pragma arguments, and pragmas that Opal interprets (`primitive:`) | Needs an `arguments` field and item 1 |

## Order

1. Commit item 3 (with a test: a collection with a minimum size keeps it at the depth limit).
2. Item 1, then remove the `size: 1` workarounds and use a pool of selectors of any arity.
3. Item 2, then replace the pools by the regular expression.
4. After each step, generate and compile again, and update the table of iterations.

Generating takes about 30 s per AST because the inferred sizes come from the largest methods in the image (`OCArrayNode statements` up to 1229, `OCSequenceNode statements` up to 178, `temporaries` up to 36). Lowering them makes each iteration much faster without changing what the grammar can express.
