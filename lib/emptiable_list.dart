import 'dart:async';

import 'package:flutter/widgets.dart';

/// Widget, that will be displayed as a placeholder-widget in [EmptiableList],
/// in case no placeholder-widget were specified explicitly.
const EMPTY_WIDGET = SizedBox.shrink();

/// Default duration of transition animation between placeholder-widget and
/// list widget.
const DEFAULT_DURATION = const Duration(milliseconds: 500);

/// Container for widgets, that display [Stream] of [List].
///
/// When [listStream] emits an empty list, [placeholder] will get displayed
/// instead of [list].
class EmptiableList extends StatefulWidget {
  final Widget placeholder;
  final Widget list;
  final Stream<List> listStream;
  final Duration transitionDuration;

  /// Create a widget, that will display [list] when [listStream] emits non-empty
  /// list and [placeholder] when [listStream] emits an empty list.
  ///
  /// Transition between [placeholder] and [list] is animated. Duration of this
  /// animation can be configured with [transitionDuration].
  EmptiableList(
      {@required this.listStream,
      Widget placeholder,
      @required this.list,
      Duration transitionDuration})
      : this.placeholder = placeholder ?? EMPTY_WIDGET,
        this.transitionDuration = transitionDuration ?? DEFAULT_DURATION;

  @override
  State<StatefulWidget> createState() {
    return _EmptiableListState();
  }
}

class _EmptiableListState extends State<EmptiableList> {
  StreamSubscription subscription;
  List currentList;

  @override
  void initState() {
    subscription = widget.listStream.listen((list) {
      setState(() {
        currentList = list;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
    subscription = null;
    currentList = null;
  }

  @override
  Widget build(BuildContext context) {
    final listIsEmpty = currentList == null || currentList.isEmpty;
    return Stack(
      children: <Widget>[
        AnimatedOpacity(
            opacity: listIsEmpty ? 1 : 0,
            duration: widget.transitionDuration,
            child: widget.placeholder),
        AnimatedOpacity(
            opacity: listIsEmpty ? 0 : 1,
            duration: widget.transitionDuration,
            child: widget.list)
      ],
    );
  }
}
