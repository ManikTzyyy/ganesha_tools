// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:loading_animation_widget/loading_animation_widget.dart';

class formEdit extends StatefulWidget {
  final String idUser;
  final String idAlat;

  const formEdit({Key? key, required this.idUser, required this.idAlat})
      : super(key: key);

  @override
  _formEditState createState() => _formEditState();
}

class _formEditState extends State<formEdit> {
  int _jumlahItem = 0;

  late Map<String, dynamic>? _userData;
  late Map<String, dynamic>? _itemData;

  bool _isLoading = true;

  TextEditingController _namaAlatController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _jumlahTotalController = TextEditingController();
  String _kategori = 'Kategori 1';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userDataResponse = await _getUserData();
      final itemDataResponse = await _getItemData();

      setState(() {
        _userData = userDataResponse;
        _itemData = itemDataResponse;
        _isLoading = false;

        _namaAlatController.text = _itemData!['nama_alat'] ?? '';
        _deskripsiController.text = _itemData!['deskripsi'] ?? '';
        _jumlahTotalController.text = _itemData!['jumlah_total'] ?? '';
        _kategori = _itemData!['kategori'] ?? 'Kategori 1';
      });
    } catch (e) {
      print('Error fetching data: $e');
      _showErrorDialog('Failed to load data. Please try again later.');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _getUserData() async {
    final response = await http.get(Uri.parse(
        'https://iamthetoolsmanagement.000webhostapp.com/readUser.php?id_User=${widget.idUser}'));

    if (response.statusCode == 200) {
      return json.decode(response.body)['user'][0];
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Map<String, dynamic>> _getItemData() async {
    final response = await http.get(Uri.parse(
        'https://iamthetoolsmanagement.000webhostapp.com/readDetailItem.php?id_Alat=${widget.idAlat}'));

    if (response.statusCode == 200) {
      return json.decode(response.body)['alat'][0];
    } else {
      throw Exception('Failed to load item data');
    }
  }

  void _submitForm() async {
    if (_userData == null || _itemData == null) {
      print('Data belum siap');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _showLoadingDialog();
      final Map<String, String> formData = {
        'id_alat': widget.idAlat,
        'nama_alat': _namaAlatController.text,
        'deskripsi': _deskripsiController.text,
        'jumlah_total': _jumlahTotalController.text,
        'kategori': _kategori,
      };

      final response = await http.post(
        Uri.parse(
            'https://iamthetoolsmanagement.000webhostapp.com/updateItem.php'),
        body: formData,
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Edit Alat'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _userData == null || _itemData == null
                  ? Center(child: Text('Failed to load data.'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${_userData!['username']}#${_userData!['id_User']}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text("ID Alat: ${widget.idAlat}"),
                          SizedBox(height: 20.0),
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
                              // Pastikan setiap nilai memiliki item yang unik
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    onPressed: _submitForm,
                                    child: Text('Update'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ),
    );
  }
}
