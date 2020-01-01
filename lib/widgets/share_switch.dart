import 'package:flutter/material.dart';
import 'package:insta_clone/constants/size.dart';

class ShareSwitch extends StatefulWidget {
  final String label;

  const ShareSwitch({Key key, this.label}) : super(key: key);

  @override
  _ShareSwitchState createState() => _ShareSwitchState();
}

class _ShareSwitchState extends State<ShareSwitch> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Padding(
              padding: const EdgeInsets.all(common_gap),
              child: Text(
          widget.label,
          textScaleFactor: 1.2,
        ),
            )),
        Switch(
          value: checked,
          onChanged: (change) {
            setState(() {
              checked = change;
            });
          },
        )
      ],
    );
  }
}
