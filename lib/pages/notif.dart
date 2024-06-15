import 'package:flutter/material.dart';
import 'package:gotravel/pages/home.dart';
import 'package:gotravel/pages/profile.dart';
import 'package:gotravel/pages/search.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold adalah struktur layout utama untuk sebagian besar layar di Flutter
      appBar: AppBar(
        // AppBar adalah header di bagian atas layar
        leading: IconButton(
          // IconButton adalah tombol dengan ikon
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            // Navigasi kembali ke layar sebelumnya
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Notifikasi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Center(
        // Widget Center menyelaraskan anaknya di tengah ruang yang tersedia
        child: Column(
          // Column mengatur anak-anaknya secara vertikal
          mainAxisAlignment: MainAxisAlignment.center, // Menyelaraskan secara vertikal di tengah
          children: [
            Image.asset('images/nothing.png', height: 100),
            SizedBox(height: 20),
            Text(
              'Tidak ada notifikasi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // BottomNavigationBar menyediakan tombol untuk navigasi antar layar yang berbeda
        elevation: 0.0, // Menghilangkan bayangan default
        type: BottomNavigationBarType.fixed, // Jumlah item tetap
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(),
              child: Image.asset('images/plane.png', height: 24),
            ),
            label: '', // Tidak ada label teks untuk item ini
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(),
              child: Image.asset('images/search.png', height: 24),
            ),
            label: '', // Tidak ada label teks untuk item ini
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Image.asset('images/notif-blue.png', height: 28), // Ikon notifikasi yang disorot
            ),
            label: '', // Tidak ada label teks untuk item ini
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(),
              child: Image.asset('images/person.png', height: 24),
            ),
            label: '', // Tidak ada label teks untuk item ini
          ),
        ],
        onTap: (index) {
          // Menangani ketukan pada item navigasi bar bawah
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
              break;
            case 2:
              // Tidak ada tindakan untuk item notifikasi saat ini (sudah berada di NotificationScreen)
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
