import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class VendorController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//Fungsi untuk menyimpan image ke firebase
  _uploadVendorImageToStorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('storageImage').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

//Fungsi untuk menyimpan image ke firebase end

//Fungsi unuk mengambil store image
  pickStoreImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
      // Return an empty Uint8List instead of null
      return Uint8List(0);
    }
  }

  //menyimpan image ke firebase storage

  //fungsi mengambil image toko
  Future<String> registerVendor(
    String namaToko,
    String email,
    String phoneNumber,
    String countryValue,
    String stateValue,
    String cityValue,
    String taxRegistered,
    String nomorNPWP,
    Uint8List? image,
  ) async {
    String res = 'some error occurances';
    try {
      String storeImage = await _uploadVendorImageToStorage(image);

      //menyimpan data ke cloud storage
      await _firestore.collection('vendors').doc(_auth.currentUser!.uid).set({
        'NamaToko': namaToko,
        'Email': email,
        'phoneNumber': phoneNumber,
        'countryValue': countryValue,
        'stateValue': stateValue,
        'cityValue': cityValue,
        'taxRegistered': taxRegistered,
        'nomorNPWP': nomorNPWP,
        'storeImage': storeImage, // Store the URL of the uploaded image
        'approve': false,
      });
      res = 'success'; // Set 'success' if the data is saved successfully
    } catch (e) {
      res =
          'Error saving data to Firestore: $e'; // Store the specific error message
      print(res); // Print the error message for debugging
    }
    return res;
  }

  // fungsi mengambil image toko end

  //fungsi menyimpan vendor data

  //menyimpan detail dari toko vendor

  //menyimpan data ke cloud firestore

  //fungsi menyimpan data vendor end
}
