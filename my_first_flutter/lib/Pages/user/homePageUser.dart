// ignore_for_file: unused_field, unused_import

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'electroList.dart';
import 'notElectroList.dart';
import 'package:my_first_flutter/Pages/loginPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String idUser;

  HomePage({required this.idUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DashboardScreenUser(idUser: widget.idUser),
          PinjamanList(idUser: widget.idUser),
          ProfileScreen(idUser: widget.idUser),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list,),
            label: 'Daftar Pinjaman',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        backgroundColor: Color.fromARGB(52, 0, 0, 0),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class DashboardScreenUser extends StatelessWidget {
  final String idUser;

  DashboardScreenUser({required this.idUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard User'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(
              child: Text(
                'Selamat Datang di Ganesha Tools',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => electroList(idUser: idUser),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Alat Elektronik'),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => notElectroList(idUser: idUser)),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Alat Non Elektronik'),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final String idUser;

  ProfileScreen({required this.idUser});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
  }

  Future<Map<String, dynamic>> _getUserData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://iamthetoolsmanagement.000webhostapp.com/readUser.php?id_User=${widget.idUser}'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['user'][0];
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: FutureBuilder(
          future: _userDataFuture,
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('Data tidak ditemukan');
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile.png'),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.person, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                      '${snapshot.data!['username']}#${snapshot.data!['id_User']}',
                      style: TextStyle(fontSize: 18)),
                  Text('${snapshot.data!['email']}',
                      style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class PinjamanList extends StatefulWidget {
  final String idUser;

  const PinjamanList({required this.idUser});

  @override
  _PinjamanListState createState() => _PinjamanListState();
}

class _PinjamanListState extends State<PinjamanList> {
  late Future<List<dynamic>?> _pinjamanDataFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pinjamanDataFuture = _getPinjamanData();
  }

  Future<List<dynamic>?> _getPinjamanData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://iamthetoolsmanagement.000webhostapp.com/readPinjaman.php?id_User=${widget.idUser}'));

      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['peminjaman'] != null) {
          return decoded['peminjaman'];
        } else {
          return [];
        }
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void _refreshData() {
    setState(() {
      _pinjamanDataFuture = _getPinjamanData();
    });
  }

  Future<void> _deletePinjamanUser(String idPeminjaman) async {
    setState(() {
      _isLoading = true;
    });

    try {
      _showLoadingDialog();

      final Map<String, String> formData = {
        'id_peminjaman': idPeminjaman,
      };

      final response = await http.post(
        Uri.parse(
            'https://iamthetoolsmanagement.000webhostapp.com/deletePinjamanUser.php'),
        body: formData,
      );

      _hideLoadingDialog();

      if (response.statusCode == 200) {
        print('Data berhasil diperbarui');
        _showSuccessDialog();
        _refreshData(); // Refresh data after update
      } else {
        throw Exception('Gagal memperbarui data');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog('Gagal memperbarui data. Silakan coba lagi nanti.');
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
            child: CircularProgressIndicator(),
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
          title: Text('Sukses'),
          content: Text('Data berhasil diperbarui.'),
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
        title: const Text('Daftar Pinjaman User'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>?>(
        future: _pinjamanDataFuture,
        builder: (context, AsyncSnapshot<List<dynamic>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(child: Text('Belum Ada Data'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        // Gambar
                        Image.asset(
                          'assets/' + snapshot.data![index]['gambar'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama alat
                              Text(
                                snapshot.data![index]['nama_alat'] ?? '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 17.0, color: Colors.grey),
                                    SizedBox(width: 5.0),
                                    Text(
                                      'Tanggal Pinjam: ${snapshot.data![index]['tanggal_pinjam']}',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(Icons.event,
                                        size: 17.0, color: Colors.grey),
                                    SizedBox(width: 5.0),
                                    Text(
                                      'Rencana Pengembalian: ${snapshot.data![index]['tanggal_pengembalian']}',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(Icons.queue,
                                        size: 17.0, color: Colors.grey),
                                    SizedBox(width: 5.0),
                                    Text(
                                      'Jumlah Dipinjam: ${snapshot.data![index]['jumlah_dipinjam']}',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      snapshot.data![index]['status'] == "0"
                                          ? Icons.lock_clock
                                          : Icons.check,
                                      color:
                                          snapshot.data![index]['status'] == "0"
                                              ? Colors.red
                                              : Colors.green,
                                      size: 17.0,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      snapshot.data![index]['status'] == "0"
                                          ? 'Menunggu konfirmasi admin'
                                          : 'Permintaan dikonfirmasi',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  if (snapshot.data![index]['status'] ==
                                      "0") ...[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.yellow,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        _deletePinjamanUser(snapshot
                                            .data![index]['id_peminjaman']);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
