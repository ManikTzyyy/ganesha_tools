<?php
// Informasi koneksi database
$host = "localhost"; 
$username = "id22415647_admin"; 
$password = "Singaraja0!"; 
$database_name = "id22415647_ganeshatool"; 

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
    $password = $_POST['password'];

    // Validasi data
    if (empty($email) || empty($password)) {
        echo json_encode(["status" => "error", "message" => "Email dan password harus diisi!"]);
        exit;
    }

    // Query untuk memeriksa pengguna berdasarkan email
    $stmt = $conn->prepare("SELECT * FROM user WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // Ambil data pengguna
        $user = $result->fetch_assoc();

        // Verifikasi password
        if (password_verify($password, $user['password'])) {
            // Berhasil login
            $isAdmin = $user['isAdmin'] == 1 ? true : false; // Konversi ke boolean
            echo json_encode(["status" => "success", "message" => "Login berhasil!", "role" => $isAdmin ? "admin" : "user"]);
        } else {
            // Password salah
            echo json_encode(["status" => "error", "message" => "Password salah"]);
        }
    } else {
        // Pengguna tidak ditemukan
        echo json_encode(["status" => "error", "message" => "Email tidak terdaftar"]);
    }

    // Tutup statement
    $stmt->close();
}

// Tutup koneksi
$conn->close();
?>
