import 'dart:async';

import 'package:emptiable_list/emptiable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const ANIMATION_DURATION = const Duration(milliseconds: 1);

class DummyWidget extends StatelessWidget {
  final Stream<List<String>> items;
  static final initializingPlaceholder = Text('Loading');
  static final placeholder = Text('Empty list placeholder');
  static final list = ListView(children: <Widget>[
    ListTile(title: Text('Item 1')),
    ListTile(title: Text('Item 2'))
  ]);

  DummyWidget({@required this.items});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: EmptiableList(
          listStream: items,
          list: list,
          placeholder: placeholder,
          initializingPlaceholder: initializingPlaceholder,
          transitionDuration: ANIMATION_DURATION,
        ),
      ),
    );
  }
}

AnimatedOpacity findOpacityOf(Widget widget, WidgetTester tester) {
  return tester.widget(find.ancestor(
      of: find.byWidget(widget), matching: find.byType(AnimatedOpacity)));
}

void main() {
  group('EmptiableList', () {
    testWidgets('displays placeholder when list, coming from stream, is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(DummyWidget(items: Stream.value([])));
      await tester.pump(ANIMATION_DURATION);
      final initializationPlaceholderOpacity = findOpacityOf(DummyWidget.initializingPlaceholder, tester);
      final placeholderOpacity = findOpacityOf(DummyWidget.placeholder, tester);
      final listOpacity = findOpacityOf(DummyWidget.list, tester);
      expect(initializationPlaceholderOpacity.opacity, 0);
      expect(placeholderOpacity.opacity, 1);
      expect(listOpacity.opacity, 0);
    });
    testWidgets(
        'displays list widget when list, coming from stream, is not empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(DummyWidget(items: Stream.value(['Item'])));
      await tester.pump(ANIMATION_DURATION);
      final initializationPlaceholderOpacity = findOpacityOf(DummyWidget.initializingPlaceholder, tester);
      final placeholderOpacity = findOpacityOf(DummyWidget.placeholder, tester);
      final listOpacity = findOpacityOf(DummyWidget.list, tester);
      expect(initializationPlaceholderOpacity.opacity, 0);
      expect(placeholderOpacity.opacity, 0);
      expect(listOpacity.opacity, 1);
    });
    testWidgets('displays initialization placeholder while waiting for an emit form a stream', (WidgetTester tester) async {
      final controller = StreamController<List<String>>();
      await tester.pumpWidget(DummyWidget(items: controller.stream));
      await tester.pump(ANIMATION_DURATION);
      final initializationPlaceholderOpacity = findOpacityOf(DummyWidget.initializingPlaceholder, tester);
      final placeholderOpacity = findOpacityOf(DummyWidget.placeholder, tester);
      final listOpacity = findOpacityOf(DummyWidget.list, tester);
      expect(initializationPlaceholderOpacity.opacity, 1);
      expect(placeholderOpacity.opacity, 0);
      expect(listOpacity.opacity, 0);
      await controller.close();
    });
  });
}
