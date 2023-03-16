// import 'package:flutter/material.dart';
// import 'package:cooing_front/pages/question_page.dart';
// import "dart:math";

// Widget pupleBox() {
//   double cardHeight = 273.0;
//   double timeAttackSize = 0.0;
//   double askClosedMentSize = 0.0;
//   String checking = '<버튼누름>';
//   String askDefault = '똑똑똑! 오늘의 질문이 도착했어요.';
//   String getAsk = '질문 받기';
//   String getAnswer = '답변 받기';
//   String closeAsk = '질문 닫기';
//   var questionList = ['내 첫인상은 어땠어?', '내 mbti는 무엇인 것 같아?', '나랑 닮은 동물은 뭐야?'];
//   final random = Random();

//   String timeAttack = '';
//   String askClosedMent = '';
//   final List<Color> colors = <Color>[
//     Colors.white,
//     const Color(0xffe0cbfe),
//     const Color(0xff9754FB)
//   ];

//   late Color timetextColor = colors[0];
//   late String askText = askDefault;
//   late String askButtonText = getAsk;
//   late Color buttonColor = colors[0];


//     return SizedBox(
//       width: 347.0,
//       height: cardHeight,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         color: const Color(0xff9754FB),
//         child: Column(
//           children: <Widget>[
//             const Padding(padding: EdgeInsets.all(9.0)),
//             Container(
//                 padding: const EdgeInsets.only(right: 190.0),
//                 child: Text(
//                   timeAttack,
//                   style:
//                       TextStyle(color: timetextColor, fontSize: timeAttackSize),
//                 )),
//             const Padding(padding: EdgeInsets.all(9.0)),
//             const SizedBox(
//               width: 80.0,
//               height: 80.0,
//               child: CircleAvatar(
//                 backgroundImage: AssetImage('images/sohee.jpg'),
//               ),
//             ),
//             const Padding(padding: EdgeInsets.all(10.0)),
//             Text(
//               askText,
//               style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                   color: Colors.white),
//             ),
//             const Padding(padding: EdgeInsets.all(15.0)),
//             OutlinedButton(
//               onPressed: () => changeAskCard(),
//               style: OutlinedButton.styleFrom(
//                 fixedSize: const Size(154, 50),
//                 foregroundColor: const Color(0xff9754FB),
//                 backgroundColor: buttonColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               child: Text(
//                 askButtonText,
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//             ),
//             const Padding(padding: EdgeInsets.all(8.0)),
//             Text(
//               askClosedMent,
//               style:
//                   TextStyle(color: Colors.white, fontSize: askClosedMentSize),
//             ),
//             const Padding(padding: EdgeInsets.all(0.0)),
//           ],
//         ),
//       ),
//     );
//   }
// }
