import 'package:flutter/material.dart';

class RatesScreen extends StatelessWidget {
  const RatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tarif Parkir"),
        backgroundColor: const Color(0xff0D93B0),
        foregroundColor: Colors.white,
      ),

      backgroundColor: const Color(0xffF5F7FA),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            tarifCard("Motor", "Rp 3.000", "Rp 2.000 / jam", Icons.two_wheeler),

            const SizedBox(height: 20),

            tarifCard(
              "Mobil",
              "Rp 5.000",
              "Rp 3.000 / jam",
              Icons.directions_car,
            ),
          ],
        ),
      ),
    );
  }

  Widget tarifCard(String title, String awal, String perJam, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),

      child: Column(
        children: [
          Icon(icon, size: 70, color: const Color(0xff0D93B0)),

          const SizedBox(height: 15),

          Text(
            title,

            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          tarifRow("Tarif Awal", awal),

          const Divider(),

          tarifRow("Per Jam", perJam),
        ],
      ),
    );
  }

  Widget tarifRow(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(left, style: const TextStyle(fontSize: 16)),

          Text(
            right,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff0D93B0),
            ),
          ),
        ],
      ),
    );
  }
}
