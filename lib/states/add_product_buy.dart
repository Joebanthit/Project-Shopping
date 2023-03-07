import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:projectshopping/utility/my_constant.dart';

class AddProductBuy extends StatefulWidget {
  const AddProductBuy({super.key});

  @override
  State<AddProductBuy> createState() => _AddProductBuyState();
}

class _AddProductBuyState extends State<AddProductBuy> {
  @override
  //Field
  File? file;
  String imageUrl = '';
  final _formkey = GlobalKey<FormState>();
  //medthod

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Widget showContent() {
    return Column(
      children: <Widget>[
        showImage(),
        showButton(),
        titleText(),
        amountText(),
        priceText(),
        addButton(),
      ],
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget showImage() {
    return Container(
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: file == null ? Image.asset(MyConstant.image2) : Image.file(file!),
    );
  }

  Widget cameraButton() {
    return IconButton(
      onPressed: () async {
        await chooseImage(ImageSource.camera);
        // ImagePicker imagePicker = ImagePicker();
        // XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
        // print('${file?.path}');

        if (file == null) return;

        String uniqueFileName =
            DateTime.now().microsecondsSinceEpoch.toString();

        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImage = referenceRoot.child('image');
        Reference referenceImageToUpload =
            referenceDirImage.child(uniqueFileName);
        try {
          await referenceImageToUpload.putFile(File(file!.path));
          imageUrl = await referenceImageToUpload.getDownloadURL();
        } catch (e) {
          //
        }
      },
      icon: Icon(
        Icons.add_a_photo,
        size: 40,
        color: Colors.deepOrange,
      ),
    );
  }

  Widget galleryButton() {
    return IconButton(
      onPressed: () async {
        // ImagePicker imagePicker = ImagePicker();
        // XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
        // print('${file?.path}');
        await chooseImage(ImageSource.gallery);
        if (file == null) return;

        String uniqueFileName =
            DateTime.now().microsecondsSinceEpoch.toString();

        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImage = referenceRoot.child('image');
        Reference referenceImageToUpload =
            referenceDirImage.child(uniqueFileName);
        try {
          await referenceImageToUpload.putFile(File(file!.path));
          imageUrl = await referenceImageToUpload.getDownloadURL();
        } catch (e) {
          //
        }
      },
      icon: Icon(
        Icons.add_photo_alternate,
        size: 40,
        color: Colors.green.shade900,
      ),
    );
  }

  Widget titleText() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        controller: titleController,
        decoration: InputDecoration(
          icon: Icon(
            Icons.shop,
            color: Colors.purple,
            size: 30.0,
          ),
          labelText: 'ชื่อสินค้า',
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        validator: (value) {
          if (value == '') {
            return "กรุณากรอกชื่อสินค้าด้วยครับ";
          }
        },
      ),
    );
  }

  Widget amountText() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: amountController,
        decoration: InputDecoration(
          icon: Icon(
            Icons.shopping_basket,
            color: Colors.purple,
            size: 30.0,
          ),
          labelText: 'จำนวนสินค้า',
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        validator: (int) {
          if (int == '') {
            return "กรุณากรอกชื่อสินค้าด้วยครับ";
          }
        },
      ),
    );
  }

  Widget priceText() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: priceController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.attach_money,
              color: Colors.purple,
              size: 30.0,
            ),
            labelText: 'ราคาสินค้า',
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          validator: (double) {
            if (double == '') {
              return "กรุณากรอกชื่อสินค้าด้วยครับ";
            }
          },
        ));
    ;
  }

  Widget addButton() {
    return Container(
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        child: Text(
          "บันทึกสินค้า",
          style: TextStyle(fontSize: 30),
        ),
        onPressed: () async {
          if (_formkey.currentState!.validate()) {
            print("Success");
          } else {
            print("Failed");
          }
          Navigator.pushNamed(context, MyConstant.routeHome);
          var title = titleController.text.trim();
          var amount = int.parse(amountController.text);
          var price = double.parse(priceController.text);

          if (title != "") {
            if (amount != "") {
              if (price != "") {
                {
                  try {
                    await FirebaseFirestore.instance
                        .collection("Product")
                        .doc()
                        .set({
                      "timestamp": DateTime.now(),
                      "title": title,
                      "amount": amount,
                      "price": price,
                      "image": imageUrl,
                    });
                  } catch (e) {
                    print("Error $e");
                  }
                }
              }
            }
          }
        },
      ),
    );
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  TextEditingController galleryController = TextEditingController();
  TextEditingController cameraController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่มสินค้าชนิดใหม่')),
      body: Form(
        key: _formkey,
        child: ListView(children: <Widget>[
          showContent(),
        ]),
      ),
    );
  }
}
