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

// Periksa apakah data dikirim dengan metode POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Ambil data dari permintaan POST
    $email = $_POST['email'];
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Validasi data (contoh: pastikan tidak ada data yang kosong)
    if (empty($email) || empty($username) || empty($password)) {
        echo "Semua kolom harus diisi!";
        exit;
    }

    // Amankan password menggunakan hashing
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);

    // Query untuk memasukkan data pengguna ke database
    $sql = "INSERT INTO user (email, username, password) VALUES ('$email', '$username', '$hashed_password')";

    if ($conn->query($sql) === TRUE) {
        echo "Registrasi berhasil!";
    } else {
        echo "Registrasi gagal: " . $conn->error;
    }
}

// Tutup koneksi
$conn->close();
?>
