import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectshopping/model/Product.dart';
import 'package:projectshopping/states/detail_product_house.dart';
import 'package:projectshopping/utility/my_constant.dart';
import 'package:projectshopping/widgets/show_image.dart';
import 'package:intl/intl.dart';
import 'package:projectshopping/states/edit_product.dart';
//model

class DetailProductHouse extends StatefulWidget {
  const DetailProductHouse({super.key});

  @override
  State<DetailProductHouse> createState() => _DetailProductHouseState();
}

class _DetailProductHouseState extends State<DetailProductHouse> {
  @override
  //Field

  //firebase

//Method
  Widget editButton() {
    return SizedBox(
      child: ElevatedButton(
        child: Text(
          "แก้ไข",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () async {
          Navigator.pushNamed(context, MyConstant.routeHome);
        },
      ),
    );
  }

  Widget useButton() {
    return SizedBox(
      child: ElevatedButton(
        child: Text(
          "ใช้งาน",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () async {
          Navigator.pushNamed(context, MyConstant.routeUseProduct);
        },
      ),
    );
  }

  Widget deleteButton() {
    return SizedBox(
      child: ElevatedButton(
        child: Text(
          "ลบ",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () async {
          Navigator.pushNamed(context, MyConstant.routeHome);
        },
      ),
    );
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f7f9),
      appBar: AppBar(
        title: Text('รายละเอียดสินค้า'),
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
              final data = documents[index].data() as Map<String, dynamic>;
              var docId = snapshot.data!.docs[index].id;

              var x = '';
              if (data['amount'] == 1) {
                x = 'ควรซื้อ';
              } else if (data['amount'] <= 5) {
                x = 'ซื้อก็ได้ไม่ซื้อก็ได้';
              } else {
                x = 'ไม่ต้องซื้อ';
              }
              final timestamp = data['timestamp'] as Timestamp;
              final formattedDate =
                  DateFormat('dd MMM yyyy').format(timestamp.toDate());
              final formattedTime =
                  DateFormat(' hh:mm aaa').format(timestamp.toDate());
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      data['image'],
                      fit: BoxFit.cover,
                    ),
                    ListTile(
                      title: Text(
                        data['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "จำนวน : " + data['amount'].toString() + "  ชิ้น",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "ราคา : " + data['price'].toString() + "  บาท",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "สถานที่ : " + data['location'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "วันที่ : " + formattedDate,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "เวลา : " + formattedTime,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "สถานะ : " + x,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(8.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(
                                  child: ElevatedButton(
                                    child: Text(
                                      "แก้ไข",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      Navigator.pushNamed(
                                          context, MyConstant.routeEditProduct);
                                    },
                                  ),
                                ),
                                useButton(),
                                SizedBox(
                                  child: ElevatedButton(
                                    child: Text(
                                      "ลบ",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      FirebaseFirestore.instance
                                          .collection("Product")
                                          .doc(docId)
                                          .delete();
                                      Navigator.pushNamed(
                                          context, MyConstant.routeHome);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ]);
            },
          );
        },
      ),
    );
  }
}
