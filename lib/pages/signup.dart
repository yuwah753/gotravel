import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gotravel/pages/home.dart';

class SignUpPage extends StatefulWidget {
  // Class untuk halaman pendaftaran
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>(); // Key untuk form validasi
  final _nameController = TextEditingController(); // Controller untuk text field nama
  final _emailController = TextEditingController(); // Controller untuk text field email
  final _passwordController = TextEditingController(); // Controller untuk text field password
  bool _isPasswordVisible = false; // Status visibility untuk password
  final _auth = FirebaseAuth.instance; // Instance Firebase Authentication
  final _firestore = FirebaseFirestore.instance; // Instance Firestore

  Future<void> _signUp() async {
    // Fungsi untuk menangani proses pendaftaran
    if (_formKey.currentState!.validate()) { // Validasi form
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'reward_points': 0,
          'travel_trips': 0,
          'bucket_lists': 0,
          'profile_picture':
              'https://firebasestorage.googleapis.com/v0/b/gotravel-9fad0.appspot.com/o/profile_pictures%2Fprofile-picture.png?alt=media&token=b1c06e95-7a77-4aad-8e69-cca375aee1b1',
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        // Menangani error dari Firebase Authentication
        if (e.code == 'weak-password') {
          _showDialog('Password terlalu lemah.');
        } else if (e.code == 'email-already-in-use') {
          _showDialog('Email tersebut sudah terdaftar.');
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
        child: Padding(
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
                  Text(
                    'Daftar Sekarang',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        'Silahkan isi detail dan buat akun',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontFamily: 'ABeeZee'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText
