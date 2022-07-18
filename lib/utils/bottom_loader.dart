import 'package:flutter/material.dart';

class BottomLoader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      alignment: Alignment.center,
      child: const Center(
        child: SizedBox(
          width: 33.0,
          height: 33.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }
}
