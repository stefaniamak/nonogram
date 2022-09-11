import 'package:flutter/material.dart';

class NonogramGrid extends StatelessWidget {
  const NonogramGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.black,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: 20,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return NonogramTile();
        },
      ),
    );
  }
}

enum NonoTileState {
  empty,
  filled,
  crossed,
}

class NonogramTile extends StatelessWidget {
  const NonogramTile({
    Key? key,
    this.tileState = NonoTileState.empty,
  }) : super(key: key);

  final NonoTileState tileState;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tileState == NonoTileState.filled ? Colors.black : Colors.white,
      height: 5,
      width: 5,
      child: tileState == NonoTileState.crossed
          ? Center(child: Icon(Icons.close))
          : Container(),
    );
  }
}
