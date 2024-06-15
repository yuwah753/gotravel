import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var userId = ''.obs;
  var userEmail = ''.obs;
  var userName = ''.obs;
  var profilePictureUrl = ''.obs;

  void setUser(
      {required String id,
      required String email,
      required String name,
      String? profilePicUrl}) {
    userId.value = id;
    userEmail.value = email;
    userName.value = name;
    if (profilePicUrl != null && profilePicUrl.trim().isNotEmpty) {
      setProfilePictureUrl(profilePicUrl);
    }
  }

  void setProfilePictureUrl(String url) {
    profilePictureUrl.value = url;
  }

  ImageProvider getProfilePicture() {
    print("VALUE OF PROFILE PICTURE URL: " + profilePictureUrl.value);
    return NetworkImage(profilePictureUrl.value);
  }
}
