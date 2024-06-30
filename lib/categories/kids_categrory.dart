import 'package:flutter/material.dart';
import 'package:gradal/utilities/categ_list.dart';
import '../widgets/category_widgets.dart';

class KidsCategory extends StatelessWidget {
  const KidsCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CategoryHeader(
                    headerLabel: 'Kids category',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 8,
                      crossAxisCount: 3,
                      children: List.generate(kids.length - 1, (index) {
                        return SubcategoryModel(
                          menCategoryName: 'kids',
                          subCategoryName: kids[index + 1],
                          assetName: 'images/kids/kids$index.jpg',
                          subcategoryLabel: kids[index + 1],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SiliderBar(menCategoryNmae: 'kids'),
          ),
        ],
      ),
    );
  }
}
