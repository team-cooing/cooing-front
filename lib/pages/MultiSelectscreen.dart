import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MultiSelectscreen extends StatefulWidget {
  const MultiSelectscreen({super.key});
  @override
  _MultiSelectscreenState createState() => _MultiSelectscreenState();
}

class _MultiSelectscreenState extends State<MultiSelectscreen> {
  List<Course> corcess = new List.empty(growable: true);
  bool selectAll = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    corcess.add(Course('귀여운', true));
    corcess.add(Course('예쁜', false));
    corcess.add(Course('해맑은', false));
    corcess.add(Course('상큼한', false));
    corcess.add(Course('사랑스러운', false));
    corcess.add(Course('훈훈한', false));
    corcess.add(Course('다정한', false));
    corcess.add(Course("청순한", false));
    corcess.add(Course("애교 많은", false));
    corcess.add(Course("마음 여린", false));
    corcess.add(Course("순진한", false));
    corcess.add(Course("호감형인", false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridView.builder(
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return prepareList(index);
              },
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: corcess.length,
            ),
          ],
        ),
      ),
    );
  }

  Widget prepareList(int k) {
    return Card(
      child: Hero(
        tag: "text$k",
        child: Material(
          child: InkWell(
              onTap: () {},
              child: corcess[k].selected
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          corcess[k].selected = !corcess[k].selected;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color.fromRGBO(51, 61, 75, 0.2),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Stack(
                          children: [
                            Center(
                                child: Text(
                              corcess[k].name,
                              style: TextStyle(
                                  color: Color.fromRGBO(51, 61, 75, 1),
                                  fontSize: 16),
                            )),
                          ],
                        ),
                      ))
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          corcess[k].selected = !corcess[k].selected;
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(151, 84, 251, 1),
                            ),
                            color: Color.fromRGBO(151, 84, 251, 0.2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                  child: Text(
                                corcess[k].name,
                                style: TextStyle(
                                    color: Color.fromRGBO(151, 84, 251, 1),
                                    fontSize: 16),
                              )),
                            ],
                          )),
                    )),
        ),
      ),
    );
  }
}

class Course {
  String name;
  bool selected;
  Course(this.name, this.selected);
}
