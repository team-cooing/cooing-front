import 'package:cooing_front/model/data/my_user.dart';
import 'package:cooing_front/model/response/response.dart';
import 'package:cooing_front/providers/UserProvider.dart';

void initializeStaticVariables(){
  // MyUser
  MyUser.userId = '';
  MyUser.appleUserUid = '';
  MyUser.appleUserEmail = '';
  MyUser.userPlatform = '';

  // Response
  Response.initializeStaticVariables();

  // UserProvider
  UserDataProvider.initializeStaticVariables();
}