import 'package:flutter/material.dart';

Widget shareCard(bool open) {
  if (open == true) {
    return (Column(children: <Widget>[
      Container(
        padding: const EdgeInsets.only(top: 20),
        child: SizedBox(
          width: double.infinity,
          height: 90.0,
          child: Container(
            padding: EdgeInsets.all(25.0),
            decoration: BoxDecoration(
                color: Color(0xffF2F3F3),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                              width: 25.0,
                              height: 25.0,
                              child: Image(
                                  image:
                                      AssetImage('images/icon_copyLink.png'))),
                          Padding(padding: EdgeInsets.only(right: 10.0)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "1단계",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff333D4B),
                                ),
                              ),
                              Text(
                                "링크 복사하기",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff333D4B),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        backgroundColor: Color.fromRGBO(151, 84, 251, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      child: const Text(
                        "복사",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ))
                ]),
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(top: 20),
        child: SizedBox(
          width: double.infinity,
          height: 90.0,
          child: Container(
            padding: EdgeInsets.all(25.0),
            decoration: BoxDecoration(
                color: Color(0xffF2F3F3),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                              width: 25.0,
                              height: 25.0,
                              child: Image(
                                  image:
                                      AssetImage('images/icon_instagram.png'))),
                          Padding(padding: EdgeInsets.only(right: 10.0)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "2단계",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff333D4B),
                                ),
                              ),
                              Text(
                                "친구들에게 공유",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff333D4B),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        backgroundColor: Color.fromRGBO(151, 84, 251, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      child: const Text(
                        "공유",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ))
                ]),
          ),
        ),
      ),
    ]));
  } else {
    return const Padding(padding: EdgeInsets.all(3.0));
  }
}
