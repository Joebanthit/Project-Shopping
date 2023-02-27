import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectshopping/utility/my_constant.dart';
import 'package:projectshopping/widgets/show_image.dart';
import 'package:intl/intl.dart';

class ListProductBuy extends StatefulWidget {
  const ListProductBuy({super.key});

  @override
  State<ListProductBuy> createState() => _ListProductBuyState();
}

class _ListProductBuyState extends State<ListProductBuy> {
  @override
  //firebase
  // void initState() {
  //   super.initState();
  //   Firebase.initializeApp();
  // }
  // final Stream<QuerySnapshot> product =
  //     FirebaseFirestore.instance.collection('Product').snapshots();
//Method

  Widget build(BuildContext context) {
    return Scaffold(
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
              final data = documents[index].data() as Map<String, dynamic>;
              final timestamp = data['timestamp'] as Timestamp;
              final formattedDate =
                  DateFormat('dd MMM yyyy').format(timestamp.toDate());
              final formattedTime =
                  DateFormat(' hh:mm aaa').format(timestamp.toDate());
              var x = '';
              if (data['amount'] == 1) {
                x = 'ควรซื้อ';
                return Container(
                  height: 100,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
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
                    onTap: () => Navigator.pushNamed(
                        context, MyConstant.routeDetailProductBuy),
                    leading: Image.network(
                      data['image'].toString(),
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      data['title'],
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
                          "วันที่ : " + formattedDate,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "สถานะ : " + x,
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

              return Column();
            },
          );
        },
      ),
    );
  }
}
