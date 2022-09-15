import 'package:flutter/material.dart';

import 'debug_page.dart';

class DebugAppbarAction extends StatelessWidget {
  const DebugAppbarAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        child: Icon(Icons.bug_report),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DebugPage()))
      ),
    );
  }
}
