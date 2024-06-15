import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotravel/controllers/user_controller.dart';
import 'package:gotravel/pages/detail.dart';
import 'package:gotravel/pages/home.dart';
import 'package:gotravel/pages/notif.dart';
import 'package:gotravel/pages/profile.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final UserController userController = Get.find();
  List destinations = [];
  List filteredDestinations = [];
  TextEditingController searchController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchDestinations();
    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
  }

  Future fetchDestinations() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('destinations').get();
      final List<QueryDocumentSnapshot> documents = snapshot.docs;
      setState(() {
        destinations = documents.map((doc) => doc.data()).toList();
        filteredDestinations = destinations;
      });
    } catch (e) {
      print("Error fetching destinations: $e");
    }
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList.addAll(destinations);
    if (query.isNotEmpty) {
      List dummyListData = [];
      dummySearchList.forEach((item) {
        if (item['destination_name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredDestinations = dummyListData;
      });
      return;
    } else {
      setState(() {
        filteredDestinations = destinations;
      });
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
          'Search',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              searchController.clear();
            },
            child: Text('Cancel', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.mic_none),
                hintText: 'Search Places',
                hintStyle: TextStyle(
                  fontFamily: 'ABeeZee',
                ),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 3.0,
                childAspectRatio: 0.72,
              ),
              itemCount: filteredDestinations.length,
              itemBuilder: (context, index) {
                var destination = filteredDestinations[index];
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
                  child: Container(
                    child: Card(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide.none,
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              destination['image'],
                              width: double.infinity,
                              height: 124,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Opacity(
                              opacity: 0.40,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  color: Color(0xFF1B1E28),
                                ),
                                child: Icon(
                                  Icons.favorite_border_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            bottom: 8,
                            right: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  destination['destination_name'],
                                  style: TextStyle(fontFamily: 'ABeeZee'),
                                ),
                                SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined,
                                        color: Colors.grey, size: 15),
                                    SizedBox(width: 3),
                                    Text(destination['city'],
                                        style: TextStyle(
                                            fontFamily: 'ABeeZee',
                                            color: Colors.grey)),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating:
                                          double.parse(destination['rating']),
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      destination['rating'],
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: destination['price'] + 'K',
                                        style: TextStyle(
                                          color: Colors.lightBlue[300],
                                          fontSize: 13,
                                          fontFamily: 'ABeeZee',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '/Person',
                                        style: TextStyle(
                                          color: Color(0xFF7C838D),
                                          fontSize: 13,
                                          fontFamily: 'ABeeZee',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(),
              child: Image.asset('images/plane.png', height: 24),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Image.asset('images/search-blue.png', height: 28),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(),
              child: Image.asset('images/notif.png', height: 24),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(),
              child: Image.asset('images/person.png', height: 24),
            ),
            label: '',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
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
    );
  }
}
