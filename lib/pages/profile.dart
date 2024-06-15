import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gotravel/controllers/user_controller.dart';
import 'package:gotravel/pages/edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ProfileScreen widget to display the user's profile
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

// State for ProfileScreen widget
class _ProfileScreenState extends State<ProfileScreen> {
  // Instance of UserController to access user data
  final UserController userController = Get.find();
  // Instance of FirebaseFirestore to access Firestore database
  final _firestore = FirebaseFirestore.instance;

  // Variables to store user data
  int _travelTrips = 0;
  int _bucketList = 0;
  int _rewardPoints = 0;

  // Initialize the state of the widget
  @override
  void initState() {
    super.initState();
    // Fetch user data from Firestore database
    _fetchUserData();
  }

  // Function to fetch user data from Firestore database
  Future<void> _fetchUserData() async {
    try {
      // Get the user document from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userController.userId.value)
          .get();
      // Update the state with fetched user data
      setState(() {
        _bucketList = userDoc['bucket_lists'] ?? 0;
        _rewardPoints = userDoc['reward_points'] ?? 0;
      });

      // Get travel trips from bookings
      QuerySnapshot bookingsSnapshot = await _firestore
          .collection('bookings')
          .where('user_id', isEqualTo: userController.userId.value)
          .get();
      // Update the state with fetched travel trip count
      setState(() {
        _travelTrips = bookingsSnapshot.docs.length;
      });
    } catch (e) {
      // Print an error message if an error occurs while fetching user data
      print('Error fetching user data: $e');
    }
  }

  // Build the UI of the ProfileScreen widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Back button
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios, // Back arrow icon
            color: Colors.black, // Icon color
            size: 20, // Icon size
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        // App bar title
        title: Text(
          'Profile', // App bar title text
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true, // Center the title
        // Edit profile button
        actions: [
          IconButton(
            icon: Image.asset('images/edit.png'), // Edit icon
            onPressed: () {
              // Navigate to the EditProfilePage when the edit button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
          ),
        ],
      ),
      // Body of the profile screen
      body: Column(
        children: [
          SizedBox(height: 20), // Add space at the top
          // User profile picture
          Obx(() => CircleAvatar(
                radius: 50, // Radius of the profile picture
                backgroundImage: userController.getProfilePicture(), // Get profile picture from UserController
              )),
          SizedBox(height: 10), // Add space below the profile picture
          // User name
          Obx(() => Text(
                '${userController.userName.value}', // Get user name from UserController
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          // User email
          Obx(() => Text(
                '${userController.userEmail.value}', // Get user email from UserController
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )),
          SizedBox(height: 20), // Add space below the user email
          // Row to display user data (reward points, travel trips, bucket list)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space items evenly
            children: [
              // Column for reward points
              Column(
                children: [
                  Text('Reward Points',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('$_rewardPoints',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 112, 41), // Text color
                      )),
                ],
              ),
              // Column for travel trips
              Column(
                children: [
                  Text('Travel Trips',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('$_travelTrips',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 112, 41), // Text color
                      )),
                ],
              ),
              // Column for bucket list
              Column(
                children: [
                  Text('Bucket List',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('$_bucketList',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 112, 41), // Text color
                      )),
                ],
              ),
            ],
          ),
          SizedBox(height: 20), // Add space below the user data row
          // Expanded ListView for profile options
          Expanded(
            child: ListView(
              children: [
                // Profile option
                ListTile(
                  leading: Image.asset('images/person.png'), // Profile icon
                  title: Text('Profile'), // Title of the option
                  trailing: Icon(Icons.arrow_forward_ios), // Arrow icon
                  onTap: () {}, // Handle tap event
                ),
                // Bookmarked option
                ListTile(
                  leading: Image.asset('images/bookmark.png'), // Bookmark icon
                  title: Text('Bookmarked'), // Title of the option
                  trailing: Icon(Icons.arrow_forward_ios), // Arrow icon
                  onTap: () {}, // Handle tap event
                ),
                // Previous Trips option
                ListTile(
                  leading: Image.asset('images/previous-trip.png'), // Previous trip icon
                  title: Text('Previous Trips'), // Title of the option
                  trailing: Icon(Icons.arrow_forward_ios), // Arrow icon
                  onTap: () {}, // Handle tap event
                ),
                // Settings option
                ListTile(
                  leading: Image.asset('images/setting.png'), // Setting icon
                  title: Text('Settings'), // Title of the option
                  trailing: Icon(Icons.arrow_forward_ios), // Arrow icon
                  onTap: () {}, // Handle tap event
                ),
                // Version option
                ListTile(
                  leading: Image.asset('images/version.png'), // Version icon
                  title: Text('Version'), // Title of the option
                  trailing: Icon(Icons.arrow_forward_ios), // Arrow icon
                  onTap: () {}, // Handle tap event
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
