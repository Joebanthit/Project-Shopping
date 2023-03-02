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

class UseProduct extends StatefulWidget {
  const UseProduct({super.key});

  @override
  State<UseProduct> createState() => _UseProductState();
}

class _UseProductState extends State<UseProduct> {
  @override
  TextEditingController amountController = TextEditingController();

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

  useButton() {
    return ElevatedButton(
      onPressed: () async {
        FirebaseFirestore.instance
            .collection("Product")
            .doc(Get.arguments['docId'])
            .update(
          {
            'amount': int.parse(amountController.text),
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
      appBar: AppBar(title: Text("แจ้งการใช้งานสินค้า")),
      body: Form(
        child: ListView(children: <Widget>[
          amountText(),
          useButton(),
        ]),
      ),
    );
  }
}
