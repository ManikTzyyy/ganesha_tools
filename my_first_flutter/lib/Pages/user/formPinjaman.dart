import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:loading_animation_widget/loading_animation_widget.dart';

class formPinjaman extends StatefulWidget {
  final String idUser;
  final String idAlat;

  const formPinjaman({Key? key, required this.idUser, required this.idAlat})
      : super(key: key);

  @override
  _formPinjamanState createState() => _formPinjamanState();
}

class _formPinjamanState extends State<formPinjaman> {
  DateTime _tanggalPinjam = DateTime.now();
  DateTime _tanggalPengembalian = DateTime.now();
  int _jumlahItem = 0;

  late Map<String, dynamic>? _userData;
  late Map<String, dynamic>? _itemData;

  bool _isLoading = true;

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
        _isLoading = false; // Set loading to false when data is loaded
      });
    } catch (e) {
      print('Error fetching data: $e');
      _showErrorDialog('Failed to load data. Please try again later.');
      setState(() {
        _isLoading = false; // Set loading false on error
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

  Future<void> _selectTanggalPinjam(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalPinjam,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _tanggalPinjam) {
      setState(() {
        _tanggalPinjam = picked;
      });
    }
  }

  Future<void> _selectTanggalPengembalian(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalPengembalian,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _tanggalPengembalian) {
      setState(() {
        _tanggalPengembalian = picked;
      });
    }
  }

  void _submitForm() async {
    if (_userData == null || _itemData == null) {
      // Handle if data is not ready
      print('Data belum siap');
      return;
    }

    setState(() {
      _isLoading = true; // Set loading true before submitting
    });

    try {
      _showLoadingDialog();
      final response = await http.post(
        Uri.parse(
            'https://iamthetoolsmanagement.000webhostapp.com/createPeminjaman.php'),
        body: {
          'tanggal_pinjam': _tanggalPinjam.toIso8601String().split('T')[0],
          'tanggal_pengembalian': _tanggalPengembalian.toIso8601String().split('T')[0],
          'id_user': widget.idUser,
          'id_alat': widget.idAlat,
          'nama_alat': _itemData!['nama_alat'],
          'nama_user': _userData!['username'],
          'jumlah_dipinjam': _jumlahItem.toString(),
          'gambar': _itemData!['gambar'],
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      _hideLoadingDialog();

      if (response.statusCode == 200) {
        // Handle success response
        print('Data berhasil disimpan');
        _showSuccessDialog();
      } else {
        throw Exception('Gagal menyimpan data');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog('Failed to submit data. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false; // Set loading false after submission attempt
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
          content: Text('Data berhasil disimpan.'),
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
        title: Text('Form Pinjaman'),
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
                          SizedBox(height: 10.0),
                          Container(
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today),
                                SizedBox(width: 8.0),
                                Text('Tanggal Pinjam:'),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                            onPressed: () => _selectTanggalPinjam(context),
                            child: Text(
                              "${_tanggalPinjam.toLocal()}".split(' ')[0],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: Row(
                              children: [
                                Icon(Icons.event),
                                SizedBox(width: 8.0),
                                Text('Tanggal Pengembalian:'),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                            onPressed: () =>
                                _selectTanggalPengembalian(context),
                            child: Text("${_tanggalPengembalian.toLocal()}"
                                .split(' ')[0]),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: Row(
                              children: [
                                Icon(Icons.widgets),
                                SizedBox(width: 8.0),
                                Text('Nama Item: ${_itemData!['nama_alat']}'),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: Row(
                              children: [
                                Icon(Icons.collections_bookmark),
                                SizedBox(width: 8.0),
                                Text(
                                    'Item tersedia: ${_itemData!['jumlah_total']}'),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: Row(
                              children: [
                                Icon(Icons.queue),
                                SizedBox(width: 8.0),
                                Text('Jumlah Item:'),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                _jumlahItem = int.tryParse(value) ?? 0;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan jumlah item';
                              }
                              int parsedValue = int.tryParse(value) ?? 0;
                              if (parsedValue <= 0) {
                                return 'Jumlah item harus lebih dari 0';
                              }
                              return null; // Validasi berhasil
                            },
                            decoration: InputDecoration(
                              hintText: 'Masukkan jumlah item',
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
                                    onPressed: () {
                                      // Validasi jumlah item dan jumlah total
                                      int jumlahTotal = int.tryParse(
                                              _itemData!['jumlah_total']) ??
                                          0;
                                      if (jumlahTotal > 0 &&
                                          _jumlahItem > 0 &&
                                          _jumlahItem <= jumlahTotal) {
                                        _submitForm();
                                      } else {
                                        // Menampilkan dialog jika validasi tidak terpenuhi
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: Text('Invalid Input'),
                                            content: Text(
                                                'Harap masukkan jumlah item yang valid.'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    child: Text('Submit'),
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
