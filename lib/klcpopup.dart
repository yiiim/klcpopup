import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef _KLCPaintHandler = void Function(PaintingContext context, Offset offset, double animationValue);

enum KLCPopupShowType {
  none(),
  fadeIn(hasOpacity: true),
  growIn(hasOpacity: true, scale: 0.85),
  shrinkIn(hasOpacity: true, scale: 1.25),
  slideInFromTop,
  slideInFromBottom,
  slideInFromLeft,
  slideInFromRight,
  bounceIn(curve: ElasticOutCurve(0.8), duration: Duration(milliseconds: 600), scale: 0.1),
  bounceInFromTop(curve: ElasticOutCurve(0.8), duration: Duration(milliseconds: 600)),
  bounceInFromBottom(curve: ElasticOutCurve(0.8), duration: Duration(milliseconds: 600)),
  bounceInFromLeft(curve: ElasticOutCurve(0.8), duration: Duration(milliseconds: 600)),
  bounceInFromRight(curve: ElasticOutCurve(0.8), duration: Duration(milliseconds: 600));

  final bool hasOpacity;
  final Curve curve;
  final Duration duration;
  final double? scale;
  const KLCPopupShowType({
    this.hasOpacity = false,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 200),
    this.scale,
  });
}

enum KLCPopupDismissType {
  none,
  fadeOut(hasOpacity: true),
  growOut(hasOpacity: true, scale: 1.25),
  shrinkOut(hasOpacity: true, scale: 0.85),
  slideOutToTop,
  slideOutToBottom,
  slideOutToLeft,
  slideOutToRight,
  bounceOut(curve: FlippedCurve(ElasticInCurve(0.8)), duration: Duration(milliseconds: 600), scale: 0.1),
  bounceOutToTop(curve: FlippedCurve(ElasticInCurve(0.8)), duration: Duration(milliseconds: 600)),
  bounceOutToBottom(curve: FlippedCurve(ElasticInCurve(0.8)), duration: Duration(milliseconds: 600)),
  bounceOutToLeft(curve: FlippedCurve(ElasticInCurve(0.8)), duration: Duration(milliseconds: 600)),
  bounceOutToRight(curve: FlippedCurve(ElasticInCurve(0.8)), duration: Duration(milliseconds: 600));

  final bool hasOpacity;
  final Curve curve;
  final Duration duration;
  final double? scale;
  const KLCPopupDismissType({
    this.hasOpacity = false,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 200),
    this.scale,
  });
}

enum KLCPopupHorizontalLayout {
  custom,
  left,
  leftOfCenter,
  center,
  rightOfCenter,
  right;
}

enum KLCPopupVerticalLayout {
  custom,
  top,
  topOfCenter,
  center,
  bottomOfCenter,
  bottom;
}

enum KLCPopupMaskType {
  /// Allow interaction with underlying views.
  none,

  /// Don't allow interaction with underlying views.
  clear,

  /// Don't allow interaction with underlying views, dim background.
  dimmed,
}

enum _KLCPopupViewState {
  idel,
  showing,
  dismissing,
  show,
  dismiss,
}

