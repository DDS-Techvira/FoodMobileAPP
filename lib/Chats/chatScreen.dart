import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../model/ChatModel.dart';
import '../util/ConstantData.dart';
import '../util/ConstantWidget.dart';
import '../util/Network.dart';

class Technicalchat extends StatefulWidget {
  bool isInitiate;
  String PeerCode;
  // String peerName;
  String chatCode;
  String Question;
  String Description;
  Technicalchat(
      {Key? key,
      required this.PeerCode,
      // required this.peerName,
      required this.Question,
      required this.chatCode,
      required this.Description,
      required this.isInitiate})
      : super(key: key);

  @override
  _chatState createState() => _chatState();
}

String? UserCode;

class _chatState extends State<Technicalchat> {
  late bool initiate;
  bool _keyboardVisible = false;
  ScrollController _scrollController = new ScrollController();
  late String chatCode;
  @override
  void initState() {
    print(widget.chatCode);
    chatCode = widget.chatCode;
    print(chatCode);
    initiate = widget.isInitiate;

    getData();
    runTimer();
    // TODO: implement initState
    super.initState();

    initQuestion();
  }

  initQuestion() async {
    if (widget.isInitiate) {
      Future.delayed(const Duration(milliseconds: 3000), () async {
        await sendMessage(UserCode.toString(),
            DateTime.now().millisecondsSinceEpoch, '', widget.Description);
      });
    }
    Future.delayed(const Duration(milliseconds: 3500), () async {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // context.read<ChatProvider>().clearChatList();
    super.dispose();
  }

  final _peerMessageController = TextEditingController();
  Timer? timer;
  List newChat = [];
  void runTimer() {
    timer = Timer.periodic(Duration(seconds: 2), (_) {
      getData();
    });
  }

  Future<List<dynamic>> getData() async {
    // EasyLoading.show(status: 'Loading...');
    print(initiate);

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString('usercode');
    print(user);
    UserCode = user;
    var data = {
      'is_initiate': initiate == true ? 'true' : 'false',
      'principal_code': user,
      'chat_code': chatCode,
      'description': widget.Description,
      'message_subject': widget.Question,
    };
    var res = await Network()
        .postAPIData(data, '/chat/GetPrincipalTechnicalChatMessage');
    print(res.body);
    print(json.decode(res.body)['data']['chat_code']);
    // setState(() {
    initiate = false;
    chatCode = json.decode(res.body)['data']['chat_code'];
    // });
    newChat.clear();
    var datas = json.decode(res.body)['data'];
    for (Map<String, dynamic> item in json.decode(datas['chat_history'])) {
      var chats = Chat.fromJson(item);
      setState(() {});
      // ChatList.add(chats);

      newChat.add(item);
    }
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 50),
    );
    // EasyLoading.dismiss();
    return json.decode(datas['chat_history']);
  }

  // sendMessage(id, date, alias, message) {
  //
  // }
  sendMessage(id, date, alias, message) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString('user');
    var user_last = localStorage.getString('user_last_name');
    var user_code = localStorage.getString('usercode');
    //todo:
    var data = {
      "id": user_code.toString(),
      "date": date,
      "alias": user.toString() + ' ' + user_last.toString(),
      "message": message.toString()
    };
    print(data);
    newChat.add(data);
    // print(newChat);
    var requestBody = {
      'chat_code': chatCode,
      'chat_hostory': newChat,
      'last_reply': message.toString(),
      'tech_replied': 0,
      'principal_replied': 1
    };
    print(requestBody);
    var res = await Network()
        .postAPIData(requestBody, '/chat/UpdateTechnicalChatMessage');
    print("Response code is" + res.statusCode.toString());
    // print(_sendbody(Code, id, date, alias, message));
    // print(res.body);
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 50),
    );
  }

  // getdata() async {
  //   print(UserCode);
  //   print('getdata');
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var userCode = localStorage.getString('user_code');
  //   setState(() {
  //     UserCode = userCode.toString();
  //     chat =
  //         context.read<ChatProvider>().getChatList(widget.PeerCode,userCode, );
  //   });
  //   _scrollToLast();
  // }
  //
  // sendMessage(id, date, alias, message) {
  //   context.read<ChatProvider>().UpdateChatList(id, date, alias, message);
  //   _scrollToLast();
  // }

  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('MM-dd-yyyy hh:mm a');
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
      elevation: 0,
      title:    Text(
        widget.Question,
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'DM Serif Text',
            fontWeight: FontWeight.w500),
      ),
      backgroundColor: primaryColor,
      centerTitle: true,
      // leading: null,

      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: getPrimaryAppBarIcon(),
            onPressed: () {
              timer?.cancel();
              // await context.read<ChatProvider>().clearChatList();
              Navigator.pop(context);
            },
          );
        },
      ),
    ),

        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment(0.0, 0.4),
                    end: Alignment(0.0, 1.0),
                    colors: [Color(0xFFFFFFFF), Color(0xff9B91CA)])),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(children: [
                // Container(
                //   width: size.width,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(2),
                //     color: Color(0xFF000983).withOpacity(0.5),
                //   ),
                //   child: Text(
                //     widget.Description,
                //     style: TextStyle(color: Colors.white,fontSize: 15),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // FutureBuilder<List<dynamic>>(
                // future: getData(),
                //     builder: (context, snapshot) {
                //       print(newChat.length);

                // if (newChat == []) {
                //   return Container(
                //     // child: Center(child: Text("Loading...")),
                //   );
                // } else {
                Container(
                  height:
                      _keyboardVisible ? size.height - 500 : size.height - 180,
                  child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      // reverse: true,
                      padding: const EdgeInsets.all(3),
                      itemCount: newChat.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (newChat[index]['id'] == UserCode) {
                          print(UserCode);
                          return Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 0),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Text(
                                              'You',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      color: Color(0xFF000983),
                                    ),
                                    height:
                                        newChat[index]['message'].length < 40
                                            ? 50
                                            : null,
                                    width: newChat[index]['message'].length < 16
                                        ? 150
                                        : 300,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Text(
                                            newChat[index]['message'],
                                            maxLines: 10,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //     mainAxisAlignment: MainAxisAlignment.end,
                              //     children: [
                              //       Container(
                              //         margin: EdgeInsets.only(bottom: 10),
                              //         // decoration: BoxDecoration(
                              //         //   borderRadius: BorderRadius.only(
                              //         //       topLeft: Radius.circular(20),
                              //         //       bottomLeft: Radius.circular(20),
                              //         //       bottomRight: Radius.circular(20)),
                              //         //   color: Color(0xFF000983),
                              //         // ),
                              //
                              //         child: Padding(
                              //           padding: const EdgeInsets.symmetric(
                              //               horizontal: 0),
                              //           child: Center(
                              //             child: Padding(
                              //               padding: const EdgeInsets.symmetric(
                              //                   horizontal: 15),
                              //               child: Text(
                              //                 DateTime.fromMillisecondsSinceEpoch(snapshot.data![index].date).month.toString()+'-'+DateTime.fromMillisecondsSinceEpoch(snapshot.data![index].date).day.toString()+'-'+DateTime.fromMillisecondsSinceEpoch(snapshot.data![index].date).year.toString(),
                              //
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ]
                              // ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      // decoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.only(
                                      //       topLeft: Radius.circular(20),
                                      //       bottomLeft: Radius.circular(20),
                                      //       bottomRight: Radius.circular(20)),
                                      //   color: Color(0xFF000983),
                                      // ),

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Text(
                                              f
                                                  .format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          newChat[index]
                                                              ['date']))
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ])
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 0),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Text(
                                              newChat[index]['alias'],
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                        color: Color(0xFFDDDDDD),
                                      ),
                                      height:
                                          newChat[index]['message'].length < 40
                                              ? 50
                                              : null,
                                      width:
                                          newChat[index]['message'].length < 16
                                              ? 150
                                              : 300,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Center(
                                          child: Text(
                                            newChat[index]['message'],
                                            maxLines: 10,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      // decoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.only(
                                      //       topLeft: Radius.circular(20),
                                      //       bottomLeft: Radius.circular(20),
                                      //       bottomRight: Radius.circular(20)),
                                      //   color: Color(0xFF000983),
                                      // ),

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Text(
                                              f
                                                  .format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          newChat[index]
                                                              ['date']))
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ])
                            ],
                          );
                        }
                      }),
                ),
                // }
                //   },
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x23000983),
                            blurRadius: 10,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(children: <Widget>[
                          new Expanded(
                              child: new TextField(
                                  enabled: true,
                                  maxLines: null,

                                  controller: _peerMessageController,
                                  style: TextStyle(color: Colors.black ),
                                  decoration: InputDecoration(

                                      border: InputBorder.none,

                                      hintText: 'Enter Message..'))),
                          Visibility(
                            visible: true,
                            child: IconButton(
                                icon: Icon(Icons.send, color: Colors.blue,size: 30,),
                                onPressed: () {
                                  sendMessage(
                                      UserCode.toString(),
                                      DateTime.now().millisecondsSinceEpoch,
                                      '',
                                      _peerMessageController.text);
                                  _peerMessageController.clear();
                                }),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ]),
            )));
  }

  _typed() {
    if (_peerMessageController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void _scrollToLast() {
    try {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    } catch (err) {}
  }
}
