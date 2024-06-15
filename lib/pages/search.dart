import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Untuk dependency management
import 'package:gotravel/controllers/user_controller.dart'; // Untuk mengakses user controller
import 'package:gotravel/pages/detail.dart';
import 'package:gotravel/pages/home.dart';
import 'package:gotravel/pages/notif.dart';
import 'package:gotravel/pages/profile.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Untuk menampilkan rating bar
import 'package:cloud_firestore/cloud_firestore.dart'; // Untuk akses ke firestore

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final UserController userController = Get.find(); // Mendapatkan user controller
  List destinations = []; // Daftar destinasi wisata
  List filteredDestinations = []; // Daftar destinasi wisata yang difilter
  TextEditingController searchController = TextEditingController(); // Controller untuk text field pencarian
  final _firestore = FirebaseFirestore.instance; // Instance Firestore

  @override
  void initState() {
    super.initState();
    fetchDestinations(); // Memanggil fungsi untuk mengambil data destinasi
    searchController.addListener(() {
      filterSearchResults(searchController.text); // Menangani perubahan text field pencarian
    });
  }

  Future fetchDestinations() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('destinations').get(); // Mengambil data dari koleksi 'destinations'
      final List<QueryDocumentSnapshot> documents = snapshot.docs;
      setState(() {
        destinations = documents.map((doc) => doc.data()).toList(); // Memproses data menjadi list
        filteredDestinations = destinations; // Set data awal yang difilter sama dengan semua destinasi
      });
    } catch (e) {
      print("Error fetching destinations: $e"); // Menampilkan pesan error jika terjadi kesalahan
    }
  }

  void filterSearchResults(String query) {
    List dummySearchList = []; // List temporary untuk proses filtering
    dummySearchList.addAll(destinations); // Menyalin semua data destinasi ke list temporary
    if (query.isNotEmpty) {
      List dummyListData = [];
      dummySearchList.forEach((item) {
        if (item['destination_name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) {
          // Mencari destinasi yang sesuai dengan keyword pencarian (case-insensitive)
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredDestinations = dummyListData; // Update data destinasi yang difilter
      });
      return;
    } else {
      setState(() {
        filteredDestinations = destinations; // Reset data destinasi yang difilter jika text field kosong
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
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: Text(
          'Pencarian',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              searchController.clear(); // Membersihkan text field pencarian
            },
            child: Text('Batal', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController, // Mengaitkan text field dengan controller
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), // Menampilkan icon pencarian
                suffixIcon: Icon(Icons.mic_none), // Menampilkan icon microphone (non-fungsional)
                hintText: 'Cari Tempat', // Text hint untuk text field
                hintStyle: TextStyle(
                  fontFamily: 'ABeeZee',
                ),
                border: InputBorder.none, // Menghilangkan border default
                filled: true, // Mengisi background text field
                fillColor: Colors.grey
