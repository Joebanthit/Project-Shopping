import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectshopping/model/Product.dart';
import 'package:projectshopping/states/detail_product_house.dart';
import 'package:projectshopping/utility/my_constant.dart';

import 'package:intl/intl.dart';

//model

class DetailProductBuy extends StatefulWidget {
  const DetailProductBuy({super.key});

  @override
  State<DetailProductBuy> createState() => _DetailProductBuyState();
}

class _DetailProductBuyState extends State<DetailProductBuy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f7f9),
      appBar: AppBar(
        title: Text(Get.arguments['title']),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.network(
          Get.arguments['image'].toString(),
          fit: BoxFit.cover,
        ),
        ListTile(
          title: Text(
            Get.arguments['title'],
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
                  "จำนวน : " + Get.arguments['amount'].toString() + "  ชิ้น",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "ราคา : " + Get.arguments['price'].toString() + "  บาท",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "สถานที่ : " + Get.arguments['location'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "วันที่ : " +
                      DateFormat('dd MMM yyyy')
                          .format(Get.arguments['timestamp'].toDate()),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "เวลา : " +
                      DateFormat(' hh:mm aaa')
                          .format(Get.arguments['timestamp'].toDate()),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                // Text(
                //   "สถานะ : " + x,
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 18,
                //   ),
                // ),
              ]),
        ),
      ]),
    );
  }
}
