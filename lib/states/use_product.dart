import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectshopping/model/Product.dart';
import 'package:projectshopping/states/detail_product_house.dart';
import 'package:projectshopping/utility/my_constant.dart';
import 'package:projectshopping/widgets/show_image.dart';
import 'package:intl/intl.dart';

//model

class UseProduct extends StatefulWidget {
  const UseProduct({super.key});

  @override
  State<UseProduct> createState() => _UseProductState();
}

class _UseProductState extends State<UseProduct> {
  @override
  //Field

  //firebase

//Method
  Widget negaButton() {
    return SizedBox(
      child: ElevatedButton(
        child: Text(
          "ลด",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () async {
          Navigator.pushNamed(context, MyConstant.routeDetailProductHouse);
        },
      ),
    );
  }

  Widget amountButton() {
    return SizedBox(
      child: ElevatedButton(
        child: Text(
          "จำนวน 1 ชิ้น",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () async {
          Navigator.pushNamed(context, MyConstant.routeDetailProductHouse);
        },
      ),
    );
  }

  Widget plusButton() {
    return SizedBox(
      child: ElevatedButton(
        child: Text(
          "เพิ่ม",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () async {
          Navigator.pushNamed(context, MyConstant.routeDetailProductHouse);
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
          Navigator.pushNamed(context, MyConstant.routeDetailProductHouse);
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
        title: Text('การใช้งานสินค้า'),
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
                    Padding(padding: EdgeInsets.all(8.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        negaButton(),
                        amountButton(),
                        plusButton(),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        useButton(),
                      ],
                    ),
                  ]);
            },
          );
        },
      ),
    );
  }
}
