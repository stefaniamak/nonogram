import 'package:flutter/material.dart';

class NonogramGrid extends StatelessWidget {
  const NonogramGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 20,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Container(
            color: Colors.green,
            height: 5,
            width: 5,
            child: Text(index.toString()));
      },
    );
  }
}
