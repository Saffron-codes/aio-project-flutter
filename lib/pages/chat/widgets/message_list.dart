import 'dart:async';

import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/widgets/message_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class MessageList extends StatefulWidget {
  final Friend friend;
  final String chatroomid;
  const MessageList(
      {Key? key,
      required this.friend,
      required this.chatroomid,
      })
      : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController _scrollcontroller = ScrollController();
  void _scrollToBottom() {
    if (_scrollcontroller.hasClients) {
      _scrollcontroller.animateTo(_scrollcontroller.position.maxScrollExtent,
          duration: Duration(microseconds: 1), curve: Curves.fastOutSlowIn);
    } else {
      //Timer(Duration(milliseconds: 400), () => _scrollToBottom());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    List<Message> messagelist = Provider.of<List<Message>>(context);
    final currentUser = context.watch<User>();
    final friend = widget.friend;
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        //How many pixels scrolled from pervious frame
        // print(notification.scrollDelta);
        return true;
      },
      child: ListView(
        controller: _scrollcontroller,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 100,
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 80,
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(currentUser.photoURL.toString()),
                    radius: 30,
                  ),
                ),
                Positioned(
                  top: 25,
                  left: 180,
                  child: Text(
                    "⚡",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 100,
                  child: Text(
                    "Begining of chat with ${friend.name}",
                    style: TextStyle(fontSize: 13, color: Color(0xffD8D8D8)),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 80,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(friend.photourl),
                    radius: 30,
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: messagelist.length,
            // controller: _scrollcontroller,
            itemBuilder: (_, idx) {
              return MessageWidget(
                message: Message(
                    messagelist[idx].message,
                    messagelist[idx].from,
                    messagelist[idx].time,
                    messagelist[idx].type,
                    messagelist[idx].reactions,
                    messagelist[idx].id),
                chatroomid: widget.chatroomid,
              );
            },
          )
        ],
      ),
    );
  }
}
