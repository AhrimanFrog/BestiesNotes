import 'package:flutter/material.dart';

class WhiteBox extends StatelessWidget {
  final Widget? child;

  const WhiteBox({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: child,
    );
  }
}
