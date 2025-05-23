import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attack Analysis')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildComparisonRow('System Stability', '98%', '62%'),
            _buildComparisonRow('Battery Health', '100%', '85%'),
            _buildComparisonRow('Data Security', 'Secure', 'Compromised'),
            Divider(height: 40),
            Text('Detected Vulnerabilities:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            _buildVulnerabilityItem('Phishing Attempt Detected'),
            _buildVulnerabilityItem('Unauthorized Access Attempt'),
            _buildVulnerabilityItem('Data Exfiltration Pattern'),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String label, String before, String after) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Row(
            children: [
              Chip(label: Text(before), backgroundColor: Colors.green),
              SizedBox(width: 10),
              Icon(Icons.arrow_forward, size: 20),
              SizedBox(width: 10),
              Chip(label: Text(after), backgroundColor: Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVulnerabilityItem(String text) {
    return ListTile(
      leading: Icon(Icons.warning, color: Colors.orange),
      title: Text(text),
    );
  }
}