/// Show the popup with the given [child] widget.
///
/// The [child] widget is the content of the popup.
///
/// [animationBuilder] is a custom animation builder, if this value is set, [showType] and [dismissType] may not work as expected.
///
/// [animationDuration] is the custom animation duration.
///
/// [duration] is the delay dismiss duration.
///
/// [showType] is the animation transition for presenting contentView. default = shrink in.
///
/// [dismissType] is the animation transition for dismissing contentView. default = shrink out.
///
/// [horizontalLayout] controls where the popup will come to rest horizontally.
///
/// [verticalLayout] controls where the popup will come to rest vertically.
///
/// [maskType] prevents background touches from passing to underlying views. default = dimmed.
///
/// [dimmedMaskAlpha] overrides alpha value for dimmed background mask. default = 0.5.
///
/// [shouldDismissOnBackgroundTouch] if YES, then popup will get dismissed when background is touched. default = YES.
///
/// [shouldDismissOnContentTouch] if YES, then popup will get dismissed when content view is touched. default = NO.
///
/// [offset] layout offset.
///
/// [showCurve] custom display animation curve. If this value is set, [showType] may not work as expected.
///
/// [dismissCurve] custom dismiss animation curve. If this value is set, [dismissType] may not work as expected.
///
/// [controller] popup controller.
///
/// [useRoute] if YES, then the popup will be shown as a route.
Future<T?> showKLCPopup<T>(
  BuildContext context, {
  required Widget child,
  Widget Function(BuildContext context, Animation<double> animation)? animationBuilder,
  Duration? animationDuration,
  Duration? duration,
  KLCPopupShowType showType = KLCPopupShowType.slideInFromTop,
  KLCPopupDismissType dismissType = KLCPopupDismissType.slideOutToTop,
  KLCPopupHorizontalLayout horizontalLayout = KLCPopupHorizontalLayout.center,
  KLCPopupVerticalLayout verticalLayout = KLCPopupVerticalLayout.center,
  KLCPopupMaskType maskType = KLCPopupMaskType.dimmed,
  double dimmedMaskAlpha = 0.5,
  bool shouldDismissOnBackgroundTouch = true,
  bool shouldDismissOnContentTouch = false,
  Offset? offset,
  Curve? showCurve,
  Curve? dismissCurve,
  KLCPopupController? controller,
  bool useRoute = false,
}) {
  if (useRoute) {
    return Navigator.of(context).push<T>(
      KLCPopupRoute<T>(
        shouldDismissOnBackgroundTouch: shouldDismissOnBackgroundTouch,
        shouldDismissOnContentTouch: shouldDismissOnContentTouch,
        animationDuration: animationDuration,
        duration: duration,
        showType: showType,
        dismissType: dismissType,
        offset: offset,
        showCurve: showCurve,
        horizontalLayout: horizontalLayout,
        verticalLayout: verticalLayout,
        dismissCurve: dismissCurve,
        animationBuilder: animationBuilder,
        dimmedMaskAlpha: dimmedMaskAlpha,
        maskType: maskType,
        popupController: controller,
        child: child,
      ),
    );
  } else {
    Completer<T> completer = Completer<T>();
    late WeakReference<OverlayEntry> weakOverlayEntry;
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return KLCPopup<T>(
          shouldDismissOnBackgroundTouch: shouldDismissOnBackgroundTouch,
          shouldDismissOnContentTouch: shouldDismissOnContentTouch,
          animationDuration: animationDuration,
          duration: duration,
          showType: showType,
          dismissType: dismissType,
          offset: offset,
          showCurve: showCurve,
          horizontalLayout: horizontalLayout,
          verticalLayout: verticalLayout,
          dismissCurve: dismissCurve,
          animationBuilder: animationBuilder,
          dimmedMaskAlpha: dimmedMaskAlpha,
          maskType: maskType,
          didFinishDismissingCompletion: (T? result) {
            weakOverlayEntry.target?.remove();
            completer.complete(result);
          },
          controller: controller,
          child: child,
        );
      },
    );
    weakOverlayEntry = WeakReference(overlayEntry);
    Overlay.of(context).insert(overlayEntry);
    return completer.future;
  }
}

extension _KLCPopupMatrix4 on Matrix4 {
  Matrix4 scaledAtCenter(Size size, dynamic x, [double? y, double? z]) {
    final result = clone();
    Offset translation = Alignment.center.alongSize(size);
    result.translate(translation.dx, translation.dy);
    result.scale(x, y, z);
    result.translate(-translation.dx, -translation.dy);
    return result;
  }
}

class KLCPopupController {
  _KLCPopupState? _state;
  void _attach(_KLCPopupState state) => _state = state;
  void _detach() => _state = null;
  void show() => _state?.show();
  void dismiss([dynamic result]) => _state?.dismiss(result);
}

