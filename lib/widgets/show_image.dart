import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final String pathImage;
  const ShowImage({super.key, required this.pathImage});

  @override
  Widget build(BuildContext context) {
    return Image.asset(pathImage);
  }
}
