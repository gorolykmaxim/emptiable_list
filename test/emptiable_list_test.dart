import 'package:emptiable_list/emptiable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const ANIMATION_DURATION = const Duration(milliseconds: 1);

class DummyWidget extends StatelessWidget {
  final Stream<List<String>> items;
  final bool defaultPlaceholder;
  static final placeholder = Text('Empty list placeholder');
  static final list = ListView(children: <Widget>[
    ListTile(title: Text('Item 1')),
    ListTile(title: Text('Item 2'))
  ]);

  DummyWidget({@required this.items, this.defaultPlaceholder = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: EmptiableList(
          listStream: items,
          list: list,
          placeholder: defaultPlaceholder ? null : placeholder,
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
      final placeholderOpacity = findOpacityOf(DummyWidget.placeholder, tester);
      final listOpacity = findOpacityOf(DummyWidget.list, tester);
      expect(placeholderOpacity.opacity, 1);
      expect(listOpacity.opacity, 0);
    });
    testWidgets(
        'displays list widget when list, coming from stream, is not empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(DummyWidget(items: Stream.value(['Item'])));
      await tester.pumpAndSettle(ANIMATION_DURATION);
      final placeholderOpacity = findOpacityOf(DummyWidget.placeholder, tester);
      final listOpacity = findOpacityOf(DummyWidget.list, tester);
      expect(placeholderOpacity.opacity, 0);
      expect(listOpacity.opacity, 1);
    });
    testWidgets(
        'displays nothing when list, coming from stream, is empty and the placeholder widget was not specified',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          DummyWidget(items: Stream.value([]), defaultPlaceholder: true));
      await tester.pumpAndSettle(ANIMATION_DURATION);
      final placeholderFinder = find.byWidget(DummyWidget.placeholder);
      final listOpacity = findOpacityOf(DummyWidget.list, tester);
      final sizedBoxFinder = find.byWidget(EMPTY_WIDGET);
      final sizedBoxOpacity = findOpacityOf(EMPTY_WIDGET, tester);
      expect(placeholderFinder, findsNothing);
      expect(sizedBoxFinder, findsOneWidget);
      expect(listOpacity.opacity, 0);
      expect(sizedBoxOpacity.opacity, 1);
    });
  });
}
