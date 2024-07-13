import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_first_flutter/Pages/detailListPage.dart'; // Sesuaikan path ini
import 'package:http/http.dart' as http;

class notElectroList extends StatefulWidget {
  final String idUser;

  notElectroList({required this.idUser});

  @override
  State<notElectroList> createState() => _notElectroListState();
}

class _notElectroListState extends State<notElectroList> {
  List<Map<String, dynamic>> items = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });

    var url = Uri.parse('https://iamthetoolsmanagement.000webhostapp.com/readNonElectronic.php');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          items = List<Map<String, dynamic>>.from(data['alat'] ?? []);
          _isLoading = false;
        });
      } else {
        print('Gagal mengambil data: ${response.statusCode}');
        _isLoading = false;
      }
    } catch (e) {
      print('Error: $e');
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(width: 8),
            Text(
              "Non Electro List",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetail(item: items[index], idUser: widget.idUser),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/' + items[index]['gambar'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items[index]['nama_alat'] ?? '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Item tersedia: " + items[index]['jumlah_total'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                int.parse(items[index]['jumlah_total']) > 0
                                    ? 'Tersedia'
                                    : 'Tidak Tersedia',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: int.parse(items[index]['jumlah_total']) > 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
