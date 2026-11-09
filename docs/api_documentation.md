# Dokumentasi API Easy Parkir Mobile

Dokumentasi ini disusun berdasarkan implementasi aplikasi Flutter pada `lib/services/api_service.dart` dan layar-layar pada folder `lib/screens`.

## Ringkasan

- **Base URL**: `https://patratenant.my.id/api`
- **Format request**: JSON
- **Format response**: JSON
- **Header umum**:

```http
Content-Type: application/json
Accept: application/json
```

- **Header endpoint yang membutuhkan login**:

```http
Authorization: Bearer {token}
```

Token login disimpan di local storage aplikasi menggunakan `SharedPreferences` dengan key `token_login`.

## Daftar Endpoint

| Fitur | Method | Endpoint | Auth | Dipakai di Aplikasi |
| --- | --- | --- | --- | --- |
| Login | `POST` | `/login` | Tidak | Ya |
| Register User | `POST` | `/user/store` | Tidak | Ya |
| Register Tenant | `POST` | `/tenants` | Ya | Ya |
| Profil Tenant Login | `GET` | `/tenant/profile` | Ya | Ya |
| Detail Tenant by ID | `GET` | `/tenants/{id}` | Tidak di-set pada kode | Belum dipakai layar |

## 1. Login

Login user dan mengambil token autentikasi.

### Request

```http
POST /login
```

### Headers

```http
Content-Type: application/json
Accept: application/json
```

### Body Request

