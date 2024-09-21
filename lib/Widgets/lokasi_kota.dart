import 'package:flutter/material.dart';

class ImageWithOverlay extends StatelessWidget {
  final String imagePath;
  final String overlayText;

  const ImageWithOverlay({
    Key? key,
    required this.imagePath,
    required this.overlayText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 135,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Layer for the image
            Positioned.fill(
              child: Image(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
            // Layer for the overlay text
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 40,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  overlayText,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
