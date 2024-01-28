import 'package:flutter/material.dart';
import 'package:gradal/utilities/categ_list.dart';

// List<String> images = [
//   'images/men/men0.jpg',
//   'images/men/men1.jpg',
//   'images/men/men2.jpg',
//   'images/men/men3.jpg',
//   'images/men/men4.jpg',
//   'images/men/men5.jpg',
//   'images/men/men6.jpg',
//   'images/men/men7.jpg',
//   'images/men/men8.jpg',
// ];

List<String> tryIt = ['shirt', 'jeans', 'shoes', 'jackets'];

class MenCategroryScreen extends StatelessWidget {
  const MenCategroryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(30.0),
          child: Text(
            'Men category',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.68,
          child: GridView.count(
            mainAxisSpacing: 30,
            crossAxisSpacing: 8,
            crossAxisCount: 3,
            children: List.generate(men.length, (index) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    //!color: Colors.blue,
                    height: 70,
                    width: 70,
                    child: Image(
                      image: AssetImage(
                        'images/men/men$index.jpg',
                      ),
                    ),
                  ),
                  Text(men[index])
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
