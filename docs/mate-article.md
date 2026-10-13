# Mate in 10 Minutes: Object Graph Grammars for Pharo

Most fuzzers generate bytes or strings. Pharo programs, however, work with **objects**: a `BlElement` with children that point back to their parent, a `Player` whose level must stay between 0 and 99, a model where some fields may be `nil` and others never are.

**Mate** is a small language and toolkit for describing those object graphs. From one description you can:

- **generate** valid objects, as many as you want, for testing and fuzzing;
- **guide** generation with feedback, so it explores the shapes that matter;
- **validate** existing objects against the description;
- **infer** a description from real objects or from your test suite;
- **visualize** how generation explored the grammar.

This guide walks through each use with small examples.

---

## 1. Installing

```smalltalk
Metacello new
    baseline: 'Mate';
    repository: 'github://FedeLoch/Mate:main';
    onConflictUseIncoming;
    load.
```

This loads the `Mate` package. The paper experiments, together with Moose and Ume, live in a separate group:

```smalltalk
Metacello new
    baseline: 'Mate';
    repository: 'github://FedeLoch/Mate:main';
    onConflictUseIncoming;
    load: 'experiments'.
```

---

## 2. Your first grammar

Suppose we have a small game model:

```smalltalk
Object << #Player
    slots: { #name . #characterClass . #level . #missingExperienceForNextLevel };
    package: 'MyGame'.
```

`characterClass` holds a `Warrior`, a `Rogue` or a `Mage`.

A Mate grammar says which classes each field may hold and which values are acceptable:

```smalltalk
Player -> {
  name: ByteString,
  characterClass: Warrior | Rogue | Mage,
  level: { type: SmallInteger, between: 0 and: 99 },
  missingExperienceForNextLevel: { type: SmallInteger, greaterThan: 0 }
}
```

Read it as: *a `Player` has a `name` that is a string, a `characterClass` that is one of three classes, a `level` from 0 to 99, and a strictly positive amount of missing experience.*

To use it, subclass `MateOGGrammar` and return the description from `defineObjectGraph`:

```smalltalk
MateOGGrammar << #PlayerGrammar
    package: 'MyGame'.

PlayerGrammar >> defineObjectGraph [
    ^ 'Player -> {
        name: ByteString,
        characterClass: Warrior | Rogue | Mage,
        level: { type: SmallInteger, between: 0 and: 99 },
        missingExperienceForNextLevel: { type: SmallInteger, greaterThan: 0 }
    }'
]
```

You can also load a grammar from a file:

```smalltalk
grammar := MateOGGrammar fromFile: 'player.mate'.
```

---

## 3. Generating objects

```smalltalk
grammar := PlayerGrammar new.
player := grammar gen: Player.

player level.           "=> always between 0 and 99"
player characterClass.  "=> a Warrior, a Rogue or a Mage"
```

Need a hundred?

```smalltalk
players := (1 to: 100) collect: [ :i | grammar gen: Player ].
```

### Values built for finding bugs

Mate does not pick values uniformly. It favours the values that tend to break code:

| Type | What you get |
| --- | --- |
| Integers | 0, ±1, powers of two, 32 and 64-bit limits, `SmallInteger minVal` / `maxVal`, the edges of your constraints, plus small and random values |
| Floats | 0.0, -0.0, ±1.0, tiny and huge values, NaN and ±infinity when the declared type is `Float`, and the edges of your constraints |
| Strings | empty, short, very long, punctuation, control bytes, and Unicode for `WideString` |

Constraints are always respected: a `level` declared `between: 0 and: 99` will be 0, 1, 98, 99 and everything in between, but never 100.

### Reproducible runs

When a generated object crashes your code, you want to get it back. Give the grammar a seed:

```smalltalk
grammar := PlayerGrammar new.
grammar seed: 1234.
players := (1 to: 100) collect: [ :i | grammar gen: Player ].
```

The same seed produces the same sequence of objects.

---

## 4. The language at a glance

