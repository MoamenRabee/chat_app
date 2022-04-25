import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class ChatScreen extends StatelessWidget {

  UserModel model;

  ChatScreen(this.model);

  ChatController controller = Get.put(ChatController());


  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Row(
          children: [
            CircleAvatar(
                radius: 23.0,
                backgroundImage: NetworkImage("${model.image}")
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model.name}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23.0,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    model.isOnline! ? "متصل الان" : "غير متصل",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: GetBuilder<ChatController>(
                  builder:(controller)=> ConditionalBuilder(
                      condition: controller.allMessages!.value.isNotEmpty,
                      builder: (context){
                        return ListView.separated(
                          physics: BouncingScrollPhysics(),
                          controller: controller.scrollController,
                            itemBuilder: (context,index){
                              MessageModel message = controller.allMessages!.value[index];
                              if(message.receiverUId == model.uId){
                                return MessageByMe(message);
                              }else{
                                return MessageByUser(message,model);
                              }
                            },
                            separatorBuilder: (context,index)=>SizedBox(height: 10.0,),
                            itemCount: controller.allMessages!.value.length
                        );
                      },
                      fallback: (context)=>Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
              Row(
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: CircleAvatar(
                      radius: 25.0,
                      child: IconButton(
                        onPressed: (){
                          controller.sendMessage(
                            receiverUId: model.uId,
                            message: messageController.text
                          );
                          messageController.text = "";
                        },
                        icon: Icon(Icons.double_arrow_rounded,size: 30.0,),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 0.0
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.grey[300],
                        ),
                        child: TextFormField(
                          controller: messageController,
                          maxLines: 5,
                          minLines: 1,
                          style: TextStyle(
                            height: 1.5
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "اكتب الرسالة ...",
                          ),
                        ),
                      ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}





Widget MessageByMe(MessageModel message){
  return Align(
    alignment: Alignment.topRight,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "${message.text}",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 7.0
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget MessageByUser(MessageModel message,UserModel model){
  return Align(
    alignment: Alignment.topLeft,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: Text(
                  "${message.text}",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 7.0
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}