import 'package:cooing_front/widgets/grid_itemview.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_item/multi_select_item.dart';

class GridBoy extends StatefulWidget {
  const GridBoy({Key? key}) : super(key: key);

  @override
  _GridBoyState createState() => _GridBoyState();
}

class _GridBoyState extends State<GridBoy> {
  List<String> items = [
    '귀여운',
    '예쁜',
    '해맑은',
    '상큼한',
    '사랑스러운',
    '훈훈한',
    '다정한',
    '청순한',
    '애교 많은',
    '마음 여린',
    '순진한',
    '호감형인'
  ];
  // List<Map<String, dynamic>> items = <Map<String, dynamic>>[
  //   <String, dynamic>{'title': '귀여운', 'color': Colors.red},
  //   <String, dynamic>{'title': '예쁜', 'color': Colors.red},
  //   <String, dynamic>{'title': '해맑은', 'color': Colors.red},
  //   <String, dynamic>{'title': '상큼한', 'color': Colors.red},
  //   <String, dynamic>{'title': '사랑스러운', 'color': Colors.red},
  //   <String, dynamic>{'title': '훈훈한', 'color': Colors.red},
  //   <String, dynamic>{'title': '다정한', 'color': Colors.red},
  //   <String, dynamic>{'title': '청순한', 'color': Colors.red},
  //   <String, dynamic>{'title': '애교 많은', 'color': Colors.red},
  //   <String, dynamic>{'title': '마음 여린', 'color': Colors.red},
  //   <String, dynamic>{'title': '순진한', 'color': Colors.red},
  //   <String, dynamic>{'title': '호감형인', 'color': Colors.red},
  // ];

  MultiSelectController myMultiSelectController = MultiSelectController();
  @override
  void initState() {
    super.initState();
    myMultiSelectController.disableEditingWhenNoneSelected = true;
    myMultiSelectController.set(items.length);
  }

  int optionSelected = 0;

  void checkOption(int index) {
    setState(() {
      optionSelected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.count(
        crossAxisCount: 3,
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          for (int i = 0; i < items.length; i++)
            GridItemView(
                title: items[i],
                onTap: () => checkOption(i + 1),
                selected: i + 1 == optionSelected)
        ],
      ),
    );
  }
}
