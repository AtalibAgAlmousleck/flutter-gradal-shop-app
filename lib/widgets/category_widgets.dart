import 'package:flutter/material.dart';

import '../minor_screens/sub_category_product.dart';

class SiliderBar extends StatelessWidget {
  const SiliderBar({super.key, required this.menCategoryNmae});

  final String menCategoryNmae;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.05,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50)),
          child: RotatedBox(
            quarterTurns: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                menCategoryNmae == 'beauty'
                    ? Text('')
                    : Text(
                        ' << ',
                        style: style,
                      ),
                Text(
                  menCategoryNmae.toUpperCase(),
                  style: style,
                ),
                menCategoryNmae == 'men'
                    ? Text('')
                    : Text(
                        ' >> '.toUpperCase(),
                        style: style,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// repeted text style!
const style = TextStyle(
  color: Colors.brown,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  letterSpacing: 10,
);

class SubcategoryModel extends StatelessWidget {
  const SubcategoryModel({
    super.key,
    required this.menCategoryName,
    required this.subCategoryName,
    required this.assetName,
    required this.subcategoryLabel,
  });

  final String menCategoryName;
  final String subCategoryName;
  final String assetName;
  final String subcategoryLabel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoryProduct(
              mencategoryName: menCategoryName,
              subcategoryName: subCategoryName,
            ),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            //!color: Colors.blue,
            height: 70,
            width: 70,
            child: Image(
              image: AssetImage(
                assetName,
              ),
            ),
          ),
          Text(
            subcategoryLabel,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}

class CategoryHeader extends StatelessWidget {
  const CategoryHeader({super.key, required this.headerLabel});

  final String headerLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Text(
        headerLabel,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
