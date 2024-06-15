import 'package:flutter/material.dart';
import 'package:gotravel/pages/booking.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> destination;

  DetailPage({required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Details',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                color: Color.fromARGB(27, 30, 40, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.bookmark_border,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(destination['image']),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    destination['destination_name'],
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'ABeeZee',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "${destination['address']}",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'ABeeZee',
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 40),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    color: Colors.grey, size: 15),
                                SizedBox(width: 3),
                                Text(destination['city'],
                                    style: TextStyle(
                                        fontFamily: 'ABeeZee',
                                        color: Colors.grey)),
                                Spacer(),
                                Icon(Icons.star,
                                    color: Colors.orange, size: 20),
                                Text(
                                  destination['rating'].toString(),
                                  style: TextStyle(fontSize: 13),
                                ),
                                Spacer(),
                                Text(
                                  "\$${destination['price']}/Person",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.lightBlue[300],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              'About Destination',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              destination['description'],
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BookingPage(destination: destination)),
                  );
                },
                child: Text('Book Now'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightBlue[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
