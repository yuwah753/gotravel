import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gotravel/controllers/user_controller.dart';
import 'package:gotravel/pages/edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserController userController = Get.find();
  final _firestore = FirebaseFirestore.instance;

  int _travelTrips = 0;
  int _bucketList = 0;
  int _rewardPoints = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userController.userId.value)
          .get();
      setState(() {
        _bucketList = userDoc['bucket_lists'] ?? 0;
        _rewardPoints = userDoc['reward_points'] ?? 0;
      });

      // Get travel trips from bookings
      QuerySnapshot bookingsSnapshot = await _firestore
          .collection('bookings')
          .where('user_id', isEqualTo: userController.userId.value)
          .get();
      setState(() {
        _travelTrips = bookingsSnapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset('images/edit.png'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Obx(() => CircleAvatar(
                radius: 50,
                backgroundImage: userController.getProfilePicture(),
              )),
          SizedBox(height: 10),
          Obx(() => Text(
                '${userController.userName.value}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          Obx(() => Text(
                '${userController.userEmail.value}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('Reward Points',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('$_rewardPoints',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 112, 41),
                      )),
                ],
              ),
              Column(
                children: [
                  Text('Travel Trips',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('$_travelTrips',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 112, 41),
                      )),
                ],
              ),
              Column(
                children: [
                  Text('Bucket List',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('$_bucketList',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 112, 41),
                      )),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Image.asset('images/person.png'),
                  title: Text('Profile'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                ListTile(
                  leading: Image.asset('images/bookmark.png'),
                  title: Text('Bookmarked'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                ListTile(
                  leading: Image.asset('images/previous-trip.png'),
                  title: Text('Previous Trips'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                ListTile(
                  leading: Image.asset('images/setting.png'),
                  title: Text('Settings'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                ListTile(
                  leading: Image.asset('images/version.png'),
                  title: Text('Version'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
