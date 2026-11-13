Class {
	#name : 'MateBlocCompleteGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateBlocCompleteGrammar >> defineObjectGraph [

	^ 'BlAnnulusSectorGeometry -> {
	extent: Point,
	startAngle: { type: SmallInteger, between: 2 and: 359 },
	endAngle: { type: SmallInteger, between: 1 and: 360 },
	innerRadius: { type: SmallFloat64, between: 0.0015315337106585503 and: 0.39852980971336366 },
	outerRadius: { type: SmallFloat64, between: 0.5060581297148019 and: 0.999853702262044 }
}

BlBorder -> {
	paint: BlColorPaint,
	style: BlStrokeStyle,
	width: { type: SmallInteger, between: 10 and: 10 },
	opacity: { type: SmallFloat64, between: 1.0 and: 1.0 }
}

BlStrokeStyle -> {
	lineCap: BlStrokeLineButtCap,
	lineJoin: BlStrokeLineMiterJoin,
	miterLimit: { type: SmallFloat64, between: 4.0 and: 4.0 },
	dashArray: { type: [ SmallFloat64 ], sizeBetween: 1 and: 1 },
	dashOffset: { type: SmallInteger, between: 5 and: 50 }
}

BlBoundsCache -> {
	boundsInLocal: BlCachedBounds?,
	element: { refType: BlElement }
}

BlCachedBounds -> {
	left: { type: SmallFloat64, between: 0.0 and: 1000 },
	top: { type: SmallFloat64, between: 0.0 and: 1000 },
	right: { type: SmallFloat64, between: 0.0 and: 1000 },
	bottom: { type: SmallFloat64, between: 0.0 and: 1000 },
	isValid: Boolean
}

BlChildrenArray -> {
	array: { type: [ BlElement ], sizeBetween: 0 and: 10 }
}

BlCircleGeometry -> {
	extent: Point,
	radius: { type: SmallFloat64, between: 0.0 and: 1000 },
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
	tabOffset: { type: SmallInteger, between: 0 and: 10 },
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
	value: { type: SmallInteger, between: 0 and: 0 }
}

BlElementFlags -> {
	value: { type: SmallInteger, between: 0 and: 31 }
}

BlElementLocalBounds -> {
	referenceElement:{ refType: BlElement },
	extent: Point,
	position: Point
}

BlInsets -> {
	top: { type: SmallFloat64, atLeast: 0 },
	left: { type: SmallFloat64, atLeast: 0 },
	bottom: { type: SmallFloat64, atLeast: 0 },
	right: { type: SmallFloat64, atLeast: 0 }
}

BlLayoutCommonConstraints -> {
	vertical: BlLayoutCommonConstraintsAxis,
	horizontal: BlLayoutCommonConstraintsAxis,
	position: Point,
	margin: BlInsets,
	padding: BlInsets,
	minHeight: { type: SmallFloat64, between: 0.0 and: 1000 },
	minWidth: { type: SmallFloat64, between: 0.0 and: 1000 },
	maxHeight: BoxedFloat64,
	maxWidth: BoxedFloat64,
	ignoredByLayout: Boolean,
	accountTransformation: Boolean
}

BlLayoutCommonConstraintsAxis -> {
	resizer: BlLayoutExactResizer
}

BlLayoutExactResizer -> {
	size: { type: SmallFloat64, between: 350.0 and: 750.0 }
}

BlMatrix2D -> {
	x: { type: SmallFloat64, atLeast: 0 },
	y: { type: SmallFloat64, atLeast: 0 },
	shx: { type: SmallFloat64, atLeast: 0 },
	shy: { type: SmallFloat64, atLeast: 0 },
	sx: { type: SmallFloat64, atLeast: 1 },
	sy: { type: SmallFloat64, atLeast: 1 }
}

BlRopedText -> {
	rope: BlAttributeRope
}

BlTaskQueue -> {
	lock: Monitor
}'
]
