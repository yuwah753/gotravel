import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gotravel/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserController userController = Get.find(); // Akses data pengguna

  // Kunci formulir dan pengontrol edit teks
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  // Penanganan gambar
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _selectedImageUrl;

  // Instansi Firestore
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    // Isi awal formulir dengan data pengguna
    _nameController.text = userController.userName.value;
    _emailController.text = userController.userEmail.value;
    _selectedImageUrl = userController.profilePictureUrl.value;
  }

  /// Memperbarui informasi profil pengguna di Firestore
  ///
  /// Memvalidasi input formulir, memperbarui Firestore dengan data pengguna,
  /// memperbarui status pengendali pengguna lokal, dan kembali ke halaman sebelumnya.
  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestore
            .collection('users')
            .doc(userController.userId.value)
            .update({
          'name': _nameController.text,
          'email': _emailController.text,
          'profile_picture': _selectedImageUrl ?? '',
        });

        // Perbarui status pengendali pengguna
        userController.userName.value = _nameController.text;
        userController.userEmail.value = _emailController.text;
        userController.setProfilePictureUrl(_selectedImageUrl ?? '');

        Navigator.pop(context);
      } catch (e) {
        print("Error memperbarui profil: <span class="math-inline">e"\);
\_showDialog\("Gagal memperbarui profil"\);
\}
\}
\}
/// Mengunggah gambar yang dipilih ke Firebase Storage
///
/// Mengunggah gambar yang disediakan ke Firebase Storage,
/// mengambil URL unduh, dan memperbarui URL gambar yang dipilih\.
Future<void\> \_uploadImageToFirebase\(File imageFile\) async \{
try \{
final storageRef \= firebase\_storage\.FirebaseStorage\.instance
\.ref\(\)
\.child\('profile\_pictures'\)
\.child\('</span>{userController.userId.value}.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      _selectedImageUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error mengunggah gambar ke Firebase: $e");
      _showDialog("Gagal mengunggah gambar profil");
    }
  }

  /// Membuka pemilih gambar untuk memilih gambar profil baru
  ///
  /// Membuka pemilih gambar dan memungkinkan pengguna untuk memilih gambar
  /// dari galeri perangkat mereka. Jika gambar dipilih, perbarui file gambar
  /// dan URL gambar yang dipilih, dan picu pengunggahan gambar.
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImageToFirebase(_imageFile!);
    }
  }

  /// Menampilkan dialog kesalahan dengan pesan yang disediakan
  ///
  /// Membuat dialog peringatan sederhana untuk menampilkan pesan kesalahan
  /// kepada pengguna.
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK
