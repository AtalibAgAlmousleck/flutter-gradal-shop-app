// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:gradal/utilities/categ_list.dart';
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
//   String mainCategoryValue = 'select category';
//   String subCategValue = 'subcategory';
//   List<String> subCategList = [];
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
//     return InkWell(
//       onLongPress: () {
//         setState(() {
//           imageFileList = [];
//         });
//       },
//       child: ListView.builder(
//           itemCount: imageFileList!.length,
//           itemBuilder: (context, index) {
//         return Image.file(File(imageFileList![index].path));
//       }),
//     );
//   }
//
//   void selectedCategory(String? value) {
//     if (value == 'select category') {
//       subCategList = [];
//     }else if (value == 'men') {
//       subCategList = men;
//     } else if (value == 'women') {
//       subCategList = women;
//     } else if (value == 'electronics') {
//       subCategList = electronics;
//     } else if (value == 'accessories') {
//       subCategList = accessories;
//     } else if (value == 'shoes') {
//       subCategList = shoes;
//     } else if (value == 'home & garden') {
//       subCategList = homeandgarden;
//     } else if(value == 'beauty') {
//       subCategList = beauty;
//     } else if (value == 'kids') {
//       subCategList = kids;
//     } else if(value == 'bags') {
//       subCategList = bags;
//     }
//     setState(() {
//       mainCategoryValue = value!;
//       subCategValue = 'subcategory';
//     });
//   }
//
//   void uploadProduct() {
//     if (mainCategoryValue != 'select category' && subCategValue != 'subcategory') {
//       if (_formKey.currentState!.validate()) {
//         _formKey.currentState!.save();
//         if (imageFileList!.isNotEmpty) {
//           // print('validated');
//           // print(price);
//           // print(quantity);
//           // print(productName);
//           // print(productDescription);
//           setState(() {
//             imageFileList = [];
//             mainCategoryValue = 'select category';
//             subCategValue = 'subcategory';
//           });
//           _formKey.currentState!.reset();
//         } else {
//           MyMessageHandler.showSnackBar(_scaffoldKey, 'Please pick images');
//         }
//       } else {
//         MyMessageHandler.showSnackBar(
//           _scaffoldKey,
//           'Please fill all fields',
//         );
//       }
//     }else {
//       MyMessageHandler.showSnackBar(_scaffoldKey, 'Please select categories');
//     }
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
//                         // height: 250,
//                         // width: 390,
//                         height: MediaQuery.of(context).size.width * 0.5,
//                         width: MediaQuery.of(context).size.width * 0.5,
//                         child: imageFileList != null
//                             && imageFileList!.isNotEmpty ? previewImages() : Center(
//                           child: const Text(
//                             'You have not \n \n picked images yet!',
//                             style: TextStyle(fontSize: 16),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                       //todo: drop down categories
//                       Column(
//                         children: <Widget>[
//                           const Text('select main category'),
//                           DropdownButton(
//                             value: mainCategoryValue,
//                             items: maincateg
//                             .map<DropdownMenuItem<String>>((value) {
//                               return DropdownMenuItem(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             onChanged: (String? value) {
//                               selectedCategory(value);
//                             },
//                           ),
//                           //todo: sub category:
//                           const Text('select subcategory'),
//                           DropdownButton(
//                             disabledHint: const Text('select category'),
//                             value: subCategValue,
//                             items: subCategList
//                                 .map<DropdownMenuItem<String>>((value) {
//                               return DropdownMenuItem(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             onChanged: (String? value) {
//                               setState(() {
//                                 subCategValue = value!;
//                               });
//                             },
//                           ),
//                         ],
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
//                 onPressed: imageFileList!.isEmpty ? () {
//                   _pickProductImages();
//                 } : () {
//                   setState(() {
//                     imageFileList = [];
//                   });
//                 },
//                 backgroundColor: Colors.yellow,
//                 child: imageFileList!.isEmpty ? Icon(
//                   Icons.photo_library,
//                   color: Colors.black,
//                 ) : Icon(Icons.delete_forever, color: Colors.red,),
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradal/utilities/categ_list.dart';
import 'package:gradal/widgets/snack_bar.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

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
  String mainCategoryValue = 'select category';
  String subCategValue = 'subcategory';
  List<String> subCategList = [];

  final ImagePicker _picker = ImagePicker();
  List<XFile>? imageFileList = [];
  List<String> imageUriList = [];
  dynamic _pickedImageError;

  void _pickProductImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        imageFileList = pickedImages!;
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

  // Widget previewImages() {
  //   return InkWell(
  //     onLongPress: () {
  //       setState(() {
  //         imageFileList = [];
  //       });
  //     },
  //     child: ListView.builder(
  //         itemCount: imageFileList!.length,
  //         itemBuilder: (context, index) {
  //           return Image.file(File(imageFileList![index].path));
  //         }),
  //   );
  // }

  void selectedCategory(String? value) {
    if (value == 'select category') {
      subCategList = [];
    } else if (value == 'men') {
      subCategList = men;
    } else if (value == 'women') {
      subCategList = women;
    } else if (value == 'electronics') {
      subCategList = electronics;
    } else if (value == 'accessories') {
      subCategList = accessories;
    } else if (value == 'shoes') {
      subCategList = shoes;
    } else if (value == 'home & garden') {
      subCategList = homeandgarden;
    } else if (value == 'beauty') {
      subCategList = beauty;
    } else if (value == 'kids') {
      subCategList = kids;
    } else if (value == 'bags') {
      subCategList = bags;
    }
    setState(() {
      mainCategoryValue = value!;
      subCategValue = 'subcategory';
    });
  }

  Future<void> uploadImages() async {
    if (mainCategoryValue != 'select category' && subCategValue != 'subcategory') {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (imageFileList!.isNotEmpty) {

          try {
            for (var image in imageFileList!) {
              firebase_storage.Reference ref =
              firebase_storage.FirebaseStorage.instance.ref(
                  'products/${path.basename(image.path)}'
              );
              await ref.putFile(File(image.path))
                  .whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imageUriList.add(value);
                });
              });
            }
          }catch(e) {print(e);}
          
        } else {
          MyMessageHandler.showSnackBar(_scaffoldKey, 'Please pick images');
        }
      } else {
        MyMessageHandler.showSnackBar(
          _scaffoldKey,
          'Please fill all fields',
        );
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please select categories');
    }
  }

  void uploadData() async {
    if (imageUriList.isNotEmpty) {
      CollectionReference productRef =
        FirebaseFirestore.instance.collection('products');
        await productRef.doc().set({
          'maincateg': mainCategoryValue,
          'subcateg': subCategValue,
          'price': price,
          'instock': quantity,
          'proname': productName,
          'prodesc': productDescription,
          'sid': FirebaseAuth.instance.currentUser!.uid,
          'proimages': imageUriList,
          'discount': 0
        }).whenComplete(() {
          setState(() {
            imageFileList = [];
            mainCategoryValue = 'select category';
            subCategList = [];
            imageUriList = [];
          });
          _formKey.currentState!.reset();
        });
    } else {
      print('no images uploaded');
    }
  }

  void uploadProduct() async {
    await uploadImages().whenComplete(() => uploadData());
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
                      Expanded(
                        child: Container(
                          color: Colors.blueGrey.shade100,
                          height: MediaQuery.of(context).size.width * 0.5,
                          child: imageFileList != null && imageFileList!.isNotEmpty
                              ? previewImages()
                              : Center(
                            child: const Text(
                              'You have not \n \n picked images yet!',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    child: Divider(color: Colors.yellow, thickness: 1.5),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter price';
                              } else if (!value.isValidPrice()) {
                                return 'Invalid price';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              price = double.parse(value!);
                            },
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: textFormDecoration.copyWith(
                              labelText: 'Price',
                              hintText: 'Price \$',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter quantity';
                              } else if (!value.isValidQuantity()) {
                                return 'Enter a valid quantity';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              quantity = int.parse(value!);
                            },
                            keyboardType: TextInputType.number,
                            decoration: textFormDecoration.copyWith(
                              labelText: 'Quantity',
                              hintText: 'Enter Quantity',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Dropdowns below price and quantity
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: DropdownButtonFormField<String>(
                            decoration: textFormDecoration.copyWith(
                              labelText: 'Main Category',
                            ),
                            value: mainCategoryValue,
                            items: maincateg.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              selectedCategory(value);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: DropdownButtonFormField<String>(
                            decoration: textFormDecoration.copyWith(
                              labelText: 'Subcategory',
                            ),
                            value: subCategValue,
                            items: subCategList.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                subCategValue = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                        labelText: 'Product Name',
                        hintText: 'Enter Product Name...',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                        labelText: 'Description',
                        hintText: 'Enter Product Description...',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                onPressed: imageFileList!.isEmpty
                    ? () {
                  _pickProductImages();
                }
                    : () {
                  setState(() {
                    imageFileList = [];
                  });
                },
                backgroundColor: Colors.yellow,
                child: imageFileList!.isEmpty
                    ? Icon(
                  Icons.photo_library,
                  color: Colors.black,
                )
                    : Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
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
  labelText: 'Price',
  hintText: 'Price \$',
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



//todo: another solution builder
// import 'dart:io';
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
//   GlobalKey<ScaffoldMessengerState>();
//
//   late String category;
//   late String subcategory;
//   late double price;
//   late int quantity;
//   late String productName;
//   late String productDescription;
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
//     return InkWell(
//       onLongPress: () {
//         setState(() {
//           imageFileList = [];
//         });
//       },
//       child: PageView.builder(
//         itemCount: imageFileList!.length,
//         itemBuilder: (context, index) {
//           return Container(
//             width: MediaQuery.of(context).size.width,
//             height: 100,
//             margin: EdgeInsets.all(5),
//             child: Image.file(
//               colorBlendMode: BlendMode.multiply,
//               File(imageFileList![index].path),
//               fit: BoxFit.cover,
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void uploadProduct() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       if (imageFileList!.isNotEmpty) {
//         print('Images picked');
//         setState(() {
//           imageFileList = [];
//         });
//         _formKey.currentState!.reset();
//       }else {
//         MyMessageHandler.showSnackBar(
//           _scaffoldKey,
//           'Please pick images',
//         );
//       }
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
//   List<String> categories = ['Electronics', 'Fashion', 'Home', 'Beauty'];
//   Map<String, List<String>> subcategories = {
//     'Electronics': ['Phones', 'Laptops', 'Cameras'],
//     'Fashion': ['Men', 'Women', 'Kids'],
//     'Home': ['Furniture', 'Decor', 'Appliances'],
//     'Beauty': ['Makeup', 'Skincare', 'Haircare']
//   };
//
//   List<String> currentSubcategories = [];
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
//                       SizedBox(
//                         height: 280,
//                         width: MediaQuery.of(context).size.width,
//                         child: imageFileList != null && imageFileList!.isNotEmpty
//                             ? previewImages()
//                             : Center(
//                           child: const Text(
//                             'You have not picked images yet!',
//                             style: TextStyle(fontSize: 25),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   // SizedBox(
//                   //   height: 20,
//                   //   child: Divider(color: Colors.yellow, thickness: 1.5),
//                   // ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Please enter price';
//                               } else if (value.isValidPrice() != true) {
//                                 return 'Invalid price';
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               price = double.parse(value!);
//                             },
//                             keyboardType:
//                             TextInputType.numberWithOptions(decimal: true),
//                             decoration: textFormDecoration.copyWith(
//                               labelText: 'price',
//                               hintText: 'price \$',
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: TextFormField(
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Please enter quantity';
//                               } else if (value.isValidQuantity() != true) {
//                                 return 'Enter a valid quantity';
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               quantity = int.parse(value!);
//                             },
//                             keyboardType: TextInputType.number,
//                             decoration: textFormDecoration.copyWith(
//                               labelText: 'quantity',
//                               hintText: 'Enter Quantity',
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: DropdownButtonFormField<String>(
//                             decoration: textFormDecoration.copyWith(
//                               labelText: 'Category',
//                             ),
//                             items: categories.map((String category) {
//                               return DropdownMenuItem<String>(
//                                 value: category,
//                                 child: Text(category),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 category = newValue!;
//                                 currentSubcategories =
//                                 subcategories[category]!;
//                               });
//                             },
//                             validator: (value) =>
//                             value == null ? 'Please select a category' : null,
//                             onSaved: (value) {
//                               category = value!;
//                             },
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: DropdownButtonFormField<String>(
//                             decoration: textFormDecoration.copyWith(
//                               labelText: 'Subcategory',
//                             ),
//                             items: currentSubcategories.map((String subcategory) {
//                               return DropdownMenuItem<String>(
//                                 value: subcategory,
//                                 child: Text(subcategory),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 subcategory = newValue!;
//                               });
//                             },
//                             validator: (value) => value == null
//                                 ? 'Please select a subcategory'
//                                 : null,
//                             onSaved: (value) {
//                               subcategory = value!;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
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
//                 onPressed: imageFileList!.isEmpty ? () {
//                   _pickProductImages();
//                 } : () {
//                   setState(() {
//                     imageFileList = [];
//                   });
//                 },
//                 backgroundColor: Colors.blue,
//                 child: imageFileList!.isEmpty ? Icon(
//                   Icons.photo_library,
//                  // color: Colors.black,
//                 ) : Icon(Icons.delete_forever, color: Colors.red,),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 8),
//               child: FloatingActionButton(
//                 onPressed: uploadProduct,
//                 backgroundColor: Colors.blue,
//                 child: Icon(
//                   Icons.upload,
//                   //color: Colors.black,
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
//   labelStyle: const TextStyle(color: Colors.blue),
//   border: OutlineInputBorder(
//     borderRadius: BorderRadius.circular(10),
//   ),
//   enabledBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.blue, width: 1),
//     borderRadius: BorderRadius.circular(10),
//   ),
//   focusedBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.blue, width: 2),
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
