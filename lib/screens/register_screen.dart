import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final hp = TextEditingController();
  final alamat = TextEditingController();
  final plat = TextEditingController();
  final instansi = TextEditingController();

  final FocusNode hpFocus = FocusNode();
  final FocusNode alamatFocus = FocusNode();
  String? jenisKendaraan;

  bool loading = false;
  bool _isShowingHpWarning = false;

  @override
  void initState() {
    super.initState();

    alamatFocus.addListener(() {
      if (alamatFocus.hasFocus) {
        _isShowingHpWarning = false;

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });
  }

  Future<void> register() async {
    // Validasi Nomor HP
    if (hp.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Nomor telepon hanya boleh berisi angka"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );

      return;
    }

    // Validasi hanya angka
    if (!RegExp(r'^[0-9]+$').hasMatch(hp.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nomor HP hanya boleh berisi angka"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validasi opsional: memastikan user memilih jenis kendaraan sebelum hit API
    if (jenisKendaraan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan pilih jenis kendaraan terlebih dahulu"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final response = await ApiService.registerTenant(
        nomorHp: hp.text,
        alamat: alamat.text,
        platNomor: plat.text,
        instansi: instansi.text,
        kendaraan: jenisKendaraan,
      );

      setState(() {
        loading = false;
      });

      if (!mounted) return;

      if (response["statusCode"] == 201) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Berhasil"),
            content: Text(
              response["message"] ?? "Data tenant berhasil disimpan",
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage(response)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error : $e")));
    }
  }

  String _errorMessage(Map<String, dynamic> response) {
    switch (response["statusCode"]) {
      case 401:
        return "Sesi login habis atau belum login, silakan login ulang";
      case 409:
        return response["message"] ?? "User sudah memiliki tenant";
      case 422:
        final errors = response["errors"];

        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;

          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
        }

        return response["message"] ?? "Validasi gagal";
      default:
        return response["message"] ?? "Gagal menyimpan data tenant";
    }
  }

  @override
  void dispose() {
    hp.dispose();
    alamat.dispose();
    plat.dispose();
    instansi.dispose();
    hpFocus.dispose();
    alamatFocus.dispose();
    super.dispose();
  }

  Widget input(
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
    FocusNode? focusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        onSubmitted: (_) {
          FocusScope.of(context).nextFocus();
        },
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(
                decimal: false,
                signed: false,
              )
            : TextInputType.text,
        textCapitalization: controller == plat
            ? TextCapitalization.characters
            : TextCapitalization.none,
        inputFormatters: isNumber
            ? [
                LengthLimitingTextInputFormatter(15),

                TextInputFormatter.withFunction((oldValue, newValue) {
                  if (!RegExp(r'^\d*$').hasMatch(newValue.text)) {
                    if (!_isShowingHpWarning) {
                      _isShowingHpWarning = true;

                      Future.microtask(() {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Nomor telepon hanya boleh berisi angka",
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                      });
                    }

                    return oldValue;
                  }

                  _isShowingHpWarning = false;
                  return newValue;
                }),
              ]
            : null,

        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // 3. Membuat Widget Dropdown kustom yang tampilannya serasi dengan TextField bawaanmu
  Widget inputDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: jenisKendaraan,
        hint: const Text("Pilih Jenis Kendaraan"),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: const [
          DropdownMenuItem(value: "mobil", child: Text("Mobil")),
          DropdownMenuItem(value: "motor", child: Text("Motor")),
        ],
        onChanged: (value) {
          setState(() {
            jenisKendaraan = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pendaftaran Tenant"),
        backgroundColor: const Color(0xff0D93B0),
        foregroundColor: Colors.white,
      ),

      backgroundColor: const Color(0xffF5F7FA),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            input("Nomor HP", hp, isNumber: true, focusNode: hpFocus),

            input("Alamat", alamat, focusNode: alamatFocus),

            input("Plat Nomor", plat),

            // 4. Dropdown disisipkan di bawah Plat Nomor agar rapi secara UX
            inputDropdown(),

            input("Asal Instansi", instansi),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: loading ? null : register,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0D93B0),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),

                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "DAFTAR",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
