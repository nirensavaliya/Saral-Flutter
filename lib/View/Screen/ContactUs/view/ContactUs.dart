import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_String.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/ContactUs/controller/ContactUsController.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/common_button.dart';
import 'package:saral/View/Widget/common_textfild.dart';

class Contactus extends StatelessWidget {
  Contactus({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Contact Us",showBackButton: true,),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              children: [

                buildInfoCard(
                  Icons.call,
                  "Phone Number",
                  "+91 45636 78908",
                ),

                const SizedBox(height: 15),

                buildInfoCard(
                  Icons.phone_android,
                  "Alternate Number",
                  "+91 98765 43210",
                ),

                const SizedBox(height: 15),

                buildInfoCard(
                  Icons.email_outlined,
                  "Email Address",
                  "john@gmail.com",
                ),

                const SizedBox(height: 15),

                buildInfoCard(
                  Icons.location_on_outlined,
                  "Office Address",
                  "101, Shree Complex,\nAhmedabad, Gujarat",
                ),

                const SizedBox(height: 25),

                // SizedBox(
                //   width: double.infinity,
                //   child: ElevatedButton.icon(
                //     onPressed: () {},
                //     icon: const Icon(Icons.call),
                //     label: const Text("Call Now"),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xffC8102E),
                //       foregroundColor: Colors.white,
                //       padding: const EdgeInsets.symmetric(vertical: 16),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(14),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            )
          ),
        ),
      ),
    );
  }
  Widget buildInfoCard(
      IconData icon,
      String title,
      String value,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [

          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: const Color(0xffC8102E).withOpacity(.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: const Color(0xffC8102E),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
