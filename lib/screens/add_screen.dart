import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getLocalFilePath(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/$fileName';
}

class AddScreen extends StatefulWidget {
  DateTime selectedDate = DateTime.now();
  final Function callback;
  final Function setName;
  final Function setDate;
  final Function setPath;
  final TextEditingController nameControl;

  AddScreen({
    super.key,
    required this.callback,
    required this.setName,
    required this.setDate,
    required this.setPath,
    required this.nameControl,
  });

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime initialDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });

      widget.setPath(_image!.path);
      // You can now use _image.path to access the image file path
      // For example, to display it: Image.file(File(_image!.path))
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adicione aniversariantes!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'MountainsofChristmas',
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _pickImage();
                  },
                  child: _image != null
                      ? CircleAvatar(
                          minRadius: 50,
                          backgroundImage: FileImage(File(_image!.path)),
                        )
                      : const Text('Escolha uma imagem!'), // Mudar isso
                  style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 25),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(right: 25),
                        child: TextField(
                          controller: widget.nameControl,
                          onChanged: (text) =>
                              widget.setName(widget.nameControl.text),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nome',
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      //Text("$selectedDate.day"),
                      Container(
                        margin: EdgeInsets.only(right: 25),
                        child: Text(
                          "Data de nascimento: ",
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            fontFamily: 'MountainsofChristmas',
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 25),
                        child: ElevatedButton.icon(
                          label: Text(
                            "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}",
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'MountainsofChristmas',
                              letterSpacing: 1,
                            ),
                          ),
                          icon: Icon(Icons.date_range),
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide(color: Colors.teal),
                                  ),
                                ),
                          ),
                          onPressed: () async {
                            var tempSelectedDate = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2150),
                            );

                            if (tempSelectedDate != null) {
                              setState(() {
                                selectedDate = tempSelectedDate;
                              });
                              widget.setDate(selectedDate);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Descrição',
                ),
              ),
            ),
            SizedBox(height: 50),
            FloatingActionButton(
              onPressed: () {
                widget.callback();
                Navigator.pop(context);
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.teal,
              shape: CircleBorder(),
            ),
          ],
        ),
      ),
    );
  }
}
