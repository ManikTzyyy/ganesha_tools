// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:loading_animation_widget/loading_animation_widget.dart';

class tambahAlat extends StatefulWidget {
  @override
  _tambahAlatState createState() => _tambahAlatState();
}

class _tambahAlatState extends State<tambahAlat> {
  TextEditingController _namaAlatController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _jumlahTotalController = TextEditingController();
  String _kategori = 'elektronik';

  bool _isLoading = false;

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _showLoadingDialog();

      final Map<String, String> formData = {
        'nama_alat': _namaAlatController.text,
        'deskripsi': _deskripsiController.text,
        'jumlah_total': _jumlahTotalController.text,
        'kategori': _kategori,
      };

      final response = await http.post(
        Uri.parse('https://iamthetoolsmanagement.000webhostapp.com/createItem.php'),
        body: formData,
      );

      _hideLoadingDialog();

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        _showSuccessDialog();
      } else {
        throw Exception('Gagal membuat data');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog('Failed to create data. Please try again later.');
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
          content: Text('Data berhasil dibuat.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();  // close the form
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Create Alat'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _namaAlatController,
                      decoration: InputDecoration(
                        labelText: 'Nama Alat',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _deskripsiController,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _jumlahTotalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Jumlah Total',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    DropdownButtonFormField<String>(
                      value: _kategori,
                      onChanged: (String? newValue) {
                        setState(() {
                          _kategori = newValue!;
                        });
                      },
                      items: <String>[
                        'elektronik',
                        'nonelektronik',
                      ].map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Batal'),
                            ),
                            SizedBox(width: 20.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: _submitForm,
                              child: Text('Create'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
