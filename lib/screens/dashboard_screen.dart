import 'package:easy_parkir_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'rules_screen.dart';
import 'rates_screen.dart';
import 'profil_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List menus = [
      {"title": "Pendaftaran Tenant", "icon": Icons.person_add},
      {"title": "Tarif Parkir", "icon": Icons.attach_money},
      {"title": "Peraturan Parkir", "icon": Icons.rule},
      {"title": "Profil", "icon": Icons.person},
      {"title": "Logout", "icon": Icons.logout},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("PATRA"),
        backgroundColor: const Color(0xff0D93B0),
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff0D93B0), Color(0xff00C6FF)],
              ),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),

            child: const Column(
              children: [
                Icon(Icons.local_parking, color: Colors.white, size: 80),

                SizedBox(height: 10),

                Text(
                  "SMART DATA TENANT COLLECT SYSTEM",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Text("PATRA", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // MENU
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: menus.length,

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1,
              ),

              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Pendaftaran Tenant
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    }
                    // Tarif Parkir
                    else if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RatesScreen()),
                      );
                    }
                    // Peraturan Parkir
                    else if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RulesScreen()),
                      );
                    }
                    // Profile
                    else if (index == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    }
                    //Logout
                    else if (index == 4) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(20),

                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(
                          menus[index]['icon'],
                          size: 50,
                          color: const Color(0xff0D93B0),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          menus[index]['title'],

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
