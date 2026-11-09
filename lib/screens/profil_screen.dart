import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map tenant = {};
  bool loading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final response = await ApiService.getTenantProfile();

      if (!mounted) return;

      setState(() {
        if (response["statusCode"] == 200 && response["data"] is Map) {
          tenant = response["data"];
          errorMessage = "";
        } else if (response["statusCode"] == 404) {
          tenant = {};
          errorMessage = "";
        } else if (response["statusCode"] == 401) {
          tenant = {};
          errorMessage = "Sesi login habis, silakan login ulang";
        } else {
          tenant = {};
          errorMessage = response["message"] ?? "Gagal mengambil profil tenant";
        }

        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        tenant = {};
        errorMessage = "Gagal mengambil profil tenant: $e";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Tenant"),
        backgroundColor: const Color(0xff0D93B0),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          if (errorMessage.isNotEmpty)
            Card(
              color: Colors.red.shade50,
              child: ListTile(
                leading: const Icon(Icons.error, color: Colors.red),
                title: const Text("Gagal Memuat Profil"),
                subtitle: Text(errorMessage),
              ),
            ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Nama"),
              subtitle: Text(tenant["nama"] ?? ""),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Email"),
              subtitle: Text(tenant["email"] ?? ""),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Nomor HP"),
              subtitle: Text(tenant["nomor_hp"] ?? ""),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Alamat"),
              subtitle: Text(tenant["alamat"] ?? ""),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text("Plat Nomor"),
              subtitle: Text(tenant["plat_nomor"] ?? ""),
            ),
          ),

          //Menampilkan Jenis Kendaraan di bawah Plat Nomor
          Card(
            child: ListTile(
              leading: Icon(
                // Ubah dari "jenis_kendaraan" menjadi "kendaraan"
                tenant["kendaraan"]?.toString().toLowerCase() == "motor"
                    ? Icons.two_wheeler
                    : Icons.directions_car_filled,
              ),
              title: const Text("Jenis Kendaraan"),
              subtitle: Text(
                // Ubah dari "jenis_kendaraan" menjadi "kendaraan"
                tenant["kendaraan"] != null
                    ? tenant["kendaraan"].toString().toUpperCase()
                    : "-",
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.business),
              title: const Text("Asal Instansi"),
              subtitle: Text(tenant["asal_instansi"] ?? ""),
            ),
          ),
        ],
      ),
    );
  }
}
