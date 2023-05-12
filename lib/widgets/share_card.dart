import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:social_share/social_share.dart';

class ShareCard extends StatefulWidget {
  final String url;
  const ShareCard({required this.url, super.key});

  @override
  ShareCardState createState() => ShareCardState();
}

class ShareCardState extends State<ShareCard> {
  late String currentQuestionUrl = '';

  String facebookId = "617417756966237";
  var imageBackground = "sohee.jpg";
  String imageBackgroundPath = "";
  String videoBackgroundPath = "";

  @override
  void initState() {
    super.initState();
    currentQuestionUrl = widget.url;
    copyBundleAssets();
  }

  void _onShareButtonPressed() {
    SocialShare.shareInstagramStory(
            appId: facebookId,
            imagePath: imageBackgroundPath,
            backgroundTopColor: "#ffffff",
            backgroundBottomColor: "#000000",
            attributionURL: "www.naver.com")
        .then((data) {
      print(data);
    });
  }

  void _onCopyButtonPressed(String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('링크 복사완료!'),
    ));
  }

  Future<void> copyBundleAssets() async {
    imageBackgroundPath = await copyImage(imageBackground);
    // videoBackgroundPath = await copyImage(videoBackground);
  }

  Future<String> copyImage(String filename) async {
    final tempDir = await getTemporaryDirectory();
    ByteData bytes = await rootBundle.load("images/$filename");
    final assetPath = '${tempDir.path}/$filename';
    File file = await File(assetPath).create();
    await file.writeAsBytes(bytes.buffer.asUint8List());
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    AssetImage iconLink = AssetImage('images/icon_copyLink.png');
    AssetImage iconInstagram = AssetImage('images/icon_instagram.png');

    return (Column(children: <Widget>[
      shareBlock(iconLink, "1단계", "링크 복사하기", "복사"),
      shareBlock(iconInstagram, "2단계", "친구들에게 공유", "공유"),
    ]));
  }

  Widget shareBlock(
      AssetImage assetImage, String level, String title, String buttonTxt) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: double.infinity,
        height: 85.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          decoration: BoxDecoration(
              color: Color(0xffF2F3F3),
              borderRadius: BorderRadius.circular(20)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: 25.0,
                        height: 25.0,
                        child: Image(image: assetImage)),
                    Padding(padding: EdgeInsets.only(right: 15.0)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff333D4B),
                          ),
                        ),
                        Text(
                          title,
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
              onPressed: () {
                if (buttonTxt == '복사') {
                  print(
                      "in ShareCard() - currentQuestionUrl :  $currentQuestionUrl");
                  currentQuestionUrl.isNotEmpty
                      ? _onCopyButtonPressed(currentQuestionUrl)
                      : print("url 비어있음");
                } else {
                  _onShareButtonPressed();
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                backgroundColor: Color.fromRGBO(151, 84, 251, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              child: Text(
                buttonTxt,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