class KLCPopupRoute<T> extends PopupRoute<T> {
  KLCPopupRoute({
    required this.child,
    this.animationDuration,
    this.showType = KLCPopupShowType.slideInFromTop,
    this.showCurve,
    this.dismissType = KLCPopupDismissType.slideOutToTop,
    this.dismissCurve,
    this.maskType = KLCPopupMaskType.dimmed,
    this.dimmedMaskAlpha = 0.5,
    this.shouldDismissOnBackgroundTouch = true,
    this.shouldDismissOnContentTouch = false,
    this.horizontalLayout = KLCPopupHorizontalLayout.center,
    this.verticalLayout = KLCPopupVerticalLayout.center,
    this.didFinishShowingCompletion,
    this.willStartDismissingCompletion,
    this.didFinishDismissingCompletion,
    this.offset,
    this.popupController,
    this.animationBuilder,
    this.duration,
  });
  final KLCPopupShowType showType;
  final Curve? showCurve;
  final KLCPopupDismissType dismissType;
  final Curve? dismissCurve;
  final KLCPopupMaskType maskType;
  final double dimmedMaskAlpha;
  final bool shouldDismissOnBackgroundTouch;
  final bool shouldDismissOnContentTouch;
  final KLCPopupHorizontalLayout horizontalLayout;
  final KLCPopupVerticalLayout verticalLayout;
  final Offset? offset;
  final void Function()? didFinishShowingCompletion;
  final void Function(T? result)? willStartDismissingCompletion;
  final void Function(T? result)? didFinishDismissingCompletion;
  final Duration? animationDuration;
  final Widget Function(BuildContext context, Animation<double> animation)? animationBuilder;
  final Widget child;
  final KLCPopupController? popupController;
  final Duration? duration;
  @override
  Color? get barrierColor => null;
  @override
  String? get barrierLabel => null;
  @override
  bool get barrierDismissible => shouldDismissOnBackgroundTouch;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return KLCPopup<T>(
      animationDuration: animationDuration,
      showType: showType,
      showCurve: showCurve,
      dismissType: dismissType,
      dismissCurve: dismissCurve,
      maskType: maskType,
      dimmedMaskAlpha: dimmedMaskAlpha,
      shouldDismissOnBackgroundTouch: shouldDismissOnBackgroundTouch,
      shouldDismissOnContentTouch: shouldDismissOnContentTouch,
      horizontalLayout: horizontalLayout,
      verticalLayout: verticalLayout,
      didFinishShowingCompletion: null,
      willStartDismissingCompletion: null,
      didFinishDismissingCompletion: null,
      offset: offset,
      controller: popupController,
      animationBuilder: animationBuilder,
      duration: duration,
      useRoute: true,
      routeAnimation: animation,
      child: child,
    );
  }

  @override
  Duration get transitionDuration => animationDuration ?? showType.duration;

  @override
  Duration get reverseTransitionDuration => animationDuration ?? dismissType.duration;
  dynamic _result;
  @override
  void install() {
    super.install();
    controller?.addStatusListener(_controllerStatusListener);
  }

  @override
  bool didPop(T? result) {
    _result = result;
    willStartDismissingCompletion?.call(result);
    return super.didPop(result);
  }

  @override
  void dispose() {
    controller?.removeStatusListener(_controllerStatusListener);
    super.dispose();
  }

  void _controllerStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      didFinishShowingCompletion?.call();
    } else if (status == AnimationStatus.dismissed) {
      didFinishDismissingCompletion?.call(_result);
    }
  }
}

class KLCPopup<T> extends StatefulWidget {
  const KLCPopup({
    super.key,
    required this.child,
    this.animationDuration,
    this.showType = KLCPopupShowType.slideInFromTop,
    this.showCurve,
    this.dismissType = KLCPopupDismissType.slideOutToTop,
    this.dismissCurve,
    this.maskType = KLCPopupMaskType.dimmed,
    this.dimmedMaskAlpha = 0.5,
    this.shouldDismissOnBackgroundTouch = true,
    this.shouldDismissOnContentTouch = false,
    this.horizontalLayout = KLCPopupHorizontalLayout.center,
    this.verticalLayout = KLCPopupVerticalLayout.center,
    this.didFinishShowingCompletion,
    this.willStartDismissingCompletion,
    this.didFinishDismissingCompletion,
    this.offset,
    this.controller,
    this.animationBuilder,
    this.duration,
    this.useRoute = false,
    this.routeAnimation,
  });

  /// Animation transition for presenting contentView. default = shrink in
  final KLCPopupShowType showType;

  /// Custom display animation curve. If this value is set, [showType] may not work as expected.
  final Curve? showCurve;

