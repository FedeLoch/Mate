Class {
	#name : 'MateASTGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateASTGrammar >> defineObjectGraph [

	^ 'AdditionalMethodState -> {
	selector: { oneOf: { #DoIt . #debug . #errorHandler . #handleCriticalError: . #processError: } }
}

ArgumentVariable -> {
	name: ByteSymbol,
	escaping: Boolean | ByteSymbol,
	index: { type: SmallInteger, between: 1 and: 6, nullable: true },
	scope: OCBlockScope | OCMethodScope | OCOptimizedBlockScope,
	usage: { oneOf: { #read . nil } }
}

Association -> {
	key: { type: SmallInteger, between: 49 and: 90 },
	value: OCAssignmentNode | OCBlockNode | OCLiteralValueNode | OCMessageNode | OCReturnNode | OCSequenceNode | OCVariableNode | RFMessageNode
}

BlBorder -> {
	paint: BlColorPaint,
	width: { type: SmallInteger, atLeast: 0 },
	style: BlStrokeStyle,
	opacity: { type: SmallFloat64, atLeast: 1 }
}

BlBoundsCache -> {
	element: { refType: BlElement }
}

BlChildrenArray -> {
	array: { type: [ BlElement ], sizeBetween: 0 and: 10 }
}

BlColorPaint -> {
	color: Color
}

BlCompositeErrorHandler -> {
	errors: { type: [ Object ], sizeBetween: 0 and: 0 },
	errorHandlers: { type: [ Object ], sizeBetween: 0 and: 0 }
}

BlCustomVisuals -> {
	border: BlBorder,
	clipChildren: Boolean
}

BlElement -> {
	spaceReference: BlAttachedCachedSpaceReference,
	parent: BlElement?,
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
	userData: IdentityDictionary,
	visuals: BlCustomVisuals | BlDefaultVisuals,
	flags: BlElementFlags,
	selfReferences: { boundsCache.element, eventDispatcher.owner }
}

BlElementEventDispatcher -> {
	owner: { refType: BlElement }
}

BlElementFlags -> {
	value: { type: SmallInteger, atLeast: 0 }
}

BlElementLocalBounds -> {
	referenceElement: BlElement,
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
	constraints: Dictionary?,
	position: Point,
	margin: BlInsets,
	padding: BlInsets,
	minHeight: { type: SmallFloat64, atLeast: 1 },
	minWidth: { type: SmallFloat64, atLeast: 1 },
	maxHeight: { type: BoxedFloat64, atLeast: 1 },
	maxWidth: { type: BoxedFloat64, atLeast: 1 },
	ignoredByLayout: Boolean,
	previouslyAccessedConstraintsType: { oneOf: { BlIgnoredLayout . nil } },
	accountTransformation: Boolean
}

BlRelativeElevation -> {
	elevation: { type: SmallInteger, atLeast: 0 }
}

BlStrokeStyle -> {
	miterLimit: { type: SmallFloat64, atLeast: 1 },
	dashArray: { type: [ Object ], sizeBetween: 0 and: 0 },
	dashOffset: { type: SmallFloat64, atLeast: 0 }
}

BlVector3D -> {
	x: { type: SmallInteger, atLeast: 0 },
	y: { type: SmallInteger, atLeast: 0 },
	z: { type: SmallInteger, atLeast: 0 }
}

ClassVariable -> {
	name: ByteSymbol,
	value: (BlBorder | BlCompositingWithoutLayerMode | BlFocusabilityBefore | BlHandlerAnnouncerRegistry class | BlInsets | BlLayoutHorizontal | BlLayoutLeftToRight | BlLayoutRightToLeft | BlLayoutVertical | BlNullEffect | BlOutskirtsCentered | BlOutskirtsInside | BlOutskirtsOutside | BlRectangleGeometry | BlRelativeElevation | BlTransparentBackground | BlVector3D | BlVisibilityVisible | ByteSymbol | Duration | Point | SmallFloat64 | SmallInteger | SparseLargeTable)?,
	owningClass: { oneOf: { BlBoundsMatcherConstraints . BlElementEventDispatcherActivatedEvents . BlElementFlags . BlElementVectorGeometry . BlElementVisuals . BlHandlerRegistry . BlHistogramGeometry . BlInsets . BlLayoutDirection . BlLayoutOrientation . BlMouseProcessor . BlOutskirts . BlSigmoidGeometry . BlTriangleGeometry . BlVector . BlViscousFluidInterpolator . Bloc . ChronologyConstants . Unicode } }
}

CopiedLocalVariable -> {
	name: ByteSymbol,
	escaping: { oneOf: { #escapingRead } },
	index: { type: SmallInteger, between: 1 and: 8, nullable: true },
	scope: OCBlockScope | OCMethodScope | OCOptimizedBlockScope,
	usage: { oneOf: { #read . #write } },
	originalVar: ArgumentVariable | TemporaryVariable
}

Dictionary -> {
	tally: { type: SmallInteger, between: 0 and: 124 },
	array: { type: [ Association | nil ], sizeBetween: 0 and: 211 }
}

Duration -> {
	nanos: { type: SmallInteger, atLeast: 1 },
	seconds: { type: SmallInteger, atLeast: 0 }
}

GlobalVariable -> {
	name: ByteSymbol,
	value: Announcer class | Array class | AssertionFailure class | Association class | BlAbstractImageBackground class | BlAffineCompositeTransformation class | BlAffineTransformationCenterOrigin class | BlAffineTransformationNormalizedPositionOrigin class | BlAffineTransformationRightCenterOrigin class | BlAffineTransformationTopLeftOrigin class | BlAlreadyAddedAsChildError class | BlAlternativeCombination class | BlAnnulusSectorGeometry class | BlAttachedCachedSpaceReference class | BlAttachedSpaceReference class | BlAttributeRopeIterator class | BlBAnnulusSectorCase class | BlBClippedImagesCase class | BlBDashedBorderCirclesCase class | BlBLinearGradientCirclesCase class | BlBRadialGradientCirclesCase class | BlBRotatedImagesCase class | BlBRotatedRectanglesCase class | BlBRotatedTextCase class | BlBScaledRectanglesCase class | BlBSolidImagesCase class | BlBTranslucentImagesCase class | BlBackground class | BlBasicLayout class | BlBitflags class | BlBlurEvent class | BlBorder class | BlBorderBuilder class | BlBottomAlignment class | BlBounds class | BlBoundsCache class | BlBoundsMatcher class | BlBoundsMatcherConstraints class | BlCachedBounds class | BlChildDoesNotExistError class | BlChildrenAccountedByLayout class | BlChildrenArray class | BlChildrenIgnoredByLayout class | BlChildrenLinkedList class | BlChildrenReversed class | BlChildrenRope class | BlChildrenSortedByElevation class | BlChildrenSortedByPerimeter class | BlClickAbortedEvent class | BlClickEvent class | BlCollectionRope class | BlCollectionRopeIterator class | BlColorPaint class | BlCompositeAlignment class | BlCompositeBackground class | BlCompositeBackgroundBuilder class | BlCompositeErrorHandler class | BlCompositeSelection class | BlCompositingSeparateLayerMode class | BlCompositingSingleLayerMode class | BlCompositingWithoutLayerMode class | BlCompulsoryCombination class | BlConcatenationRopeIterator class | BlCornerRadii class | BlCustomVisuals class | BlDefaultVisuals class | BlDetachedSpaceReference class | BlDirectEventDispatcher class | BlDoubleClickEvent class | BlDragEndEvent class | BlDragEnterEvent class | BlDragEvent class | BlDragLeaveEvent class | BlDragStartEvent class | BlDrawingErrorHandler class | BlDropEvent class | BlEasingBounceIn class | BlEasingBounceInOut class | BlEasingBounceOut class | BlElement class | BlElementAbsoluteTransformation class | BlElementAddedToParentEvent class | BlElementAddedToSceneGraphEvent class | BlElementAlignment class | BlElementBackgroundChangedEvent class | BlElementBorderChangedEvent class | BlElementBoundsInChild class | BlElementBoundsInLocal class | BlElementBoundsInParent class | BlElementBoundsInSpace class | BlElementBoundsUpdater class | BlElementBoundsUpdaterChange class | BlElementCachedExplicitTransformation class | BlElementCachedIdentityTransformation class | BlElementEventDispatcherActivatedEvents class | BlElementExtentChangedEvent class | BlElementFlags class | BlElementId class | BlElementIdentityTransformation class | BlElementIndexedId class | BlElementLayoutChangedEvent class | BlElementLayoutComputedEvent class | BlElementLocalBounds class | BlElementLocalTransformation class | BlElementNamedId class | BlElementNoId class | BlElementPositionChangedEvent class | BlElementPositionInSpaceChangedEvent class | BlElementRemovedFromParentEvent class | BlElementRemovedFromSceneGraphEvent class | BlElementScrolledEvent class | BlElementSelectionAcquiredEvent class | BlElementSelectionLostEvent class | BlElementToBeRemovedFromParentEvent class | BlElementTransformationChangedEvent class | BlElementTransformationInSpaceChangedEvent class | BlElementUniqueId class | BlElementVisibilityChangedEvent class | BlElevation class | BlEmUnit class | BlEmptySelection class | BlEndAlignment class | BlEvent class | BlEventDispatcherChain class | BlEventDispatcherEmptyChain class | BlEventHandler class | BlExtentMeasurementSpec class | BlFastForwardedTime class | BlFocusChain class | BlFocusEvent class | BlFocusInEvent class | BlFocusOutEvent class | BlFocusProcessor class | BlFocusability class | BlFocusabilityAfter class | BlFocusabilityBefore class | BlFocusabilityBlock class | BlFocusabilityIgnore class | BlFocusabilityNone class | BlFormSetBackground class | BlHandledError class | BlHandlerAnnouncementSubscription class | BlHandlerRegistry class | BlHeadlessHost class | BlHeadlessHostSpace class | BlHorizontalAlignment class | BlHorizontalCenterAlignment class | BlHorizontalCoordinateLeftAlignment class | BlHorizontalCoordinateRightAlignment class | BlHorizontalCoordinateStartAlignment class | BlHorizontalEndAlignment class | BlHorizontalStartAlignment class | BlHostPulseLoop class | BlHostRegistry class | BlHostRenderer class | BlIgnoredLayout class | BlIgnoredLayoutConstraints class | BlIgnoredLayoutConstraintsHorizontal class | BlIgnoredLayoutConstraintsVertical class | BlImageBackground class | BlImageBackgroundBuilder class | BlImmutableObjectChangeError class | BlInsets class | BlKeyCombinationBuilder class | BlKeyCombinationConverterCNF class | BlKeyCombinationConverterDNF class | BlKeyModifiers class | BlKeyUpEvent class | BlKeyboardBuffer class | BlKeyboardProcessor class | BlLayoutChildNode class | BlLayoutChildNodeWithEdges class | BlLayoutChildNodeWithElement class | BlLayoutChildNodeWithTransformation class | BlLayoutCommonConstraints class | BlLayoutCommonConstraintsAxis class | BlLayoutConstraintsAxis class | BlLayoutDirection class | BlLayoutErrorHandler class | BlLayoutExactResizer class | BlLayoutFitContentLimitedOffsetResizer class | BlLayoutFitContentLimitedResizer class | BlLayoutFitContentResizer class | BlLayoutGraphConnectedEdges class | BlLayoutGraphConnectedNodes class | BlLayoutGraphIncomingEdges class | BlLayoutGraphOutgoingEdges class | BlLayoutHorizontal class | BlLayoutLeftToRight class | BlLayoutMatchParentResizer class | BlLayoutNodeChildren class | BlLayoutNodeComputedMeasurement class | BlLayoutNodeElementMeasurement class | BlLayoutNodeNullMeasurement class | BlLayoutParentNode class | BlLayoutParentNodeWithFilter class | BlLayoutParentNodeWithTransformation class | BlLayoutResizer class | BlLayoutResizerChangedEvent class | BlLayoutRightToLeft class | BlLayoutVertical class | BlLeftAlignment class | BlLinearInterpolator class | BlMatrix2D class | BlMatrix3D class | BlMatrixDecomposition2D class | BlMatrixTransformation class | BlMeasurementAtMostMode class | BlMeasurementExactMode class | BlMeasurementMode class | BlMeasurementSpec class | BlMeasurementUnspecifiedMode class | BlMiddleAlignment class | BlMonotoneSelection class | BlMouseButton class | BlMouseDownEvent class | BlMouseEnterEvent class | BlMouseEvent class | BlMouseLeaveEvent class | BlMouseMiddleButton class | BlMouseMoveEvent class | BlMouseOtherButton class | BlMouseOutEvent class | BlMouseOverEvent class | BlMousePrimaryButton class | BlMouseProcessor class | BlMouseSecondaryButton class | BlMultipleSelection class | BlNullAlignment class | BlNullEffect class | BlNullHorizontalAlignment class | BlNullLeftAlignment class | BlNullRightAlignment class | BlNullSpaceReference class | BlNullVerticalAlignment class | BlOutskirts class | BlOutskirtsCentered class | BlOutskirtsInside class | BlOutskirtsOutside class | BlPaint class | BlPaintBackground class | BlPaintBackgroundBuilder class | BlParallelUniverse class | BlPathCache class | BlPercentUnit class | BlPoint2D class | BlPoint3D class | BlPoint4D class | BlPolygonHitTester class | BlPtUnit class | BlQuaternion class | BlRay class | BlRealTime class | BlRectangleGeometry class | BlReflectionTransformation class | BlRelativeElevation class | BlRemUnit class | BlRightAlignment class | BlRotationTransformation class | BlRoundedRectangleGeometry class | BlScalingTransformation class | BlSelection class | BlSelectionNode class | BlSelectionTree class | BlShearTransformation class | BlShortcutEvent class | BlShortcutHandlerWithShortcuts class | BlShortcutHandlerWithoutShortcuts class | BlShortcutRegistry class | BlSimulatedTime class | BlSingleKeyCombination class | BlSingularMatrixError class | BlSpace class | BlSpaceClosedEvent class | BlSpaceDragCancelEvent class | BlSpaceEventListener class | BlSpaceEventsProcessedEvent class | BlSpaceFrame class | BlSpaceFrameDrawingPhase class | BlSpaceFrameDrawingValidationPhase class | BlSpaceFrameEventPhase class | BlSpaceFrameHostValidationPhase class | BlSpaceFrameLayoutPhase class | BlSpaceFrameTaskPhase class | BlSpaceFrameUnknownPhase class | BlSpaceIconChangedEvent class | BlSpaceLayoutEndEvent class | BlSpaceRenderEndEvent class | BlSpaceRootChangeEvent class | BlSpaceShownEvent class | BlSpaceTaskQueue class | BlSpaceTasksEndEvent class | BlStartAlignment class | BlStrokeLineBevelJoin class | BlStrokeLineButtCap class | BlStrokeLineCap class | BlStrokeLineJoin class | BlStrokeLineMiterJoin class | BlStrokeLineRoundCap class | BlStrokeLineRoundJoin class | BlStrokeLineSquareCap class | BlStrokeStyle class | BlSubRopeIterator class | BlTaskAction class | BlTaskQueue class | BlTextIndexEOS class | BlTextInputBuffer class | BlTextInputEvent class | BlTime class | BlTopAlignment class | BlTransformationBuilder class | BlTranslationTransformation class | BlTransparentBackground class | BlUIEvent class | BlUnit class | BlVector class | BlVector2D class | BlVector3D class | BlVerticalAlignment class | BlVerticalCenterAlignment class | BlVerticalCoordinateBottomAlignment class | BlVerticalCoordinateTopAlignment class | BlVisibility class | BlVisibilityGone class | BlVisibilityHidden class | BlVisibilityVisible class | Bloc class | C2CoverageCollector class | Character class | ClassVariable class | Color class | Cursor class | DateAndTime class | Dictionary class | Duration class | Error class | Float class | HashedCollection class | IdentityDictionary class | IdentitySet class | IncrementalCoverageResult class | KeyboardKey class | LinkedList class | Margin class | MateBlocCompleteGrammar class | MateBlocGrammarWithoutConstraintsByLang class | MateBlocWithRandomReferenceSelectionGrammar class | MateGrammarBaseInstanceGenerator class | MateGrammarInferrer class | MateOGDerivationNode class | MateOGInstanceNode class | MatePaperBlocExperiment class | MatePaperExperiment class | MateReferencePath class | Metacello class | Monitor class | Mutex class | NonInteractiveTranscript class | NotFound class | OCMessageNode class | OCMethodNode class | OSPlatform class | Object class | OrderedCollection class | OrderedDictionary class | ProcessorScheduler | Random class | ReadStream class | Rectangle class | Semaphore class | SessionManager class | Set class | SmalltalkImage | SortedCollection class | Stack class | String class | Symbol class | SystemNavigation class | TBlSingletonHost classTrait | Time class | UmeBlocRender class | UnhandledException class | WaitfreeQueue class | WeakIdentityKeyDictionary class | WebBrowser class | ZnCharacterEncodingError class | ZnCharacterReadStream class
}

IdentityDictionary -> {
	tally: { type: SmallInteger, between: 0 and: 1 },
	array: { type: [ Association | nil ], sizeBetween: 5 and: 5 }
}

InstanceVariableSlot -> {
	name: ByteSymbol,
	owningClass: { oneOf: { BlAffineCompositeTransformation . BlAffineTransformation . BlAffineTransformationCenterOrigin class . BlAffineTransformationNormalizedPositionOrigin . BlAlternativeCombination . BlAnnulusSectorGeometry . BlArrayObjectPool . BlAttachedSpaceReference class . BlAttributeRope . BlAttributeRopeIterator . BlBackground . BlBackgroundBuilder . BlBagObjectPool . BlBaseEventProcessor . BlBasicLayout class . BlBasicShortcut . BlBezierCurveGeometry . BlBitflags . BlBorder . BlBorder class . BlBorderBuilder . BlBounds . BlBoundsCache . BlBoundsMatcher . BlCachedBounds . BlChildBoundsBasedFinder . BlChildrenArray . BlChildrenCollection . BlChildrenLinkedList . BlChildrenOrderedCollection . BlChildrenRope . BlChildrenSubset . BlCircleGeometry . BlClipOutGeometryEffect . BlClipOutInsetsEffect . BlCollectionRope . BlCollectionRopeIterator . BlColorPaint . BlColorPaint class . BlCompositeAlignment . BlCompositeBackground . BlCompositeBackgroundBuilder . BlCompositeEffect . BlCompositeErrorHandler . BlCompositeSelection . BlCompositingMode class . BlCompulsoryCombination . BlConcatenationRope . BlConcatenationRopeIterator . BlCornerRadii . BlCornerRadii class . BlCosineInterpolator . BlCustomVisuals . BlDecelerateInterpolator . BlDefaultVisuals class . BlDelayedTask . BlDelayedTaskAction . BlDetachedSpaceReference class . BlDirectEventDispatcher . BlElement . BlElementAbsoluteTransformation . BlElementAlignment class . BlElementBounds . BlElementBoundsUpdater . BlElementBoundsUpdaterChange . BlElementCachedExplicitTransformation . BlElementCachedIdentityTransformation . BlElementCachedIdentityTransformation class . BlElementCompositeTransformation . BlElementComputedBounds . BlElementEventDispatcher . BlElementIdentityTransformation class . BlElementIndexedId . BlElementLocalBounds . BlElementLocalTransformation . BlElementNamedId . BlElementNoId class . BlElementUniqueId class . BlElementVectorGeometry . BlElevation . BlElevation class . BlEqualizer . BlEvent . BlEventDispatcherChain . BlEventDispatcherEmptyChain class . BlEventFilter . BlExtentMeasurementSpec . BlFastForwardedTime . BlFocusProcessor . BlFocusability class . BlFormSetBackground . BlGaussianShadowEffect . BlGradientPaint . BlGradientShadowEffect . BlHandledError . BlHandlerAnnouncerRegistry . BlHandlerArrayRegistry . BlHeadlessHostSpace . BlHeightEqualizer . BlHistogramGeometry . BlHorizontalAlignment class . BlHorizontalCoordinateAlignment . BlHostPulseLoop . BlHostRegistry . BlHostRegistry class . BlHostRenderer . BlHostRenderer class . BlHostSpace . BlIgnoredLayoutConstraintsHorizontal . BlIgnoredLayoutConstraintsVertical . BlImageBackground . BlInsets . BlInterpolator class . BlKeyCombinationBuilder . BlKeyModifiers . BlKeyboardBuffer . BlKeyboardEvent . BlKeyboardProcessor . BlLayoutChildNode . BlLayoutChildNodeWithEdges . BlLayoutChildNodeWithElement . BlLayoutChildNodeWithTransformation . BlLayoutCommonConstraints . BlLayoutCommonConstraintsAxis . BlLayoutConstraints . BlLayoutExactResizer class . BlLayoutFitContentLimitedOffsetResizer . BlLayoutFitContentLimitedResizer class . BlLayoutFitContentResizer class . BlLayoutGraphConnectedNodes . BlLayoutMatchParentResizer class . BlLayoutNodeComputedMeasurement . BlLayoutNonLeafChildNode . BlLayoutNonLeafParentNode . BlLayoutParentNode . BlLayoutParentNodeWithEdges . BlLayoutParentNodeWithFilter . BlLayoutParentNodeWithTransformation . BlLineGeometry . BlLinearGradientPaint . BlMatrix2D . BlMatrix3D . BlMatrixDecomposition2D . BlMatrixTransformation . BlMeasurementMode class . BlMeasurementSpec . BlMonotoneSelection . BlMouseEvent . BlMouseNamedButton class . BlMouseOtherButton . BlMouseProcessor . BlMouseWheelEvent . BlMultipleSelection . BlNullHorizontalAlignment class . BlNullSpaceReference class . BlOnActionHandler . BlOverlayEffect . BlPaintBackground . BlParallelUniverse . BlPathCache . BlPerspectiveTransformation . BlPoint2D . BlPoint3D . BlPoint4D . BlPolygonGeometry . BlPolylineGeometry . BlPulseLoopHost . BlQuaternion . BlRadialGradientPaint . BlRay . BlReflectionTransformation . BlRepeatedTask . BlRepeatedTaskAction . BlRopeIterator . BlRopeableCollectionFile . BlRotationTransformation . BlRoundedRectangleGeometry . BlScalingTransformation . BlSelection class . BlSelectionHandler . BlSelectionNode . BlSelectionTree . BlShadowEffect . BlSharedEventDistributor . BlShearTransformation . BlShortcutEvent . BlShortcutHandlerWithShortcuts . BlShortcutHandlerWithoutShortcuts class . BlShortcutRegistry . BlShortcutWithAction . BlSigmoidGeometry . BlSimulatedTime . BlSineInterpolator . BlSingleErrorHandler . BlSingleKeyCombination . BlSpace . BlSpaceEventListener . BlSpaceFrame . BlSpacePhaseEvent . BlSpaceResizedEvent . BlSpaceShutdownOnCloseListener . BlSpaceTaskQueue . BlSquareGeometry . BlStrokeLineCap class . BlStrokeLineJoin class . BlStrokeStyle . BlSubRope . BlSubRopeIterator . BlSynchronizedObjectPool . BlTask . BlTaskAction . BlTaskQueue . BlTextIndexEOS . BlTextInputBuffer . BlTime . BlTransformationBuilder . BlTranslationTransformation . BlTransparentBackground class . BlTriangleGeometry . BlUIEvent . BlUnit class . BlValueWithUnit . BlVector2D . BlVector3D . BlVerticalAlignment class . BlVerticalCoordinateAlignment . BlVisibility class . BlVisualSelectionHandler . BlWidthEqualizer . DateAndTime . GncBPGrammarGenerator . MateGenerator . MateOGGrammar . MatePaperExperiment . MateParser . Point . ProcessList . TBlAnnouncerProvider . TBlSingletonHost classTrait } },
	index: { type: SmallInteger, between: 1 and: 29 }
}

Interval -> {
	start: { type: SmallInteger, between: 1 and: 2658 },
	stop: { type: SmallInteger, between: 11 and: 2674 },
	step: { type: SmallInteger, between: 1 and: 1 },
	invariants: { start < stop }
}

MateBlocCompleteGrammar -> {
	typeDeclarations: Dictionary,
	generator: MateGenerator,
	parser: MateParser,
	writer: MateWriter,
	selfReferences: { generator.grammar, parser.grammar, writer.grammar }
}

MateGenerator -> {
	grammar: { refType: MateOGGrammar },
	builtInGenerators: Dictionary,
	maxDerivationHeight: { type: SmallInteger, atLeast: 1 },
	random: Random,
	nilProbability: { type: SmallFloat64, atLeast: 1 },
	maxObjects: { type: SmallInteger, atLeast: 1, nullable: true },
	objectCount: { type: SmallInteger, atLeast: 1, nullable: true },
	closing: Boolean?,
	truncations: { type: SmallInteger, atLeast: 0, nullable: true },
	instanceGeneator: MateGrammarBaseInstanceGenerator?
}

MateOGGrammar -> {
	typeDeclarations: Dictionary,
	generator: MateGenerator,
	parser: MateParser,
	writer: MateWriter,
	selfReferences: { generator.grammar, parser.grammar, writer.grammar }
}

MateParser -> {
	grammar: { refType: MateOGGrammar },
	visiting: { type: [ Object ], collection: IdentitySet, sizeBetween: 0 and: 0 }
}

MateWriter -> {
	grammar: { refType: MateOGGrammar }
}

MetaLink -> {
	arguments: { type: [ OCLiteralValueNode ], sizeBetween: 2 and: 2 },
	control: { oneOf: { #before } },
	nodes: { type: [ OCSequenceNode ], collection: IdentitySet, sizeBetween: 0 and: 1 },
	selector: { oneOf: { #tagExecuted:inMethod: } },
	options: OCCompilationContext
}

OCArrayNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	left: { type: SmallInteger, between: 17 and: 1633 },
	right: { type: SmallInteger, between: 23 and: 2679 },
	statements: { type: [ OCLiteralValueNode | OCMessageNode | OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 20 },
	periods: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 19 },
	invariants: { left < right }
}

OCAssignmentErrorNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary,
	errorMessage: { oneOf: { ''variable expected in assigment'' } },
	value: { oneOf: { '':='' } },
	start: { type: SmallInteger, between: 143 and: 607 },
	stop: { type: SmallInteger, between: 222 and: 686 },
	errorPosition: { type: SmallInteger, between: 143 and: 607 },
	valueAfter: { oneOf: { '''' } },
	contents: { type: [ OCCascadeNode ], sizeBetween: 0 and: 1 },
	invariants: { start < stop, errorPosition = start, errorPosition < stop }
}

OCAssignmentNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	variable: OCPatternVariableNode | OCVariableNode,
	assignment: { type: SmallInteger, between: 4 and: 2239, nullable: true },
	value: OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCPatternVariableNode | OCVariableNode
}

OCBlockNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	left: { type: SmallInteger, between: 0 and: 2611 },
	right: { type: SmallInteger, between: 0 and: 2676 },
	arguments: { type: [ OCPatternVariableNode | OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 4 },
	bar: { type: SmallInteger, between: 20 and: 2616, nullable: true },
	body: { refType: OCSequenceNode },
	scope: (OCBlockScope | OCOptimizedBlockScope)?,
	bcToASTCache: OCBytecodeToASTCache?,
	selfReferences: { scope.node },
	invariants: { left <= right }
}

OCBlockScope -> {
	outerScope: OCBlockScope | OCMethodScope | OCOptimizedBlockScope,
	tempVars: OrderedDictionary,
	copiedVars: OrderedDictionary,
	tempVector: OrderedDictionary,
	id: { type: SmallInteger, between: 1 and: 18 },
	tempVectorVar: TemporaryVariable?,
	node: { refType: OCProgramNode }
}

OCBytecodeToASTCache -> {
	firstBcOffset: { type: SmallInteger, between: 17 and: 289 },
	lastBcOffset: { type: SmallInteger, between: 18 and: 431 },
	bcToASTMap: Dictionary,
	methodOrBlockNode: OCBlockNode | OCMethodNode,
	invariants: { firstBcOffset < lastBcOffset }
}

OCCascadeNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	messages: { type: [ OCMessageNode ], collection: OrderedCollection, sizeBetween: 0 and: 11 },
	semicolons: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 1 and: 10 }
}

OCCommentNode -> {
	parent: { refType: OCProgramNode },
	contents: ByteString | WideString,
	start: { type: SmallInteger, between: 23 and: 2443 },
	stop: { type: SmallInteger, between: 60 and: 2502 },
	invariants: { start < stop }
}

OCCompilationContext -> {
	options: { type: [ ByteSymbol ], collection: Set, sizeBetween: 11 and: 11 },
	parserClass: { oneOf: { OCParser } },
	semanticAnalyzerClass: { oneOf: { OCASTSemanticAnalyzer . RFSemanticAnalyzer } },
	astTranslatorClass: { oneOf: { OCASTTranslator . RFASTTranslator . nil } },
	bytecodeGeneratorClass: { oneOf: { OCIRBytecodeGenerator . nil } },
	encoderClass: { oneOf: { EncoderForSistaV1 . nil } },
	astParseTransformPlugins: { type: [ Object ], collection: OrderedCollection, sizeBetween: 0 and: 0 },
	requestorScopeClass: { oneOf: { OCRequestorScope . nil } },
	semanticScope: OCMethodSemanticScope | OCReceiverDoItSemanticScope
}

OCDoItMethodNode -> {
	properties: SmallDictionary?,
	scope: OCMethodScope?,
	selector: { oneOf: { #DoIt } },
	body: { refType: OCSequenceNode },
	source: ByteString,
	arguments: { type: [ Object ], sizeBetween: 0 and: 0 },
	pragmas: { type: [ Object ], sizeBetween: 0 and: 0 },
	replacements: SortedCollection,
	nodeReplacements: IdentityDictionary,
	compilationContext: OCCompilationContext?,
	selfReferences: { scope.node }
}

OCIRMethod -> {
	sourceNode: OCBlockNode | OCDoItMethodNode | OCMethodNode,
	startSequence: OCIRSequence,
	numArgs: { type: SmallInteger, between: 0 and: 6 },
	properties: AdditionalMethodState?,
	tempMap: Dictionary,
	pragmas: { type: [ Pragma ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	additionalLiterals: OCLiteralSet,
	compilationContext: OCCompilationContext,
	irPrimitive: OCIRPrimitive,
	selfReferences: { startSequence.method }
}

OCIRPrimitive -> {
	primitiveNum: { type: SmallInteger, between: 0 and: 0 }
}

OCIRSequence -> {
	orderNumber: { type: SmallInteger, between: 1 and: 1 },
	method: { refType: OCIRMethod }
}

OCLiteralArrayNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	start: { type: SmallInteger, between: 1 and: 932 },
	stop: { type: SmallInteger, between: 16 and: 957 },
	isByteArray: Boolean,
	contents: { type: [ OCLiteralArrayNode | OCLiteralValueNode | OCPatternVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 16 },
	openerSize: { type: SmallInteger, between: 2 and: 2 },
	invariants: { start < stop }
}

OCLiteralSet -> {
	tally: { type: SmallInteger, between: 0 and: 3 },
	array: { type: [ ByteSymbol | nil ], sizeBetween: 5 and: 5 }
}

OCLiteralValueNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	start: { type: SmallInteger, between: 0 and: 2665 },
	stop: { type: SmallInteger, between: -1 and: 2673 },
	value: (Boolean | ByteString | ByteSymbol | Character | SmallFloat64 | SmallInteger)?,
	sourceText: ByteString?
}

OCMessageNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	receiver: OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCParseErrorNode | OCPatternVariableNode | OCVariableNode,
	selector: OCSelectorNode,
	keywordsPositions: IntegerArray?,
	superOf: { oneOf: { BlAffineCompositeTransformation . BlAffineTransformation . BlAffineTransformationNormalizedPositionOrigin . BlAffineTransformationPositionOrigin . BlAlternativeCombination . BlAnnulusSectorGeometry . BlArrayObjectPool . BlAttributeRopeIterator . BlBackgroundBuilder . BlBagObjectPool . BlBaseDragEvent . BlBasicLayout . BlBasicShortcut . BlBezierCurveGeometry . BlBitflags . BlBlurEvent . BlBorder . BlBorder class . BlBorderBuilder . BlBoundsMatcher . BlBoundsMatcherConstraints class . BlCachedBounds . BlChildrenArray . BlChildrenLinkedList . BlChildrenOrderedCollection . BlChildrenReversed . BlChildrenRope . BlCircleGeometry . BlClipOutGeometryEffect . BlClipOutInsetsEffect . BlCollectionRopeIterator . BlColorPaint . BlColorPaint class . BlCompositeAlignment . BlCompositeBackground . BlCompositeBackgroundBuilder . BlCompositeEffect . BlCompositeSelection . BlCompulsoryCombination . BlConcatenationRopeIterator . BlCornerRadii class . BlCosineInterpolator . BlDecelerateInterpolator . BlDelayedTask . BlDelayedTaskAction . BlDirectEventDispatcher . BlElement . BlElementBoundsUpdater . BlElementCachedIdentityTransformation . BlElementCompositeTransformation . BlElementEventDispatcher . BlElementEventDispatcherActivatedEvents class . BlElementFlags class . BlElementLocalBounds . BlElementLocalTransformation . BlElementVectorGeometry . BlElevation . BlElevation class . BlEvent . BlEventDispatcherEmptyChain class . BlFastForwardedTime . BlFocusEvent . BlFocusability class . BlGradientPaint . BlHandlerAnnouncerRegistry . BlHandlerArrayRegistry . BlHeadlessHostSpace . BlHeightEqualizer . BlHistogramGeometry . BlHorizontalAlignment class . BlHorizontalCoordinateAlignment . BlHostPulseLoop . BlHostRegistry . BlHostSpace . BlIgnoredLayoutConstraintsHorizontal . BlIgnoredLayoutConstraintsVertical . BlImageBackground . BlInterpolator class . BlKeyCombinationBuilder . BlKeyModifiers . BlKeyboardBuffer . BlKeyboardEvent . BlKeyboardProcessor . BlLayoutChildNode . BlLayoutChildNodeWithEdges . BlLayoutCommonConstraints . BlLayoutCommonConstraintsAxis . BlLayoutCommonConstraintsAxis class . BlLayoutConstraints . BlLayoutExactResizer . BlLayoutExactResizer class . BlLayoutFitContentLimitedOffsetResizer . BlLayoutFitContentLimitedResizer class . BlLayoutFitContentResizer class . BlLayoutMatchParentResizer class . BlLayoutParentNode . BlLayoutParentNodeWithTransformation . BlLineGeometry . BlLinearGradientPaint . BlMatrix2D . BlMatrix3D . BlMatrixDecomposition2D . BlMatrixTransformation . BlMeasurementMode class . BlMouseEvent . BlMouseNamedButton class . BlMouseProcessor . BlMouseWheelEvent . BlMultipleSelection . BlNullAlignment class . BlNullHorizontalAlignment class . BlOutskirts class . BlOverlayEffect . BlPaintBackground . BlParallelUniverse . BlPoint2D . BlPoint3D . BlPoint4D . BlPolygonGeometry . BlPulseLoopHost . BlQuaternion . BlRadialGradientPaint . BlRay . BlRepeatedTask . BlRepeatedTaskAction . BlRopeableCollectionFile . BlRotationTransformation . BlScalingTransformation . BlSelection class . BlSelectionHandler . BlSharedEventDistributor . BlShearTransformation . BlShortcutEvent . BlShortcutHandlerWithShortcuts . BlShortcutRegistry . BlShortcutWithAction . BlSigmoidGeometry . BlSimulatedTime . BlSineInterpolator . BlSpace . BlSpaceFrame . BlSpaceShutdownOnCloseListener . BlSpaceTaskQueue . BlStrokeLineCap class . BlStrokeLineJoin class . BlSubRopeIterator . BlSynchronizedObjectPool . BlTask . BlTaskAction . BlTaskQueue . BlTextIndexEOS . BlTextInputBuffer . BlTime . BlTransformationBuilder . BlTranslationTransformation . BlTransparentBackground class . BlTransparentPaint . BlTriangleGeometry . BlUIEvent . BlValueWithUnit . BlVector class . BlVerticalAlignment class . BlVerticalCoordinateAlignment . BlVisibility class . BlVisualSelectionHandler . BlWidthEqualizer . MateGenerator . MateParser . nil } }
}

OCMethodNode -> {
	properties: SmallDictionary?,
	scope: OCMethodScope?,
	selector: ByteSymbol,
	keywordsPositions: IntegerArray?,
	body: { refType: OCSequenceNode },
	source: ByteString | WideString,
	replacements: SortedCollection,
	nodeReplacements: IdentityDictionary,
	compilationContext: OCCompilationContext?,
	selfReferences: { scope.node, pragmas[ .parent ] }
}

OCMethodScope -> {
	outerScope: OCMethodSemanticScope | OCReceiverDoItSemanticScope | OCRequestorScope,
	tempVars: OrderedDictionary,
	copiedVars: OrderedDictionary,
	tempVector: OrderedDictionary,
	id: { type: SmallInteger, between: 0 and: 0 },
	tempVectorVar: TemporaryVariable?,
	node: { refType: OCProgramNode }
}

OCMethodSemanticScope -> {
	targetClass: { oneOf: { Behavior . BlAbstractImageBackground . BlAbstractImageBackground class . BlAbstractLayoutChildNode . BlAbstractLayoutParentNode . BlAffineCompositeTransformation . BlAffineTransformation . BlAffineTransformationCenterOrigin . BlAffineTransformationCenterOrigin class . BlAffineTransformationLeftCenterOrigin . BlAffineTransformationNormalizedPositionOrigin . BlAffineTransformationNormalizedPositionOrigin class . BlAffineTransformationOrigin . BlAffineTransformationPositionOrigin . BlAffineTransformationPositionOrigin class . BlAffineTransformationRightCenterOrigin . BlAffineTransformationTopLeftOrigin . BlAlreadyAddedAsChildError class . BlAlternativeCombination . BlAnnulusSectorGeometry . BlArrayObjectPool . BlArrayObjectPool class . BlAttachedCachedSpaceReference . BlAttachedCachedSpaceReference class . BlAttachedSpaceReference class . BlAttributeRope . BlAttributeRope class . BlAttributeRopeIterator . BlBackground . BlBackground class . BlBackgroundBuilder . BlBagObjectPool . BlBagObjectPool class . BlBaseDragEvent . BlBaseEventProcessor . BlBaseEventProcessor class . BlBaseFocusEvent . BlBasicEventHandler . BlBasicLayout . BlBasicLayout class . BlBasicNodeBasedLayout . BlBasicShortcut . BlBezierCurveGeometry . BlBezierCurveGeometry class . BlBitflags . BlBitflags class . BlBlurEffect class . BlBlurEvent . BlBorder . BlBorder class . BlBorderBuilder . BlBottomAlignment . BlBottomAlignment class . BlBounds . BlBounds class . BlBoundsCache . BlBoundsCache class . BlBoundsMatcher . BlBoundsMatcherConstraints . BlBoundsMatcherConstraints class . BlBubblingEventDispatcher . BlCachedBounds . BlChildBoundsBasedFinder . BlChildDoesNotExistError . BlChildren . BlChildrenAccountedByLayout . BlChildrenArray . BlChildrenArray class . BlChildrenCollection . BlChildrenIgnoredByLayout . BlChildrenLinkedList . BlChildrenOrderedCollection . BlChildrenReversed . BlChildrenReversed class . BlChildrenRope . BlChildrenSortedByElevation . BlChildrenSortedByPerimeter . BlChildrenSubset . BlChildrenSubset class . BlCircleGeometry . BlClickAbortedEvent . BlClickEvent . BlClipOutGeometryEffect . BlClipOutInsetsEffect . BlCollectionRope . BlCollectionRope class . BlCollectionRopeIterator . BlColorPaint . BlColorPaint class . BlCompositeAlignment . BlCompositeAlignment class . BlCompositeBackground . BlCompositeBackground class . BlCompositeBackgroundBuilder . BlCompositeEffect . BlCompositeEffect class . BlCompositeErrorHandler . BlCompositeErrorHandler class . BlCompositeSelection . BlCompositeSelection class . BlCompositingMode . BlCompositingMode class . BlCompulsoryCombination . BlConcatenationRope . BlConcatenationRope class . BlConcatenationRopeIterator . BlCornerRadii . BlCornerRadii class . BlCosineInterpolator . BlCustomEventHandler . BlCustomVisuals . BlDecelerateInterpolator . BlDecelerateInterpolator class . BlDefaultVisuals . BlDefaultVisuals class . BlDelayedTask . BlDelayedTaskAction . BlDetachedSpaceReference class . BlDirectEventDispatcher . BlDirectEventDispatcher class . BlDoubleClickEvent . BlDragEndEvent . BlDragEnterEvent . BlDragEvent . BlDragLeaveEvent . BlDragStartEvent . BlDrawingErrorHandler . BlDropEvent . BlEasing . BlEasing class . BlEasingBaseBounce . BlEasingBounceIn . BlEasingBounceInOut . BlEasingBounceOut . BlEasingElastic . BlEasingQuad . BlElement . BlElement class . BlElementAbsoluteTransformation . BlElementAbsoluteTransformation class . BlElementAddedToParentEvent . BlElementAddedToParentEvent class . BlElementAddedToSceneGraphEvent . BlElementAddedToSceneGraphEvent class . BlElementAlignment . BlElementAlignment class . BlElementBackgroundChangedEvent class . BlElementBorderChangedEvent class . BlElementBounds . BlElementBoundsInChild . BlElementBoundsInParent . BlElementBoundsInSpace . BlElementBoundsUpdater . BlElementBoundsUpdaterChange . BlElementCachedExplicitTransformation . BlElementCachedExplicitTransformation class . BlElementCachedIdentityTransformation . BlElementCachedIdentityTransformation class . BlElementCachedTransformation . BlElementCompositeTransformation . BlElementComputedBounds . BlElementEffect . BlElementEvent class . BlElementEventDispatcher . BlElementEventDispatcherActivatedEvents . BlElementEventDispatcherActivatedEvents class . BlElementExtentChangedEvent . BlElementExtentChangedEvent class . BlElementFlags . BlElementFlags class . BlElementGeometry . BlElementId . BlElementId class . BlElementIdentityTransformation . BlElementIdentityTransformation class . BlElementIndexedId . BlElementLayoutChangedEvent class . BlElementLayoutComputedEvent . BlElementLayoutComputedEvent class . BlElementLocalBounds . BlElementLocalTransformation . BlElementLocalTransformation class . BlElementNamedId . BlElementNoId . BlElementNoId class . BlElementPositionChangedEvent . BlElementPositionChangedEvent class . BlElementPositionInSpaceChangedEvent . BlElementPositionInSpaceChangedEvent class . BlElementRemovedFromParentEvent . BlElementRemovedFromParentEvent class . BlElementRemovedFromSceneGraphEvent . BlElementRemovedFromSceneGraphEvent class . BlElementScrolledEvent . BlElementScrolledEvent class . BlElementSelectionAcquiredEvent class . BlElementSelectionLostEvent class . BlElementToBeRemovedFromParentEvent . BlElementTransformation . BlElementTransformation class . BlElementTransformationChangedEvent class . BlElementTransformationInSpaceChangedEvent . BlElementTransformationInSpaceChangedEvent class . BlElementUniqueId . BlElementUniqueId class . BlElementVectorGeometry . BlElementVectorGeometry class . BlElementVisibilityChangedEvent . BlElementVisibilityChangedEvent class . BlElementVisuals . BlElementVisuals class . BlElevation . BlElevation class . BlEllipseGeometry . BlEmUnit . BlEmptyGeometry . BlEmptySelection . BlEndAlignment class . BlEqualizer . BlEqualizer class . BlErrorHandler . BlEvent . BlEvent class . BlEventDelegator . BlEventDelegator class . BlEventDispatcher . BlEventDispatcherChain . BlEventDispatcherChain class . BlEventDispatcherEmptyChain . BlEventDispatcherEmptyChain class . BlEventFilter . BlEventFilter class . BlEventForwarder . BlEventForwarder class . BlEventHandler . BlEventHandler class . BlEventListener . BlExtentMeasurementSpec . BlExtentMeasurementSpec class . BlFastForwardedTime . BlFocusChain . BlFocusChain class . BlFocusEvent . BlFocusInEvent . BlFocusOutEvent . BlFocusProcessor . BlFocusability . BlFocusability class . BlFocusabilityAfter . BlFocusabilityBefore . BlFocusabilityBlock . BlFocusabilityIgnore . BlFormSetBackground . BlFormSetBackground class . BlGaussianShadowEffect . BlGaussianShadowEffect class . BlGradientPaint . BlGradientShadowEffect . BlGradientShadowEffect class . BlHandledError . BlHandlerAnnouncementSubscription . BlHandlerAnnouncerRegistry . BlHandlerArrayRegistry . BlHandlerRegistry . BlHandlerRegistry class . BlHeadlessHost . BlHeadlessHostSpace . BlHeightEqualizer . BlHistogramGeometry . BlHistogramGeometry class . BlHorizontalAlignment . BlHorizontalAlignment class . BlHorizontalCenterAlignment . BlHorizontalCenterAlignment class . BlHorizontalCoordinateAlignment . BlHorizontalCoordinateAlignment class . BlHorizontalCoordinateEndAlignment class . BlHorizontalCoordinateLeftAlignment . BlHorizontalCoordinateLeftAlignment class . BlHorizontalCoordinateRightAlignment . BlHorizontalCoordinateRightAlignment class . BlHorizontalCoordinateStartAlignment class . BlHorizontalEndAlignment . BlHorizontalEndAlignment class . BlHorizontalStartAlignment . BlHorizontalStartAlignment class . BlHost . BlHost class . BlHostPulseLoop . BlHostRegistry . BlHostRegistry class . BlHostRenderer . BlHostRenderer class . BlHostSpace . BlHostTextMeasurer . BlIgnoredLayout class . BlIgnoredLayoutConstraints . BlIgnoredLayoutConstraintsHorizontal . BlIgnoredLayoutConstraintsVertical . BlImageBackground . BlImageBackground class . BlImageBackgroundBuilder . BlImagePatternPaint class . BlImmutableObjectChangeError . BlImmutableObjectChangeError class . BlInsets . BlInsets class . BlInterpolator . BlInterpolator class . BlKeyCombination . BlKeyCombination class . BlKeyCombinationBuilder . BlKeyCombinationConverterCNF . BlKeyCombinationConverterDNF . BlKeyDownEvent . BlKeyModifiers . BlKeyModifiers class . BlKeyUpEvent . BlKeyboardBuffer . BlKeyboardEvent . BlKeyboardKeyTable . BlKeyboardProcessor . BlLayout . BlLayout class . BlLayoutChildNode . BlLayoutChildNodeWithEdges . BlLayoutChildNodeWithElement . BlLayoutChildNodeWithTransformation . BlLayoutCommonConstraints . BlLayoutCommonConstraintsAxis . BlLayoutCommonConstraintsAxis class . BlLayoutConstraints . BlLayoutDirection . BlLayoutDirection class . BlLayoutErrorHandler . BlLayoutExactResizer . BlLayoutExactResizer class . BlLayoutFitContentLimitedOffsetResizer . BlLayoutFitContentLimitedOffsetResizer class . BlLayoutFitContentLimitedResizer . BlLayoutFitContentLimitedResizer class . BlLayoutFitContentResizer . BlLayoutFitContentResizer class . BlLayoutGraphConnectedEdges . BlLayoutGraphConnectedNodes . BlLayoutGraphConnectedNodes class . BlLayoutGraphEdgesIterator . BlLayoutGraphIncomingEdges . BlLayoutGraphIterator . BlLayoutGraphIterator class . BlLayoutGraphOutgoingEdges . BlLayoutHorizontal . BlLayoutLeftToRight . BlLayoutMatchParentResizer . BlLayoutMatchParentResizer class . BlLayoutNode . BlLayoutNodeChildren . BlLayoutNodeComputedMeasurement . BlLayoutNodeComputedMeasurement class . BlLayoutNodeElementMeasurement . BlLayoutNodeMeasurement . BlLayoutNodeResizerMeasurement . BlLayoutNonLeafChildNode . BlLayoutNonLeafParentNode . BlLayoutOrientation . BlLayoutOrientation class . BlLayoutParentNode . BlLayoutParentNode class . BlLayoutParentNodeWithEdges . BlLayoutParentNodeWithFilter . BlLayoutParentNodeWithTransformation . BlLayoutResizer . BlLayoutResizer class . BlLayoutResizerChangedEvent . BlLayoutRightToLeft . BlLayoutVertical . BlLeftAlignment . BlLeftAlignment class . BlLineGeometry . BlLineGeometry class . BlLinearGradientPaint . BlLinearGradientPaint class . BlMatrix . BlMatrix2D . BlMatrix2D class . BlMatrix3D . BlMatrix3D class . BlMatrixDecomposition . BlMatrixDecomposition2D . BlMatrixTransformation . BlMatrixTransformation class . BlMeasurementAtMostMode . BlMeasurementExactMode . BlMeasurementMode . BlMeasurementMode class . BlMeasurementSpec . BlMeasurementSpec class . BlMeasurementUnspecifiedMode . BlMiddleAlignment class . BlMonotoneSelection . BlMonotoneSelection class . BlMouseButton . BlMouseButton class . BlMouseDownEvent . BlMouseDownEvent class . BlMouseEnterEvent . BlMouseEvent . BlMouseLeaveEvent . BlMouseMiddleButton . BlMouseMoveEvent . BlMouseMoveEvent class . BlMouseNamedButton . BlMouseNamedButton class . BlMouseOtherButton . BlMouseOtherButton class . BlMouseOutEvent . BlMouseOverEvent . BlMousePrimaryButton . BlMouseProcessor . BlMouseProcessor class . BlMouseSecondaryButton . BlMouseUpEvent . BlMouseUpEvent class . BlMouseWheelEvent . BlMultipleSelection . BlMultipleSelection class . BlNodeBasedLayout . BlNullAlignment . BlNullAlignment class . BlNullHorizontalAlignment . BlNullHorizontalAlignment class . BlNullLeftAlignment class . BlNullRightAlignment class . BlNullSpaceReference class . BlNullVerticalAlignment . BlNullVerticalAlignment class . BlObjectPool . BlOnActionHandler . BlOnActionHandler class . BlOutskirts . BlOutskirts class . BlOutskirtsCentered . BlOutskirtsInside . BlOutskirtsOutside . BlOverlayEffect . BlPaint . BlPaint class . BlPaintBackground . BlPaintBackground class . BlPaintBackgroundBuilder . BlParallelUniverse . BlParallelUniverse class . BlPathCache . BlPathCache class . BlPercentUnit . BlPerspectiveTransformation . BlPerspectiveTransformation class . BlPoint . BlPoint2D . BlPoint2D class . BlPoint3D . BlPoint3D class . BlPoint4D . BlPoint4D class . BlPolygonGeometry . BlPolygonGeometry class . BlPolygonHitTester class . BlPolylineGeometry . BlPolylineGeometry class . BlPtUnit . BlPulseLoopHost . BlQuaternion . BlQuaternion class . BlQuinticInterpolator . BlRadialGradientPaint . BlRay . BlRay class . BlRealTime . BlRectangleGeometry . BlReflectionTransformation . BlRelativeAlignment . BlRelativeAlignment class . BlRelativeElevation . BlRemUnit . BlRepeatedTask . BlRepeatedTaskAction . BlRightAlignment . BlRightAlignment class . BlRope . BlRope class . BlRopeIterator . BlRopeIterator class . BlRopeableCollectionFile . BlRotationTransformation . BlRoundedPolygonGeometry class . BlRoundedRectangleGeometry . BlRoundedRectangleGeometry class . BlScalingTransformation . BlScalingTransformation class . BlSelection . BlSelection class . BlSelectionHandler . BlSelectionNode . BlSelectionNode class . BlSelectionTree . BlShadowEffect . BlSharedEventDistributor . BlSharedEventDistributor class . BlShearTransformation . BlShortcutEvent . BlShortcutHandler . BlShortcutHandlerWithShortcuts . BlShortcutHandlerWithoutShortcuts . BlShortcutHandlerWithoutShortcuts class . BlShortcutRegistry . BlShortcutWithAction . BlSigmoidGeometry . BlSigmoidGeometry class . BlSimpleShadowEffect . BlSimpleShadowEffect class . BlSimulatedTime . BlSimulatedTime class . BlSineInterpolator . BlSingleErrorHandler . BlSingleKeyCombination . BlSingleKeyCombination class . BlSpace . BlSpace class . BlSpaceCloseRequest . BlSpaceClosedEvent . BlSpaceDragCancelEvent . BlSpaceDragDraggedEvent . BlSpaceDragDropEnterEvent . BlSpaceDragDropEvent . BlSpaceDragLiftEvent . BlSpaceEvent . BlSpaceEventListener . BlSpaceEventListener class . BlSpaceEventsProcessedEvent . BlSpaceFocusInEvent . BlSpaceFocusOutEvent . BlSpaceFrame . BlSpaceFrameDrawingPhase . BlSpaceFrameDrawingValidationPhase . BlSpaceFrameEventPhase . BlSpaceFrameHostValidationPhase . BlSpaceFrameLayoutPhase . BlSpaceFramePhase . BlSpaceFrameTaskPhase . BlSpaceIconChangedEvent . BlSpaceMouseEnterEvent . BlSpaceMouseLeaveEvent . BlSpaceMovedEvent . BlSpacePhaseEvent . BlSpaceReference . BlSpaceResizedEvent . BlSpaceShutdownOnCloseListener . BlSpaceTaskQueue . BlSpaceTaskQueue class . BlSquareGeometry . BlStadiumGeometry . BlStartAlignment class . BlStencil . BlStencil class . BlStrokeLineCap . BlStrokeLineCap class . BlStrokeLineJoin . BlStrokeLineJoin class . BlStrokeStyle . BlSubRope . BlSubRope class . BlSubRopeIterator . BlSynchronizedObjectPool . BlSynchronizedObjectPool class . BlTask . BlTaskAction . BlTaskAction class . BlTaskQueue . BlTextIndex . BlTextIndexEOS . BlTextInputBuffer . BlTextInputEvent . BlTime . BlTime class . BlTopAlignment . BlTopAlignment class . BlTransformationBuilder . BlTransformationBuilder class . BlTranslationTransformation . BlTranslationTransformation class . BlTransparentBackground . BlTransparentBackground class . BlTransparentPaint . BlTransparentPaint class . BlTriangleGeometry . BlUIEvent . BlUnit . BlUnit class . BlUseAsyncFeatures . BlUseAsyncFeatures class . BlValueWithUnit . BlValueWithUnit class . BlVector . BlVector class . BlVector2D . BlVector3D . BlVerticalAlignment . BlVerticalAlignment class . BlVerticalCenterAlignment . BlVerticalCenterAlignment class . BlVerticalCoordinateAlignment . BlVerticalCoordinateAlignment class . BlVerticalCoordinateBottomAlignment . BlVerticalCoordinateBottomAlignment class . BlVerticalCoordinateTopAlignment . BlVerticalCoordinateTopAlignment class . BlVerticesFromRectanglesOperator . BlVerticesFromRectanglesOperator class . BlViscousFluidInterpolator . BlViscousFluidInterpolator class . BlVisibility . BlVisibility class . BlVisualSelectionHandler . BlWidthEqualizer . Bloc class . Character . Collection . Color . DateAndTime . DateAndTime class . Form . FormSet . GncBPGrammarGenerator . KeyboardKey . KeyboardKey class . MateGenerator . MateOGGrammar . MatePaperBlocExperiment . MatePaperExperiment . MateParser . Number . OSPlatform . Object class . Point . ProcessList . String . TBlAlignable . TBlAnnounceable . TBlAnnouncerProvider . TBlDebug . TBlDebug classTrait . TBlEventTarget . TBlLayoutResizable . TBlOrientableLayout . TBlSingletonHost classTrait . TBlSpaceProperties . TBlTransformable . UndefinedObject . Unicode class } }
}

OCOptimizedBlockScope -> {
	outerScope: OCBlockScope | OCMethodScope | OCOptimizedBlockScope,
	tempVars: OrderedDictionary,
	copiedVars: OrderedDictionary,
	tempVector: OrderedDictionary,
	id: { type: SmallInteger, between: 1 and: 17 },
	tempVectorVar: TemporaryVariable?,
	node: { refType: OCProgramNode },
	isInlinedLoop: Boolean
}

OCParseErrorNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary,
	errorMessage: ByteString,
	value: ByteString,
	start: { type: SmallInteger, atLeast: 1 },
	stop: { type: SmallInteger, atLeast: 1 },
	errorPosition: { type: SmallInteger, atLeast: 1 }
}

OCPatternMessageNode -> {
	parent: { refType: OCProgramNode },
	receiver: OCMessageNode | OCPatternVariableNode,
	selector: OCSelectorNode,
	keywordsPositions: IntegerArray,
	isList: Boolean,
	isCascadeList: Boolean
}

OCPatternMethodNode -> {
	selector: { oneOf: { #''`@method:'' . #''`@methodName:'' } },
	keywordsPositions: IntegerArray,
	body: { refType: OCSequenceNode },
	source: ByteString,
	arguments: { type: [ OCPatternVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	pragmas: { type: [ Object ], sizeBetween: 0 and: 0 },
	replacements: SortedCollection,
	nodeReplacements: IdentityDictionary,
	isList: Boolean
}

OCPatternVariableNode -> {
	parent: { refType: OCProgramNode },
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	name: ByteSymbol,
	variable: OCUnresolvedVariable,
	start: { type: SmallInteger, between: 1 and: 213 },
	recurseInto: Boolean,
	isList: Boolean,
	isLiteral: Boolean,
	isStatement: Boolean,
	isAnything: Boolean
}

OCPragmaNode -> {
	parent: { refType: OCProgramNode },
	selector: ByteSymbol,
	keywordsPositions: IntegerArray,
	left: { type: SmallInteger, between: 6 and: 873 },
	right: { type: SmallInteger, between: 22 and: 889 },
	pragma: Pragma,
	invariants: { left < right }
}

OCReceiverDoItSemanticScope -> {
	targetReceiver: (Array | MatePaperBlocExperiment class | MatePaperExperiment class)?
}

OCRequestorScope -> {
	outerScope: OCReceiverDoItSemanticScope,
	requestor: SpCodePresenter | StPlaygroundInteractionModel,
	variables: Dictionary?
}

OCReturnNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	value: OCArrayNode | OCAssignmentNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCPatternVariableNode | OCVariableNode,
	start: { type: SmallInteger, between: 0 and: 2426 }
}

OCSelectorNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	value: ByteSymbol
}

OCSequenceNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	leftBar: { type: SmallInteger, between: 1 and: 2096, nullable: true },
	rightBar: { type: SmallInteger, between: 11 and: 2100, nullable: true },
	statements: { type: [ OCAssignmentErrorNode | OCAssignmentNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCPatternMessageNode | OCPatternVariableNode | OCReturnNode | OCUnfinishedStatementErrorNode | OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 32 },
	periods: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 31 },
	temporaries: { type: [ OCPatternVariableNode | OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 20 },
	selfReferences: { parent.body }
}

OCSyntaxErrorNotice -> {
	node: OCParseErrorNode | OCUnfinishedStatementErrorNode
}

OCUnfinishedStatementErrorNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary,
	errorMessage: { oneOf: { ''End of statement expected'' } },
	value: { oneOf: { '''' } },
	start: { type: SmallInteger, between: 123 and: 532 },
	stop: { type: SmallInteger, between: 142 and: 606 },
	errorPosition: { type: SmallInteger, between: 143 and: 607 },
	valueAfter: { oneOf: { '''' } },
	contents: { type: [ OCMessageNode ], sizeBetween: 0 and: 1 },
	invariants: { start < stop, start < errorPosition, stop < errorPosition }
}

OCVariableNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	name: ByteSymbol,
	variable: ArgumentVariable | ClassVariable | CopiedLocalVariable | GlobalVariable | InstanceVariableSlot | OCUnresolvedVariable | OCVectorTempVariable | SelfVariable | SuperVariable | TemporaryVariable | UndeclaredVariable | WorkspaceVariable,
	start: { type: SmallInteger, between: 0 and: 2659 }
}

OCVectorTempVariable -> {
	name: ByteSymbol,
	escaping: { oneOf: { #escapingWrite } },
	index: { type: SmallInteger, between: 1 and: 4, nullable: true },
	scope: OCBlockScope | OCMethodScope | OCOptimizedBlockScope,
	usage: { oneOf: { #repeatedWrite . #write } },
	vectorName: { oneOf: { ''0vector0'' . ''0vector1'' . ''0vector3'' } }
}

OCWarningNotice -> {
	messageText: { oneOf: { ''Unitialized variable'' } },
	node: OCVariableNode
}

OrderedDictionary -> {
	dictionary: Dictionary,
	orderedKeys: { type: [ ByteString | ByteSymbol | nil ], sizeBetween: 10 and: 33 }
}

Pragma -> {
	selector: { oneOf: { #event: . #reflection: . #return: . #return:of: . #return:or: . #script: } },
	arguments: { type: [ ByteString | ByteSymbol | nil ], sizeBetween: 1 and: 2 }
}

ProcessorScheduler -> {
	quiescentProcessLists: { type: [ ProcessList ], sizeBetween: 0 and: 80 }
}

RFMessageNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary,
	receiver: OCLiteralValueNode,
	selector: OCSelectorNode,
	arguments: { type: [ OCLiteralValueNode ], sizeBetween: 2 and: 2 }
}

Random -> {
	seed: { type: SmallInteger, atLeast: 1 }
}

SelfVariable -> {
	name: ByteSymbol
}

SmallDictionary -> {
	keys: { type: [ ByteSymbol | nil ], sizeBetween: 2 and: 8 },
	size: { type: SmallInteger, between: 1 and: 7 }
}

SmalltalkImage -> {
	vm: VirtualMachine
}

SortedCollection -> {
	array: { type: [ nil ], sizeBetween: 10 and: 10 },
	firstIndex: { type: SmallInteger, between: 1 and: 1 },
	lastIndex: { type: SmallInteger, between: 0 and: 0 }
}

SpCodePresenter -> {
	needRebuild: Boolean,
	properties: SmallDictionary,
	askOkToClose: Boolean,
	titleHolder: ByteString,
	visible: Boolean,
	styles: { type: [ Object ], sizeBetween: 0 and: 0 },
	dragEnabled: Boolean,
	dropEnabled: Boolean,
	enabled: Boolean,
	selection: Interval,
	text: ByteString,
	placeholder: ByteString,
	editable: Boolean,
	scrollValue: Point,
	editionContextMenu: Boolean,
	wrapWord: Boolean,
	undoRedoHistory: Boolean,
	wrapScrollBars: Boolean,
	propagateNaturalHeight: Boolean,
	propagateNaturalWidth: Boolean,
	scrollBarStyles: { type: [ Object ], sizeBetween: 0 and: 0 },
	syntaxHighlight: Boolean,
	smartCharacters: Boolean,
	lineNumbers: Boolean,
	interactionModel: StPlaygroundInteractionModel,
	overrideContextMenu: Boolean,
	selfReferences: { interactionModel.owner }
}

SparseLargeTable -> {
	base: { type: SmallInteger, atLeast: 1 },
	size: { type: SmallInteger, atLeast: 1 },
	chunkSize: { type: SmallInteger, atLeast: 1 },
	defaultValue: { type: SmallInteger, atLeast: 0 }
}

StPlaygroundInteractionModel -> {
	owner: { refType: SpCodePresenter },
	bindings: Dictionary
}

SuperVariable -> {
	name: ByteSymbol
}

TemporaryVariable -> {
	name: ByteString | ByteSymbol,
	escaping: Boolean | ByteSymbol,
	index: { type: SmallInteger, between: 1 and: 24, nullable: true },
	scope: OCBlockScope | OCMethodScope | OCOptimizedBlockScope,
	usage: { oneOf: { #repeatedWrite . #write . nil } }
}

UndeclaredVariable -> {
	name: ByteSymbol
}

WeakSet -> {
	tally: { type: SmallInteger, atLeast: 1 }
}

WorkspaceVariable -> {
	name: ByteSymbol,
	value: Array | BlElement | IdentitySet | MateBlocCompleteGrammar | MateOGGrammar | OrderedCollection
}'
]