Here is a grammar for a hypothetical shop model that uses most of the language:

```smalltalk
"Comments go between double quotes"
Shop -> {
  name: ByteString,
  rating: { type: Float, between: 0.0 and: 5.0 },
  stock: { type: SmallInteger, atLeast: 0 },
  status: { oneOf: { #open . #closed . #moved } },
  website: ByteString?,
  logo: (PNGImage | JPEGImage)?,
  products: { type: [ Product ], sizeBetween: 0 and: 20 },
  owner: { refType: Person },
  selfReferences: { products[ .shop ] }
}
```

| You write | It means |
| --- | --- |
| `A \| B` | the field holds an `A` or a `B` |
| `T?` | the field may also be `nil` |
| `between: a and: b`, `atLeast:`, `atMost:` | numeric bounds, inclusive |
| `greaterThan:`, `lessThan:` | numeric bounds, exclusive |
| `in: [ 200, 404, 500 ]` | the value is one of these literals |
| `oneOf: { #open . #closed }` | the value is one of these literals (symbols, strings, numbers, booleans, `nil` or classes) |
| `{ type: [ T ], sizeBetween: a and: b }` | an `Array` of `T`, with a size range (`size: n` for an exact size, 0 to 10 by default) |
| `refType: T` | a back-pointer, filled in by `selfReferences` instead of being generated |
| `selfReferences: { products[ .shop ] }` | after building a `Shop`, set the `shop` field of each of its products to that shop |
| `X class` | the class object itself (a metaclass type) |

### Relationships between objects

Real object graphs are not trees. In Bloc, every child points back to its parent:

```smalltalk
BlElement -> {
  children: BlChildrenArray,
  parent: { refType: BlElement },
  visuals: BlCustomVisuals | BlDefaultVisuals,
  constraints: BlLayoutCommonConstraints,
  selfReferences: { children.array[ .parent ] }
}

BlChildrenArray -> {
  array: { type: [ BlElement ], sizeBetween: 0 and: 10 }
}
```

`children.array[ .parent ]` reads: *follow `children`, then `array`, and for each element set its `parent` to me.* Every generated element tree is therefore consistent: `child parent == element` holds for every child.

### Recursion

Grammars can be recursive (`BlElement` contains `BlElement`s). Generation stops at a maximum depth (12 by default). At that depth, a field takes a simple value if its type allows one, and `nil` otherwise. You can tune this and how often nullable fields are `nil`:

```smalltalk
grammar generator
    maxDerivationHeight: 6;
    nilProbability: 0.2.
```

---

## 5. Guided fuzzing: teaching the grammar what is interesting

Random generation finds shallow bugs. To go deeper, tell Mate which objects were *interesting*: they reached new code, were slow, or produced a bigger difference in the output. Mate keeps a reward for every choice it made while building that object (which union option, which value, which size) and favours the choices that paid off, while still exploring the rest. Under the hood this is the UCT formula from Monte Carlo Tree Search.

```smalltalk
grammar := PlayerGrammar new.
grammar seed: 42.

1 to: 1000 do: [ :i |
    | player score |
    player := grammar gen: Player.
    score := self newCoverageReachedBy: player.
    grammar backPropagate: score from: player ].
```

`backPropagate:from:` takes a generated object, works out its derivation, and rewards every choice in it. If you already have the derivation tree, use `backpropagate:improvement:` directly:

```smalltalk
derivation := grammar gen: Player from: MateContext new.
player := derivation instance.
grammar backpropagate: derivation improvement: 42.
```

### Mutating part of an object

Sometimes you want to keep an object and regenerate only one part of it. Take a node of the derivation tree, generate a variant, and swap it in. References such as `parent` are kept consistent:

```smalltalk
derivation := grammar gen: BlElement from: MateContext new.
node := derivation edges at: 'children'.

variant := grammar genVariant: node.
grammar replace: node by: variant.
```

### How much of the grammar did we explore?