  /// Animation transition for dismissing contentView. default = shrink out
  final KLCPopupDismissType dismissType;

  /// Custom dismiss animation curve. If this value is set, [dismissType] may not work as expected.
  final Curve? dismissCurve;

  /// Mask prevents background touches from passing to underlying views. default = dimmed.
  final KLCPopupMaskType maskType;

  /// Overrides alpha value for dimmed background mask. default = 0.5
  final double dimmedMaskAlpha;

  /// If YES, then popup will get dismissed when background is touched. default = YES.
  final bool shouldDismissOnBackgroundTouch;

  /// If YES, then popup will get dismissed when content view is touched. default = NO.
  final bool shouldDismissOnContentTouch;

  /// Controls where the popup will come to rest horizontally.
  final KLCPopupHorizontalLayout horizontalLayout;

  /// Controls where the popup will come to rest vertically.
  final KLCPopupVerticalLayout verticalLayout;

  /// Layout offset.
  final Offset? offset;

  /// called after show animation finishes
  final void Function()? didFinishShowingCompletion;

  /// called when dismiss animation starts
  final bool Function(T? result)? willStartDismissingCompletion;

  /// called after dismiss animation finishes
  final void Function(T? result)? didFinishDismissingCompletion;

  /// Custom animation duration.
  final Duration? animationDuration;

  /// Custom animation builder.
  final Widget Function(BuildContext context, Animation<double> animation)? animationBuilder;

  /// Popup content view
  final Widget child;

  /// Popup controller.
  final KLCPopupController? controller;

  /// Delay dismiss duration.
  final Duration? duration;
  final bool useRoute;
  final Animation<double>? routeAnimation;
  @override
  State<StatefulWidget> createState() => _KLCPopupState();
}

class _KLCPopupState extends State<KLCPopup> with SingleTickerProviderStateMixin {
  _KLCPopupViewState state = _KLCPopupViewState.idel;
  Timer? _delayDismissTimer;
  late final AnimationController _controller = AnimationController(
    duration: widget.animationDuration,
    vsync: this,
  );
  final GlobalKey _childKey = GlobalKey();

  Animation<double> get _effectiveAnimation {
    return widget.useRoute ? widget.routeAnimation! : _controller;
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
    if (!widget.useRoute) {
      show();
    } else {
      assert(widget.routeAnimation != null);
      assert(widget.routeAnimation?.status == AnimationStatus.completed || widget.routeAnimation?.status == AnimationStatus.forward);
      state = widget.routeAnimation?.status == AnimationStatus.completed ? _KLCPopupViewState.show : _KLCPopupViewState.showing;
      widget.routeAnimation?.addStatusListener(
        (status) {
          state = switch (status) {
            AnimationStatus.completed => _KLCPopupViewState.show,
            AnimationStatus.dismissed => _KLCPopupViewState.dismiss,
            AnimationStatus.reverse => _KLCPopupViewState.dismissing,
            AnimationStatus.forward => _KLCPopupViewState.showing,
          };
          if (mounted) setState(() {});
        },
      );
    }
  }

  @override
  void didUpdateWidget(covariant KLCPopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller?._detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Builder(
      key: _childKey,
      builder: (context) {
        return widget.child;
      },
    );
    if (widget.animationBuilder != null) {
      child = AnimatedBuilder(
        animation: _effectiveAnimation,
        builder: (context, child) {
          return widget.animationBuilder?.call(context, _effectiveAnimation) ?? widget.child;
        },
      );
    }
    child = _KLCPopupRenderObjectWidget(
      animation: _effectiveAnimation,
      state: state,
      showType: widget.showType,
      dismissType: widget.dismissType,
      horizontalLayout: widget.horizontalLayout,
      verticalLayout: widget.verticalLayout,
      offset: widget.offset,
      dimmedMaskAlpha: widget.dimmedMaskAlpha,
      maskType: widget.maskType,
      child: child,
    );
    child = Listener(
      behavior: widget.maskType == KLCPopupMaskType.none ? HitTestBehavior.translucent : HitTestBehavior.opaque,
      onPointerUp: (point) {
        final renderObject = _childKey.currentContext?.findRenderObject();
        if (renderObject is RenderBox) {
          Rect rect = renderObject.paintBounds;
          rect = (renderObject.localToGlobal(Offset.zero) & rect.size);
          if (!rect.contains(point.position)) {
            if (widget.shouldDismissOnBackgroundTouch) {
              dismiss();
            }
          } else {
            if (widget.shouldDismissOnContentTouch) {
              dismiss();
            }
          }
        }
      },
      child: child,
    );

    return child;
  }

