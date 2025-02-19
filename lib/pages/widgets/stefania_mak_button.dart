import 'package:flutter/material.dart';

class StefaniaMakButton extends StatefulWidget {
  const StefaniaMakButton({
    super.key,
  });

  @override
  State<StefaniaMakButton> createState() => _StefaniaMakButtonState();
}

class _StefaniaMakButtonState extends State<StefaniaMakButton> {
  List<Color> get splashColors => <Color>[
        Colors.grey,
        Colors.red,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.deepPurple,
        Colors.orange,
        Colors.pink,
        Colors.purple,
        Colors.teal,
        Colors.cyan,
        Colors.indigo,
        Colors.amber,
        Colors.lime,
        Colors.lightBlue,
        Colors.lightGreen,
        Colors.deepOrange,
        Colors.blueGrey,
        Colors.black,
      ];

  int index = 0;

  Color get randomColor => splashColors[DateTime.now().second % splashColors.length];

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        overlayColor: splashColors[index],
      ),
      onPressed: () {
        setState(() {
          index = (index + 1) % splashColors.length;
        });
      },
      child: const Text('Stefania Mak', style: TextStyle(color: Colors.black)),
    );
  }
}
