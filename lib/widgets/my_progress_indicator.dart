
import 'package:flutter/material.dart';
import 'package:insta_clone/constants/size.dart';

class myProgressIndicator extends StatelessWidget {
  final double containerSize;
  final double progressSize;

  const myProgressIndicator({
    Key key, this.containerSize, this.progressSize = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerSize,
      height: containerSize,
      child: Center(
        child: SizedBox(
          width: progressSize,
          height: progressSize,
          child: Image.asset('assets/loading_img.gif'),
        ),
      ),
    );
  }
}