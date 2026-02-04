<p align="center">
  <img src="images/mate.png" alt="Logo" width="300"/>
</p>

# Mate - Object Graph Language

Mate is an object graph language implementation that allows you to define grammars representing software system structures and generate valid object instances from those grammars. It supports:

- **Type constraints** — Specify valid ranges for primitive types
- **Polymorphic types** — Use `|` operator for type alternatives
- **Reward-based learning** — It learns which type choices lead to better outcomes
- **Derivation trees** — Inspect generation structure before instantiation

## Getting Started

```Smalltalk
Metacello new
    baseline: 'Mate';
    repository: 'github://FedeLoch/Mate:main';
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
MatePersonGrammar >> initialize
    super initialize.
    
	self addTypeDeclaration: (MateInstDecl new type: Person; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'age'; type: Age 
	}).
	self addTypeDeclaration: (MateInstDecl new type: Age; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'value'; type: SmallInteger 
	}).
```

Generate instances:

```smalltalk
grammar := MatePersonGrammar new.
person := grammar gen: Person.

person age.  "=> 42 (random SmallInteger)"
```

### Polymorphic Types

Use `|` for type alternatives:

```smalltalk
MateInstVarDecl new 
    name: 'characterClass'; 
    type: (Warrior | Rogue | Mage).
```

### Constrained Values

Add constraints to limit generated values:

```smalltalk
MateInstanceVariableDeclaration new 
    name: 'level'; 
    type: SmallInteger; 
    constraint: (MateConstraint between: 0 and: 99).
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
MatePlayerGrammar >> initialize
    super initialize.
    
	self addTypeDeclaration: (MateInstDecl new type: Player; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'name'; type: String.
		MateInstVarDecl new name: 'characterClass'; type: (Warrior | Rogue | Mage).
		MateInstVarDecl new name: 'level'; type: SmallInteger; constraint: (MateConstraint between: 0 and: 99).
		MateInstVarDecl new name: 'missingExperienceForNextLevel'; type: SmallInteger; constraint: (MateConstraint greaterThan: 0).
	}).
```

```smalltalk
grammar := MatePlayerGrammar new.
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
MatePlayerGrammar >> initialize
    super initialize.
    
    self addTypeDeclaration: (MateInstDecl new type: BlElement; instanceVariableDeclarations: { 	
		MateInstVarDecl new name: 'children'; type: BlChildrenArray.
		MateInstVarDecl new name: 'visuals'; type: BlCustomVisuals.
		MateInstVarDecl new name: 'constraints'; type: BlLayoutCommonConstraints.
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlChildrenArray; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'array'; type: (MateArray of: BlElement); constraint: (MateArrayConstraint sizeBetween: 0 and: 30)
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlCustomVisuals; instanceVariableDeclarations:{
		MateInstVarDecl new name: 'background'; type: (BlPaintBackground | BlTransparentBackground).
		MateInstVarDecl new name: 'geometry'; type: (BlRectangleGeometry | BlEllipseGeometry | BlTriangleGeometry).
		MateInstVarDecl new name: 'clipChildren'; type: Boolean.
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlLayoutCommonConstraints; instanceVariableDeclarations: { 	
		MateInstVarDecl new name: 'position'; type: Point.
		MateInstVarDecl new name: 'vertical'; type: BlLayoutCommonConstraintsAxis.
		MateInstVarDecl new name: 'horizontal'; type: BlLayoutCommonConstraintsAxis.
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlLayoutCommonConstraintsAxis; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'resizer'; type: BlLayoutExactResizer.
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlLayoutExactResizer; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'size'; type: SmallInteger.
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlPaintBackground; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'paint'; type: Color.
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlTriangleGeometry; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'orientation'; constraint: (MateConstraint oneOf: { #top . #right . #left . #bottom }).
	}).
```


### Backpropagation

Propagate rewards through the derivation tree to improve future generations:

```smalltalk
grammar := MatePlayerGrammar new.
derivationTree := grammar gen: Player from: MateContext new.
player := derivationTree instantiate.

"After testing: propagate improvement score"
grammar backpropagate: derivationTree improvement: 0.8 from: MateContext new.
```