  void _updateDelayDismiss() {
    if (widget.duration != null) {
      _delayDismissTimer?.cancel();
      _delayDismissTimer = Timer(
        widget.duration!,
        () {
          dismiss();
        },
      );
    }
  }

  void show() {
    if (widget.useRoute) return;
    assert(state == _KLCPopupViewState.idel, "popup only can show once");
    if (!mounted) return;
    if (state != _KLCPopupViewState.idel) {
      return;
    }
    state = _KLCPopupViewState.showing;
    if (widget.showType == KLCPopupShowType.none) {
      state = _KLCPopupViewState.show;
      _controller.value = 1;
    } else {
      _controller.animateTo(1, duration: widget.animationDuration ?? widget.showType.duration).then(
        (value) {
          state = _KLCPopupViewState.show;
          widget.didFinishShowingCompletion?.call();
          _updateDelayDismiss();
          if (mounted) setState(() {});
        },
      );
    }
    setState(() {});
  }

  void dismiss([dynamic result]) {
    if (!mounted) return;
    if (state == _KLCPopupViewState.dismissing || state == _KLCPopupViewState.dismiss) {
      return;
    }
    if (widget.useRoute) {
      final route = ModalRoute.of(context);
      if (route == null) return;
      if (route.isCurrent) {
        Navigator.of(context).pop(result);
      } else {
        Navigator.of(context).removeRoute(route);
        state = _KLCPopupViewState.dismiss;
      }
    } else {
      if (state == _KLCPopupViewState.showing) {
        _controller.stop();
      }
      state = _KLCPopupViewState.dismissing;
      if (widget.dismissType == KLCPopupDismissType.none) {
        state = _KLCPopupViewState.dismiss;
        _controller.value = 0;
        widget.didFinishDismissingCompletion?.call(result);
      } else {
        _controller.animateBack(0, duration: widget.animationDuration ?? widget.dismissType.duration).then(
          (value) {
            state = _KLCPopupViewState.dismiss;
            widget.didFinishDismissingCompletion?.call(result);
            if (mounted) setState(() {});
          },
        );
      }
      setState(() {});
    }
  }
}

class _KLCPopupRenderObjectWidget extends SingleChildRenderObjectWidget {
  const _KLCPopupRenderObjectWidget({
    required super.child,
    this.animation,
    this.state = _KLCPopupViewState.idel,
    this.showType = KLCPopupShowType.slideInFromTop,
    this.dismissType = KLCPopupDismissType.slideOutToTop,
    this.horizontalLayout = KLCPopupHorizontalLayout.center,
    this.verticalLayout = KLCPopupVerticalLayout.center,
    this.maskType = KLCPopupMaskType.dimmed,
    this.dimmedMaskAlpha = 0.5,
    this.offset,
  });
  final Animation<double>? animation;
  final _KLCPopupViewState state;
  final KLCPopupShowType showType;
  final KLCPopupDismissType dismissType;
  final KLCPopupHorizontalLayout horizontalLayout;
  final KLCPopupVerticalLayout verticalLayout;
  final KLCPopupMaskType maskType;
  final double dimmedMaskAlpha;
  final Offset? offset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _KLCPopupRenderObject(
      state: state,
      animation: animation,
      showType: showType,
      dismissType: dismissType,
      horizontalLayout: horizontalLayout,
      verticalLayout: verticalLayout,
      dimmedMaskAlpha: dimmedMaskAlpha,
      maskType: maskType,
      offset: offset,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderObject renderObject) {
    if (renderObject is _KLCPopupRenderObject) {
      renderObject
        ..state = state
        ..animation = animation
        ..showType = showType
        ..dismissType = dismissType
        ..horizontalLayout = horizontalLayout
        ..verticalLayout = verticalLayout
        ..maskType = maskType
        ..dimmedMaskAlpha = dimmedMaskAlpha
        ..offset = offset;
    }
  }
}

