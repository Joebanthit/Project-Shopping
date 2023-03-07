import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projectshopping/states/detail_product_house.dart';

import 'package:projectshopping/utility/my_constant.dart';

import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
//firebase
  final CollectionReference _Prodcuts =
      FirebaseFirestore.instance.collection('Product');

//Widget
  Widget addProduct() {
    return ListTile(
      leading: Icon(
        Icons.add,
        size: 40.0,
        color: Colors.green,
      ),
      title: Text('เพิ่มสินค้าชนิดใหม่'),
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
        // shouldBuy(),
      ],
    ));
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Future<void> _update([DocumentSnapshot? data]) async {
    if (data != null) {
      titleController.text = data['title'];
      amountController.text = data['amount'].toString();
      priceController.text = data['price'].toString();
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
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'ชื่อสินค้า'),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'จำนวน'),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'ราคา'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text(
                      "แก้ไข",
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () async {
                      final String title = titleController.text;

                      final int? amount = int.tryParse(amountController.text);
                      final double? price =
                          double.tryParse(amountController.text);
                      if (amount != null) {
                        if (price != null) {
                          await _Prodcuts.doc(data!.id).update({
                            "title": title,
                            "amount": amount,
                            "price": price,
                          });
                          titleController.text = '';
                          amountController.text = '';
                          priceController.text = '';
                        }
                      }
                      Navigator.pop(context);
                    },
                  ),
                ]),
          );
        });
  }

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
                    decoration:
                        const InputDecoration(labelText: 'จำนวนคงเหลือสินค้า'),
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

  Future<void> _delete(String productId) async {
    await _Prodcuts.doc(productId).delete();
  }

  //Home

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'แอพช่วยซื้อสินค้าเข้าบ้าน',
          style: TextStyle(
              fontFamily: 'Varela', fontSize: 20.0, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SearchPage())),
              icon: const Icon(Icons.search))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _Prodcuts.orderBy('amount', descending: false).snapshots(),
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
                if (data['amount'] <= 1) {
                  return Card(
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
                                    "สินค้า : " + data['title'],
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                      "จำนวนคงเหลือ : " +
                                          data['amount'].toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                      "ราคา : " + data['price'].toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                      "วันที่ : " +
                                          DateFormat(' dd MMM yyyy').format(
                                              data['timestamp'].toDate()),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                      "เวลา : " +
                                          DateFormat(' hh:mm aaa').format(
                                              data['timestamp'].toDate()),
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
                                          "ใช้งาน",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () => _useProdcut(data),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      GestureDetector(
                                        onTap: () => _update(data),
                                        child: Icon(
                                          Icons.edit,
                                          size: 30,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      GestureDetector(
                                        onTap: () => _delete(data.id),
                                        child: Icon(
                                          Icons.delete,
                                          size: 30,
                                        ),
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
                  );
                } else if (data['amount'] == 2) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.yellow.shade700,
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
                                    "สินค้า : " + data['title'],
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                      "จำนวนคงเหลือ : " +
                                          data['amount'].toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                      "ราคา : " + data['price'].toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                      "วันที่ : " +
                                          DateFormat(' dd MMM yyyy').format(
                                              data['timestamp'].toDate()),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                      "เวลา : " +
                                          DateFormat(' hh:mm aaa').format(
                                              data['timestamp'].toDate()),
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
                                          "ใช้งาน",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () => _useProdcut(data),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      GestureDetector(
                                        onTap: () => _update(data),
                                        child: Icon(
                                          Icons.edit,
                                          size: 30,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      GestureDetector(
                                        onTap: () => _delete(data.id),
                                        child: Icon(
                                          Icons.delete,
                                          size: 30,
                                        ),
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
                  );
                } else {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.green.shade400,
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
                                    "สินค้า : " + data['title'],
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                      "จำนวนคงเหลือ : " +
                                          data['amount'].toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                      "ราคา : " + data['price'].toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                      "วันที่ : " +
                                          DateFormat(' dd MMM yyyy').format(
                                              data['timestamp'].toDate()),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                      "เวลา : " +
                                          DateFormat(' hh:mm aaa').format(
                                              data['timestamp'].toDate()),
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
                                          "ใช้งาน",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () => _useProdcut(data),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      GestureDetector(
                                        onTap: () => _update(data),
                                        child: Icon(
                                          Icons.edit,
                                          size: 30,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      GestureDetector(
                                        onTap: () => _delete(data.id),
                                        child: Icon(
                                          Icons.delete,
                                          size: 30,
                                        ),
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
                  );
                }
              });
        },
      ),
      drawer: showDrawer(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  final TextEditingController searchController = TextEditingController();
  List streamSnapshot = [];
  List _resultList = [];

  @override
  void initState() {
    searchController.addListener(_onSearchChanged);
    super.initState();
  }

  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void didChangeDependencies() {
    getClientStram();
    super.didChangeDependencies();
  }

  _onSearchChanged() {
    print(searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (searchController.text != "") {
      for (var clientSnapShot in streamSnapshot) {
        var title = clientSnapShot['title'].toString().toLowerCase();
        if (title.contains(searchController.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }
      }
    } else {
      showResults = List.from(_resultList);
    }
    setState(() {
      streamSnapshot = showResults;
    });
  }

  getClientStram() async {
    var data = await FirebaseFirestore.instance
        .collection('Product')
        .orderBy('amount')
        .get();
    setState(() {
      _resultList = data.docs;
    });
    searchResultList();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Future<void> _update([DocumentSnapshot? data]) async {
    if (data != null) {
      titleController.text = data['title'];
      amountController.text = data['amount'].toString();
      priceController.text = data['price'].toString();
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
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'ชื่อสินค้า'),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'จำนวน'),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'ราคา'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text(
                      "แก้ไข",
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () async {
                      final String title = titleController.text;

                      final int? amount = int.tryParse(amountController.text);
                      final double? price =
                          double.tryParse(amountController.text);
                      if (amount != null) {
                        if (price != null) {
                          final CollectionReference _Prodcuts =
                              FirebaseFirestore.instance.collection('Product');
                          await _Prodcuts.doc(data!.id).update({
                            "title": title,
                            "amount": amount,
                            "price": price,
                          });
                          titleController.text = '';
                          amountController.text = '';
                          priceController.text = '';
                        }
                      }
                      Navigator.pushNamed(context, MyConstant.routeHome);
                    },
                  ),
                ]),
          );
        });
  }

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
                    decoration:
                        const InputDecoration(labelText: 'จำนวนคงเหลือ'),
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
                        final CollectionReference _Prodcuts =
                            FirebaseFirestore.instance.collection('Product');
                        await _Prodcuts.doc(data!.id).update({
                          "amount": amount,
                        });

                        amountController.text = '';
                      }
                      Navigator.pushNamed(context, MyConstant.routeHome);
                    },
                  ),
                ]),
          );
        });
  }

  Future<void> _delete(String productId) async {
    final CollectionReference _Prodcuts =
        FirebaseFirestore.instance.collection('Product');
    await _Prodcuts.doc(productId).delete();
    Navigator.pushNamed(context, MyConstant.routeHome);
  }

  //Home

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0.0,
        centerTitle: true,
        title: CupertinoSearchTextField(
          controller: searchController,
        ),
      ),
      body: ListView.builder(
          itemCount: streamSnapshot.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot data = streamSnapshot[index];

            if (data['amount'] <= 1) {
              return Card(
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
                                "สินค้า : " + data['title'],
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                  "จำนวนคงเหลือ : " + data['amount'].toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text("ราคา : " + data['price'].toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                  "วันที่ซื้อล่าสุด : " +
                                      DateFormat(' dd MMM yyyy')
                                          .format(data['timestamp'].toDate()),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                  "เวลาซื้อล่าสุด : " +
                                      DateFormat(' hh:mm aaa')
                                          .format(data['timestamp'].toDate()),
                                  style: TextStyle(
                                      fontSize: 15,
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
                                      "ใช้งาน",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    onPressed: () => _useProdcut(data),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () => _update(data),
                                    child: Icon(
                                      Icons.edit,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  GestureDetector(
                                    onTap: () => _delete(data.id),
                                    child: Icon(
                                      Icons.delete,
                                      size: 30,
                                    ),
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
              );
            } else if (data['amount'] == 2) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.yellow.shade700,
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
                                "สินค้า : " + data['title'],
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                  "จำนวนคงเหลือ : " + data['amount'].toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text("ราคา : " + data['price'].toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                  "วันที่ : " +
                                      DateFormat(' dd MMM yyyy')
                                          .format(data['timestamp'].toDate()),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                  "เวลา : " +
                                      DateFormat(' hh:mm aaa')
                                          .format(data['timestamp'].toDate()),
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
                                      "ใช้งาน",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    onPressed: () => _useProdcut(data),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () => _update(data),
                                    child: Icon(
                                      Icons.edit,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  GestureDetector(
                                    onTap: () => _delete(data.id),
                                    child: Icon(
                                      Icons.delete,
                                      size: 30,
                                    ),
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
              );
            } else {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.green.shade400,
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
                                "สินค้า : " + data['title'],
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                  "จำนวนคงเหลือ : " + data['amount'].toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text("ราคา : " + data['price'].toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                  "วันที่ : " +
                                      DateFormat(' dd MMM yyyy')
                                          .format(data['timestamp'].toDate()),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                  "เวลา : " +
                                      DateFormat(' hh:mm aaa')
                                          .format(data['timestamp'].toDate()),
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
                                      "ใช้งาน",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    onPressed: () => _useProdcut(data),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () => _update(data),
                                    child: Icon(
                                      Icons.edit,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  GestureDetector(
                                    onTap: () => _delete(data.id),
                                    child: Icon(
                                      Icons.delete,
                                      size: 30,
                                    ),
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
              );
            }
          }),
    );
  }
}
