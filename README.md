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
	Person -> { age: Age }.
	Age -> { value: SmallInteger }
```

```smalltalk
EnPersonGrammar >> initialize
    super initialize.
    
	self addTypeDeclaration: (EnInstDecl new type: Person; instanceVariableDeclarations: {
		EnInstVarDecl new name: 'age'; type: Age 
	}).
	self addTypeDeclaration: (EnInstDecl new type: Age; instanceVariableDeclarations: {
		EnInstVarDecl new name: 'value'; type: SmallInteger 
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
EnInstVarDecl new 
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

### Example 2: Player Grammar

```smalltalk
    Player -> {
			name: String,
			characterClass: Warrior | Rogue | Mage,
			level: { type: SmallInteger, between: 0 and: 99 },
			missingExperienceForNextLevel: { type: SmallInteger, greaterThan: 0 }
		}
```

```smalltalk
EnPlayerGrammar >> initialize
    super initialize.
    
	self addTypeDeclaration: (EnInstDecl new type: Player; instanceVariableDeclarations: {
		EnInstVarDecl new name: 'name'; type: String.
		EnInstVarDecl new name: 'characterClass'; type: (Warrior | Rogue | Mage).
		EnInstVarDecl new name: 'level'; type: SmallInteger; constraint: (EnConstraint between: 0 and: 99).
		EnInstVarDecl new name: 'missingExperienceForNextLevel'; type: SmallInteger; constraint: (EnConstraint greaterThan: 0).
	}).
```

```smalltalk
grammar := EnPlayerGrammar new.
player := grammar gen: Player.

player name.            "=> 'xyz123'"
player characterClass.  "=> a Warrior"
player level.           "=> 47 (always 0-99)"
```

### Example 3: Bloc Element Grammar

```smalltalk
	BlElement -> {
		children: BlElementArray,
		visuals: BlCustomVisuals,
		constraints: BlLayoutCommonConstraints
	}.
		
	BlElementArray -> { 
		array: { type: [ BlElement ], sizeBetween: 0 and: 30 }
	}.
		
	BlCustomVisuals -> { 
		background: (BlPaintBackground | BlTransparentBackground),
		geometry: (BlRectangleGeometry | BlElipseGeometry | BlTriangleGeometry),
		clipChildren: Boolean,
	}.
		
	BlLayoutCommonConstraints -> {
		position: Point,
		vertical: BlLayoutCommonConstraintsAxis,
		horizontal: BlLayoutCommonConstraintsAxis
	}.
		
	BlLayoutCommonConstraintsAxis -> {
		resizer: BlLayoutExactResizer
	}.
		
	BlLayoutExactResizer -> {
		size: SmallInteger
	}.
		
	BlPaintBackground -> {
		paint: Color
	}.
		
	BlTriangleGeometry -> {
		orientation: { oneOf: { #top . #right . #left . #bottom } }
	}
```

```smalltalk
EnPlayerGrammar >> initialize
    super initialize.
    
    self addTypeDeclaration: (EnInstDecl new type: BlElement; instanceVariableDeclarations: { 	
		EnInstVarDecl new name: 'children'; type: BlChildrenArray.
		EnInstVarDecl new name: 'visuals'; type: BlCustomVisuals.
		EnInstVarDecl new name: 'constraints'; type: BlLayoutCommonConstraints.
	}).
	
	self addTypeDeclaration: (EnInstDecl new type: BlChildrenArray; instanceVariableDeclarations: {
		EnInstVarDecl new name: 'array'; type: (EnArray of: BlElement); constraint: (EnArrayConstraint sizeBetween: 0 and: 30)
	}).
	
	self addTypeDeclaration: (EnInstDecl new type: BlCustomVisuals; instanceVariableDeclarations:{
		EnInstVarDecl new name: 'background:'; type: (BlPaintBackground | BlTransparentBackground).
		EnInstVarDecl new name: 'background:'; type: (BlRectangleGeometry | BlEllipseGeometry | BlTriangleGeometry).
		EnInstVarDecl new name: 'clipChildren:'; type: Boolean.
	}).
	
	self addTypeDeclaration: (EnInstDecl new type: BlLayoutCommonConstraints; instanceVariableDeclarations: { 	
		EnInstVarDecl new name: 'position'; type: Point.
		EnInstVarDecl new name: 'vertical'; type: BlLayoutCommonConstraintsAxis.
		EnInstVarDecl new name: 'horizontal'; type: BlLayoutCommonConstraintsAxis.
	}).
	
	self addTypeDeclaration: (EnInstDecl new type: BlLayoutCommonConstraintsAxis; instanceVariableDeclarations: {
		EnInstVarDecl new name: 'resizer'; type: BlLayoutExactResizer.
	}).
	
	self addTypeDeclaration: (EnInstDecl new type: BlLayoutExactResizer; instanceVariableDeclarations: {
		EnInstVarDecl new name: 'size'; type: SmallInteger.
	}).
	
	self addTypeDeclaration: (EnInstDecl new type: BlPaintBackground; instanceVariableDeclarations: {
		EnInstVarDecl new name: 'paint'; type: Color.
	}).
	
	self addTypeDeclaration: (EnInstDecl new type: BlTriangleGeometry; instanceVariableDeclarations: {
		EnInstVarDecl new name: 'orientation:'; constraint: (EnConstraint oneOf: { #top . #right . #left . #bottom }).
	}).
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