class _KLCPopupRenderObject extends RenderShiftedBox {
  _KLCPopupRenderObject({
    RenderBox? child,
    Animation<double>? animation,
    _KLCPopupViewState state = _KLCPopupViewState.idel,
    KLCPopupShowType showType = KLCPopupShowType.slideInFromTop,
    KLCPopupDismissType dismissType = KLCPopupDismissType.none,
    KLCPopupHorizontalLayout horizontalLayout = KLCPopupHorizontalLayout.center,
    KLCPopupVerticalLayout verticalLayout = KLCPopupVerticalLayout.center,
    KLCPopupMaskType maskType = KLCPopupMaskType.dimmed,
    double dimmedMaskAlpha = 0.5,
    Offset? offset,
  })  : _animation = animation,
        super(child) {
    this.animation = animation;
    _state = state;
    _showType = showType;
    _dismissType = dismissType;
    _horizontalLayout = horizontalLayout;
    _verticalLayout = verticalLayout;
    _dimmedMaskAlpha = dimmedMaskAlpha;
    _maskType = maskType;
    _offset = offset;
  }

  Animation<double>? _animation;
  Animation<double>? get animation => _animation;
  set animation(Animation<double>? value) {
    if (_animation == value) {
      return;
    }
    if (attached) {
      animation?.removeListener(_animationUpdate);
    }
    _animation = value;
    if (attached) {
      animation?.addListener(_animationUpdate);
    }
    _animationUpdate();
  }

  _KLCPopupViewState _state = _KLCPopupViewState.idel;
  _KLCPopupViewState get state => _state;
  set state(_KLCPopupViewState value) {
    if (_state != value) {
      _state = value;
      _animationUpdate();
    }
  }

