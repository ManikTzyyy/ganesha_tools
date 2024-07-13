// ignore_for_file: unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:my_first_flutter/Pages/admin/formAdmin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class itemdetailAdmin extends StatefulWidget {
  final Map<String, dynamic> item;
  final String idUser;

  const itemdetailAdmin({Key? key, required this.item, required this.idUser}) : super(key: key);

  @override
  _itemdetailAdminState createState() => _itemdetailAdminState();
}

class _itemdetailAdminState extends State<itemdetailAdmin> {
  bool _isLoading = false;

  void _deleteAlat(String idAlat) async {
    setState(() {
      _isLoading = true;
    });

    try {
      _showLoadingDialog();

      final Map<String, String> formData = {
        'id_alat': idAlat,
      };

      final response = await http.post(
        Uri.parse('https://iamthetoolsmanagement.000webhostapp.com/deleteItem.php'),
        body: formData,
      );

      _hideLoadingDialog();

      if (response.statusCode == 200) {
        print('Data berhasil diperbarui');
        _showSuccessDialog();
      } else {
        throw Exception('Gagal memperbarui data');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog('Failed to update data. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 50,
            ),
          ),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    Navigator.of(context).pop();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Data berhasil diperbarui.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final idUser = widget.idUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          item['kategori'] == 'elektronik' ? 'ELEKTRONIK' : 'NON ELEKTRONIK',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: Image.asset(
                    'assets/' + item['gambar'],
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['nama_alat'] ?? '',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        item['deskripsi'] ?? '',
                        style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 0, 0, 0)),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Item tersedia: " + item['jumlah_total'],
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 0, 0)),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => formEdit(
                                  idUser: idUser,
                                  idAlat: item['id_alat'],
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.edit, color: Colors.white),
                              SizedBox(width: 8.0),
                              Text('Edit'),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                            textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _deleteAlat(item['id_alat']);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              SizedBox(width: 8.0),
                              Text('Delete'),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                            textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(0.0),
                    child: Text("Item ini "),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      int.parse(item['jumlah_total']) > 0 ? 'Tersedia' : 'Tidak Tersedia',
                      style: TextStyle(
                        fontSize: 18,
                        color: int.parse(item['jumlah_total']) > 0 ? Colors.green : Colors.red,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
