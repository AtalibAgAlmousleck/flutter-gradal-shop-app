import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/add_employee_dialog.dart';
import '../providers/employee.dart';
import '../providers/employee_provider.dart';

class ManageProduct extends StatelessWidget {
  const ManageProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> employeesStream =
    FirebaseFirestore.instance.collection('employees').snapshots();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Manage Employees', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: employeesStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final data = snapshot.requireData;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Country')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: data.docs.map((DocumentSnapshot document) {
                        Employee employee = Employee.fromFirestore(document);
                        return DataRow(
                          cells: [
                            DataCell(Text(employee.name)),
                            DataCell(Text(employee.email)),
                            DataCell(Text(employee.phone)),
                            DataCell(Text(employee.country)),
                            DataCell(Row(
                              children: [
                                // IconButton(
                                //   icon: Icon(Icons.edit),
                                //   onPressed: () {
                                //     // Add functionality to edit the employee
                                //   },
                                // ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red,),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('employees')
                                        .doc(employee.id)
                                        .delete();
                                  },
                                ),
                              ],
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            //SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (context) => AddEmployeeDialog(),
            //     );
            //   },
            //   child: Text('Add employee'),
            // ),
            SizedBox(height: 20),
            EmployeePagination(),
            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddEmployeeDialog(),
            );
          },
        ),
      ),
    );
  }
}

class EmployeePagination extends StatelessWidget {
  const EmployeePagination({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final pageCount = (employeeProvider.employees.length / employeeProvider.rowsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            iconColor: index == employeeProvider.currentPage ? Colors.blue : Colors.grey,
          ),
          child: Text('${index + 1}'),
          onPressed: () => employeeProvider.setPage(index),
        );
      }),
    );
  }
}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:gradal/widgets/app_bar_widgets.dart';
//
// class ManageProduct extends StatelessWidget {
//   const ManageProduct({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> productsStream = FirebaseFirestore
//         .instance.collection('products')
//         .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//         .snapshots();
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: AppBarTitle(title: 'Manage Employees'),
//         centerTitle: true,
//         leading: AppBarBackButton(),
//       ),
//       body: Center(
//         child: Text('Manage Employees'),
//       )
//     );
//   }
// }


// StreamBuilder<QuerySnapshot>(
//   stream: productsStream,
//   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//     if (snapshot.hasError) {
//       return Text('Something went wrong');
//     }
//
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return Center(
//         child: CircularProgressIndicator(
//         ),
//       );
//     }
//     if (snapshot.data!.docs.isEmpty) {
//       return Center(
//         child: Text('This category has no items yet!',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//           ),),
//       );
//     }
//     return SingleChildScrollView(
//       child: StaggeredGrid.count(
//         crossAxisCount: 2,
//         mainAxisSpacing: 4,
//         crossAxisSpacing: 4,
//         children: List.generate(snapshot.data!.docs.length, (index) {
//           var doc = snapshot.data!.docs[index];
//           return StaggeredGridTile.fit(
//             crossAxisCellCount: 1,
//             child: ProductModel(
//               //doc: doc,
//               products: snapshot.data!.docs[index],
//             ),
//           );
//         }),
//       ),
//     );
//   },
// ),