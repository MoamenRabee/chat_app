class MessageModel{
  String? text;
  String? senderUId;
  String? receiverUId;
  String? dateTime;


  MessageModel({this.text,this.senderUId,this.receiverUId,this.dateTime});

  MessageModel.fromJson(Map <String,dynamic> json){
    this.text = json["text"];
    this.senderUId = json["senderUId"];
    this.receiverUId = json["receiverUId"];
    this.dateTime = json["dateTime"];
  }


  Map<String,dynamic> toMap(){
    return {
      "text" : this.text,
      "senderUId" : this.senderUId,
      "receiverUId" : this.receiverUId,
      "dateTime" : this.dateTime,
    };
  }


}