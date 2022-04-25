import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/shared/components.dart';
import 'package:chat_app/views/home_screen.dart';
import 'package:chat_app/views/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ChatController extends GetxController {


  bool isUserOnline = true;

  GetStorage localData = GetStorage();

  bool isLoading = false;

  void register({
    required String? name,
    required String? email,
    required String? password,
  }) {
    isLoading = true;
    update();
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email!, password: password!).then((user) {

      // add user profile
      UserModel userData = UserModel(
        name: name,
        email: email,
        uId: user.user!.uid,
        image: "https://image.freepik.com/free-photo/medium-shot-happy-man-smiling_23-2148221808.jpg",
        isOnline: true
      );

      FirebaseFirestore.instance.collection("users").doc(user.user!.uid).set(userData.toMap()).then((value){
        localData.write("uId", user.user!.uid);
        ShowToast(text: "تم انشاء الحساب بنجاح");
        Get.offAll(Directionality(
          textDirection: TextDirection.rtl,
          child: HomeScreen(),
        ));
        isLoading = false;
        update();
      }).catchError((error){
        print(error.toString());
        isLoading = false;
        update();
      });

    }).catchError((error){
      print(error.toString());
      isLoading = false;
      update();
    });

  }

  void logOut() {
    FirebaseFirestore.instance.collection("users").doc(localData.read("uId")).update({"isOnline":false}).then((value){
      ShowToast(text: "تم تسجيل الخروج بنجاح");
      localData.remove("uId");
      Get.offAll(Directionality(
        textDirection: TextDirection.rtl,
        child: LoginScreen(),
      ));
    }).catchError((error){
      print(error.toString());
    });
  }


  void login({
    required String? email,
    required String? password,
  }){
    isLoading = true;
    update();

    FirebaseAuth.instance.signInWithEmailAndPassword(email: email!, password: password!).then((value){

      FirebaseFirestore.instance.collection("users").doc(value.user!.uid).update({"isOnline":true}).then((result){
        localData.write("uId", value.user!.uid);
        ShowToast(text: "تم تسجيل الدخول الحساب بنجاح");
        isLoading = false;
        update();
        Get.offAll(Directionality(
          textDirection: TextDirection.rtl,
          child: HomeScreen(),
        ));
      }).catchError((error){
        print(error.toString());
        isLoading = false;
        update();
      });

    }).catchError((error){
      print(error.toString());
      isLoading = false;
      update();
    });

  }


  void changeIsOnline(bool val){
    isUserOnline = val;
    print(val);
    update();
    changeFireIsOnline(uId: localData.read("uId"),IsOnline: val);
  }


  void changeFireIsOnline({
    required String? uId,
    required bool? IsOnline,
  }){
    FirebaseFirestore.instance.collection("users").doc(uId).update({"isOnline":IsOnline}).then((value){
      update();
    }).catchError((error){
      print(error.toString());
    });
  }



  RxList allUsers = [].obs;


  getAllUsers(){
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      allUsers = [].obs;
      event.docs.forEach((element){
        allUsers.add(UserModel.fromJson(element.data()));
      });
      update();
    });
  }



  void sendMessage({
  required String? message,
  required String? receiverUId,
  }){

    if(message != ""){
      String? senderUId = localData.read("uId");

      MessageModel messageModel = MessageModel(
          text: message,
          dateTime: DateTime.now().toString(),
          receiverUId: receiverUId,
          senderUId: senderUId
      );

      FirebaseFirestore.instance
          .collection("users")
          .doc(senderUId)
          .collection("chats")
          .doc("messages")
          .collection(receiverUId!)
          .add(messageModel.toMap()).then((value){

        update();

      }).catchError((error){
        print(error.toString());
        update();

      });


      FirebaseFirestore.instance
          .collection("users")
          .doc(receiverUId)
          .collection("chats")
          .doc("messages")
          .collection(senderUId!)
          .add(messageModel.toMap()).then((value){

        update();

      }).catchError((error){
        print(error.toString());
        update();

      });


    }

    getMessages(receiverUId: receiverUId);

  }



  ScrollController scrollController = ScrollController();

  void scrollDown() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }


  RxList? allMessages = [].obs;

  void getMessages({
    required String? receiverUId,
  }){
    String uId = localData.read("uId");
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .collection("chats")
        .doc("messages")
        .collection(receiverUId!)
        .orderBy("dateTime",descending: false)
        .snapshots().listen((event){
      allMessages = [].obs;
      event.docs.forEach((element) {
        allMessages!.add(MessageModel.fromJson(element.data()));
      });
      scrollDown();
      update();

    });

  }




}
