import 'package:cooing_front/widgets/firebase_method.dart';
import 'package:cooing_front/widgets/share_card.dart';
import 'package:cooing_front/model/Question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/providers/UserProvider.dart';
import 'package:cooing_front/model/User.dart';
import 'package:provider/provider.dart';
import "dart:async";
import 'dart:convert';

class QuestionPage extends StatefulWidget {
  final String uid;

  QuestionPage({this.uid = '', Key? key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with AutomaticKeepAliveClientMixin {
  late CollectionReference contentCollectionRef;
  late CollectionReference userCollectionRef;
  // late CollectionReference schoolCollectionRef;
  UserDataProvider? _userDataProvider;
  User? _userData;
  late Question newQuestion;
  late List<Map<String, dynamic>> newQuestionInfos;
  late final String schoolCode;

  @override
  void initState() {
    super.initState();
    String uid = widget.uid;
    newQuestion = Question(
      id: '',
      ownerProfileImage: '',
      ownerName: '',
      owner: '',
      content: '',
      contentId: 0,
      receiveTime: '',
      openTime: '',
      url: '',
      isValidity: false,
    );
    userCollectionRef = FirebaseFirestore.instance.collection('users');
    contentCollectionRef = FirebaseFirestore.instance.collection('contents');
    // schoolCollectionRef = FirebaseFirestore.instance.collection('schools');
    // final userDataJson = userProvider.loadData();

    _userData = Provider.of<UserDataProvider>(context, listen: false).userData;

    print(_userData?.questionInfos);

    Future<User> getUserData() async {
      final prefs = await AsyncPrefsOperation();
      print(2222222222222);

      final userDataJson = prefs.getString('userData');
      if (userDataJson != null) {
        print("쿠키 에서 UserData 로드");
        print(userDataJson);
        Map<String, dynamic> userDataMap =
            json.decode(userDataJson); //z쿠키가 있ㅇㅡ면 쿠키 리턴
        return User.fromJson(userDataMap);
      } else {
        // Handle missing data
        print('No user data found in shared preferences');
        userDocRef = userCollectionRef.doc(uid);
        print("uid : $uid");
        print("firebase 에서 UserData 로드");
        return await getUserDocument(userDocRef, uid); //쿠키없으면 파베에서 유저 데이터 리턴
      }
    }

    try {
      late User userData;

      getUserData().then((data) {
        userData = data;
        newQuestion.owner = userData.uid;
        newQuestion.ownerName = userData.name;
        newQuestion.ownerProfileImage = userData.profileImage;
        newQuestionInfos = userData.questionInfos;

        // schoolCode = userData.schoolCode;
        schoolCode = '7041275';
        print("스쿨코드는 7041275이다 강제로 맞춰놓았다. 까먹을까봐 출력해놓는다 나중에 고쳐라 신혜은아");
        userDocRef = userCollectionRef.doc(newQuestion.owner);

        print("newQuestion 에 제대로 들어갔을까");
        print(newQuestion.ownerProfileImage);

        if (newQuestionInfos.isEmpty) {
          print("userData - questionInfos is Empty");
        } else {
          final lastQuestionInfo = newQuestionInfos.last;
          final String? currentContentId =
              lastQuestionInfo['contentId']?.toString();
          final String? currentQuestionId = lastQuestionInfo['questionId'];
          if (currentContentId != null && currentQuestionId != null) {
            questionDocRef = contentCollectionRef
                .doc(currentContentId)
                .collection('questions')
                .doc(currentQuestionId);

            getDocument(questionDocRef, currentQuestionId).then((value) {
              setState(() {
                print("value.contentId : ${value.contentId}");
                print("value.questionId : ${value.id}");
                print("value.receiveTime : ${value.receiveTime}");
                print("value : $value");
                newQuestion = value;
              });
            });
          }
        }
      });
    } on FormatException catch (e) {
      // Handle JSON decoding error
      print('Error decoding user data: $e');
    } catch (e) {
      // Handle other errors
      print('Error loading user data: $e');
    }
  }

  @override
  bool get wantKeepAlive => true;
  // UserDataProvider userDataProvider = UserDataProvider();

  Object? questionId;
  Map<String, dynamic> randomQ = {"id": -1, "question": ""};

  //버튼 text
  bool isButtonEnabled = true;
  bool isViewContent = false;
  String btnBottomMent = '';
  String viewContentText = '';
  final List<Color> _colors = <Color>[
    Colors.white,
    const Color(0xffe0cbfe),
    const Color(0xff9754FB)
  ];

  late String askButtonText = '질문 받기';

  //shareCard
  bool openShareCard = false;
  late String userDataJson;
  //타이머 관련
  Timer? _timer;
  Duration _countdown = Duration.zero;
  bool _isRunning = false; //타이머 isRunning
  late DateTime receiveTime; //초기화
  late String receiveTimeText;
  late DateTime closeDate; //초기화
  late String closeDateText;

  //임시 questionInfos
  late Map<String, dynamic> questionInfoList = {};
  late String currentContentId;

// 'questions'  의 document reference 초기화
  late DocumentReference questionDocRef;
  late DocumentReference userDocRef;
// Firebase Firestore 인스턴스 생성
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
// "content_id" 문서의 "questions" 콜렉션에서 "question_id" 문서를 가져옵니다.

// "question_id" 문서를 만듭니다.
  void createQuestionDocument(String contentId, String questionId) {
    firestore
        .collection('Contents')
        .doc(contentId)
        .collection('questions')
        .doc(questionId)
        .set({});
  }

  //open 하기 전인 상태
  initialState() {
    print("initialState");
    openShareCard = false;
    askButtonText = '질문 받기';
    isViewContent = false; //"똑똑똑 질문이 도착했어요~"
    isButtonEnabled = true;
  }

//
  openButNotReceive() {
    print("openButNotReceive");
    askButtonText = '답변 받기'; //버튼 text는 질문닫기로 변경
    isViewContent = true;
    openShareCard = false; //아래에 share card 생성
    isButtonEnabled = true;
  }

//답장o 닫는시간x (closeTime 지나기 전)
  receiveButNotClose() {
    print("receiveButNotClose");
    askButtonText = '질문 닫기';
    isButtonEnabled = false;
    openShareCard = true; //아래에 share card 생성
  }

//답장o 닫는시간지남(closeTime 지난 후)
  receiveAndClose() {
    print("receiveAndClose");

    isButtonEnabled = true;
    askButtonText = '질문 닫기';
    btnBottomMent = '새로운 질문이 도착했어요';
    openShareCard = true; //아래에 share card 생성
  }

  changeAskCard() {
    // setState(() {
    switch (askButtonText) {
      case '질문 받기':
        //질문
        newQuestion = initQuestion(newQuestion);
        openButNotReceive();
        randomQ = filterQuestion(newQuestionInfos);
        print("빠져나왓니?");
        newQuestion.content = randomQ['question'].toString();
        newQuestion.id = DateTime.now().toString();
        print(newQuestion.contentId);
        newQuestion.contentId = randomQ['id'];
        viewContentText = newQuestion.content;
        _startTimer(); //openTime
        questionDocRef = contentCollectionRef
            .doc(newQuestion.contentId.toString())
            .collection('questions')
            .doc(newQuestion.id); //title이 id인 firebase document reference 생성
        addNewQuestion(questionDocRef, newQuestion);
        newQuestionInfos.add({
          'contentId': newQuestion.contentId.toString(),
          'questionId': newQuestion.id
        });
        print("${newQuestion.contentId} ---- ${newQuestion.content}");
        print(
            "239 라인 newQuestion.receiveTime ---- ${newQuestion.receiveTime} ");

        userDocRef.update({
          'questionInfos': newQuestionInfos
        }); //파이어베이스 user - questionInfos 업데이트
        final userProvider =
            Provider.of<UserDataProvider>(context, listen: false);

        userProvider.updateQuestionInfos(
            newQuestionInfos); //기기 쿠키 user - questionInfos 업데이트

        break;

      case '답변 받기':
        print('들어갔니?000');
        receiveButNotClose();
        _resetTimer();
        newQuestion.isValidity = true;

        String url = 'www.kookmin.ac.kr/12345'; //임시 url
        receiveTime = DateTime.now();
        closeDate = receiveTime.add(const Duration(hours: 24));
        newQuestion.receiveTime = receiveTime.toString();
        print('262라인 case 문 안에 ${newQuestion.receiveTime}');
        updateQuestion('receiveTime', newQuestion.receiveTime, questionDocRef);
        updateQuestion('url', url, questionDocRef);
        updateQuestion('isValidity', true, questionDocRef);
        addQuestionToFeed(schoolCode, newQuestion); //피드 추가
        print('267 라인 ${newQuestion.receiveTime}');

        btnBottomMent =
            '해당 질문은 ${closeDate.day}일 ${closeDate.hour}시 ${closeDate.minute}분부터 닫을 수 있습니다.';

        break;

      case '질문 닫기':
        if (DateTime.now().isAfter(closeDate)) {
          receiveAndClose();
          updateQuestion('isValidity', false, questionDocRef);
          deleteQuestionFromFeed(schoolCode, newQuestion.id);
          askButtonText = '질문 받기'; //버튼 text는 답변받기로 변경
          initState();
        }
        break;
    }
    // });
  }

  void _startTimer() {
    if (newQuestion.openTime == "") {
      final openTime = DateTime.now();
      newQuestion.openTime = openTime.toString();
      newQuestion.id = openTime.toString();
      // print(1144$openTime.toString());
    }
    DateTime openTime = DateTime.parse(newQuestion.openTime);
    final endOfDay = DateTime(openTime.year, openTime.month, openTime.day + 1);
    final remainingSeconds = endOfDay.difference(openTime).inSeconds;
    setState(() {
      _countdown = Duration(seconds: remainingSeconds);
      _isRunning = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown.inSeconds == 0) {
          _timer?.cancel();
          _isRunning = false;
          if (openShareCard == false) {
            askButtonText = '질문 받기';
            // contentCollectionRef
            //     .doc(newQuestion.contentId.toString())
            //     .collection('questions')
            //     .doc(newQuestion.id)
            //     .delete();
          }
        } else {
          _countdown = Duration(seconds: _countdown.inSeconds - 1);
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _countdown = Duration.zero;
      _isRunning = false;
    });
    _timer?.cancel();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);

    return "남은 시간 $twoDigitHours : $twoDigitMinutes : $twoDigitSeconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SingleChildScrollView(child: _askBody()),
    );
  }

  Widget _askBody() {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: SafeArea(
            child: Center(
                child: Column(children: <Widget>[
          pupleBox(),
          shareCard(openShareCard),
        ]))));
  }

