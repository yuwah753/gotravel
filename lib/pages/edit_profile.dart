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
  final UserController userController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _selectedImageUrl;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nameController.text = userController.userName.value;
    _emailController.text = userController.userEmail.value;
    _selectedImageUrl = userController.profilePictureUrl.value;
  }

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
        userController.userName.value = _nameController.text;
        userController.userEmail.value = _emailController.text;
        userController.setProfilePictureUrl(_selectedImageUrl ?? '');

        Navigator.pop(context);
      } catch (e) {
        print("Error updating profile: $e");
        _showDialog("Failed to update profile");
      }
    }
  }

  Future<void> _uploadImageToFirebase(File imageFile) async {
    try {
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${userController.userId.value}.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      _selectedImageUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image to Firebase: $e");
      _showDialog("Failed to upload profile picture");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImageToFirebase(_imageFile!);
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _cancelImageChange() {
    setState(() {
      _imageFile = null;
      _selectedImageUrl = userController.profilePictureUrl.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
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
        actions: [
          IconButton(
            icon: Text(
              'Done',
              style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            onPressed: _updateProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : _selectedImageUrl != null
                        ? NetworkImage(_selectedImageUrl!)
                        : userController.getProfilePicture(),
                radius: 50,
              ),
              TextButton(
                onPressed: _pickImage,
                child: Text('Change Profile Picture'),
              ),
              if (_imageFile != null)
                TextButton(
                  onPressed: _cancelImageChange,
                  child: Text('Cancel Change'),
                ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '${userController.userName.value}',
                  filled: true,
                  fillColor: Color(0xFFF7F7F9),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: '${userController.userEmail.value}',
                  filled: true,
                  fillColor: Color(0xFFF7F7F9),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be empty';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
