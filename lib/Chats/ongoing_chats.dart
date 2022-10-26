import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/Network.dart';
import 'chatScreen.dart';

class TechnicalOngoingChat extends StatefulWidget {
  // String username;
  // OngoingChatLists({Key? key, required this.username}) : super(key: key);

  @override
  _chatListState createState() => _chatListState();
}

late String name;

class _chatListState extends State<TechnicalOngoingChat> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // principal = context.read<CoachProvider>().getPrincipalList();
  }
  doNothing(id) {


    var data = {
      'id' : id
    };
    var res =  Network().postAPIData(data, '/Notifications/DeleteNotifications');



  }
  Future<List<dynamic>> fetchList() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString('usercode');

    var data = {
      'principal_code' : user
    };
    var res = await Network().postAPIData(data, '/chat/GetTechnicalChatListPrincipal');
    print(res.body);
    return json.decode(res.body)['data'];

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
          padding: const EdgeInsets.all(8.0),
          child:  RefreshIndicator(
            onRefresh: () async {
              (context as Element).reassemble();
            },
            child:FutureBuilder<List<dynamic>>(
              future: fetchList(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(child: Center(child: Text("")));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Technicalchat(
                                        isInitiate: false,
                                        PeerCode: '',
                                        chatCode: snapshot
                                            .data![index]['chat_code'],
                                        Question: snapshot
                                            .data![index]['subject'],
                                        Description: snapshot
                                            .data![index]['description'],


                                      )));

                          // snapshot.data[index]['type']=='new_appointment_request'? Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => CallSchduledList(   UsernameLogin: '',))):'';
                        },
                        child: Container(
                          width: size.width,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),

                            border: Border.all(
                              color: snapshot.data![index]['coach_replied'] == 1
                                  ? Colors.orange
                                  : Colors.transparent, width: 2,),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x23000983),
                                blurRadius: 20,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  ListTile(
                                    leading:CircleAvatar(
                                        backgroundImage:
                                        NetworkImage(
                                          Network().getBucketURL()+'/assets/coach/images/profile/'+snapshot.data![index]['profile_image'].toString(),
                                        )
                                    ) ,
                                    title: Text(
                                        snapshot.data![index]['subject'] ?? '-',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500)),
                                    subtitle: Text(
                                        snapshot.data![index]['description'] ??
                                            '-',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500)),

                                  ),


                                ],
                              )),
                        ),
                      );
                    },
                  );
                }
              }

          ),
    )

    );
  }
}
