import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projectshopping/states/detail_product_house.dart';
import 'package:projectshopping/utility/my_constant.dart';

import 'package:intl/intl.dart';

//model

class DetailProductHouse extends StatelessWidget {
  final DocumentSnapshot data;
  const DetailProductHouse({super.key, required this.data});

  @override
  @override
  Widget deleteButton() {
    return SizedBox(
      child: ElevatedButton(
        child: Text(
          "ลบ",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () async {
          FirebaseFirestore.instance
              .collection("Product")
              .doc(data['docId'])
              .delete();
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("รายละเอียด : " + data['title'],
            style: TextStyle(
                fontFamily: 'Varela', fontSize: 20.0, color: Colors.white)),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 300.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(data['image'].toString()),
                    fit: BoxFit.cover)),
          ),
          SizedBox(height: 20.0),
          Center(
            child: Text(
              data['title'],
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF322F2E)),
            ),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Text(
              "จำนวน : " + data['amount'].toString() + " ชิ้น",
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF808080)),
            ),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Text(
              "ราคา : " + data['price'].toString() + " บาท",
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF808080)),
            ),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Text(
              "วันที่ : " +
                  DateFormat(' dd MMM yyyy').format(data['timestamp'].toDate()),
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF808080)),
            ),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Text(
              "เวลา :  " +
                  DateFormat(' hh:mm aaa').format(data['timestamp'].toDate()),
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF808080)),
            ),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Text(
              "สถานที่: " + data['location'],
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF808080)),
            ),
          ),
        ],
      ),
    );
  }
}
