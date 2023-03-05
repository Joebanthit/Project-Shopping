import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projectshopping/states/add_product_buy.dart';

import 'package:projectshopping/states/detail_product_house.dart';

import 'package:projectshopping/states/list_product_buy.dart';

import 'package:projectshopping/states/home.dart';

import 'package:projectshopping/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/home': (BuildContext context) => Home(),
  '/listproductbuy': (BuildContext context) => ListProductBuy(),
  '/addproductbuy': (BuildContext context) => AddProductBuy(),
  // '/useproduct': (BuildContext context) => UseProduct(),
  // '/detailproducthouse': (BuildContext context) => DetailProductHouse(),
  // '/detailproductbuy': (BuildContext context) => DetailProductBuy(),
};

String? initlalRoute;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initlalRoute = MyConstant.routeHome;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.pink),
      title: ('ผู้ช่วยซื้อสินค้าเข้าบ้าน'),
      routes: map,
      initialRoute: initlalRoute,
    );
  }
}
