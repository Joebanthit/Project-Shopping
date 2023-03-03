import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:projectshopping/states/detail_product_house.dart';

import 'package:projectshopping/utility/my_constant.dart';

import 'package:intl/intl.dart';

class ListProductBuy extends StatefulWidget {
  const ListProductBuy({super.key});

  @override
  State<ListProductBuy> createState() => _ListProductBuyState();
}

class _ListProductBuyState extends State<ListProductBuy> {
  @override //firebase

  final CollectionReference _Prodcuts =
      FirebaseFirestore.instance.collection('Product');

//
  final TextEditingController amountController = TextEditingController();
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
                    keyboardType: TextInputType.number,
                    controller: amountController,
                    decoration: const InputDecoration(
                        labelText: 'ระบุจำนวนที่ใช้งานสินค้า'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text(
                      "ยืนยัน",
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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f7f9),
      appBar: AppBar(
        title: Text('รายการสินค้าที่ควรซื้อเข้าบ้าน'),
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
              if (data['amount'] <= 1) {
                status = 'ควรซื้อ';

                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailProductHouse(data: data))),
                  child: Card(
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
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text("สถานะ : " + status,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                        child: Text(
                                          "เพิ่มสินค้าที่ซื้อเข้าบ้าน",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () => _useProdcut(data),
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
