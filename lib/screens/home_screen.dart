import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:birthdays/screens/add_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<List<Object>> register = [
    ['Daniel', 21, 07, 200, ''],
    ['Leticia', 31, 08, 2001, ''],
    ['Marina', 14, 02, 2001, ''],
    ['Maira', 7, 06, 2001, ''],
    ['Amanda', 7, 01, 2001, ''],
    ['Natalie', 5, 12, 2001, ''],
    ['Cássio', 23, 06, 2001, ''],
  ];

  var tempName = "NoN";
  DateTime data = DateTime.now();
  var imagePath = "";
  final TextEditingController nameControl = TextEditingController();

  @override
  void dispose() {
    nameControl.dispose();
    super.dispose();
  }

  Future<String> getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/dados.json';
  }

  Future<void> saveJson(List<List<Object>> register) async {
    final path = await getFilePath();
    final file = File(path);
    await file.writeAsString(jsonEncode(register));
  }

  Future<void> loadJson() async {
    final path = await getFilePath();
    final file = File(path);

    if (await file.exists()) {
      String contents = await file.readAsString();
      var data = jsonDecode(contents);
      register = List<List<Object>>.from(data.map((e) => List<Object>.from(e)));
    } else {
      print("File does not exist.");
    }
  }

  void setName(String nome) {
    tempName = nome;
  }

  void setDate(DateTime dataChild) {
    if (dataChild != Null) {
      data = dataChild;
    }
  }

  void setPath(String path) {
    imagePath = path;
  }

  void _addMember() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddScreen(
          callback: onChanged,
          setName: setName,
          setDate: setDate,
          setPath: setPath,
          nameControl: nameControl,
        ),
      ),
    );

    setState(() {});
  }

  void onChanged() {
    register.add([tempName, data.day, data.month, data.year, imagePath]);
    saveJson(register);
  }

  @override
  void initState() {
    super.initState();
    saveJson(register);
    loadJson();
  }

  @override
  Widget build(BuildContext context) {
    register.sort((a, b) {
      var aData, bData;
      if ((a[2] as int) * 100 + (a[1] as int) - data.month * 100 - data.day >=
          0) {
        aData =
            (a[2] as int) * 100 + (a[1] as int) - data.month * 100 - data.day;
      } else {
        aData =
            9999 +
            (a[2] as int) * 100 +
            (a[1] as int) +
            -data.month * 100 -
            data.day;
      }

      if ((b[2] as int) * 100 + (b[1] as int) - data.month * 100 - data.day >=
          0) {
        bData =
            (b[2] as int) * 100 + (b[1] as int) - data.month * 100 - data.day;
      } else {
        bData =
            9999 +
            ((b[2] as int) * 100 + (b[1] as int) - data.month * 100 - data.day);
      }

      return aData.compareTo(bData);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, position) {
            return Row(
              spacing: 20,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: (register[position][4] != "")
                      ? FileImage(File(register[position][4].toString()))
                      : AssetImage('images/cake.jpg'),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      register[position][0].toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MountainsofChristmas',
                        fontSize: 20,
                        height: 3,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      register[position][1].toString().padLeft(2, '0') +
                          '/' +
                          register[position][2].toString().padLeft(2, '0') +
                          '/' +
                          register[position][3].toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MountainsofChristmas',
                        fontSize: 20,
                        height: 1.5,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          separatorBuilder: (context, position) {
            return Container(height: 20);
          },
          itemCount: register.length,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Aniversários',
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addMember,
        tooltip: 'Adicione um membro!',
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
        shape: CircleBorder(),
      ),
    );
  }
}
