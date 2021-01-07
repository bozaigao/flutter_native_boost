import 'package:flutter/widgets.dart';

/// Debugger todo:
class ContainerDebugger extends StatefulWidget {
  @override
  _ContainerDebuggerState createState() => _ContainerDebuggerState();
}

class _ContainerDebuggerState extends State<ContainerDebugger> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('Debugger'),
    );
  }
}
