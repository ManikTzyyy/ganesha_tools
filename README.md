Aplikasi ini merupakan aplikasi yang di buat menggunakan framework flutter. Aplikasi ini menggunakan mysql sebagai databasenya dan menggunakan Bahasa php untuk API nya.

Untuk dapat terkoneksi dengan database, flutter menggunnakan library http untuk membaca file php di server
   ![image](https://github.com/user-attachments/assets/ead8bb40-c5bc-492d-9bdf-66a070f375e7)

Gambar 1 library http

Cara kerjanya adalah sebagai berikut:
Contoh membaca data dari table alat di database
- file php yang sudah di upload di server akan dibaca menggunakan fungsi yang di atur di flutter
 ![image](https://github.com/user-attachments/assets/6975a99b-4547-4225-9452-a6d3ae4012aa)

Gambar 2 file php sebagai koneksi kedatabase
 ![image](https://github.com/user-attachments/assets/3c7eae21-83b2-44a1-b12d-4c7c5885d9c1)

Gambar 3 bagian code untuk memanggil fungsi php tersebut
Jadi sederhananya adalah flutter akan mengakses link file yang ada di file manager di webhostnya, dan flutter akan membaca hasil output dari link tersebut.

 ![image](https://github.com/user-attachments/assets/efbae18e-0315-4ce9-9830-364240500ba5)

Gambar 4 hasil dari koneksi database pada table alat





![image](https://github.com/user-attachments/assets/79dcf082-2259-4281-9999-7555edf47a04)

 
Gambar 5 Register page
Pada menu register, data user akan di kirim ke database menggunakan file php dan user akan menggunakan role user sebgai default.
Pada login, hal pertama yang dilakukan adalah mengecek role pada database, 
 ![image](https://github.com/user-attachments/assets/337c8e38-a2af-4765-8cca-ceb54dc16b7e)

jika isAdmin memiliki nilai 1 maka akun tersebut akan di anggap sebagai admin dan akun tersebut akan di arahkan ke menu admin dan juga sebaliknya. Saat berhasil login, user akan membawa id_user.
![image](https://github.com/user-attachments/assets/1cfa5c23-9e02-41fb-9f23-beedcacb26e4)
 
Gambar 6 fungsi yang mengatur untuk login user atau admin


Id_user ini berfungsi untuk mengatur tentang data dari si user, seperti username, alat yang di pinjam dan lain lain
   
![image](https://github.com/user-attachments/assets/8a8b6dfd-7cc1-4692-af9a-9923f60eeb1b)
![image](https://github.com/user-attachments/assets/87052fe8-073f-4b74-b4be-a3dbf5c491a7)
![image](https://github.com/user-attachments/assets/756b2b37-3673-4861-8777-26e3693c8d05)



Skema Dasar USER
User pertama akan login sebagai user
![image](https://github.com/user-attachments/assets/3a9c8a87-ce2b-46d9-aef8-a87b34ea4ece)

 
User akan di arahkan menu utama dan bisa memilih alat apa yang akan di pinjam
Sebagai contoh missal user ingin meminjam alat kabel HDMI.
![image](https://github.com/user-attachments/assets/06c9a06e-5d23-4ca7-857d-51e3843a19a8)
![image](https://github.com/user-attachments/assets/c3b6dc34-af33-4357-8b1e-ef547ea1373b)

![image](https://github.com/user-attachments/assets/2f3dcbab-2a10-464b-b57e-e7f0ee3daa13)

Setelah mengisi form, maka data itu akan di post ke database dengan nama table peminjaman dimana terdapat data dari user lainnya juga
 ![image](https://github.com/user-attachments/assets/fa23aa55-f990-4677-9aed-b2e7c14776cf)

Gambar 7 tabel peminjaman
Setelah itu user dapat meilhat tentang daftar pinjaman si user pada menu daftar pinjaman di homepage. Id_user tersebut mengatur untuk mengambil data agar hanya data dengan id_user yang login saja tampil. Hal tersebut membuat data pinjaman dari id_user lainnya tidak tampil. Pada menu daftar pinjaman, user akan diminta menunggu konfirmasi dari admin terlebih dahulu. Berikut merupakan tampilan sebelum dan sesudah dikonfirmasi admin

![image](https://github.com/user-attachments/assets/e01f8ecd-84ec-4869-bc9f-fdd9d61ab1ff)
![image](https://github.com/user-attachments/assets/36e2336b-3e8a-4c64-9020-c09ad3e0c8bf)




Skema dasar Admin
Admin akan login menggunakan admin yang sudah di set admin di database
 ![image](https://github.com/user-attachments/assets/306cc756-39d7-4529-8f1e-7fd80e85fc85)

Admin bisa menambah alat, mengedit alat dan memanajemen user yang ingin meminjam barang
       
![image](https://github.com/user-attachments/assets/095ea3e5-662b-4a85-a558-9a17d5ae69e1)
![image](https://github.com/user-attachments/assets/cb89b059-c5d2-48a6-a1ba-85a7cce8d79f)
![image](https://github.com/user-attachments/assets/9501bead-9551-4c1c-b093-6cda190e715b)
![image](https://github.com/user-attachments/assets/aedf6421-47b2-4fa3-82af-bfcd61342d4e)




admin akan mengirim data ke tabel alat untuk menambah, mengedit, menghapus data alat seperti ketersediaan alat, deskripsi dan kategori
 ![image](https://github.com/user-attachments/assets/13666d4e-3d75-4e39-9166-e9b0d0b2be6e)

Gambar 8 tabel alat
Saat ke menu daftar pinjaman, admin akan melihat semua data dari user yang ingin meminjam alat, dimana admin bisa menolak dan menkonfirmasi pinjaman tersebut
  
![image](https://github.com/user-attachments/assets/d36e03a4-e600-41fb-b08c-fbe03e577e0b)
![image](https://github.com/user-attachments/assets/9703b628-9cb8-46b8-9ed6-3541c3c64969)


Pada table peminjaman, terdapat status dari peminjaman. Dimana status ini akan mengatur kondisi dari daftar pinjaman user

  ![image](https://github.com/user-attachments/assets/31e339ec-70ac-4c5c-b61e-34d1e6f3cc77)

Gambar 9 tabel peminjaman
Status ini akan mengatur kondisi pada container didaftar peminjaman, dimana jika status 0 maka barang membutuhkan konfirmasi dari admin. Status itu juga mengatur tampilan pada container tersebut jika status 0 maka akan muncul  2 button dan Ketika status maka hanya ada 1 button
 
 ![image](https://github.com/user-attachments/assets/84f37297-b165-4925-9a4b-6e84dfcdd886)
![image](https://github.com/user-attachments/assets/5fa468c1-0008-40b0-9762-edce594b96a6)

Gambar 10 code yang mengatur untuk tampilan button. Dimana Ketika status 0 maka akan muncul button accept dan reject
