import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectshopping/states/detail_product_buy.dart';
import 'package:projectshopping/states/detail_product_house.dart';
import 'package:projectshopping/states/edit_product.dart';
import 'package:projectshopping/states/use_product.dart';
import 'package:projectshopping/utility/my_constant.dart';

import 'package:intl/intl.dart';

class ListProductBuy extends StatefulWidget {
  const ListProductBuy({super.key});

  @override
  State<ListProductBuy> createState() => _ListProductBuyState();
}

class _ListProductBuyState extends State<ListProductBuy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f7f9),
      appBar: AppBar(
        title: Text('รายการสินค้าที่ควรซื้อเข้าบ้าน'),
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
                  height: 100,
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
                      Get.to(() => DetailProductBuy(), arguments: {
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
                      ],
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
