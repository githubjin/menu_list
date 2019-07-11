import 'package:flutter/material.dart';

class SubItem extends StatelessWidget {
  final int index;

  SubItem(this.index);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.centerLeft,
        height: 40,
        child: Text("item_$index"),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.orangeAccent.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }
}

class StickHeader extends StatelessWidget {
  final String text;

  StickHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orangeAccent,
      padding: const EdgeInsets.only(left: 8),
      height: 30,
      child: Text(text),
      alignment: Alignment.centerLeft,
    );
  }
}
