import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class _ChildEntry {
  _ChildEntry({
    required this.controller,
    required this.animation,
    required this.transition,
    required this.widgetChild,
  })  : assert(animation != null),
        assert(transition != null),
        assert(controller != null);
  final AnimationController controller;
  final Animation<double> animation;
  Widget transition;
  Widget widgetChild;
  @override
  String toString() => 'Entry#${shortHash(this)}($widgetChild)';
}

typedef AnimatedSwitcherTransitionBuilder = Widget Function(
  Widget child,
  Animation<double> animation,
);
typedef AnimatedSwitcherLayoutBuilder = Widget Function(
  AlignmentGeometry alignment,
  Widget currentChild,
  List<Widget> previousChildren,
);

class AnimatedSwitcherWidget extends StatefulWidget {
  const AnimatedSwitcherWidget({
    Key? key,
    this.child,
    required this.duration,
    this.reverseDuration,
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
    this.transitionBuilder = AnimatedSwitcherWidget.defaultTransitionBuilder,
    this.layoutBuilder = AnimatedSwitcherWidget.defaultLayoutBuilder,
    this.alignment = Alignment.topLeft,
  })  : assert(duration != null),
        assert(switchInCurve != null),
        assert(switchOutCurve != null),
        assert(transitionBuilder != null),
        assert(layoutBuilder != null),
        super(key: key);
  final Widget? child;
  final Duration duration;
  final Duration? reverseDuration;
  final Curve switchInCurve;
  final AlignmentGeometry alignment;
  final Curve switchOutCurve;
  final AnimatedSwitcherTransitionBuilder transitionBuilder;
  final AnimatedSwitcherLayoutBuilder layoutBuilder;

  @override
  _AnimatedSwitcherState createState() => _AnimatedSwitcherState();
  static Widget defaultTransitionBuilder(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  static Widget defaultLayoutBuilder(
    AlignmentGeometry alignment,
    Widget currentChild,
    List<Widget> previousChildren,
  ) {
    return Stack(
      children: <Widget>[
        ...previousChildren,
        if (currentChild != null) currentChild,
      ],
      alignment: alignment,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('duration', duration.inMilliseconds, unit: 'ms'));
    properties.add(IntProperty('reverseDuration', reverseDuration?.inMilliseconds, unit: 'ms', defaultValue: null));
  }
}

class _AnimatedSwitcherState extends State<AnimatedSwitcherWidget> with TickerProviderStateMixin {
  _ChildEntry? _currentEntry;
  final Set<_ChildEntry> _outgoingEntries = <_ChildEntry>{};
  List<Widget> _outgoingWidgets = const <Widget>[];
  int _childNumber = 0;

  @override
  void initState() {
    super.initState();
    _addEntryForNewChild(animate: false);
  }

  @override
  void didUpdateWidget(AnimatedSwitcherWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transitionBuilder != oldWidget.transitionBuilder) {
      _outgoingEntries.forEach(_updateTransitionForEntry);
      if (_currentEntry != null) _updateTransitionForEntry(_currentEntry!);
      _markChildWidgetCacheAsDirty();
    }

    final bool hasNewChild = widget.child != null;
    final bool hasOldChild = _currentEntry != null;
    if (hasNewChild != hasOldChild || hasNewChild && !Widget.canUpdate(widget.child!, _currentEntry!.widgetChild)) {
      _childNumber += 1;
      _addEntryForNewChild(animate: true);
    } else if (_currentEntry != null) {
      assert(hasOldChild && hasNewChild);
      assert(Widget.canUpdate(widget.child!, _currentEntry!.widgetChild));
      _currentEntry!.widgetChild = widget.child!;
      _updateTransitionForEntry(_currentEntry!); // uses entry.widgetChild
      _markChildWidgetCacheAsDirty();
    }
  }

  void _addEntryForNewChild({required bool animate}) {
    assert(animate || _currentEntry == null);
    if (_currentEntry != null) {
      assert(animate);
      assert(!_outgoingEntries.contains(_currentEntry));
      _outgoingEntries.add(_currentEntry!);
      _currentEntry!.controller.reverse();
      _markChildWidgetCacheAsDirty();
      _currentEntry = null;
    }
    if (widget.child == null) return;
    final AnimationController controller = AnimationController(
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      vsync: this,
    );
    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: widget.switchInCurve,
      reverseCurve: widget.switchOutCurve,
    );
    _currentEntry = _newEntry(
      child: widget.child!,
      controller: controller,
      animation: animation,
      builder: widget.transitionBuilder,
    );
    if (animate) {
      controller.forward();
    } else {
      assert(_outgoingEntries.isEmpty);
      controller.value = 1.0;
    }
  }

  _ChildEntry _newEntry({
    required Widget child,
    required AnimatedSwitcherTransitionBuilder builder,
    required AnimationController controller,
    required Animation<double> animation,
  }) {
    final _ChildEntry entry = _ChildEntry(
      widgetChild: child,
      transition: KeyedSubtree.wrap(builder(child, animation), _childNumber),
      animation: animation,
      controller: controller,
    );
    animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          assert(mounted);
          assert(_outgoingEntries.contains(entry));
          _outgoingEntries.remove(entry);
          _markChildWidgetCacheAsDirty();
        });
        controller.dispose();
      }
    });
    return entry;
  }

  void _markChildWidgetCacheAsDirty() {
    _outgoingWidgets = [];
  }

  void _updateTransitionForEntry(_ChildEntry entry) {
    entry.transition = KeyedSubtree(
      key: entry.transition.key,
      child: widget.transitionBuilder(entry.widgetChild, entry.animation),
    );
  }

  void _rebuildOutgoingWidgetsIfNeeded() {
    _outgoingWidgets = List<Widget>.unmodifiable(
      _outgoingEntries.map<Widget>((_ChildEntry entry) => entry.transition),
    );
    assert(_outgoingEntries.length == _outgoingWidgets.length);
    assert(_outgoingEntries.isEmpty || _outgoingEntries.last.transition == _outgoingWidgets.last);
  }

  @override
  void dispose() {
    if (_currentEntry != null) _currentEntry!.controller.dispose();
    for (final _ChildEntry entry in _outgoingEntries) entry.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _rebuildOutgoingWidgetsIfNeeded();
    return widget.layoutBuilder(widget.alignment, _currentEntry!.transition, _outgoingWidgets);
  }
}
