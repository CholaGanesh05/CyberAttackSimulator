import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(DataExfiltrationSimApp());

class DataExfiltrationSimApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CyberSec Training Simulator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Color(0xFF0D1117),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF161B22),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF238636),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: SimulationHomePage(),
    );
  }
}

class SimulationHomePage extends StatefulWidget {
  @override
  _SimulationHomePageState createState() => _SimulationHomePageState();
}

class _SimulationHomePageState extends State<SimulationHomePage>
    with TickerProviderStateMixin {
  bool _simulationStarted = false;
  bool _showEndButton = false;
  bool _showOptions = false;
  String _simulationOutput = '';
  int _currentStep = 0;
  Timer? _timer;
  
  late AnimationController _pulseController;
  late AnimationController _typewriterController;
  late Animation<double> _pulseAnimation;
  
  final List<String> _attackSteps = [
    'Initializing attack simulation...',
    'Establishing connection to C2 server (192.168.1.14:8080)...',
    'Bypassing Windows Defender...',
    'Escalating privileges...',
    'Scanning for sensitive files...',
    'Located target files in Documents folder...',
    'Compressing files with AES-256 encryption...',
    'Creating covert channel via DNS tunneling...',
    'Exfiltrating data in 4KB chunks...',
    'Progress: ████████████████████████████████ 100%',
    'Data successfully transmitted (2.3 GB)...',
    'Cleaning up traces...',
    'Connection terminated.',
    '',
    '🚨 SECURITY ALERT 🚨',
    'Unusual network activity detected!',
    'Multiple files being transmitted over suspicious ports.',
    'Potential data breach in progress.',
    'Immediate investigation required!'
  ];

  final List<Map<String, dynamic>> _scenarios = [
    {
      'title': 'Email Phishing Attack',
      'description': 'Simulates credential harvesting via malicious email',
      'icon': Icons.email,
      'color': Colors.orange,
    },
    {
      'title': 'Data Exfiltration',
      'description': 'Demonstrates unauthorized data extraction',
      'icon': Icons.cloud_download,
      'color': Colors.red,
    },
    {
      'title': 'Ransomware Simulation',
      'description': 'Shows file encryption and ransom demands',
      'icon': Icons.lock,
      'color': Colors.purple,
    },
    {
      'title': 'Network Intrusion',
      'description': 'Lateral movement and privilege escalation',
      'icon': Icons.network_check,
      'color': Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _typewriterController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _typewriterController.dispose();
    super.dispose();
  }

  void _startSimulation() async {
    setState(() {
      _simulationStarted = true;
      _simulationOutput = '';
      _currentStep = 0;
    });

    _timer = Timer.periodic(Duration(milliseconds: 800), (timer) {
      if (_currentStep < _attackSteps.length) {
        setState(() {
          _simulationOutput += _attackSteps[_currentStep] + '\n';
          _currentStep++;
        });
        
        // Add haptic feedback for critical alerts
        if (_attackSteps[_currentStep - 1].contains('ALERT')) {
          HapticFeedback.vibrate();
        }
      } else {
        timer.cancel();
        setState(() {
          _showEndButton = true;
        });
      }
    });
  }

  void _endSimulation() {
    _timer?.cancel();
    setState(() {
      _simulationStarted = false;
      _showEndButton = false;
      _simulationOutput = 'Simulation complete. Analyze the attack or explore preventive measures.';
      _showOptions = true;
    });
  }

  void _showAnalysis() {
    setState(() {
      _simulationOutput = '''
═══════════════════════════════════════
          INCIDENT ANALYSIS REPORT
═══════════════════════════════════════

🔍 ATTACK TIMELINE:
[14:32:15] Initial compromise via phishing email
[14:32:45] Malicious payload executed
[14:33:12] Privilege escalation successful
[14:33:28] File enumeration initiated
[14:34:01] Sensitive data identified
[14:34:33] Data compression started
[14:35:12] Exfiltration commenced
[14:37:45] 2.3 GB successfully transmitted

📂 COMPROMISED FILES:
• Employee_Database.xlsx (1.2 GB)
• Financial_Reports_Q4.pdf (456 MB)
• Client_Contracts_2024.zip (234 MB)
• System_Credentials.txt (12 KB)
• Network_Topology.png (890 KB)

🚩 INDICATORS OF COMPROMISE:
• Unusual outbound traffic on port 8080
• DNS queries to suspicious domains
• PowerShell execution by non-admin user
• File access outside normal hours
• Large file transfers detected

⚠️ RISK ASSESSMENT: CRITICAL
Data sensitivity: HIGH
Compliance impact: SEVERE
Business continuity: AFFECTED

💰 ESTIMATED IMPACT:
• Regulatory fines: \$2.5M - \$15M
• Business disruption: \$500K
• Incident response: \$250K
• Reputation damage: SIGNIFICANT
''';
      _showOptions = false;
    });
  }

  void _showPreventiveMeasures() {
    setState(() {
      _simulationOutput = '''
═══════════════════════════════════════
        CYBERSECURITY COUNTERMEASURES
═══════════════════════════════════════

🛡️ TECHNICAL CONTROLS:
✅ Data Loss Prevention (DLP)
   → Monitor and block sensitive data transfers
   → Real-time content inspection
   
✅ Network Segmentation
   → Isolate critical systems
   → Implement zero-trust architecture
   
✅ Endpoint Detection & Response (EDR)
   → Behavioral analysis
   → Automated threat hunting
   
✅ Email Security Gateway
   → Advanced threat protection
   → Sandbox analysis for attachments

👥 HUMAN CONTROLS:
✅ Security Awareness Training
   → Monthly phishing simulations
   → Incident reporting procedures
   
✅ Access Management
   → Principle of least privilege
   → Multi-factor authentication
   
✅ Incident Response Plan
   → Clear escalation procedures
   → Regular tabletop exercises

📊 MONITORING & DETECTION:
✅ SIEM Implementation
   → Real-time log analysis
   → Correlation rules for anomalies
   
✅ Network Traffic Analysis
   → Baseline establishment
   → Anomaly detection algorithms
   
✅ File Integrity Monitoring
   → Critical file change alerts
   → Tamper detection

🔧 CONFIGURATION HARDENING:
✅ Disable unnecessary services
✅ Regular security patches
✅ Strong password policies
✅ Encrypted communications
✅ Backup and recovery procedures

💡 RECOMMENDED IMMEDIATE ACTIONS:
1. Deploy DLP solution
2. Implement network monitoring
3. Conduct security training
4. Review access permissions
5. Update incident response plan
''';
      _showOptions = false;
    });
  }

  void _resetSimulation() {
    setState(() {
      _simulationStarted = false;
      _showEndButton = false;
      _showOptions = false;
      _simulationOutput = '';
      _currentStep = 0;
    });
    _timer?.cancel();
  }

  Widget _buildScenarioCard(Map<String, dynamic> scenario) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Color(0xFF21262D),
      child: ListTile(
        leading: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: scenario['title'] == 'Data Exfiltration' ? _pulseAnimation.value : 1.0,
              child: Icon(
                scenario['icon'],
                color: scenario['color'],
                size: 32,
              ),
            );
          },
        ),
        title: Text(
          scenario['title'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          scenario['description'],
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: scenario['title'] == 'Data Exfiltration'
            ? Icon(Icons.play_arrow, color: Colors.green)
            : Icon(Icons.lock, color: Colors.grey),
        onTap: scenario['title'] == 'Data Exfiltration' ? _startSimulation : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.security, color: Colors.red),
            SizedBox(width: 8),
            Text('CyberSec Training Simulator'),
          ],
        ),
        actions: [
          if (_simulationStarted || _showOptions)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetSimulation,
              tooltip: 'Reset Simulation',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_simulationStarted && !_showOptions) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF21262D),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Welcome to CyberSec Training',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Experience realistic cybersecurity attack simulations in a safe environment. Learn to identify threats, understand attack vectors, and implement effective countermeasures.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Available Simulations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              ..._scenarios.map((scenario) => _buildScenarioCard(scenario)).toList(),
            ],
            if (_simulationStarted || _showOptions)
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF0D1117),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[800]!),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _simulationOutput,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: Colors.green[400],
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
            if (_showEndButton)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value * 0.1 + 0.95,
                        child: ElevatedButton.icon(
                          onPressed: _endSimulation,
                          icon: Icon(Icons.stop),
                          label: Text('End Simulation'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            if (_showOptions)
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showAnalysis,
                        icon: Icon(Icons.analytics),
                        label: Text('Detailed Analysis'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showPreventiveMeasures,
                        icon: Icon(Icons.shield),
                        label: Text('Countermeasures'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: _simulationStarted && !_showEndButton
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showEndButton = true;
                });
                _timer?.cancel();
              },
              backgroundColor: Colors.red,
              child: Icon(Icons.emergency_outlined),
              tooltip: 'Emergency Stop',
            )
          : null,
    );
  }
}