  KLCPopupMaskType _maskType = KLCPopupMaskType.dimmed;
  KLCPopupMaskType get maskType => _maskType;
  set maskType(KLCPopupMaskType value) {
    if (_maskType != value) {
      _maskType = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  double _dimmedMaskAlpha = 0.5;
  double get dimmedMaskAlpha => _dimmedMaskAlpha;
  set dimmedMaskAlpha(double value) {
    if (_dimmedMaskAlpha != value) {
      _dimmedMaskAlpha = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  KLCPopupShowType _showType = KLCPopupShowType.slideInFromTop;
  KLCPopupShowType get showType => _showType;
  set showType(KLCPopupShowType value) {
    if (_showType != value) {
      _showType = value;
      _updateShowBeginPosition();
    }
  }

  Curve? _showCurve;
  Curve? get showCurve => _showCurve;
  set showCurve(Curve? value) {
    if (_showCurve != value) {
      _showCurve = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  KLCPopupDismissType _dismissType = KLCPopupDismissType.none;
  KLCPopupDismissType get dismissType => _dismissType;
  set dismissType(KLCPopupDismissType value) {
    if (_dismissType != value) {
      _dismissType = value;
      _updateDismissEndPosition();
    }
  }

  Curve? _dismissCurve;
  Curve? get dismissCurve => _dismissCurve;
  set dismissCurve(Curve? value) {
    if (_dismissCurve != value) {
      _dismissCurve = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  KLCPopupHorizontalLayout _horizontalLayout = KLCPopupHorizontalLayout.center;
  KLCPopupHorizontalLayout get horizontalLayout => _horizontalLayout;
  set horizontalLayout(KLCPopupHorizontalLayout value) {
    if (_horizontalLayout != value) {
      _horizontalLayout = value;
      _updateTargetPosition();
    }
  }

  KLCPopupVerticalLayout _verticalLayout = KLCPopupVerticalLayout.center;
  KLCPopupVerticalLayout get verticalLayout => _verticalLayout;
  set verticalLayout(KLCPopupVerticalLayout value) {
    if (_verticalLayout != value) {
      _verticalLayout = value;
      _updateTargetPosition();
    }
  }

  Offset? _offset;
  Offset? get offset => _offset;
  set offset(Offset? value) {
    if (_offset != value) {
      _offset = value;
      _updateTargetPosition();
    }
  }

  Curve? get _effectiveShowCurve {
    return _showCurve ?? _showType.curve;
  }

  Curve? get _effectiveDismissCurve {
    return _dismissCurve ?? _dismissType.curve;
  }

  Offset _targetPosition = Offset.zero;
  Offset _showBeginPosition = Offset.zero;
  Offset _dismissEndPosition = Offset.zero;

  Size? _lastLayoutChildSize;
  Size? _lastLayoutSelfSize;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    animation?.addListener(_animationUpdate);
  }

  @override
  void detach() {
    animation?.removeListener(_animationUpdate);
    super.detach();
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    child!.layout(_childConstraints(), parentUsesSize: true);
    if (child!.size != _lastLayoutChildSize || size != _lastLayoutSelfSize) {
      _updateTargetPosition();
      _updateShowBeginPosition();
      _updateDismissEndPosition();
      _lastLayoutChildSize = child!.size;
      _lastLayoutSelfSize = size;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (state == _KLCPopupViewState.idel || state == _KLCPopupViewState.dismiss) {
      return;
    }
    if (maskType == KLCPopupMaskType.dimmed) {
      Color bgColor = Colors.transparent;
      if (animation != null && (state == _KLCPopupViewState.showing || state == _KLCPopupViewState.dismissing || state == _KLCPopupViewState.show)) {
        bgColor = ColorTween(begin: Colors.transparent, end: Colors.black.withOpacity(dimmedMaskAlpha)).evaluate(animation!)!;
      }
      final paint = Paint()
        ..color = bgColor
        ..style = PaintingStyle.fill;
      context.canvas.drawRect(offset & size, paint);
    }

    _KLCPaintHandler handler = paintChild;
    handler = _withAlphaIfNeed(handler);
    handler = _withTransformIfNeed(handler);
    handler(
      context,
      offset,
      switch (state) {
        _KLCPopupViewState.showing => _effectiveShowCurve?.transform(animation!.value) ?? animation!.value,
        _KLCPopupViewState.dismissing => _effectiveDismissCurve?.transform(animation!.value) ?? animation!.value,
        _ => 1,
      },
    );
  }

  _KLCPaintHandler _withAlphaIfNeed(_KLCPaintHandler handler) {
    return (PaintingContext context, Offset offset, double animationValue) {
      final alpha = switch ((animationValue, state, showType, dismissType)) {
        (1, _, _, _) => 1,
        (_, _KLCPopupViewState.showing, KLCPopupShowType(hasOpacity: true), _) => animationValue,
        (_, _KLCPopupViewState.dismissing, _, KLCPopupDismissType(hasOpacity: true)) => animationValue,
        _ => 1,
      };
      if (animationValue == 1) {
        handler(context, offset, animationValue);
        return;
      }
      if (alpha == 0) return;
      context.pushOpacity(
        offset,
        (alpha * 255).toInt(),
        (context, offset) {
          handler(context, offset, animationValue);
        },
      );
    };
  }

  TransformLayer? _oldLayer;

  _KLCPaintHandler _withTransformIfNeed(_KLCPaintHandler handler) {
    return (PaintingContext context, Offset offset, double animationValue) {
      _oldLayer = null;
      if (animationValue == 1) {
        handler(context, offset, animationValue);
        return;
      }
      Matrix4 transform = Matrix4.identity();
      final animationOffset = switch (state) {
        _KLCPopupViewState.showing => Offset.lerp(_showBeginPosition, _targetPosition, animationValue)!,
        _KLCPopupViewState.dismissing => Offset.lerp(_dismissEndPosition, _targetPosition, animationValue)!,
        _ => Offset.zero,
      };
      if (animationOffset != Offset.zero) {
        final Offset effectiveOffset = animationOffset - _targetPosition;
        transform.translate(effectiveOffset.dx, effectiveOffset.dy);
      }
      final animationScale = switch ((animationValue, state, showType, dismissType)) {
        (1, _, _, _) => 1,
        (_, _KLCPopupViewState.showing, KLCPopupShowType(scale: double scale), _) => lerpDouble(scale, 1, animationValue),
        (_, _KLCPopupViewState.dismissing, _, KLCPopupDismissType(scale: double scale)) => lerpDouble(scale, 1, animationValue),
        _ => 1,
      };
      if (animationScale != 1) {
        transform = transform.scaledAtCenter(size, animationScale);
      }
      if (transform != Matrix4.identity()) {
        _oldLayer = context.pushTransform(
          true,
          offset,
          transform,
          (context, offset) {
            handler(context, offset, animationValue);
          },
          oldLayer: _oldLayer,
        );
      } else {
        handler(context, offset, animationValue);
      }
    };
  }

  void paintChild(PaintingContext context, Offset offset, double animationValue) {
    final parentData = child!.parentData as BoxParentData;
    context.paintChild(child!, parentData.offset + offset);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (state == _KLCPopupViewState.show) {
      return super.hitTest(result, position: position);
    }
    return false;
  }

  BoxConstraints _childConstraints() {
    return BoxConstraints(
      maxWidth: switch (horizontalLayout) {
        KLCPopupHorizontalLayout.leftOfCenter || KLCPopupHorizontalLayout.rightOfCenter => size.width / 2,
        _ => size.width,
      },
      maxHeight: switch (verticalLayout) {
        KLCPopupVerticalLayout.topOfCenter || KLCPopupVerticalLayout.bottomOfCenter => size.height / 2,
        _ => size.height,
      },
    );
  }

  void _animationUpdate() {
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  void _updateTargetPosition() {
    final double width = child!.size.width;
    final double height = child!.size.height;
    final result = Offset(
          switch (horizontalLayout) {
            KLCPopupHorizontalLayout.custom => 0,
            KLCPopupHorizontalLayout.left => 0,
            KLCPopupHorizontalLayout.leftOfCenter => (size.width - width) / 4,
            KLCPopupHorizontalLayout.center => (size.width - width) / 2,
            KLCPopupHorizontalLayout.rightOfCenter => (size.width - width) * 3 / 4,
            KLCPopupHorizontalLayout.right => size.width - width,
          },
          switch (verticalLayout) {
            KLCPopupVerticalLayout.custom => 0,
            KLCPopupVerticalLayout.top => 0,
            KLCPopupVerticalLayout.topOfCenter => (size.height - height) / 4,
            KLCPopupVerticalLayout.center => (size.height - height) / 2,
            KLCPopupVerticalLayout.bottomOfCenter => (size.height - height) * 3 / 4,
            KLCPopupVerticalLayout.bottom => size.height - height,
          },
        ) +
        (offset ?? Offset.zero);
    if (_targetPosition != result) {
      _targetPosition = result;
      final parentData = child!.parentData as BoxParentData;
      parentData.offset = _targetPosition;
    }
  }

  void _updateShowBeginPosition() {
    _showBeginPosition = switch (showType) {
      KLCPopupShowType.slideInFromTop || KLCPopupShowType.bounceInFromTop => Offset(_targetPosition.dx, -child!.size.height),
      KLCPopupShowType.slideInFromBottom || KLCPopupShowType.bounceInFromBottom => Offset(_targetPosition.dx, size.height),
      KLCPopupShowType.slideInFromLeft || KLCPopupShowType.bounceInFromLeft => Offset(-child!.size.width, _targetPosition.dy),
      KLCPopupShowType.slideInFromRight || KLCPopupShowType.bounceInFromRight => Offset(size.width, _targetPosition.dy),
      _ => _targetPosition,
    };
  }

  void _updateDismissEndPosition() {
    _dismissEndPosition = switch (dismissType) {
      KLCPopupDismissType.slideOutToTop || KLCPopupDismissType.bounceOutToTop => Offset(_targetPosition.dx, -child!.size.height),
      KLCPopupDismissType.slideOutToBottom || KLCPopupDismissType.bounceOutToBottom => Offset(_targetPosition.dx, size.height),
      KLCPopupDismissType.slideOutToLeft || KLCPopupDismissType.bounceOutToLeft => Offset(-child!.size.width, _targetPosition.dy),
      KLCPopupDismissType.slideOutToRight || KLCPopupDismissType.bounceOutToRight => Offset(size.width, _targetPosition.dy),
      _ => _targetPosition,
    };
  }
}
