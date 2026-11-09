import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Peraturan Parkir"),
        backgroundColor: const Color(0xff0D93B0),
        foregroundColor: Colors.white,
      ),

      backgroundColor: const Color(0xffF5F7FA),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Peraturan Parkir Umum",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff0D93B0),
              ),
            ),

            const SizedBox(height: 20),

            rule(
              "1. Penggunaan Kartu/Tiket",
              "Setiap pengendara wajib mengambil tiket atau tapping kartu pada mesin yang tersedia.",
            ),

            rule(
              "2. Kehilangan Tiket",
              "Wajib menunjukkan STNK dan identitas diri serta dikenakan denda administratif.",
            ),

            rule(
              "3. Ketentuan Menginap",
              "Kendaraan boleh parkir lebih dari 24 jam dan tarif dihitung otomatis.",
            ),

            rule(
              "4. Tanggung Jawab Barang",
              "Pengelola tidak bertanggung jawab atas kehilangan barang.",
            ),

            rule(
              "5. Keamanan & Ketertiban",
              "Kendaraan wajib dikunci dan diparkir dengan rapi.",
            ),

            rule(
              "6. Larangan Khusus",
              "Dilarang meninggalkan benda berbahaya di kendaraan.",
            ),

            const SizedBox(height: 30),

            const Text(
              "Peraturan Parkir Tenant",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff0D93B0),
              ),
            ),

            const SizedBox(height: 20),

            rule(
              "1. Kepemilikan Hak Parkir",
              "Hak parkir hanya berlaku untuk kendaraan terdaftar.",
            ),

            rule(
              "2. Kartu Akses Member",
              "Kartu akses tidak boleh dipindahtangankan.",
            ),

            rule(
              "3. Area Parkir Terpilih",
              "Tenant wajib parkir di area khusus member.",
            ),

            rule(
              "4. Laporan Parkir Jangka Panjang",
              "Parkir lebih dari 7 hari wajib melapor.",
            ),

            rule(
              "5. Kebersihan Area",
              "Dilarang mencuci kendaraan atau servis berat.",
            ),

            rule(
              "6. Administrasi Langganan",
              "Perpanjangan tenant maksimal 3 hari sebelum habis.",
            ),
          ],
        ),
      ),
    );
  }

  Widget rule(String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(15),

        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xff0D93B0),
            ),
          ),

          const SizedBox(height: 8),

          Text(desc),
        ],
      ),
    );
  }
}
