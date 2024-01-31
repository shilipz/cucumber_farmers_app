import 'package:cucumber_app/main.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('About the App'),
        ),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: Alignment.bottomCenter,
                  colors: [kwhite, lightgreen])),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FarmFriendly App',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Welcome to the FarmFriendly  App, your ultimate tool for seamlessly managing and optimizing your farm produce operations. This app is designed to empower farmers and administrators in the agricultural ecosystem, providing a user-friendly interface for handling vegetable prices, updating collection details, facilitating payments to farmers, and engaging in direct communication with customers.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Key Features:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '1. Update Collection Details: Stay organized by updating and managing collection details efficiently. Track the origin, quantity, and quality of vegetables collected from farmers.',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '3. Secure Payment System: Streamline the payment process by securely transferring earnings to farmers. Our app ensures transparent and timely transactions, fostering a strong and trusting relationship with the farming community.',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '4. Customer-Care Interaction: Enhance communication with customers through an integrated chat feature. Address inquiries, provide updates on available produce, and build a stronger connection between your farm and the end consumers.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Why Choose FarmFriendly  App:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '- User-Friendly Interface: Navigate through the app effortlessly with its intuitive design, making farm management tasks a breeze.',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '- Real-time Updates: Stay informed with real-time updates on market conditions, payment transactions, and customer interactions.',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '- Data Security: Your data is important to us. Rest assured that our app employs robust security measures to safeguard sensitive information.',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '- Supporting Sustainable Agriculture: By using the FarmFriendly Admin App, you contribute to promoting sustainable agriculture practices and supporting local farmers.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Get Started:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Download the FarmFriendly  App today and embark on a journey towards efficient farm produce management. Empower your farming community and connect with customers in a meaningful way.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
