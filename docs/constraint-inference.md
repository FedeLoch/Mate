# Inferring Mate Constraints and Relationships from Instances

Status: phases 1, 2, 3, 4 (except dictionaries) and 5 of the plan in section 8 are implemented in `MateGrammarInferrer`, `MateObserver`, `MateFieldProfile`, `MateInferenceFinding` and `MateInvariant`. Not implemented yet: string shapes, divisibility, conditional nullness, type correlations, linear equalities, ownership as a grammar construct (sharing is only reported), dictionaries, numeric confidence scores, held-out validation and incremental change reports.

## 1. Where we are

`MateOGGrammar fromObjects:` walks each instance and records, per class:

- one declaration per non-nil instance variable, with its observed class (unions are built across instances);
- arrays (`Array` only) with a merged element type and a `0..maxObservedSize` size range;
- class-valued fields as `oneOf` choices.

What it cannot express today:

| Gap | Consequence |
| --- | --- |
| `nil` fields are skipped | Nullability is lost; a field that is sometimes `nil` looks mandatory |
| No value statistics | No ranges, enumerations, string shapes or size distributions |
| No relationship analysis | Back-pointers (`child.parent == self`) are inferred as plain fields, so generated graphs break them and the generator only terminates thanks to the depth limit |
| Collections other than `Array` are treated as plain objects | `OrderedCollection`, `Dictionary` and `Set` are rebuilt from their private slots (`firstIndex`, `tally`, hash buckets), so generated instances violate their internal invariants |
| One global `seen` set | Shared objects and aliasing are invisible; a shared object is described once and then generated as many independent copies |
| Merge is the only operation | Every observation widens the grammar, nothing ever narrows it, and there is no measure of how sure we are |

## 2. Proposed architecture

Separate observing from deciding.

```
instances ──► Observer ──► Evidence store ──► Inferrers ──► Candidate constraints ──► Selector ──► MateOGGrammar
                (walk)       (profiles +        (one per      (with support and          (thresholds,
                              object graph)      family)       confidence)                review)
```

1. **Observer** walks the instances once, by identity, and records two things:
   - **Field profiles**, one per `(class, field)`: count, nil count, observed classes, numeric min/max/sum, distinct values (capped), string lengths and character classes, collection sizes, element classes.
   - **The object graph**: every object gets a node id; every field and collection slot becomes an edge `(source, label, target)`. This is what makes relationship inference possible after the walk.
2. **Inferrers**, one per constraint family (section 3), propose candidate constraints from the evidence. They follow the Daikon approach: instantiate templates, discard every candidate falsified by an observation, keep the survivors.
3. **Selector** turns survivors into grammar constructs only when they are justified (section 5), and attaches a confidence to each one so the writer can print, hide or comment them.
4. **Incremental mode**: new instances update the evidence; a falsified constraint is widened (ranges) or dropped (equalities, enumerations), and the change is reported so the user sees how the grammar moved.

Suggested classes: `MateObserver`, `MateFieldProfile`, `MateObjectGraph`, `MateInferrer` (with one subclass per family), `MateConstraintCandidate`, `MateGrammarInferrer` (the facade):

```smalltalk
grammar := MateGrammarInferrer new
	observeAll: instances;
	minimumSupport: 30;
	confidence: 0.95;
	grammar.
```

The existing `fromObjects:` stays as the "types only" inferrer, so current tests keep working.

## 3. What we can infer

### 3.1 Single field (unary)

| Constraint | Evidence | Grammar |
| --- | --- | --- |
| Type / union | observed classes | `A \| B` (exists) |
| Nullability | nil count > 0 | `T?` (exists) |
| Mandatory | nil count = 0 with enough support | plain `T` |
| Numeric range | min / max | `between:and:`, `atLeast:` (exists) |
| Sign | all ≥ 0, all > 0 | `atLeast: 0`, `greaterThan: 0` |
| Integrality of floats, finiteness | all values integral / finite | new: `integral`, `finite` |
| Step / divisibility | gcd of observed values | new: `multipleOf: n` |
| Enumeration | few distinct values seen many times | `oneOf:` / `in:` (exists) |
| Constant | a single value | `oneOf: { v }` |
| Shared singleton | always the identical object (e.g. `BlNullSpaceReference uniqueInstance`) | new: `{ sameAs: <expression> }` |
| String shape | length range, character classes, common prefix/suffix | new: `length:`, `charset:`, `matching:` |
| Collection size | size range, never empty | `sizeBetween:and:` (exists), new: `nonEmpty` |
| Collection elements | element classes, no nils, all distinct, sorted | union element type (exists), new: `unique`, `sorted` |
| Frequency | how often each union option or `oneOf` value appears | initial MCTS rewards (priors), not a hard constraint |

### 3.2 Several fields of the same object

Templates over pairs (and a few triples) of fields of the same class:

| Constraint | Example |
| --- | --- |
| Order | `firstIndex <= lastIndex + 1`, `min <= max` |
| Linear equality | `size = lastIndex - firstIndex + 1`, `total = price * quantity` (only small coefficient search) |
| Equality / identity | `a = b`, `a == b` |
| Conditional nullness | `x isNil ⇒ y isNil`, exactly one of `x`, `y` is set |
| Type correlation | `kind = #circle ⇒ radius notNil`, `shape isKindOf: BlRectangle ⇒ cornerRadii notNil` |
| Collection to scalar | `count = items size` |

Grammar extension: an object-level `invariants:` section, for example `invariants: { firstIndex <= (lastIndex + 1) }`.

### 3.3 Relationships between objects

All of these come from the object graph:

