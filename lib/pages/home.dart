import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gotravel/controllers/user_controller.dart';
import 'package:gotravel/pages/detail.dart';
import 'package:gotravel/pages/notif.dart';
import 'package:gotravel/pages/profile.dart';
import 'package:gotravel/pages/search.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// HomeScreen widget to display the home screen of the app
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// State for HomeScreen widget
class _HomeScreenState extends State<HomeScreen> {
  // Instance of UserController to access user data
  final UserController userController = Get.find();
  // List to store destinations data
  List destinations = [];
  // Instance of FirebaseFirestore to access Firestore database
  final _firestore = FirebaseFirestore.instance;

  // Initialize the state of the widget
  @override
  void initState() {
    super.initState();
    // Fetch destinations data from Firestore database
    fetchDestinations();
  }

  // Function to fetch destinations data from Firestore database
  Future fetchDestinations() async {
    try {
      // Get a snapshot of the 'destinations' collection
      final QuerySnapshot snapshot =
          await _firestore.collection('destinations').get();
      // Get a list of documents from the snapshot
      final List<QueryDocumentSnapshot> documents = snapshot.docs;
      // Update the destinations list with data from the documents
      setState(() {
        destinations = documents.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      // Show a toast message if an error occurs while fetching destinations
      Fluttertoast.showToast(
          msg: "Error fetching destinations: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // Print the error message to the console
      print("Error fetching destinations: $e");
    }
  }

  // Function to handle the 'onWillPop' event, prompting the user to confirm exit
  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ingin keluar dari aplikasi?',
            style: TextStyle(fontSize: 15)), // Alert dialog title
        actions: <Widget>[
          // 'Tidak' button to cancel exit
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Tidak'),
          ),
          // 'Ya' button to confirm exit
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              SystemNavigator.pop(); // Exit the app
            },
            child: Text('Ya'),
          ),
        ],
      ),
    );
  }

  // Build the UI of the HomeScreen widget
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle 'onWillPop' event
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Prevent bottom inset from resizing the Scaffold
        backgroundColor: Color(0xFF2D79DC), // Set background color
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25), // Add space at the top
                // User profile section
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  title: Row(
                    children: [
                      // Container for user profile picture and name
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.white, // Container background color
                          border: Border.all(color: Colors.white), // Container border
                          borderRadius: BorderRadius.circular(30), // Container border radius
                        ),
                        child: Row(
                          children: [
                            // User profile picture
                            Obx(() => CircleAvatar(
                                  backgroundImage:
                                      userController.getProfilePicture(), // Get profile picture from UserController
                                  radius: 20, // Radius of the profile picture
                                )),
                            SizedBox(width: 5), // Add space between profile picture and name
                            // User name
                            Obx(() => Text(
                                  '${userController.userName.value}', // Get user name from UserController
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    fontSize: 18, // Text size
                                    fontFamily: 'Inter', // Text font family
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navigate to the ProfileScreen when tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
                SizedBox(height: 20), // Add space after user profile section
                // Welcome message section
                Stack(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Explore the\n',
                            style: TextStyle(
                                color: Colors.white, fontSize: 30), // Text style for 'Explore the'
                          ),
                          TextSpan(
                            text: 'Beautiful ',
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 30, // Text size
                              fontWeight: FontWeight.bold, // Text font weight
                            ),
                          ),
                          TextSpan(
                            text: 'world!',
                            style: TextStyle(
                              color: Colors.orange, // Text color
                              fontSize: 30, // Text size
                              fontWeight: FontWeight.bold, // Text font weight
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Image for the line below the welcome message
                    Positioned(
                      left: 120, // Position the image to the left
                      bottom: -3, // Position the image at the bottom
                      child: Image.asset(
                        'images/line_bawah.png', // Image path
                        width: 100, // Image width
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30), // Add space after welcome message section
                // Best Destination section
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text for 'Best Destination'
                      Text(
                        'Best Destination',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 17, // Text size
                          fontWeight: FontWeight.bold, // Text font weight
                        ),
                      ),
                      // Text for 'View all'
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          'View all',
                          style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 14,
                              fontFamily: 'ABeeZee'), // Text style for 'View all'
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Add space after 'Best Destination' section
                // List of destinations
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Scroll horizontally
                    itemCount: destinations.length, // Number of destinations
                    itemBuilder: (context, index) {
                      // Get the destination data for the current index
                      var destination = destinations[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to the DetailPage when a destination is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(destination: destination),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Stack(
                            children: [
                              // Container for the destination card
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.7, // Width of the destination card
                                height: MediaQuery.of(context).size.height *
                                    0.51, // Height of the destination card
                                decoration: ShapeDecoration(
                                  color: Color(0xFFF8F9FA), // Container background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24), // Container border radius
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x1EB3BCC8), // Shadow color
                                      blurRadius: 16, // Shadow blur radius
                                      offset: Offset(0, 6), // Shadow offset
                                      spreadRadius: 0, // Shadow spread radius
                                    )
                                  ],
                                ),
                              ),
                              // Image of the destination
                              Positioned(
                                top: 16, // Position the image at the top
                                left: 14, // Position the image to the left
                                right: 14, // Position the image to the right
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.65, // Image width
                                  height: MediaQuery.of(context).size.height *
                                      0.4, // Image height
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        destination['image'], // Get image URL from destination data
                                      ),
                                      fit: BoxFit.cover, // Fit the image to the container
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20), // Image border radius
                                    ),
                                  ),
                                ),
                              ),
                              // Bookmark icon
                              Positioned(
                                top: 20, // Position the icon at the top
                                right: 20, // Position the icon to the right
                                child: Opacity(
                                  opacity: 0.50, // Set icon opacity
                                  child: Container(
                                    width: 25, // Icon width
                                    height: 25, // Icon height
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF1B1E28), // Icon background color
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.5), // Icon border radius
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.bookmark_border, // Icon type
                                      color: Colors.white, // Icon color
                                      size: 20, // Icon size
                                    ),
                                  ),
                                ),
                              ),
                              // Destination details section
                              Positioned(
                                bottom: 30, // Position the details at the bottom
                                left: 20, // Position the details to the left
                                right: 20, // Position the details to the right
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Destination name and rating
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            destination[
                                                'destination_name'], // Get destination name from destination data
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'ABeeZee'), // Text style for destination name
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Spacer(), // Add space between name and rating
                                        Icon(Icons.star,
                                            size: 14,
                                            color: Colors.yellow), // Star icon for rating
                                        SizedBox(width: 4),
                                        // Display rating
                                        Text(destination['rating'].toString()),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    // Destination location
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_on,
                                                  size: 14), // Location icon
                                              SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  destination['city'], // Get destination city from destination data
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Number of reviews
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 50, // Container width
                                              height: 20, // Container height
                                              child: Stack(
                                                children: [
                                                  // Images for reviews
                                                  Positioned(
                                                    left: 0,
                                                    child: CircleAvatar(
                                                      radius: 10,
                                                      backgroundImage: AssetImage(
                                                          'images/eclipse21.png'),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 10,
                                                    child: CircleAvatar(
                                                      radius: 10,
                                                      backgroundImage: AssetImage(
                                                          'images/eclipse22.png'),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 20,
                                                    child: CircleAvatar(
                                                      radius: 10,
                                                      backgroundImage: AssetImage(
                                                          'images/eclipse23.png'),
                                                    ),
                                                  ),
                                                  // Text for number of reviews
                                                  Positioned(
                                                    left: 30,
                                                    child: CircleAvatar(
                                                      radius: 10,
                                                      backgroundColor:
                                                          Colors.white, // Background color of the circle
                                                      child: Text(
                                                        '+50', // Text for the number of reviews
                                                        style: TextStyle(
                                                          fontSize: 10, // Text size
                                                          color: Colors.black, // Text color
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Bottom navigation bar
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
          child: BottomNavigationBar(
            elevation: 0.0, // Remove shadow from the bottom navigation bar
            type: BottomNavigationBarType.fixed, // Fix the number of items in the bottom navigation bar
            items: [
              // Home item
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(),
                  child: Image.asset(
                      'images/plane-blue.png', height: 28), // Image for the home item
                ),
                label: '',
              ),
              // Search item
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: Image.asset(
                      'images/search.png', height: 24), // Image for the search item
                ),
                label: '',
              ),
              // Notifications item
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: Image.asset(
                      'images/notif.png', height: 24), // Image for the notifications item
                ),
                label: '',
              ),
              // Profile item
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: Image.asset(
                      'images/person.png', height: 24), // Image for the profile item
                ),
                label: '',
              ),
            ],
            onTap: (index) {
              // Handle navigation based on the tapped item
              switch (index) {
                case 0:
                  break; // Do nothing for the home item
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchScreen()),
                  ); // Navigate to the search screen
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()),
                  ); // Navigate to the notifications screen
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  ); // Navigate to the profile screen
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
