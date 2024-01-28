import 'package:flutter/material.dart';
import 'package:gradal/utilities/categ_list.dart';
import '../widgets/category_widgets.dart';

class BeautyCategory extends StatelessWidget {
  const BeautyCategory({super.key});

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
                    headerLabel: 'Beauty category',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 8,
                      crossAxisCount: 3,
                      children: List.generate(beauty.length, (index) {
                        return SubcategoryModel(
                          menCategoryName: 'beauty',
                          subCategoryName: beauty[index],
                          assetName: 'images/beauty/beauty$index.jpg',
                          subcategoryLabel: beauty[index],
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
            child: SiliderBar(menCategoryNmae: 'beauty'),
          ),
        ],
      ),
    );
  }
}
