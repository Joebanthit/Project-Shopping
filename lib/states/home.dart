import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectshopping/model/Product.dart';
import 'package:projectshopping/states/detail_product_house.dart';
import 'package:projectshopping/states/edit_product.dart';
import 'package:projectshopping/states/use_product.dart';
import 'package:projectshopping/utility/my_constant.dart';

import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  //Home

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f7f9),
      appBar: AppBar(
        title: Text('แอพช่วยซื้อสินค้าเข้าบ้าน'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Product').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              var title = snapshot.data!.docs[index]['title'];
              var image = snapshot.data!.docs[index]['image'];
              var location = snapshot.data!.docs[index]['location'];
              var amount = snapshot.data!.docs[index]['amount'];
              var price = snapshot.data!.docs[index]['price'];
              var timestamp = snapshot.data!.docs[index]['timestamp'];
              var docId = snapshot.data!.docs[index].id;

              var status = '';

              if (amount == 1) {
                status = 'ควรซื้อ';

                return Container(
                  height: 110,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          spreadRadius: 3,
                          offset: Offset(3, 4))
                    ],
                  ),
                  child: ListTile(
                    onTap: () {
                      Get.to(() => DetailProductHouse(), arguments: {
                        'title': title,
                        'location': location,
                        'amount': amount,
                        'price': price,
                        'image': image,
                        'timestamp': timestamp,
                        'docId': docId,
                      });
                    },
                    leading: Image.network(
                      image.toString(),
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "สถานะ : " + status,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text(
                                "ใช้งาน",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                Get.to(() => UseProduct(), arguments: {
                                  'amount': amount,
                                  'docId': docId,
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text(
                                "แก้ไข",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                Get.to(() => EditProduct(), arguments: {
                                  'title': title,
                                  'location': location,
                                  'amount': amount,
                                  'price': price,
                                  'image': image,
                                  'timestamp': timestamp,
                                  'docId': docId,
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (amount <= 5) {
                status = 'ซื้อก็ได้ไม่ซื้อก็ได้';
                return Container(
                  height: 110,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade400,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          spreadRadius: 3,
                          offset: Offset(3, 4))
                    ],
                  ),
                  child: ListTile(
                    onTap: () {
                      Get.to(() => DetailProductHouse(), arguments: {
                        'title': title,
                        'location': location,
                        'amount': amount,
                        'price': price,
                        'image': image,
                        'timestamp': timestamp,
                        'docId': docId,
                      });
                    },
                    leading: Image.network(
                      image.toString(),
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "สถานะ : " + status,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text(
                                "ใช้งาน",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                Get.to(() => UseProduct(), arguments: {
                                  'amount': amount,
                                  'docId': docId,
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text(
                                "แก้ไข",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                Get.to(() => EditProduct(), arguments: {
                                  'title': title,
                                  'location': location,
                                  'amount': amount,
                                  'price': price,
                                  'image': image,
                                  'timestamp': timestamp,
                                  'docId': docId,
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (amount > 6) {
                status = 'ไม่ต้องซื้อ';
                return Container(
                  height: 110,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          spreadRadius: 3,
                          offset: Offset(3, 4))
                    ],
                  ),
                  child: ListTile(
                    onTap: () {
                      Get.to(() => DetailProductHouse(), arguments: {
                        'title': title,
                        'location': location,
                        'amount': amount,
                        'price': price,
                        'image': image,
                        'timestamp': timestamp,
                        'docId': docId,
                      });
                    },
                    leading: Image.network(
                      image.toString(),
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "สถานะ : " + status,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text(
                                "ใช้งาน",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                Get.to(() => UseProduct(), arguments: {
                                  'amount': amount,
                                  'docId': docId,
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text(
                                "แก้ไข",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                Get.to(() => EditProduct(), arguments: {
                                  'title': title,
                                  'location': location,
                                  'amount': amount,
                                  'price': price,
                                  'image': image,
                                  'timestamp': timestamp,
                                  'docId': docId,
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (amount == 0) {}
            },
          );
        },
      ),
      drawer: showDrawer(),
    );
  }
}
