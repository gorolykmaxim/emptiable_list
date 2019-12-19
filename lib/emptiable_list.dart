import 'dart:async';

import 'package:flutter/widgets.dart';

const EMPTY_WIDGET = SizedBox.shrink();
const DEFAULT_DURATION = const Duration(milliseconds: 500);

class EmptiableList extends StatefulWidget {
  final Widget placeholder;
  final Widget list;
  final Stream<List> listStream;
  final Duration transitionDuration;

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
