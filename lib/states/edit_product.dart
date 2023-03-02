import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectshopping/states/home.dart';

import 'package:projectshopping/utility/my_constant.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  @override
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController galleryController = TextEditingController();
  TextEditingController cameraController = TextEditingController();

  Widget titleText() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        controller: titleController
          ..text = "${Get.arguments['title'].toString()}",
        decoration: InputDecoration(
            icon: Icon(
              Icons.shop,
              color: Colors.purple,
              size: 30.0,
            ),
            labelText: 'ชื่อสินค้า',
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            helperText: 'กรุณากรอกชื่อสินค้าด้วยครับ',
            helperStyle: TextStyle(fontSize: 15.0)),
      ),
    );
  }

  Widget amountText() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        controller: amountController
          ..text = "${Get.arguments['amount'].toString()}",
        decoration: InputDecoration(
            icon: Icon(
              Icons.shopping_basket,
              color: Colors.purple,
              size: 30.0,
            ),
            labelText: 'จำนวนสินค้า',
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            helperText: 'กรุณากรอกจำนวนสินค้าด้วยครับ',
            helperStyle: TextStyle(fontSize: 15.0)),
      ),
    );
  }

  Widget priceText() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextFormField(
          controller: priceController
            ..text = "${Get.arguments['price'].toString()}",
          decoration: InputDecoration(
              icon: Icon(
                Icons.attach_money,
                color: Colors.purple,
                size: 30.0,
              ),
              labelText: 'ราคาสินค้า',
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              helperText: 'กรุณากรอกราคาสินค้าด้วยครับ',
              helperStyle: TextStyle(fontSize: 15.0)),
        ));
    ;
  }

  Widget locationText() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        controller: locationController
          ..text = "${Get.arguments['location'].toString()}",
        decoration: InputDecoration(
            icon: Icon(
              Icons.location_on,
              color: Colors.purple,
              size: 30.0,
            ),
            labelText: 'สถานที่',
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            helperText: 'กรุณากรอกชื่อสถานที่ด้วยครับ',
            helperStyle: TextStyle(fontSize: 15.0)),
      ),
    );
  }

  editButton() {
    return ElevatedButton(
      onPressed: () async {
        FirebaseFirestore.instance
            .collection("Product")
            .doc(Get.arguments['docId'])
            .update(
          {
            'title': titleController.text.trim(),
            'amount': int.parse(amountController.text),
            'price': double.parse(priceController.text),
            'location': locationController.text.trim(),
          },
        ).then(
          (value) => Get.offAll(() => Home()),
        );
      },
      child: Text("อัพเดทสินค้า"),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("แก้ไขสินค้า : " + Get.arguments['title'])),
      body: Form(
        child: ListView(children: <Widget>[
          titleText(),
          amountText(),
          priceText(),
          locationText(),
          editButton(),
        ]),
      ),
    );
  }
}
