# En - Object Graph Language

En is an object graph language implementation that allows you to define grammars representing software system structures and generate valid object instances from those grammars. It supports:

- **Type constraints** — Specify valid ranges for primitive types
- **Polymorphic types** — Use `|` operator for type alternatives
- **Reward-based learning** — It learns which type choices lead to better outcomes
- **Derivation trees** — Inspect generation structure before instantiation

## Getting Started

```Smalltalk
Metacello new
    baseline: 'En';
    repository: 'github://FedeLoch/En:main';
    onConflictUseIncoming;
    load.
```

## Examples

Define a `Person` with an `Age`:

```smalltalk
EnPersonGrammar >> initialize
    super initialize.
    
    self addTypeDeclaration: (EnInstanceDeclaration new 
        type: Person; 
        instanceVariableDeclarations: {
            EnInstanceVariableDeclaration new name: 'age'; type: Age 
        }).
    
    self addTypeDeclaration: (EnInstanceDeclaration new 
        type: Age; 
        instanceVariableDeclarations: {
            EnInstanceVariableDeclaration new name: 'value'; type: SmallInteger 
        }).
```

Generate instances:

```smalltalk
grammar := EnPersonGrammar new.
person := grammar gen: Person.

person age.  "=> 42 (random SmallInteger)"
```

### Polymorphic Types

Use `|` for type alternatives:

```smalltalk
EnInstanceVariableDeclaration new 
    name: 'characterClass'; 
    type: (Warrior | Rogue | Mage).
```

### Constrained Values

Add constraints to limit generated values:

```smalltalk
EnInstanceVariableDeclaration new 
    name: 'level'; 
    type: SmallInteger; 
    constraint: (EnConstraint between: 0 and: 99).
```

### Full Example: Player Grammar

```smalltalk
EnPlayerGrammar >> initialize
    super initialize.
    
    self addTypeDeclaration: (EnInstanceDeclaration new 
        type: Player; 
        instanceVariableDeclarations: {
            EnInstanceVariableDeclaration new name: 'name'; type: String.
            EnInstanceVariableDeclaration new name: 'characterClass'; type: (Warrior | Rogue | Mage).
            EnInstanceVariableDeclaration new name: 'level'; type: SmallInteger; 
                constraint: (EnConstraint between: 0 and: 99).
            EnInstanceVariableDeclaration new name: 'missingExperienceForNextLevel'; type: SmallInteger; 
                constraint: (EnConstraint greaterThan: 0).
        }).
```

```smalltalk
grammar := EnPlayerGrammar new.
player := grammar gen: Player.

player name.            "=> 'xyz123'"
player characterClass.  "=> a Warrior"
player level.           "=> 47 (always 0-99)"
```

### Backpropagation

Propagate rewards through the derivation tree to improve future generations:

```smalltalk
grammar := EnPlayerGrammar new.
derivationTree := grammar gen: Player from: EnContext new.
player := derivationTree instantiate.

"After testing: propagate improvement score"
grammar backpropagate: derivationTree improvement: 0.8 from: EnContext new.
```
