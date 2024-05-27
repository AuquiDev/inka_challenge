
import 'package:flutter/material.dart';

class ClosePageButon extends StatelessWidget {
  const ClosePageButon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              size: 20,
              color: Colors.blue,
            )));
  }
}
