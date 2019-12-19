# emptiable_list

Container for a list-displaying widget, that can display a 
placeholder-widget when the list is empty.

Can be handy if you are displaying stream of lists in a widget,
that supports animations and must remain in widget hierarchy
when empty in order to preserve animation states (for example 
https://pub.dev/packages/animated_stream_list).

EmptiableList always keeps both placeholder and list widgets
in a widget tree, thus both of them can have animated transitions.
What EmptiableList does, is it keeps both widgets on top of each
other, only changing their transparency.

## Getting Started

Create list with placeholder:
```dart
Widget build(BuildContext context) {
  return EmptiableList(
            listStream: stream,
            placeholder: Center(child: Text('No items =(')),
            list: AnimatedStreamList(
                streamList: controller.stream,
                itemBuilder: _createItem,
                itemRemovedBuilder: _createItem
            )
  );
}
```