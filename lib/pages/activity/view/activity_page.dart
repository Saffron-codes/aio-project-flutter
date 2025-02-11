import 'package:chatapp/config/theme/theme_constants.dart';
import 'package:chatapp/models/search_user_model.dart';
import 'package:chatapp/models/user_activity_model.dart';
import 'package:chatapp/utils/convert_to_ago.dart';
import 'package:chatapp/pages/activity/widgets/user_activity_tile.dart';
import 'package:chatapp/widgets/touchable_opacity.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_activity.dart';

class ActivityTabPage extends StatefulWidget {
  const ActivityTabPage({Key? key}) : super(key: key);

  @override
  _ActivityTabPageState createState() => _ActivityTabPageState();
}

class _ActivityTabPageState extends State<ActivityTabPage> {
  String dropdownvalue = 'Received';

  // List of items in our dropdown menu
  var items = [
    'Received',
    'Sent',
    'Seen',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: StreamProvider<List<UserActivity>>.value(
        value: UserActivityProvider().getAllActivities(),
        initialData: [],
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text("Activities",style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1),),
            bottom: TabBar(
              unselectedLabelStyle: TextStyle(color: Colors.grey),
              indicatorWeight: 5.0,
              tabs: const [
                Tab(
                  child: Text(
                    "Received",
                  ),
                ),
                Tab(
                  child: Text(
                    "Sent",
                  ),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: const [
              UserActivityList(category: "received"),
              UserActivityList(category: "sent"),
            ],
          ),
        ),
      ),
    );
    // return StreamProvider<List<UserActivity>>.value(
    //     value: UserActivityProvider().getAllActivities(),
    //     initialData: [],
    //     child: SafeArea(
    //       child: Column(
    //         // physics: BouncingScrollPhysics(),
    //         children: [
    //           Padding(
    //               padding: EdgeInsets.all(8.0),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(
    //                     "Activities",
    //                     style: TextStyle(color: Colors.white, fontSize: 30),
    //                   ),
    //                   DropdownButton(
    //                     value: dropdownvalue,
    //                     style: TextStyle(color: Colors.amber),
    //                     dropdownColor: Color.fromARGB(255, 2, 109, 180),
    //                     elevation: 2,
    //                     borderRadius: BorderRadius.circular(10),
    //                     underline: Container(),
    //                     icon: const Icon(Icons.keyboard_arrow_down),
    //                     items: items.map((String items) {
    //                       return DropdownMenuItem(
    //                         value: items,
    //                         child: Text(
    //                           items,
    //                           style: TextStyle(color: Colors.black),
    //                         ),
    //                       );
    //                     }).toList(),
    //                     onChanged: (String? newValue) {
    //                       setState(() {
    //                         dropdownvalue = newValue!;
    //                       });
    //                     },
    //                   ),
    //                 ],
    //               )),
    //           Flexible(
    //               child: UserActivityList(
    //             category: dropdownvalue.toLowerCase(),
    //           ))
    //         ],
    //       ),
    //     ));
  }
}

class UserActivityList extends StatefulWidget {
  final String category;
  const UserActivityList({Key? key, required this.category}) : super(key: key);

  @override
  _UserActivityListState createState() => _UserActivityListState();
}

class _UserActivityListState extends State<UserActivityList> {
  @override
  Widget build(BuildContext context) {
    final activityServices = Provider.of<List<UserActivity>>(context);
    List<SearchUser> _userList = Provider.of<List<SearchUser>>(context);
    List<UserActivity> _activities = [];
    List<Map<String, String>> _profiles = [];
    for (var user in _userList) {
      for (var activity in activityServices) {
        if (activity.friend_uid == user.uid) {
          if (activity.category == widget.category) {
            _activities.add(activity);
            _profiles.add({"name": user.name, "photo_url": user.photourl});
          }
        }
      }
    }
    return _activities.isNotEmpty
        ? ListView.separated(
            // shrinkWrap: true,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: _activities.length,
            separatorBuilder: (ctx, idx) => Padding(
              padding: const EdgeInsets.all(1),
              child: Divider(
                height: 10,
                color: Color.fromARGB(255, 45, 48, 53),
              ),
            ),
            itemBuilder: (ctx, idx) {
              return UserActivityTile(
                profile: _profiles[idx],
                activity: _activities[idx],
                isSent: _activities[idx].category == "sent" ? false : true,
              );
            },
          )
        : Center(
            heightFactor: 25,
            child: Text(
              "No Activities Found",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          );
  }
}
