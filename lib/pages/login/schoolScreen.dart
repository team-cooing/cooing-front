import 'package:cooing_front/model/response/user.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/model/response/school.dart';
import 'package:cooing_front/providers/schools_providers.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  FocusNode node1 = FocusNode();
  List<School> schools = [];
  bool isLoading = true;
  bool empty = false;
  bool button = true;
  bool disableButton = true;
  String searchSchool = '';
  String beforeSearch = '';
  SchoolsProviders schoolsProvider = SchoolsProviders();

  Future initSchools(args) async {
    schools = await schoolsProvider.getSchools(args);
    print(schools.length);
    if (schools.isEmpty) {
      empty = true;
    } else {
      empty = false;
    }
    // print(schools[0].location);
  }

  @override
  void initState() {
    super.initState();
  }

  void searchButton() {
    initSchools(searchSchool).then((_) {
      setState(() {
        beforeSearch = searchSchool;
        isLoading = false;
        button = false;

        if (empty) {
          button = true;
          isLoading = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final node1 = FocusNode();
    final args = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Color(0xFFffffff),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Form(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '우리 학교를 검색해주세요.',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color.fromARGB(255, 51, 61, 75)),
              ),
              Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        searchSchool = text;

                        if (searchSchool != beforeSearch) {
                          button = true;
                          isLoading = true;
                        }

                        if (text.isEmpty) {
                          setState(() {
                            disableButton = false;
                          });
                        } else {
                          setState(() {
                            disableButton = true;
                          });
                        }
                      });
                    },
                    focusNode: node1,
                    autofocus: true,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 151, 84, 251))),
                        labelText: "학교 입력",
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 182, 183, 184))),
                  )),
              Visibility(
                  visible: empty,
                  child: Text(
                    '검색 결과가 없습니다.',
                    style: TextStyle(
                        color: Color.fromRGBO(51, 61, 75, 0.4), fontSize: 16),
                  )),
              Visibility(visible: button, child: Spacer()),
              Visibility(
                  visible: button,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 151, 84, 251),
                            onSurface: Color.fromRGBO(151, 84, 251, 0.2)),
                        onPressed: disableButton ? searchButton : null,
                        child: Text('검색',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))),
                  )),
              isLoading
                  ? Container()
                  : Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 6 / 1.1,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: schools.length,
                          itemBuilder: (context, index) {
                            return Container(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      width: 2.0,
                                      color: Color.fromRGBO(51, 61, 75, 0.2)),
                                )),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      'class',
                                      arguments: User(
                                        uid: args.uid,
                                        name: args.name,
                                        profileImage: args.profileImage,
                                        gender: args.gender,
                                        number: args.number,
                                        age: args.age,
                                        birthday: args.birthday,
                                        school: schools[index].name,
                                        schoolCode: schools[index].code,
                                        schoolOrg: schools[index].org,
                                        grade: args.grade,
                                        group: args.group,
                                        eyes: args.eyes,
                                        mbti: args.mbti,
                                        hobby: args.hobby,
                                        style: args.style,
                                        isSubscribe: args.isSubscribe,
                                        candyCount: args.candyCount,
                                        recentDailyBonusReceiveDate: args.recentDailyBonusReceiveDate,
                                        recentQuestionBonusReceiveDate: args.recentQuestionBonusReceiveDate,
                                        questionInfos: args.questionInfos,
                                        answeredQuestions:
                                            args.answeredQuestions,
                                        currentQuestionId: args.currentQuestionId,
                                        serviceNeedsAgreement:
                                            args.serviceNeedsAgreement,
                                        privacyNeedsAgreement:
                                            args.privacyNeedsAgreement,
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 5, bottom: 5),

                                          // padding:
                                          //     const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            schools[index].name,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromRGBO(
                                                    51, 61, 75, 1)),
                                          )),
                                      Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            width: 40,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  151, 84, 251, 0.2),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            child: Center(
                                                child: Text(
                                              '주소',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      151, 84, 251, 1)),
                                            )),
                                          ),
                                          Text(
                                            schools[index].location,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                                color: Color.fromRGBO(
                                                    51, 61, 75, 1)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                          })),
            ]),
          ),
        ));
  }
}
