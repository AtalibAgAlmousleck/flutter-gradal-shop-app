import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';
import 'package:gradal/widgets/yellow_button.dart';
import 'package:image_picker/image_picker.dart';

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

  final ImagePicker _picker = ImagePicker();
  XFile? imageFileLogo;
  dynamic _pickedImageError;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(
          title: 'Edit Store',
        ),
        centerTitle: true,
      ),
      body: Column(
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
                  imageFileLogo == null ? SizedBox() :  YellowButton(
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
            imageFileLogo == null ? SizedBox() :  CircleAvatar(
                radius: 60,
                backgroundImage: FileImage(File(imageFileLogo!.path)),
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
    );
  }
}
