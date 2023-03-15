import 'package:flutter/material.dart';

class GridItemView extends StatelessWidget {
  const GridItemView({Key? key, this.title, this.onTap, this.selected})
      : super(key: key);

  final String? title;
  final VoidCallback? onTap;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Color.fromRGBO(51, 61, 75, 0.2),
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title.toString(),
              style:
                  TextStyle(color: Color.fromRGBO(51, 61, 75, 1), fontSize: 16),
            ),
            selected ?? false
                ? Icon(Icons.check, color: Colors.white)
                : Container(),
          ],
        )),
      ),
      onTap: onTap,
    );
  }
}
