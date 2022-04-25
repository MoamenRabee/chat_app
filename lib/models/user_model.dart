class UserModel{
  String? name;
  String? email;
  String? uId;
  String? image;
  bool? isOnline;

  UserModel({this.name,this.uId,this.email,this.image,this.isOnline});

  UserModel.fromJson(Map <String,dynamic> json){
    this.name = json["name"];
    this.email = json["email"];
    this.uId = json["uId"];
    this.image = json["image"];
    this.isOnline = json["isOnline"];
  }


  Map<String,dynamic> toMap(){
    return {
      "name" : this.name,
      "email" : this.email,
      "uId" : this.uId,
      "image" : this.image,
      "isOnline" : this.isOnline,
    };
  }


}