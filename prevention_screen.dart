import 'package:flutter/material.dart';

class PreventionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preventive Measures')),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          _buildPreventionCard(
            'Verify Links',
            Icons.link,
            'Always check URLs before clicking. Look for HTTPS and valid certificates.',
          ),
          _buildPreventionCard(
            'Regular Updates',
            Icons.system_update,
            'Keep your OS and apps updated to patch security vulnerabilities.',
          ),
          _buildPreventionCard(
            'Two-Factor Auth',
            Icons.lock,
            'Enable 2FA for all critical accounts to add extra security layer.',
          ),
          _buildPreventionCard(
            'Backup Data',
            Icons.backup,
            'Maintain regular backups in secure, offline locations.',
          ),
        ],
      ),
    );
  }

  Widget _buildPreventionCard(String title, IconData icon, String text) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  )),
                  SizedBox(height: 5),
                  Text(text, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}