```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

### Field Request

| Field | Tipe | Wajib | Keterangan |
| --- | --- | --- | --- |
| `email` | `string` | Ya | Email user. |
| `password` | `string` | Ya | Password user. |

### Response Berhasil

Aplikasi menganggap login berhasil jika field `success` bernilai `true` dan `token` berisi string.

```json
{
  "success": true,
  "message": "Login berhasil",
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOi..."
}
```

### Response Gagal

```json
{
  "success": false,
  "message": "Email atau Password Salah"
}
```

### Catatan Aplikasi

- Jika `email` atau `password` kosong, aplikasi tidak memanggil API dan menampilkan pesan validasi.
- Jika login berhasil tetapi `token` tidak diterima, aplikasi menampilkan error dan tidak masuk dashboard.
- Token yang diterima disimpan ke `SharedPreferences` dengan key `token_login`.

## 2. Register User

Mendaftarkan akun user baru dengan role default `user`.

### Request

```http
POST /user/store
```

### Headers

```http
Content-Type: application/json
Accept: application/json
```

### Body Request

```json
{
  "name": "Budi Santoso",
  "email": "budi@example.com",
  "password": "password123",
  "role": "user"
}
```

### Field Request

| Field | Tipe | Wajib | Keterangan |
| --- | --- | --- | --- |
| `name` | `string` | Ya | Nama user. Di form aplikasi bernama `Nama`. |
| `email` | `string` | Ya | Email user. |
| `password` | `string` | Ya | Password user. |
| `role` | `string` | Ya | Selalu dikirim dengan nilai `user`. |

### Response Berhasil

Aplikasi mendeteksi berhasil jika field `message` bernilai `User berhasil dibuat`.

```json
{
  "message": "User berhasil dibuat",
  "data": {
    "id": 1,
    "name": "Budi Santoso",
    "email": "budi@example.com",
    "role": "user"
  }
}
```

### Response Gagal

Struktur error dari server ditampilkan langsung oleh aplikasi sebagai teks `response.toString()`.

```json
{
  "message": "Validasi gagal",
  "errors": {
    "email": ["Email sudah digunakan"]
  }
}
```

## 3. Register Tenant

Mendaftarkan data tenant/kendaraan. Endpoint ini membutuhkan token login.

### Request

```http
POST /tenants
```

### Headers

```http
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
```

### Body Request

```json
{
  "no_hp": "081234567890",
  "alamat": "Jl. Contoh No. 1",
  "plat_nomor": "B 1234 XYZ",
  "asal_instansi": "PT Patra",
  "kendaraan": "Mobil"
}
```

### Field Request

| Field | Tipe | Wajib | Keterangan |
| --- | --- | --- | --- |
| `no_hp` | `string` | Ya | Nomor handphone tenant. |
| `alamat` | `string` | Ya | Alamat tenant. |
| `plat_nomor` | `string` | Ya | Nomor plat kendaraan. |
| `asal_instansi` | `string` | Ya | Asal instansi tenant. |
| `kendaraan` | `string` | Ya di aplikasi | Jenis kendaraan dari dropdown. Nilai yang disediakan aplikasi: `Mobil`, `Motor`. |

### Response Berhasil

Aplikasi menganggap berhasil jika HTTP status code `201`.

```json
{
  "message": "Data tenant berhasil disimpan",
  "data": {
    "id": 10,
    "no_hp": "081234567890",
    "alamat": "Jl. Contoh No. 1",
    "plat_nomor": "B 1234 XYZ",
    "asal_instansi": "PT Patra",
    "kendaraan": "Mobil"
  }
}
```

Pada sisi aplikasi, response ditambahkan field lokal `statusCode` dari HTTP response.

```json
{
  "statusCode": 201,
  "message": "Data tenant berhasil disimpan",
  "data": {
    "id": 10,
    "no_hp": "081234567890",
    "alamat": "Jl. Contoh No. 1",
    "plat_nomor": "B 1234 XYZ",
    "asal_instansi": "PT Patra",
    "kendaraan": "Mobil"
  }
}
```

### Response Gagal Validasi

```json
{
  "statusCode": 422,
  "message": "Data yang diberikan tidak valid",
  "errors": {
    "plat_nomor": ["Plat nomor wajib diisi"]
  }
}
```

### Response Token Tidak Ada di Aplikasi

Jika token tidak ditemukan di `SharedPreferences`, aplikasi tidak memanggil API dan membuat response lokal berikut:

```json
{
  "statusCode": 401,
  "message": "Token tidak ditemukan, silakan login ulang"
}
```

### Catatan Aplikasi

- Aplikasi hanya memvalidasi `kendaraan` sebelum memanggil API.
- Field teks lain dikirim apa adanya dari form.
- Pesan error yang ditampilkan ditentukan dari `statusCode` dan `message` response.

## 4. Profil Tenant Login

Mengambil data profil tenant berdasarkan user yang sedang login.

### Request

```http
GET /tenant/profile
```

### Headers

```http
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
```

### Body Request

Tidak ada body request.

### Response Berhasil

Aplikasi menganggap berhasil jika HTTP status code `200` dan field `data` berbentuk object.

```json
{
  "data": {
    "id": 10,
    "nama": "Budi Santoso",
    "no_hp": "081234567890",
    "alamat": "Jl. Contoh No. 1",
    "plat_nomor": "B 1234 XYZ",
    "asal_instansi": "PT Patra",
    "kendaraan": "Mobil"
  }
}
```

Pada sisi aplikasi, response ditambahkan field lokal `statusCode`.

```json
{
  "statusCode": 200,
  "data": {
    "id": 10,
    "nama": "Budi Santoso",
    "no_hp": "081234567890",
    "alamat": "Jl. Contoh No. 1",
    "plat_nomor": "B 1234 XYZ",
    "asal_instansi": "PT Patra",
    "kendaraan": "Mobil"
  }
}
```

### Response Tenant Tidak Ditemukan

Aplikasi memperlakukan HTTP status code `404` sebagai kondisi tenant belum terdaftar.

```json
{
  "statusCode": 404,
  "message": "Profil tenant tidak ditemukan"
}
```

### Response Unauthorized

```json
{
  "statusCode": 401,
  "message": "Unauthenticated."
}
```

Jika token tidak ada di local storage, aplikasi membuat response lokal:

```json
{
  "statusCode": 401,
  "message": "Token tidak ditemukan, silakan login ulang"
}
```

### Field yang Ditampilkan di Aplikasi

Layar profil menampilkan field dari object `data` berikut:

| Label UI | Key Response |
| --- | --- |
| Nama | `nama` |
| Nomor HP | `no_hp` |
| Alamat | `alamat` |
| Plat Nomor | `plat_nomor` |
| Asal Instansi | `asal_instansi` |
| Jenis Kendaraan | `kendaraan` |

Jika key tidak tersedia, aplikasi menampilkan tanda `-`.

## 5. Detail Tenant by ID

Endpoint helper tersedia di service, tetapi belum digunakan oleh layar aplikasi saat ini.

### Request

```http
GET /tenants/{id}
```

### Path Parameter

| Parameter | Tipe | Wajib | Keterangan |
| --- | --- | --- | --- |
| `id` | `integer` | Ya | ID tenant. |

### Headers

Pada implementasi saat ini helper tidak mengirim header auth maupun header JSON khusus.

### Body Request

Tidak ada body request.

### Response Berhasil

Aplikasi hanya mengembalikan body JSON jika HTTP status code `200`.

```json
{
  "data": {
    "id": 10,
    "no_hp": "081234567890",
    "alamat": "Jl. Contoh No. 1",
    "plat_nomor": "B 1234 XYZ",
    "asal_instansi": "PT Patra",
    "kendaraan": "Mobil"
  }
}
```

### Response Gagal

Jika status code bukan `200`, helper melempar exception:

```text
Gagal mengambil data tenant
```

## Fitur yang Tidak Memakai API

Berikut fitur yang ada di aplikasi tetapi tidak melakukan request API.

### Dashboard

- Menampilkan menu utama aplikasi.
- Navigasi ke halaman:
  - `Pendaftaran Tenant`
  - `Tarif Parkir`
  - `Peraturan Parkir`
  - `Profil`
  - `Logout`
- Tidak mengambil data dari API.

### Tarif Parkir

Data tarif ditulis statis di aplikasi.

| Jenis Kendaraan | Tarif Awal | Tarif Per Jam |
| --- | --- | --- |
| Motor | Rp 3.000 | Rp 2.000 / jam |
| Mobil | Rp 5.000 | Rp 3.000 / jam |

### Peraturan Parkir

Data peraturan ditulis statis di aplikasi.

#### Peraturan Umum Parkir

| No | Peraturan |
| --- | --- |
| 1 | Kendaraan wajib dikunci dan diparkir dengan rapi. |
| 2 | Karcis/token parkir wajib disimpan. |
| 3 | Barang berharga tidak boleh ditinggalkan di kendaraan. |
| 4 | Kehilangan karcis/token harus melapor ke petugas. |
| 5 | Kerusakan atau kehilangan bukan tanggung jawab pengelola. |
| 6 | Dilarang meninggalkan benda berbahaya di kendaraan. |

#### Peraturan Parkir Tenant

| No | Peraturan |
| --- | --- |
| 1 | Hak parkir hanya berlaku untuk kendaraan terdaftar. |
| 2 | Kartu akses tidak boleh dipindahtangankan. |
| 3 | Tenant wajib parkir di area khusus member. |
| 4 | Parkir lebih dari 7 hari wajib melapor. |
| 5 | Dilarang mencuci kendaraan atau servis berat. |
| 6 | Perpanjangan tenant maksimal 3 hari sebelum habis. |

### Logout

- Logout hanya melakukan navigasi kembali ke halaman login menggunakan `Navigator.pushAndRemoveUntil`.
- Implementasi saat ini tidak menghapus token `token_login` dari `SharedPreferences`.
- Tidak memanggil endpoint logout.

### Penyimpanan Token Lokal

- Token login disimpan menggunakan package `shared_preferences`.
- Key penyimpanan: `token_login`.
- Fungsi yang tersedia:
  - `saveToken(token)` untuk menyimpan token.
  - `getToken()` untuk membaca token.
  - `hasToken()` untuk mengecek token tersedia atau tidak.
- Tidak ada endpoint API yang dipanggil untuk fitur ini.

## Catatan Implementasi

- `statusCode` bukan selalu berasal dari server body; pada beberapa method aplikasi menambahkan `statusCode` dari HTTP response ke object hasil decode JSON.
- Dokumentasi response berisi contoh struktur berdasarkan field yang dibaca oleh aplikasi. Struktur final tetap mengikuti implementasi backend.
- Endpoint `GET /tenants/{id}` ada di service tetapi belum terhubung ke UI.
