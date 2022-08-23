import 'package:flutter/material.dart';
import 'package:text_to_img/Screens/image_convert.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String text = "";
  TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("TxtToImg"),
      ),
      body: Container(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter Text",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  text = value;
                  setState(() {});
                },
                validator: (value) {
                  return value!.isEmpty ? "Enter Text" : null;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Text to convert : $text",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 30,
            ),
            Material(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.blue,
              child: InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageConvert(text),
                      ),
                    );
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    "Convert to Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      )),
    );
  }
}
