import 'package:flutter/material.dart';
import 'package:my_first_flutter/Pages/user/formPinjaman.dart';

class ItemDetail extends StatelessWidget {
  final Map<String, dynamic> item;
  final String idUser;

  const ItemDetail({Key? key, required this.item, required this.idUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          // Konten utama di dalam SingleChildScrollView
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container 1: Gambar besar di atas menyesuaikan ukuran gambar
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Warna border
                      width: 1.0, // Ketebalan border
                    ),
                  ),
                  child: Image.asset(
                    'assets/' + item['gambar'], // Sesuaikan field untuk gambar
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: 16),
                // Container 2: Nama, Deskripsi, Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "id user $idUser",
                      //   style: TextStyle(color: Colors.black),
                      // ),
                      Text(
                        item['nama_alat'] ?? '',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        item['deskripsi'] ?? '',
                        style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "item tersedia :" + item['jumlah_total'],
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Ruang tambahan agar konten di atas bisa di-scroll di atas container sticky
                SizedBox(height: 80),
              ],
            ),
          ),
          // Container 3: Sticky di bagian bawah layar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.grey,
              //     width: 0.0,
              //   ),
              // ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(0.0),
                    child: Text("Item ini "),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      int.parse(item['jumlah_total']) > 0
                          ? 'Tersedia'
                          : 'Tidak Tersedia',
                      style: TextStyle(
                        fontSize: 18,
                        color: int.parse(item['jumlah_total']) > 0
                            ? Colors.green
                            : Colors.red,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => formPinjaman(
                              idUser: idUser,
                              idAlat: item['id_alat'],
                            ),
                          ),
                        );
                      },
                      child: Text('Pinjam'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green, // Warna teks tombol
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 15.0), // Ukuran padding tombol
                        textStyle: TextStyle(
                          fontSize: 16.0, // Ukuran teks tombol
                          fontWeight: FontWeight.bold, // Berat teks tombol
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Bentuk border tombol
                        ),
                      ),
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
