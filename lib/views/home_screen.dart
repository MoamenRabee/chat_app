
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/views/chat_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get_storage/get_storage.dart';

String myUId = GetStorage().read("uId");

ChatController controller = Get.put(ChatController());

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getAllUsers();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 20.0,
        title: Row(
          children: [
            CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage("https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper.png")
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              "الرسائل",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              GetBuilder<ChatController>(
                builder:(controller)=> Checkbox(
                  activeColor: Colors.green,
                  value: controller.isUserOnline,
                  onChanged: (val){
                    controller.changeIsOnline(val!);
                },),
              ),
              Text("اون لاين",style: TextStyle(color: Colors.white),),
              SizedBox(width: 10.0,),
              TextButton(onPressed: (){
                controller.logOut();
              }, child: Text("تسجيل خروج",style: TextStyle(color: Colors.white),)),
              SizedBox(width: 10.0,)
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GetBuilder<ChatController>(
          builder:(controller)=> ConditionalBuilder(
            condition: controller.allUsers.isNotEmpty,
            builder:(context)=> SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    height: 110.0,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index) => BuildOnlineWidget(model: controller.allUsers.value[index]),
                      separatorBuilder: (context,index) => SizedBox(
                        width: 15.0,
                      ),
                      itemCount: controller.allUsers.value.length,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context,index) => BuildChatWidget(model: controller.allUsers.value[index]),
                    separatorBuilder: (context,index) => SizedBox(
                      height: 0.0,
                    ),
                    itemCount: controller.allUsers.value.length,
                  )
                ],
              ),
            ),
            fallback:(context)=> Center(child: CircularProgressIndicator(),),
          ),
        ),
      ),
    );
  }
}


Widget BuildOnlineWidget({required UserModel model}){

  if(model.isOnline == true && model.uId != myUId){
    return Container(
      width: 60.0,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage("${model.image}")
              ),
              CircleAvatar(
                radius: 10.5,
                backgroundColor: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 2.0,
                  right: 2.0,
                ),
                child: CircleAvatar(
                  radius: 8.0,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "${model.name}",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 16.0,
                height: 1.0
            ),
          )
        ],
      ),
    );
  }else{
    return Container(width: 0.0,);
  }

}

Widget BuildChatWidget({required UserModel model}){

  if(model.uId != myUId){
    return InkWell(
      onTap: (){
        controller.getMessages(receiverUId: model.uId);
        Get.to(Directionality(
          textDirection: TextDirection.rtl,
          child: ChatScreen(model),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage("${model.image}")
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Text(
                    "${model.name}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }else{
    return Container(width: 0.0,);
  }


}


