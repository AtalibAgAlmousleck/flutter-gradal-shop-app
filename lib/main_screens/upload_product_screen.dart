import 'package:flutter/material.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    color: Colors.blueGrey.shade100,
                    // height: 250,
                    // width: 390,
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Center(
                      child: const Text('You have not \n \n picked images yet!',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: 30,
                  child: Divider(
                    color: Colors.yellow,
                    thickness: 1.5
                  ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true
                    ),
                    //numberWithOptions(decimal: true,),
                    decoration: textFormDecoration.copyWith(
                      labelText: 'price',
                      hintText: 'price \$',
                    ),
                  ),
                ),
              ),
              //todo quantity
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: textFormDecoration.copyWith(
                      labelText: 'quantity',
                      hintText: 'Enter Quantity',
                    ),
                  ),
                ),
              ),
              // product name:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
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
      // buttons
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.yellow,
              child: Icon(Icons.photo_library, color: Colors.black,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.yellow,
              child: Icon(Icons.upload, color: Colors.black,),
            ),
          ),
        ],
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

