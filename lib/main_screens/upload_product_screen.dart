// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:gradal/widgets/snack_bar.dart';
// import 'package:image_picker/image_picker.dart';
//
// class UploadProductScreen extends StatefulWidget {
//   const UploadProductScreen({super.key});
//
//   @override
//   State<UploadProductScreen> createState() => _UploadProductScreenState();
// }
//
// class _UploadProductScreenState extends State<UploadProductScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
//       GlobalKey<ScaffoldMessengerState>();
//
//   late double price;
//   late int quantity;
//   late String productName;
//   late String productDescription;
//
//   void uploadProduct() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       print('validated');
//       print(price);
//       print(quantity);
//       print(productName);
//       print(productDescription);
//     } else {
//       MyMessageHandler.showSnackBar(
//         _scaffoldKey,
//         'Please fill all fields',
//       );
//     }
//   }
//
//   //! upload products images
//   final ImagePicker _picker = ImagePicker();
//
//   List<XFile>? imageFileList = [];
//   dynamic _pickedImageError;
//
//   //todo: image with camera
//   void _pickProductImages() async {
//     try {
//       final pickedImages = await _picker.pickMultiImage(
//         maxHeight: 300,
//         maxWidth: 300,
//         imageQuality: 95,
//       );
//       setState(() {
//         imageFileList = pickedImages!; //!
//       });
//     } catch (e) {
//       setState(() {
//         _pickedImageError = e;
//       });
//       print(_pickedImageError);
//     }
//   }
//
//   Widget previewImages() {
//     return ListView.builder(
//         itemCount: imageFileList!.length,
//         itemBuilder: (context, index) {
//       return Image.file(File(imageFileList![index].path));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldMessenger(
//       key: _scaffoldKey,
//       child: Scaffold(
//         body: SafeArea(
//           child: SingleChildScrollView(
//             reverse: true,
//             keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Row(
//                     children: <Widget>[
//                       Container(
//                         color: Colors.blueGrey.shade100,
//                         height: 250,
//                         width: 390,
//                         // height: MediaQuery.of(context).size.width * 0.5,
//                         // width: MediaQuery.of(context).size.width * 0.5,
//                         child: imageFileList != null ? previewImages() : Center(
//                           child: const Text(
//                             'You have not \n \n picked images yet!',
//                             style: TextStyle(fontSize: 16),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 30,
//                     child: Divider(color: Colors.yellow, thickness: 1.5),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.50,
//                       child: TextFormField(
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter price';
//                           } else if (value.isValidPrice() != true) {
//                             return 'Invalid price';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) {
//                           price = double.parse(value!);
//                         },
//                         keyboardType:
//                             TextInputType.numberWithOptions(decimal: true),
//                         //numberWithOptions(decimal: true,),
//                         decoration: textFormDecoration.copyWith(
//                           labelText: 'price',
//                           hintText: 'price \$',
//                         ),
//                       ),
//                     ),
//                   ),
//                   //todo quantity
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.50,
//                       child: TextFormField(
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter quantity';
//                           } else if (value.isValidQuantity() != true) {
//                             return 'Enter a valid quantity';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) {
//                           quantity = int.parse(value!);
//                         },
//                         keyboardType: TextInputType.number,
//                         decoration: textFormDecoration.copyWith(
//                           labelText: 'quantity',
//                           hintText: 'Enter Quantity',
//                         ),
//                       ),
//                     ),
//                   ),
//                   // product name:
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: TextFormField(
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter name';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) {
//                           productName = value!;
//                         },
//                         maxLength: 100,
//                         maxLines: 3,
//                         decoration: textFormDecoration.copyWith(
//                           labelText: 'product name',
//                           hintText: 'Enter Product name...',
//                         ),
//                       ),
//                     ),
//                   ),
//                   //! product description
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: TextFormField(
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter description';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) {
//                           productDescription = value!;
//                         },
//                         maxLength: 800,
//                         maxLines: 5,
//                         decoration: textFormDecoration.copyWith(
//                           labelText: 'description',
//                           hintText: 'Enter product description...',
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         // buttons
//         floatingActionButton: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.only(right: 10),
//               child: FloatingActionButton(
//                 onPressed: _pickProductImages,
//                 backgroundColor: Colors.yellow,
//                 child: Icon(
//                   Icons.photo_library,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 8),
//               child: FloatingActionButton(
//                 onPressed: uploadProduct,
//                 backgroundColor: Colors.yellow,
//                 child: Icon(
//                   Icons.upload,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// var textFormDecoration = InputDecoration(
//   labelText: 'price',
//   hintText: 'price \$',
//   labelStyle: const TextStyle(color: Colors.purple),
//   border: OutlineInputBorder(
//     borderRadius: BorderRadius.circular(10),
//   ),
//   enabledBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.yellow, width: 1),
//     borderRadius: BorderRadius.circular(10),
//   ),
//   focusedBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//     borderRadius: BorderRadius.circular(10),
//   ),
// );
//
// // validator
// extension QuantityValidator on String {
//   bool isValidQuantity() {
//     return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
//   }
// }
//
// extension PriceValidator on String {
//   bool isValidPrice() {
//     return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
//         .hasMatch(this);
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gradal/widgets/snack_bar.dart';
import 'package:image_picker/image_picker.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int quantity;
  late String productName;
  late String productDescription;

  //! upload products images
  final ImagePicker _picker = ImagePicker();

  List<XFile>? imageFileList = [];
  dynamic _pickedImageError;

  //todo: image with camera
  void _pickProductImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        imageFileList = pickedImages!; //!
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Widget previewImages() {
    return InkWell(
      onLongPress: () {
        setState(() {
          imageFileList = [];
        });
      },
      child: PageView.builder(
        itemCount: imageFileList!.length,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            margin: EdgeInsets.all(5),
            child: Image.file(
              colorBlendMode: BlendMode.multiply,
              File(imageFileList![index].path),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  void uploadProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (imageFileList!.isNotEmpty) {
        print('Images picked');
        setState(() {
          imageFileList = [];
        });
        _formKey.currentState!.reset();
      }else {
        MyMessageHandler.showSnackBar(
          _scaffoldKey,
          'Please pick images',
        );
      }
      print('validated');
      print(price);
      print(quantity);
      print(productName);
      print(productDescription);
    } else {
      MyMessageHandler.showSnackBar(
        _scaffoldKey,
        'Please fill all fields',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        child: imageFileList != null && imageFileList!.isNotEmpty
                            ? previewImages()
                            : Center(
                          child: const Text(
                            'You have not \n \n picked images yet!',
                            style: TextStyle(fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    child: Divider(color: Colors.yellow, thickness: 1.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter price';
                              } else if (value.isValidPrice() != true) {
                                return 'Invalid price';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              price = double.parse(value!);
                            },
                            keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                            decoration: textFormDecoration.copyWith(
                              labelText: 'price',
                              hintText: 'price \$',
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter quantity';
                              } else if (value.isValidQuantity() != true) {
                                return 'Enter a valid quantity';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              quantity = int.parse(value!);
                            },
                            keyboardType: TextInputType.number,
                            decoration: textFormDecoration.copyWith(
                              labelText: 'quantity',
                              hintText: 'Enter Quantity',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // product name:
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          productName = value!;
                        },
                        maxLength: 100,
                        maxLines: 3,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'product name',
                          hintText: 'Enter Product name...',
                        ),
                      ),
                    ),
                  ),
                  //! product description
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          productDescription = value!;
                        },
                        maxLength: 800,
                        maxLines: 5,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'description',
                          hintText: 'Enter product description...',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // buttons
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                onPressed: imageFileList!.isEmpty ? () {
                  _pickProductImages();
                } : () {
                  setState(() {
                    imageFileList = [];
                  });
                },
                backgroundColor: Colors.yellow,
                child: imageFileList!.isEmpty ? Icon(
                  Icons.photo_library,
                  color: Colors.black,
                ) : Icon(Icons.delete_forever, color: Colors.red,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FloatingActionButton(
                onPressed: uploadProduct,
                backgroundColor: Colors.yellow,
                child: Icon(
                  Icons.upload,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'price',
  hintText: 'price \$',
  labelStyle: const TextStyle(color: Colors.purple),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.yellow, width: 1),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
    borderRadius: BorderRadius.circular(10),
  ),
);

// validator
extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}
