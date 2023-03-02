import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectshopping/model/Product.dart';
import 'package:projectshopping/states/detail_product_house.dart';

import 'package:projectshopping/states/use_product.dart';
import 'package:projectshopping/utility/my_constant.dart';

import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
//firebase
  final CollectionReference _Prodcuts =
      FirebaseFirestore.instance.collection('Product');

//Widget
  Widget addProduct() {
    return ListTile(
      leading: Icon(
        Icons.add,
        size: 40.0,
        color: Colors.green,
      ),
      title: Text('เพิ่มสินค้าเข้าบ้าน'),
      onTap: () => Navigator.pushNamed(context, MyConstant.routeAddProductBuy),
    );
  }

  Widget shouldBuy() {
    return ListTile(
      leading: Icon(
        Icons.checklist,
        size: 40.0,
        color: Colors.green,
      ),
      title: Text('รายการสินค้าที่ควรซื้อเข้าบ้าน'),
      onTap: () => Navigator.pushNamed(context, MyConstant.routeListProductBuy),
    );
  }

  Widget showHead() {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(MyConstant.image1), fit: BoxFit.cover),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 6.0,
          )
        ],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
        child: ListView(
      children: <Widget>[
        showHead(),
        addProduct(),
        shouldBuy(),
      ],
    ));
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  Future<void> _update([DocumentSnapshot? data]) async {
    if (data != null) {
      titleController.text = data['title'];
      amountController.text = data['amount'].toString();
      priceController.text = data['price'].toString();
      locationController.text = data['location'];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'ชื่อสินค้า'),
                  ),
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'จำนวน'),
                  ),
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'ราคา'),
                  ),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'สถานที่'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text(
                      "แก้ไข",
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () async {
                      final String title = titleController.text;
                      final String location = titleController.text;
                      final int? amount = int.tryParse(amountController.text);
                      final double? price =
                          double.tryParse(amountController.text);
                      if (amount != null) {
                        if (price != null) {
                          await _Prodcuts.doc(data!.id).update({
                            "title": title,
                            "amount": amount,
                            "price": price,
                            "location": location,
                          });
                          titleController.text = '';
                          amountController.text = '';
                          priceController.text = '';
                          locationController.text = '';
                        }
                      }
                      Navigator.pop(context);
                    },
                  ),
                ]),
          );
        });
  }

  Future<void> _useProdcut([DocumentSnapshot? data]) async {
    if (data != null) {
      amountController.text = data['amount'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'จำนวน'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text(
                      "ยืนยันข้อมูล",
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () async {
                      final int? amount = int.tryParse(amountController.text);

                      if (amount != null) {
                        await _Prodcuts.doc(data!.id).update({
                          "amount": amount,
                        });

                        amountController.text = '';
                      }
                      Navigator.pop(context);
                    },
                  ),
                ]),
          );
        });
  }

  //Home

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f7f9),
      appBar: AppBar(
        title: Text('แอพช่วยซื้อสินค้าเข้าบ้าน'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _Prodcuts.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasError) {
            return Text('Something went wrong');
          }

          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot data = streamSnapshot.data!.docs[index];

                var status = '';
                if (data['amount'] == 1) {
                  status = 'ควรซื้อ';
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.red.shade400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image(
                              image: NetworkImage(data['image'].toString()),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Text(
                                      data['title'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Text("สถานะ : " + status),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          child: Text(
                                            "ใช้งาน",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          onPressed: () => _useProdcut(data),
                                        ),
                                        ElevatedButton(
                                          child: Text(
                                            "แก้ไข",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          onPressed: () => _update(data),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (data['amount'] <= 5) {
                  status = 'ซื้อก็ได้ไม่ซื้อก็ไ้ด้';
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.orange.shade400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image(
                              image: NetworkImage(data['image'].toString()),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    data['title'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text("สถานะ : " + status),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        child: Text(
                                          "ใช้งาน",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () => _useProdcut(data),
                                      ),
                                      ElevatedButton(
                                        child: Text(
                                          "แก้ไข",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () => _update(data),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  );
                } else if (data['amount'] > 6) {
                  status = 'ไม่ควรซื้อ';
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.green.shade400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image(
                              image: NetworkImage(data['image'].toString()),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    data['title'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text("สถานะ : " + status),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        child: Text(
                                          "ใช้งาน",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () => _useProdcut(data),
                                      ),
                                      ElevatedButton(
                                        child: Text(
                                          "แก้ไข",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () => _update(data),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  );
                }
              });

          //   child: ListTile(
          //     onTap: () => Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 DetailProductHouse(data: data))),
          //     leading: Image.network(
          //       data['image'].toString(),
          //       fit: BoxFit.cover,
          //     ),
          //     title: Text(
          //       data['title'],
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //         fontSize: 25,
          //       ),
          //     ),
          //     subtitle: Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           "สถานะ : " + status,
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 16,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // );
        },
      ),
      drawer: showDrawer(),
    );
  }
}
