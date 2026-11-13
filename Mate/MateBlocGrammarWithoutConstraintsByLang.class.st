Class {
	#name : 'MateBlocGrammarWithoutConstraintsByLang',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateBlocGrammarWithoutConstraintsByLang >> defineObjectGraph [

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
	element: BlElement
}

BlCachedBounds -> {
	left: SmallFloat64,
	top: SmallFloat64,
	right: SmallFloat64,
	bottom: SmallFloat64,
	isValid: Boolean
}

BlChildrenArray -> {
	array: { type: [ BlElement ], sizeBetween: 0 and: 10 }
}

BlCircleGeometry -> {
	extent: Point,
	radius: SmallFloat64,
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
	parent: BlElement,
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
	flags: BlElementFlags
}

BlTextElement -> {
	parent: BlElement,
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
	owner: BlElement,
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
	referenceElement: BlElement,
	extent: Point,
	position: Point
}

BlInsets -> {
	top: SmallFloat64,
	left: SmallFloat64,
	bottom: SmallFloat64,
	right: SmallFloat64
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
	size: SmallFloat64
}

BlMatrix2D -> {
	x: SmallFloat64,
	y: SmallFloat64,
	shx: SmallFloat64,
	shy: SmallFloat64,
	sx: SmallFloat64,
	sy: SmallFloat64
}

BlRopedText -> {
	rope: BlAttributeRope
}

BlTaskQueue -> {
	lock: Monitor
}'
]
