import 'package:flutter/material.dart';

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  List<ChildWidget> _childWidgets = [];

  void _addChildWidget() {
    setState(() {
      _childWidgets.add(ChildWidget(
        onSubmitted: _handleChildData,
      ));
    });
  }

  void _handleChildData(String data) {
    // handle the data here
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Widget'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _childWidgets.length,
              itemBuilder: (BuildContext context, int index) {
                return _childWidgets[index];
              },
            ),
          ),
          ElevatedButton(
            onPressed: _addChildWidget,
            child: Text('Add Child Widget'),
          ),
        ],
      ),
    );
  }
}

class ChildWidget extends StatefulWidget {
  final Function(String) onSubmitted;

  ChildWidget({required this.onSubmitted});

  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    String data = _textController.text.trim();
    if (data.isNotEmpty) {
      widget.onSubmitted(data);
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          labelText: 'Enter Data',
        ),
      ),
    );
  }
}
