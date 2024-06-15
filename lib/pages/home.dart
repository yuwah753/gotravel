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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController userController = Get.find();
  List destinations = [];
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchDestinations();
  }

  Future fetchDestinations() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('destinations').get();
      final List<QueryDocumentSnapshot> documents = snapshot.docs;
      setState(() {
        destinations = documents.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error fetching destinations: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print("Error fetching destinations: $e");
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text('Ingin keluar dari aplikasi?', style: TextStyle(fontSize: 15)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              SystemNavigator.pop();
            },
            child: Text('Ya'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFF2D79DC),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  title: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Obx(() => CircleAvatar(
                                  backgroundImage:
                                      userController.getProfilePicture(),
                                  radius: 20,
                                )),
                            SizedBox(width: 5),
                            Obx(() => Text(
                                  '${userController.userName.value}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
                SizedBox(height: 20),
                Stack(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Explore the\n',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                          TextSpan(
                            text: 'Beautiful ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'world!',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 120,
                      bottom: -3,
                      child: Image.asset(
                        'images/line_bawah.png',
                        width: 100,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Best Destination',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          'View all',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'ABeeZee'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      var destination = destinations[index];
                      return GestureDetector(
                        onTap: () {
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
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height:
                                    MediaQuery.of(context).size.height * 0.51,
                                decoration: ShapeDecoration(
                                  color: Color(0xFFF8F9FA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x1EB3BCC8),
                                      blurRadius: 16,
                                      offset: Offset(0, 6),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 16,
                                left: 14,
                                right: 14,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        destination['image'],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                right: 20,
                                child: Opacity(
                                  opacity: 0.50,
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF1B1E28),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.5),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.bookmark_border,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 30,
                                left: 20,
                                right: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            destination['destination_name'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'ABeeZee'),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(Icons.star,
                                            size: 14, color: Colors.yellow),
                                        SizedBox(width: 4),
                                        Text(destination['rating'].toString()),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_on, size: 14),
                                              SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  destination['city'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              height: 20,
                                              child: Stack(
                                                children: [
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
                                                  Positioned(
                                                    left: 30,
                                                    child: CircleAvatar(
                                                      radius: 10,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Text(
                                                        '+50',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black,
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
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
          child: BottomNavigationBar(
            elevation: 0.0,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(),
                  child: Image.asset('images/plane-blue.png', height: 28),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: Image.asset('images/search.png', height: 24),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: Image.asset('images/notif.png', height: 24),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: Image.asset('images/person.png', height: 24),
                ),
                label: '',
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
