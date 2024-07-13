import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';
import 'package:gradal/widgets/snack_bar.dart';
import 'package:gradal/widgets/yellow_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditStore extends StatefulWidget {
  const EditStore({
    super.key,
    required this.data,
  });

  final dynamic data;

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final ImagePicker _picker = ImagePicker();
  XFile? imageFileLogo;
  XFile? imageFileCover;
  dynamic _pickedImageError;
  late String storeName;
  late String phone;
  late String storeLogo;
  late String coverImage;
  bool processing = false;

  pickStoreLogoImage() async {
    try {
      final pickedStoreLogo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        imageFileLogo = pickedStoreLogo;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  pickCoverImage() async {
    try {
      final pickedSCoverImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        imageFileCover = pickedSCoverImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Future uploadStoreLogo() async {
    if (imageFileLogo != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-images/${widget.data['email']}.jpg');

        await ref.putFile(File(imageFileLogo!.path));
        storeLogo = await ref.getDownloadURL();
      }catch(e) {
        print(e);
      }
    } else {
      storeLogo = widget.data['storelogo'];
    }
  }

  Future uploadCoverImage() async {
    if (imageFileCover != null) {
      try {
        firebase_storage.Reference ref2 = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-images/${widget.data['email']}.jpg-cover');

        await ref2.putFile(File(imageFileCover!.path));
        coverImage = await ref2.getDownloadURL();
      }catch(e) {
        print(e);
      }
    } else {
      coverImage = widget.data['coverimage'];
    }
  }

  editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance.collection('suppliers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'storename': storeName,
        'phone': phone,
        'storelogo': storeLogo,
        'coverimage': coverImage,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  saveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        processing = true;
      });
      await uploadStoreLogo().whenComplete(() async => await uploadCoverImage()
      .whenComplete(() => editStoreData()));
    } else {
      MyMessageHandler.showSnackBar(scaffoldKey, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarBackButton(),
          elevation: 0,
          backgroundColor: Colors.white,
          title: AppBarTitle(
            title: 'Edit Store',
          ),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    'Store Logo',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(widget.data['storelogo']),
                      ),
                      Column(
                        children: [
                          YellowButton(
                            label: 'Change',
                            onPressed: () {
                              pickStoreLogoImage();
                            },
                            width: 0.25,
                          ),
                          SizedBox(height: 10),
                          imageFileLogo == null
                              ? SizedBox()
                              : YellowButton(
                                  label: 'Reset',
                                  onPressed: () {
                                    setState(() {
                                      imageFileLogo = null;
                                    });
                                  },
                                  width: 0.25,
                                ),
                        ],
                      ),
                      //todo: new logo
                      imageFileLogo == null
                          ? SizedBox()
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  FileImage(File(imageFileLogo!.path)),
                            ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Divider(
                      color: Colors.blue,
                      thickness: 2.5,
                    ),
                  )
                ],
              ),
              //todo: cover image
              Column(
                children: [
                  Text(
                    'Cover image',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            NetworkImage(widget.data['coverimage']),
                      ),
                      Column(
                        children: [
                          YellowButton(
                            label: 'Change',
                            onPressed: () {
                              pickCoverImage();
                            },
                            width: 0.25,
                          ),
                          SizedBox(height: 10),
                          imageFileCover == null
                              ? SizedBox()
                              : YellowButton(
                                  label: 'Reset',
                                  onPressed: () {
                                    setState(() {
                                      imageFileCover = null;
                                    });
                                  },
                                  width: 0.25,
                                ),
                        ],
                      ),
                      //todo: new logo
                      imageFileCover == null
                          ? SizedBox()
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  FileImage(File(imageFileCover!.path)),
                            ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Divider(
                      color: Colors.blue,
                      thickness: 2.5,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter store name';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    storeName = value!;
                  },
                  initialValue: widget.data['storename'],
                  decoration: textFormDecoration.copyWith(
                      labelText: 'store name', hintText: 'edit store name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter phone number';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    phone = value!;
                  },
                  initialValue: widget.data['phone'],
                  decoration: textFormDecoration.copyWith(
                      labelText: 'phone number', hintText: 'edit phone number'),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    YellowButton(
                      label: 'Cancel',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      width: 0.25,
                    ),
                    SizedBox(width: 10),
                  processing == true ? YellowButton(
                    label: 'Please wait ..',
                    onPressed: () {
                      null;
                    },
                    width: 0.5,
                  ) :  YellowButton(
                      label: 'Edit store',
                      onPressed: () {
                        saveChanges();
                      },
                      width: 0.5,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'Price',
  hintText: 'Price \$',
  labelStyle: const TextStyle(color: Colors.purple),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 1),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
    borderRadius: BorderRadius.circular(10),
  ),
);