| Relationship | How to detect it | Grammar |
| --- | --- | --- |
| Back-reference | for every object `o` and path `p` up to length 3, check `o.p == o`; keep the paths that always hold | `selfReferences: { children.array[ .parent ] }` (exists) plus `refType` on the closing field |
| Inverse pair | `a.f == b` always implies `b.g == a` (1-1) or `b.g includes: a` (1-n) | `selfReferences`, new `inverseOf:` |
| Ownership vs sharing | in-degree of each object per incoming label: always 1 means owned (a tree), more than 1 means shared (a DAG) | new: `owned` / `shared` |
| Aliasing inside an object | `o.a == o.b.c` | new `sameAs:` path constraint |
| Recursion shape | for recursive fields, the length of the chain until `nil`, and whether a cycle was ever seen | depth hint for the generator, `acyclic` |
| Cardinality | sizes of 1-n relations | `sizeBetween:and:` on the relation |
| Containment | every element of `a.items` is also in `b.items` | new: `subsetOf:` |
| Global keys | a field is unique across all instances of a class (ids) | new: `unique` at class level |

Detecting back-references is the most valuable item: it turns inferred Bloc grammars into the same shape as the hand-written `MateBlocGrammar`, and it is cheap because paths are short.

### 3.4 Collections and other encapsulated classes

Describing `OrderedCollection` or `Dictionary` through their slots is the wrong abstraction. Instead:

- Keep a registry of "abstract" classes that are observed through their public protocol (`do:`, `size`, `keysAndValuesDo:`) and generated through it (`withAll:`, `at:put:`).
- Infer element types, key and value types, size ranges, uniqueness and order on the abstract view.
- Fall back to slots only for classes not in the registry.

This also fixes the "generated objects violate internal invariants" problem from the first analysis.

## 4. What we cannot infer (or not reliably)

1. **Accidental truths.** A constraint that holds on every sample is not necessarily an invariant: if every test player is level 42, the inferrer will propose `level = 42`. Only more varied data or a human can tell an essential constraint from an accidental one. Confidence scores reduce this risk but do not remove it.
2. **What was never observed.** A union option that never appears, a field that can be `nil` but never was, a subclass that is never instantiated, a collection that can be empty but never was: none of these can be inferred. Inference always under-approximates the valid space.
3. **Constraints defined by behavior.** Caches that must match computed values (`boundsCache` vs `bounds`), hashed collections whose layout depends on `hash`, objects that are valid only after a particular method was called, state machines: snapshots do not show them. They need execution traces or the class's own validation methods.
4. **Arbitrary functions.** Checksums, hashes, encodings, "this string is valid Smalltalk", or a regular expression that is valid: template search cannot find them, and the search space for general formulas is too large.
5. **Unbounded properties.** "This linked list is sorted" or "this graph is acyclic" for any length can only be checked on what was observed, and generalized as a hypothesis.
6. **External state.** Objects that wrap files, sockets, processes, time, or globals (`Smalltalk`, singletons) are not reproducible values. The best we can do is detect them (identity shared with a global) and mark them as `sameAs:` or exclude them.
7. **Rare events with few samples.** With `n` instances, a value that occurs with probability below about `1/n` will usually be missed, and observed ranges are narrower than the real ones.
8. **Identity vs equality.** Two equal strings may or may not be the same object in the real system; snapshots taken after interning or copying can mislead aliasing inference.

## 5. Deciding which candidates to keep

- **Minimum support**: a candidate needs at least `k` observations where it was not trivially true (for example `x isNil ⇒ y isNil` needs observations where `x` is nil).
- **Chance test** (as in Daikon): keep a candidate only if the probability of seeing it by chance is below a threshold. For example an enumeration with `d` distinct values seen in `n` observations is justified when `n` is much larger than `d`.
- **Generalize ranges** that have little support: widen to the next power of two or keep only the sign.
- **Held-out validation**: split the instances, infer on one part, and drop constraints that reject instances from the other part.
- **Confidence on every constraint**, so the writer can show high-confidence constraints as code and low-confidence ones as suggestions for review.

## 6. Effects on generation

Not every constraint is equally easy to satisfy when generating:

| Kind | Strategy |
| --- | --- |
| Ranges, enumerations, sizes, nullability, string length | constructive (already supported or easy) |
| Back-references, inverses, `sameAs:` | constructive after the object is built (the `selfReferences` mechanism) |
| Order and linear relations between fields | generate fields in dependency order and derive the dependent one, or repair |
| Uniqueness, sortedness | generate then sort or deduplicate |
| Abstract collections | generate through the public protocol |
| Complex conditionals | generate and filter with a retry budget; report the rejection rate |

## 7. Evaluation

We already have ground truth: the hand-written grammars `MateBlocGrammar` and `MatePlayerGrammar`.

1. Infer from real Bloc and Player instances, compare with the hand-written grammars, and measure precision and recall per constraint family.
2. Generate from the inferred grammar and measure how often the objects are valid (`parse:` against the hand-written grammar, plus the class's own sanity checks).
3. Measure how the grammar changes as the number of instances grows (stability).

## 8. Implementation plan

1. Observer, field profiles and object graph, with tests on Player and Bloc instances. Record nils.
2. Unary inferrers (section 3.1) and the selector; writer prints confidence.
3. Relationship inferrer for back-references and ownership (section 3.3), validated against `MateBlocGrammar`.
4. Abstract collections (section 3.4).
5. Multi-field invariants (section 3.2), the `invariants:` syntax, and generation support.
6. Incremental mode and change reports.

## 9. Open questions

1. Should inferred constraints be hard (generation never violates them) or soft (generation sometimes violates them on purpose, which is useful for fuzzing robustness)?
2. How should the user review low-confidence constraints: comments in the written grammar, a separate report, or an interactive inspector?
3. Which classes should be in the abstract-collection registry by default?
4. Do we want to use behavior (calling the class's own validation or accessors) when it exists, accepting the risk of side effects?
