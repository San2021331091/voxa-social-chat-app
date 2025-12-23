import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Column(
      children: [
        /// Tile padding like WhatsApp
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.lightBlue,
              child: SvgPicture.asset(
                "assets/groups.svg",
                height: 34,
                width: 34,
              ),
            ),
            title: const Text(
              "John Doe",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            subtitle: Row(
              children: const [
                Icon(Icons.done_all, size: 16, color: Colors.red),
                SizedBox(width: 4),
                Text(
                  "Hello! How are you?",
                  style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            trailing: const Text(
              "18:04",
              style: TextStyle(fontSize: 12, color: Colors.blue,fontWeight: FontWeight.w600),
            ),
          ),
        ),

        /// 🔹 divider with padding
        const Padding(
          padding: EdgeInsets.only(left: 78, right: 12),
          child: Divider(
            height: 0,
            thickness: 0.6,
            color: Colors.blueGrey,
          ),
        ),
      ],
    ));
  }
}
