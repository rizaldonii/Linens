import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Widget destinationScreen;

  const CategoryIcon({
    Key? key,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.destinationScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: backgroundColor,
          child: IconButton(
            padding: EdgeInsets.all(0),
            constraints: BoxConstraints(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destinationScreen),
              );
            },
            icon: Icon(icon, color: Colors.white),
          ),
        ),
        SizedBox(height: 4),
        SizedBox(
          height: 30, // Set a fixed height to ensure alignment
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
