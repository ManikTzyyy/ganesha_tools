<?php
// Informasi koneksi database
$host = "localhost"; // biasanya localhost
$username = "id22415647_admin"; // sesuaikan dengan username database Anda
$password = "Singaraja0!"; // sesuaikan dengan password database Anda
$database_name = "id22415647_ganeshatool"; // sesuaikan dengan nama database Anda

// Buat koneksi
$conn = new mysqli($host, $username, $password, $database_name);

// Periksa koneksi
if ($conn->connect_error) {
    die("Koneksi Gagal: " . $conn->connect_error);
}

// Berhasil terhubung
echo "Koneksi Berhasil!";
?>
