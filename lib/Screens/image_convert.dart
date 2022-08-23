// ignore_for_file: prefer_const_constructors

import 'dart:async';
//import 'dart:html' as File;
import 'dart:io' as file;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

class ImageConvert extends StatefulWidget {
  final String text;
  const ImageConvert(this.text);

  @override
  State<ImageConvert> createState() => _ImageConvertState();
}

class _ImageConvertState extends State<ImageConvert> {
  int _counter = 0;
  // late Uint8List _imageFile;
  late PickedFile _imageFile = _imageFile;
  final ImagePicker _picker = ImagePicker();
  int c = 0;
  var imageFile;
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  GlobalKey _globalKey = GlobalKey();
  int originalSize = 800;
  Color mycolor = Colors.lightBlue;
  @override
  void initState() {
    super.initState();
    permission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image"),
        actions: [
          IconButton(
              onPressed: () {
                _saveScreen();
              },
              icon: Icon(Icons.download)),
          IconButton(
              onPressed: () {
                ShareFilesAndScreenshotWidgets().shareScreenshot(
                    _globalKey, originalSize, "Title", "Name.png", "image/png",
                    text: "This is the caption!");
              },
              icon: Icon(Icons.share)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10.0,
                child: c == 0
                    ? RepaintBoundary(
                        key: _globalKey,
                        child: Container(
                          color: mycolor,
                          width: MediaQuery.of(context).size.width / 0.15,
                          height: MediaQuery.of(context).size.height / 2.3,
                          child: Center(
                              child: Text(
                            widget.text,
                            style: TextStyle(fontSize: 18),
                          )),
                        ),
                      )
                    : RepaintBoundary(
                        key: _globalKey,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 0.15,
                          height: MediaQuery.of(context).size.height / 2.3,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.file(
                                file.File(_imageFile.path),
                                fit: BoxFit.fill,
                              ),
                              Center(
                                  child: Text(
                                widget.text,
                                style: TextStyle(fontSize: 18),
                              )),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 24, 14, 8),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                      child: Text('Change Background',
                          style: TextStyle(fontSize: 12)),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Pick a color!'),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: mycolor, //default color
                                    onColorChanged: (Color color) {
                                      //on color picked
                                      setState(() {
                                        c = 0;
                                        mycolor = color;
                                      });
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('DONE'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); //dismiss the color picker
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 24, 14, 8),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                      child: Text(
                        'Upload Image',
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        _pickImage();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  void _pickImage() async {
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile!;
        // imageFile = File(pickedFile.path);
        if (_imageFile != null) {
          c = 1;
        }
      });
    } catch (e) {
      print("Image picker error " + e.toString());
    }
  }

  void permission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[
          Permission.storage]); // it should print PermissionStatus.granted
    }
  }

  _saveScreen() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 10.0);
    ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
        as FutureOr<ByteData?>);
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);
      _toastInfo(result.toString());
    }
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }
}
