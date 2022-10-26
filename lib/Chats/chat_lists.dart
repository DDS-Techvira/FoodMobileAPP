
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
// import 'package:principals_app/Screens/Home/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../util/ConstantData.dart';
import '../util/ConstantWidget.dart';
import 'chatScreen.dart';
import 'ongoing_chats.dart';
// import 'Calls.dart';
// import 'Chats.dart';

class ChatLists extends StatefulWidget {
  ChatLists({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<ChatLists> with TickerProviderStateMixin {
  final _User = TextEditingController();
  TextEditingController _questiontextFieldController = TextEditingController();
  TextEditingController _descriptiontextFieldController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  List notificationList = ["1", "2", "2"];
  var notifications=0;
  late String count;

  late TabController _tabController;
  _getNotificationCount()async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      notifications = localStorage.getInt('notifications')!;
    });

  }
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _getNotificationCount();
    // TODO: implement initState
    super.initState();
    count = notificationList.length.toString();
  }
  void onBackPress() {
   Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setState(() {
      count = notificationList.length.toString();
    });
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          title: Text('Chats'),
          backgroundColor: primaryColor,
          centerTitle: true,
          // leading: null,

          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: getPrimaryAppBarIcon(),
                onPressed: () {
                  onBackPress();
                },
              );
            },
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          height: size.height * 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 10,
              ),
              Expanded(
                child: TechnicalOngoingChat(),
              ),
            ],
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child:SizedBox(
              height: 115,
              width: 115,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  // CircleAvatar(
                  //   backgroundImage: AssetImage("assets/images/Profile Image.png"),
                  // ),
                  Positioned(
                      bottom: 0,
                      right: -25,
                      child: RawMaterialButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(

                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                  contentPadding: EdgeInsets.only(top: 10.0),
                                  content: Container(

                                    width: 350.0,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              "Create Diet Question",
                                              style: TextStyle(fontSize: 24.0),
                                            ),

                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                          height: 4.0,
                                        ),
                                        // dialog centre
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(  padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                              child:Text(
                                                "Topic",
                                                style: TextStyle(fontSize: 20.0),
                                              ),
                                            )

                                          ],
                                        ),
                                        Padding(  padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                          child: TextField(
                                            maxLines: 2,
                                            controller: _questiontextFieldController,
                                            decoration: new InputDecoration(
                                              border: InputBorder.none,
                                              filled: false,
                                              contentPadding: new EdgeInsets.only(
                                                  left: 10.0,
                                                  top: 10.0,
                                                  bottom: 10.0,
                                                  right: 10.0),
                                              hintText: ' add topic',
                                              hintStyle: new TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 18.0,
                                                fontFamily: 'helvetica_neue_light',
                                              ),
                                            ),
                                          ),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(  padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                              child:Text(
                                                "Question",
                                                style: TextStyle(fontSize: 20.0),
                                              ),
                                            )

                                          ],
                                        ),
                                        Padding(  padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                          child: TextField(
                                            maxLines: 4,
                                            controller: _descriptiontextFieldController,
                                            decoration: new InputDecoration(
                                              border: InputBorder.none,
                                              filled: false,
                                              contentPadding: new EdgeInsets.only(
                                                  left: 10.0,
                                                  top: 10.0,
                                                  bottom: 10.0,
                                                  right: 10.0),
                                              hintText: ' add question',
                                              hintStyle: new TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 18.0,
                                                fontFamily: 'helvetica_neue_light',
                                              ),
                                            ),
                                          ),),

                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            if(_questiontextFieldController.text.isNotEmpty && _descriptiontextFieldController.text.isNotEmpty){
                                              Navigator.pop(context);
                                              var question= _questiontextFieldController.text;
                                              var description= _descriptiontextFieldController.text;

                                              _questiontextFieldController.text='';
                                              _descriptiontextFieldController.text='';
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => Technicalchat(
                                                        isInitiate: true,
                                                        PeerCode: '',
                                                        chatCode: '',
                                                        Question:question,
                                                        Description:description,


                                                      )));



                                            }
                                            else{
                                              // Fluttertoast.showToast(
                                              //   msg: "Please enter the both question and description fields",
                                              //   toastLength: Toast.LENGTH_SHORT,
                                              // );
                                            }

                                          },
                                          child:Container(
                                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                                            decoration: BoxDecoration(
                                              color:  Color(0xff000983),
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(32.0),
                                                  bottomRight: Radius.circular(32.0)),
                                            ),
                                            child: new Text(
                                              'Submit',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontFamily: 'helvetica_neue_light',
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ) ,
                                        )




                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        elevation: 2.0,
                        fillColor: Color(0xFFF5F6F9),
                        child: Icon(Icons.add, color: Colors.blue,size: 40,),
                        padding: EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                      )),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            onPressed: () {


              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => NewScheduledPage(
              //         UsernameLogin: widget.UsernameLogin,
              //       )),
              // );
            })
    );
  }
}
