import 'dart:async';

import 'package:animated_stream_list/animated_stream_list.dart';
import 'package:emptiable_list/emptiable_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ExampleApp());
}

class ExampleApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExampleAppState();
  }
}

class _ExampleAppState extends State<ExampleApp> {
  final title = 'Emptiable list example';
  final controller = StreamController<List<String>>.broadcast();
  final items = <String>[];

  @override
  void dispose() {
    controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: _add
            ),
            IconButton(
                icon: Icon(Icons.remove),
                onPressed: _remove
            )
          ],
        ),
        body: EmptiableList(
            listStream: controller.stream,
            placeholder: Center(child: Text('No items =(')),
            list: AnimatedStreamList(
                streamList: controller.stream,
                itemBuilder: _createItem,
                itemRemovedBuilder: _createItem
            )
        ),
      ),
    );
  }

  Widget _createItem(String item, int index, BuildContext context, Animation<double> animation) {
    return SizeTransition(sizeFactor: animation, child: Text(item));
  }

  void _add() {
    items.add('Item');
    controller.add(items);
  }

  void _remove() {
    items.removeLast();
    controller.add(items);
  }
}