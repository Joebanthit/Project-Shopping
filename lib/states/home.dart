import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectshopping/model/Product.dart';
import 'package:projectshopping/states/detail_product_house.dart';
import 'package:projectshopping/utility/my_constant.dart';
import 'package:projectshopping/widgets/show_image.dart';
import 'package:intl/intl.dart';

//model
class Product {
  final image;
  final title;
  Product(this.image, this.title);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  //Field

  //firebase

//Method

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
              final data = documents[index].data() as Map<String, dynamic>;
              var docId = snapshot.data!.docs[index].id;
              var x = '';

              if (data['amount'] == 0) {
                FirebaseFirestore.instance
                    .collection("Product")
                    .doc(docId)
                    .delete();
              } else if (data['amount'] == 1) {
                x = 'ควรซื้อ';
              } else if (data['amount'] <= 5) {
                x = 'ซื้อก็ได้ไม่ซื้อก็ได้';
              } else if (data['amount'] > 6) {
                x = 'ไม่ต้องซื้อ';
              }

              final timestamp = data['timestamp'] as Timestamp;
              final formattedDate =
                  DateFormat('dd MMM yyyy').format(timestamp.toDate());
              final formattedTime =
                  DateFormat(' hh:mm aaa').format(timestamp.toDate());
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
                      context, MyConstant.routeDetailProductHouse),
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
            },
          );
        },
      ),
      drawer: showDrawer(),
    );
  }
}