  Widget padding(double num) {
    return Padding(padding: EdgeInsets.all(num));
  }

  Widget pupleBox() {
    if (newQuestion.isValidity == false) {
      if (newQuestion.openTime == "") {
        //질문 open 안한 상태
        initialState();
      } else if (newQuestion.receiveTime == "") {
        //질문 받았으나 답변받기 안누른 상태
        _isRunning = true; //timer
        _startTimer(); //openTime
        openButNotReceive();
        viewContentText = newQuestion.content;
        print(newQuestion);
      }
    } else if (newQuestion.isValidity == true) {
      //답변받기 누른 상태
      //closeTime 전이면
      isViewContent = true;
      viewContentText = newQuestion.content;
      DateTime rcvTime = DateTime.parse(newQuestion.receiveTime);
      closeDate = rcvTime.add(const Duration(hours: 24));
      print('setState 문 안에 $rcvTime');

      if (DateTime.now().isAfter(closeDate)) {
        print("답변받기& after close");
        receiveAndClose();
        deleteQuestionFromFeed(schoolCode, newQuestion.id);
        initialState();
        // updateQuestion('isValidity', false, questionDocRef);
      } else {
        print("답변받기& before close");
        receiveButNotClose();
        btnBottomMent =
            '해당 질문은 ${closeDate.day}일 ${closeDate.hour}시 ${closeDate.minute}분부터 닫을 수 있습니다.';
      }
    }

    // Update button state
    setState(() {
      isButtonEnabled = isButtonEnabled;
    });
    // Update button state

    String remainTimer = _formatDuration(_countdown);

    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: const Color(0xff9754FB),
        child: Column(
          children: <Widget>[
            padding(5),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const Padding(padding: EdgeInsets.only(left: 25.0)),
              Text(remainTimer,
                  style: TextStyle(
                      color: Colors.white,
                      backgroundColor: _colors[2],
                      fontSize: _isRunning ? 12 : 0))
            ]),
            const Padding(padding: EdgeInsets.all(15.0)),
            newQuestion.ownerProfileImage.isEmpty
                ? const CircularProgressIndicator()
                : Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(newQuestion.ownerProfileImage),
                      ),
                    ),
                  ),
            const Padding(padding: EdgeInsets.all(20.0)),
            Text(
              isViewContent ? viewContentText : '똑똑똑! 오늘의 질문이 도착했어요.',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white),
            ),
            Container(
              padding: EdgeInsets.all(25.0),
              child: OutlinedButton(
                onPressed: isButtonEnabled ? () => changeAskCard() : null,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  foregroundColor: const Color(0xff9754FB),
                  backgroundColor: isButtonEnabled ? _colors[0] : _colors[1],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  askButtonText,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            Text(
              btnBottomMent,
              style: TextStyle(
                  color: Colors.white, fontSize: openShareCard ? 10 : 0),
            ),
            const Padding(padding: EdgeInsets.all(9.0)),
          ],
        ),
      ),
    );
  }
}
