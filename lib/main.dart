import 'package:chat_app/views/chat_screen.dart';
import 'package:chat_app/views/home_screen.dart';
import 'package:chat_app/views/login_screen.dart';
import 'package:chat_app/views/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();

  String? isLogin = GetStorage().read("uId");
  print(isLogin);

  Widget returnedWidget;
  if(isLogin != null){
    returnedWidget = HomeScreen();
  }else{
    returnedWidget = LoginScreen();
  }

  runApp(MyApp(returnedWidget));


}

class MyApp extends StatelessWidget {

  MyApp(this.returnedWidget);

  Widget returnedWidget;


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: returnedWidget,
      ),
    );
  }
}
