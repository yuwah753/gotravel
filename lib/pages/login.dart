import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotravel/pages/home.dart';
import 'package:gotravel/pages/signup.dart';
import 'package:gotravel/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Key untuk form validasi
  final _emailController = TextEditingController(); // Controller untuk text field email
  final _passwordController = TextEditingController(); // Controller untuk text field password
  bool _isPasswordVisible = false; // Status visibility untuk password
  final _auth = FirebaseAuth.instance; // Instance Firebase Authentication
  final _firestore = FirebaseFirestore.instance; // Instance Firestore

  final UserController userController = Get.put(UserController()); // Inisiasi UserController

  Future<void> _login() async {
    // Fungsi untuk menangani proses login
    if (_formKey.currentState!.validate()) { // Validasi form
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        final userDoc = await _firestore // Ambil data user dari firestore berdasarkan UID
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          userController.setUser( // Set data user ke UserController
            id: userCredential.user!.uid,
            email: _emailController.text,
            name: userDoc.data()!['name'],
            profilePicUrl: userDoc.data()!['profile_picture'],
          );
          print("User ID: " + userCredential.user!.uid);
          Navigator.pushReplacement( // Navigasi ke halaman Home dan hapus halaman login dari stack
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          _showDialog('User tidak ditemukan.');
        }
      } on FirebaseAuthException catch (e) {
        // Menangani error dari Firebase Authentication
        if (e.code == 'user-not-found') {
          _showDialog('Email tersebut tidak terdaftar.');
        } else if (e.code == 'wrong-password') {
          _showDialog('Password yang dimasukkan salah.');
        } else {
          _showDialog('Terjadi kesalahan. Silahkan coba lagi.');
        }
      } catch (e) {
        print(e);
        _showDialog('Terjadi kesalahan. Silahkan coba lagi.');
      }
    }
  }

  void _showDialog(String message) {
    // Fungsi untuk menampilkan dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menghilangkan resize pada bottom inset (keyboard)
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          // Agar konten bisa scroll jika keyboard muncul
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Batasi ukuran minimum kolom
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ABeeZee'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Silahkan masuk untuk melanjutkan',
                    style: TextStyle(color: Colors.grey, fontFamily: 'ABeeZee'),
