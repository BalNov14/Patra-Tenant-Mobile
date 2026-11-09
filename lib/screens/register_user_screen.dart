import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final nama = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;

  register() async {
    setState(() {
      loading = true;
    });

    try {
      var response = await ApiService.registerUser(
        nama: nama.text,
        email: email.text,
        password: password.text,
      );

      setState(() {
        loading = false;
      });

      if (response["message"] == "User berhasil dibuat") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Register Berhasil"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error : $e"), backgroundColor: Colors.red),
      );
    }
  }

  Widget input(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: TextField(
        controller: controller,

        obscureText: hint == "Password",

        decoration: InputDecoration(
          hintText: hint,

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register User"),

        backgroundColor: const Color(0xff0D93B0),

        foregroundColor: Colors.white,
      ),

      backgroundColor: const Color(0xffF5F7FA),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            input("Nama", nama),

            input("Email", email),

            input("Password", password),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0D93B0),

                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),

                onPressed: loading ? null : register,

                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "REGISTER",

                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
