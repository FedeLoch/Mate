Class {
	#name : 'MateBlocCompleteWithoutConstraintsGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateBlocCompleteWithoutConstraintsGrammar >> defineObjectGraph [

	^ 'BlAnnulusSectorGeometry -> {
	extent: Point,
	startAngle: SmallInteger,
	endAngle: SmallInteger,
	innerRadius: SmallFloat64,
	outerRadius: SmallFloat64
}

BlBorder -> {
	paint: BlColorPaint,
	style: BlStrokeStyle,
	width: SmallInteger,
	opacity: SmallFloat64
}

BlStrokeStyle -> {
	lineCap: BlStrokeLineButtCap,
	lineJoin: BlStrokeLineMiterJoin,
	miterLimit: SmallFloat64,
	dashArray: { type: [ SmallFloat64 ], sizeBetween: 0 and: 1 },
	dashOffset: SmallInteger
}

BlBoundsCache -> {
	boundsInLocal: BlCachedBounds?,
	element: { refType: BlElement }
}

BlCachedBounds -> {
	left: OptionalCustomNumber,
	top: OptionalCustomNumber,
	right: OptionalCustomNumber,
	bottom: OptionalCustomNumber,
	isValid: Boolean
}

BlChildrenArray -> {
	array: { type: [ BlElement ], sizeBetween: 0 and: 10 }
}

BlCircleGeometry -> {
	extent: Point,
	radius: OptionalCustomNumber,
	origin: Point
}

BlCompositeSelection -> {
	selections: BlSelectionTree
}

BlCustomVisuals -> {
	geometry: (BlAnnulusSectorGeometry | BlCircleGeometry | BlRectangleGeometry),
	border: BlBorder,
	background: (BlPaintBackground | BlTransparentBackground),
	clipChildren: Boolean
}

BlPaintBackground -> {
	paint: BlColorPaint
}

BlColorPaint -> {
	color: Color
}

BlElement -> {
	parent: { refType: BlElement },
	children: BlChildrenArray,
	bounds: BlElementLocalBounds,
	measuredBounds: BlElementLocalBounds,
	boundsCache: BlBoundsCache,
	eventDispatcher: BlElementEventDispatcher,
	constraints: BlLayoutCommonConstraints,
	layout: BlBasicLayout,
	transformation: BlElementCachedExplicitTransformation | BlElementCachedIdentityTransformation,
	taskQueue: BlTaskQueue,
	visuals: BlCustomVisuals | BlDefaultVisuals,
	flags: BlElementFlags,
	selfReferences: { boundsCache.element, bounds.referenceElement, measuredBounds.referenceElement, eventDispatcher.owner, children.array[ .parent ] }
}

BlTextElement -> {
	parent: { refType: BlElement },
	children: BlChildrenArray,
	bounds: BlElementLocalBounds,
	measuredBounds: BlElementLocalBounds,
	boundsCache: BlBoundsCache,
	eventDispatcher: BlElementEventDispatcher,
	constraints: BlLayoutCommonConstraints,
	layout: BlBasicLayout,
	transformation: BlElementCachedExplicitTransformation,
	taskQueue: BlTaskQueue,
	errorHandler: BlCompositeErrorHandler,
	visuals: BlDefaultVisuals,
	flags: BlElementFlags,
	text: BlRopedText,
	selection: BlCompositeSelection,
	measurement: BlTextElementTightMeasurementStrategy,
	measurer: BlTextElementHostMeasurer,
	baselineMeasurer: BlBoundsBaselineMeasurer,
	tabOffset: SmallInteger,
	selfReferences: { boundsCache.element, bounds.referenceElement, measuredBounds.referenceElement, eventDispatcher.owner }
}

BlElementCachedExplicitTransformation -> {
	elementTransformation: BlElementLocalTransformation,
	boundingRectangle: BlCachedBounds
}

BlElementCachedIdentityTransformation -> {
	identityMatrix: BlMatrix2D
}

BlElementEventDispatcher -> {
	owner: { refType: BlElement },
	shortcutHandler: BlShortcutHandlerWithoutShortcuts,
	activatedElementEvents: BlElementEventDispatcherActivatedEvents
}

BlElementEventDispatcherActivatedEvents -> {
	value: SmallInteger
}

BlElementFlags -> {
	value: SmallInteger
}

BlElementLocalBounds -> {
	referenceElement:{ refType: BlElement },
	extent: Point,
	position: Point
}

OptionalCustomNumber = SmallFloat64 | BoxedFloat64 | SmallInteger

BlInsets -> {
	top: OptionalCustomNumber,
	left: OptionalCustomNumber,
	bottom: OptionalCustomNumber,
	right: OptionalCustomNumber
}

BlLayoutCommonConstraints -> {
	vertical: BlLayoutCommonConstraintsAxis,
	horizontal: BlLayoutCommonConstraintsAxis,
	position: Point,
	margin: BlInsets,
	padding: BlInsets,
	minHeight: SmallFloat64,
	minWidth: SmallFloat64,
	maxHeight: BoxedFloat64,
	maxWidth: BoxedFloat64,
	ignoredByLayout: Boolean,
	accountTransformation: Boolean
}

BlLayoutCommonConstraintsAxis -> {
	resizer: BlLayoutExactResizer
}

BlLayoutExactResizer -> {
	size: OptionalCustomNumber
}

BlMatrix2D -> {
	x: OptionalCustomNumber,
	y: OptionalCustomNumber,
	shx: OptionalCustomNumber,
	shy: OptionalCustomNumber,
	sx: OptionalCustomNumber,
	sy: OptionalCustomNumber
}

BlRopedText -> {
	rope: BlAttributeRope
}

BlTaskQueue -> {
	lock: Monitor
}'
]
