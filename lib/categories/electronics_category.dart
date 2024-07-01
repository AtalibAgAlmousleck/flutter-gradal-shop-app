// import 'package:flutter/material.dart';
// import 'package:gradal/utilities/categ_list.dart';
// import '../widgets/category_widgets.dart';
//
// class ElectronicCategory extends StatelessWidget {
//   const ElectronicCategory({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: Stack(
//         children: [
//           Positioned(
//             bottom: 0,
//             left: 0,
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height * 0.8,
//               width: MediaQuery.of(context).size.width * 0.75,
//               child: Column(
//                 //crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   CategoryHeader(
//                     headerLabel: 'Electronics category',
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.68,
//                     child: GridView.count(
//                       mainAxisSpacing: 30,
//                       crossAxisSpacing: 8,
//                       crossAxisCount: 3,
//                       children: List.generate(electronics.length - 1, (index) {
//                         return SubcategoryModel(
//                           menCategoryName: 'electronics',
//                           subCategoryName: electronics[index + 1],
//                           assetName: 'images/electronics/electronics$index.jpg',
//                           subcategoryLabel: electronics[index + 1],
//                         );
//                       }),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: SiliderBar(menCategoryNmae: 'electronics'),
//           ),
//         ],
//       ),
//     );
//   }
// }
