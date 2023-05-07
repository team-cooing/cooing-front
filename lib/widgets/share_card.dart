import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

class ShareCard extends StatefulWidget {
  const ShareCard({super.key});

  @override
  _ShareCardState createState() => _ShareCardState();
}

class _ShareCardState extends State<ShareCard> {
  String facebookId = "617417756966237";

  var imageBackground = "sohee.jpg";
  // var videoBackground = "video-background.mp4";
  String imageBackgroundPath = "";
  String videoBackgroundPath = "";
  @override
  void initState() {
    super.initState();
    copyBundleAssets();
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

  Future<String?> pickImage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    var path = file?.path;
    if (path == null) {
      return null;
    }
    return file?.path;
  }

  Future<String?> screenshot() async {
    var data = await screenshotController.capture();
    if (data == null) {
      return null;
    }
    final tempDir = await getTemporaryDirectory();
    final assetPath = '${tempDir.path}/temp.png';
    File file = await File(assetPath).create();
    await file.writeAsBytes(data);
    return file.path;
  }

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return shareCard(true);
  }

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
                                    image: AssetImage(
                                        'images/icon_copyLink.png'))),
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
                                    image: AssetImage(
                                        'images/icon_instagram.png'))),
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
                        onPressed: () async {
                          var path = await pickImage();
                          if (path == null) {
                            return;
                          }
                          SocialShare.shareInstagramStory(
                                  appId: facebookId,
                                  imagePath: path,
                                  backgroundTopColor: "#ffffff",
                                  backgroundBottomColor: "#000000",
                                  attributionURL: "www.naver.com")
                              .then((data) {

                            print(data);
                          });
                        },
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
}