```smalltalk
grammar explorationPercentage.            "=> fraction of the grammar visited so far"
grammar explorationPercentageFrom: Player. "=> the same, counting only what is reachable from Player"
```

---

## 6. Validating objects

The same grammar can check objects that come from anywhere: your application, a file, a test.

```smalltalk
grammar := PlayerGrammar new.

grammar parse: (Player new
    name: 'Fede';
    level: 42;
    characterClass: Rogue new;
    missingExperienceForNextLevel: 1).
"=> a derivation tree: the object is valid"

grammar parse: (Player new
    name: 'Fede';
    level: 500;
    characterClass: Rogue new;
    missingExperienceForNextLevel: 1).
"=> Error: Value 500 of type SmallInteger violates MateConstraint( min: 0 max: 99)"
```

`parse:` checks field types (subclasses are accepted), array sizes, value constraints and `selfReferences`. It never modifies the object, and it handles cyclic graphs.

This makes Mate useful as an **oracle** too: generate objects, run an operation on them, and check that the result still matches the grammar.

---

## 7. Inferring a grammar from real objects

Writing a grammar by hand is not always practical. Mate can infer one from objects you already have:

```smalltalk
grammar := MateOGGrammar fromObjects: { player1 . player2 . player3 }.
grammar mateDefinition.
```

```smalltalk
Player -> {
	name: ByteString,
	characterClass: Mage | Rogue | Warrior,
	level: SmallInteger,
	missingExperienceForNextLevel: SmallInteger
}
```

Mate merges what it sees across all instances: field types become unions, arrays get the element types and size ranges observed, booleans become `Boolean`, and fields that hold classes become `oneOf` choices.

You can also infer a grammar from the objects your **test suite** builds:

```smalltalk
grammar := MateOGGrammar fromTest: PlayerTest.
```

Every test is set up and run, and the objects held in its instance variables, plus its return value, are fed to the inference. Failing tests are skipped.

Inferred grammars are a starting point: they know the *types* but not yet the *constraints* (ranges, relationships). Edit the output of `mateDefinition`, which can be parsed back with no changes, and turn it into your hand-written grammar.

---

## 8. Seeing what happened

Mate uses Roassal to draw two things.

**A derivation tree**: how one object was built, with every choice made.

```smalltalk
(PlayerGrammar new gen: Player from: MateContext new) render.
```

**The grammar as a heat map**: which declarations and options were visited most during generation.

```smalltalk
grammar := MateBlocGrammar new.
100 timesRepeat: [ grammar gen: BlElement ].
grammar render.
```

---

## 9. Cheat sheet

| I want to... | Code |
| --- | --- |
| generate one object | `grammar gen: Player` |
| generate reproducibly | `grammar seed: 42` |
| get the derivation tree too | `grammar gen: Player from: MateContext new` |
| reward an interesting object | `grammar backPropagate: score from: player` |
| regenerate part of an object | `grammar replace: node by: (grammar genVariant: node)` |
| check an object | `grammar parse: anObject` |
| infer a grammar | `MateOGGrammar fromObjects: objects` or `MateOGGrammar fromTest: aTestClass` |
| print a grammar | `grammar mateDefinition` |
| load a grammar from a file | `MateOGGrammar fromFile: 'grammar.mate'` |
| measure exploration | `grammar explorationPercentageFrom: Player` |
| visualize | `derivation render`, `grammar render` |
| limit recursion | `grammar generator maxDerivationHeight: 6` |

---

## 10. Good to know

- **Objects are built field by field.** Mate creates the object with `new` and sets each field directly. For classes whose fields must agree with each other (internal caches, collection internals), describe them with a grammar at the right level, or check the generated objects with `parse:` and your own sanity checks.
- **Inference only knows what it saw.** If no sample player was a `Mage`, the inferred grammar will not mention `Mage`. Feed it varied objects.
- **Unknown classes still work.** A field whose class has no declaration is generated as an empty instance of that class.

---

Learn more in the [repository](https://github.com/FedeLoch/Mate) and the other pages of this wiki.
