import 'package:chat_app/controllers/chat_controller.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class RegisterScreen extends StatelessWidget {

  ChatController controller = Get.put(ChatController());

  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "حساب جديد",
                    style: TextStyle(
                      fontSize: 50.0,
                    ),
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "الاسم"
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "يرجى ادخال الأسم أولاً";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "البريد الإلكترونى"
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "يرجى ادخال البريد الإليكترونى أولاً";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "كلمة المرور"
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "يرجى ادخال كلمة المرور أولاً";
                      }
                      if(value.length < 6){
                        return "يرجى استخدام كلمه سر أكبر من 6 حروف";
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    height: 50.0,
                    onPressed: () {
                      if(formKey.currentState!.validate()){
                        controller.register(name: nameController.text,email: emailController.text,password: passwordController.text);
                      }
                    },
                    child: GetBuilder<ChatController>(
                      builder: (controller)=> ConditionalBuilder(
                        condition: controller.isLoading == false,
                        builder: (context)=>Text(
                          "انشاء الحساب",
                          style: TextStyle(color: Colors.white,fontSize: 16.0),
                        ),
                        fallback: (context)=>CircularProgressIndicator(color: Colors.white,),
                      ),
                    ),
                    minWidth: 200.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
