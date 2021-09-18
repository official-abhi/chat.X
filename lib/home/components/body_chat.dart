import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterchat/constrain.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/service/database_services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'message_field.dart';

class BodyChat extends StatefulWidget {
  final String roomid;
  const BodyChat({Key? key, required this.roomid}) : super(key: key);

  @override
  _BodyChatState createState() => _BodyChatState();
}

class _BodyChatState extends State<BodyChat> {
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }
  void scrollToBottom() {
    final bottomOffset = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      bottomOffset,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
    @override
    void dispose() {
      _scrollController.dispose();
      super.dispose();

  }
  }






  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Timer(
      Duration(seconds: 2),
          () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
    );
    return SingleChildScrollView(
      child: Container(
        height: size.height*0.75,

        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
                initialData: null,
                stream: FirebaseFirestore.instance
                    .collection('chatroom')
                    .doc(widget.roomid)
                    .collection('chats').orderBy("time",descending:false)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      controller: _scrollController,
                        itemCount: snapshot.data!.docs.length,
                    //    physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          Map dat = snapshot.data!.docs[index].data() as Map;


                          return Biuble(data: dat);

                          //Messagebox(size: size, data: dat);
                        });
                  } else {
                    return Container();
                  }
                }),
        //   MessageField(size: size, message: _message,roomid: widget.roomid,)
/*
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.photo),
                            ),
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send), onPressed:(){ DatabaseService().onMessageSend(_message.text, widget.roomid);}),
                  ],
                ),
              ),
            ),
*/
          ],
        ),
      ),
    );
  }

}



class Messagebox extends StatelessWidget {
  const Messagebox({Key? key, required this.size, required this.data})
      : super(key: key);
  final Size size;
  final Map<dynamic, dynamic> data;
  @override
  Widget build(BuildContext context) {
    bool send =
        (data['sendby'] == FirebaseAuth.instance.currentUser!.displayName);
    return Column(
        mainAxisAlignment:
            send ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: size.width * 0.6),
            child: Container(
              alignment: send ? Alignment.centerRight : Alignment.centerLeft,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: send ? kPrimaryLowColor : Color(0xFF62EA45)),
              child: Text(
                data['message'],
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ]);
  }
}

class Biuble extends StatelessWidget {
  const Biuble({Key? key, required this.data}) : super(key: key);
  final Map<dynamic, dynamic> data;

  @override
  Widget build(BuildContext context) {
    bool send =
        (data['sendby'] == FirebaseAuth.instance.currentUser!.displayName);

    return Column(children: <Widget>[
      Container(
        alignment: send ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.80,
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: send ? kPrimaryColor : Color(0xffffffff),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Text(
            data['message'],
            style: TextStyle(
              color: send ? Colors.white : kPrimaryColor,
            ),
          ),
        ),
      )
    ]);
  }
}
