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
      title: 'Data Exfiltration Simulator',
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
  bool _simulationComplete = false;
  String _simulationOutput = '';
  int _currentStep = 0;
  Timer? _timer;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  final List<String> _attackSteps = [
    'Connecting to compromised endpoint: WORKSTATION-7834...',
    'Establishing persistence via registry modification...',
    'Bypassing Windows Defender real-time protection...',
    'Injecting payload into explorer.exe process...',
    'Escalating privileges using UAC bypass technique...',
    'Enumerating network shares and mapped drives...',
    'Scanning C:\\Users\\%USERNAME%\\Documents for sensitive files...',
    'Located: customer_database.xlsx (2.1 MB)',
    'Located: financial_records_2024.pdf (854 KB)',
    'Located: employee_ssn_list.csv (234 KB)',
    'Located: credit_card_data.txt (67 KB)',
    'Located: confidential_contracts.zip (1.8 MB)',
    'Compressing files using 7zip with password protection...',
    'Splitting archive into 512KB chunks to avoid detection...',
    'Establishing encrypted tunnel to C&C server 185.220.101.47:443...',
    'Using HTTPS traffic to blend with normal web activity...',
    'Uploading chunk 1/12... [████████████████████████████████] 100%',
    'Uploading chunk 2/12... [████████████████████████████████] 100%',
    'Uploading chunk 3/12... [████████████████████████████████] 100%',
    'Uploading chunk 4/12... [████████████████████████████████] 100%',
    'Uploading chunk 5/12... [████████████████████████████████] 100%',
    'Uploading chunk 6/12... [████████████████████████████████] 100%',
    'Uploading chunk 7/12... [████████████████████████████████] 100%',
    'Uploading chunk 8/12... [████████████████████████████████] 100%',
    'Uploading chunk 9/12... [████████████████████████████████] 100%',
    'Uploading chunk 10/12... [███████████████████████████████] 100%',
    'Uploading chunk 11/12... [███████████████████████████████] 100%',
    'Uploading chunk 12/12... [███████████████████████████████] 100%',
    'Total data exfiltrated: 5.2 MB in 47 seconds',
    'Clearing event logs to hide tracks...',
    'Removing temporary files and registry entries...',
    'Terminating malicious processes...',
    'Exfiltration complete. Connection closed.',
    '',
    '⚠️  SECURITY OPERATIONS CENTER ALERT ⚠️',
    '',
    'INCIDENT ID: INC-2024-0523-001',
    'SEVERITY: HIGH',
    'CLASSIFICATION: Data Breach',
    '',
    'Anomalous network activity detected:',
    '• Unusual HTTPS traffic volume to external IP',
    '• File access patterns outside normal business hours',
    '• Multiple sensitive files accessed within short timeframe',
    '• Process injection detected in explorer.exe',
    '• Registry modifications in HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\Run',
    '',
    'RECOMMENDATION: Initiate incident response protocol immediately',
    'NEXT STEPS: Isolate affected systems and preserve forensic evidence'
  ];

  final List<Map<String, String>> _realWorldExamples = [
    {
      'company': 'Equifax (2017)',
      'impact': '147 million records compromised',
      'method': 'Web application vulnerability exploitation',
      'data': 'SSNs, birth dates, addresses, credit card numbers',
      'cost': '\$4 billion in total costs'
    },
    {
      'company': 'Capital One (2019)',
      'impact': '100 million customers affected',
      'method': 'Misconfigured AWS S3 bucket access',
      'data': 'Credit applications, SSNs, bank account numbers',
      'cost': '\$270 million in fines and costs'
    },
    {
      'company': 'SolarWinds (2020)',
      'impact': '18,000+ organizations compromised',
      'method': 'Supply chain attack via software update',
      'data': 'Government and corporate sensitive data',
      'cost': 'Estimated \$100+ billion global impact'
    },
    {
      'company': 'Colonial Pipeline (2021)',
      'impact': 'US fuel supply disrupted for 6 days',
      'method': 'Ransomware via compromised VPN credentials',
      'data': 'Operational systems and business data',
      'cost': '\$4.4 million ransom paid + operational losses'
    },
    {
      'company': 'T-Mobile (2021)',
      'impact': '54 million customers affected',
      'method': 'Unauthorized access through unprotected router',
      'data': 'SSNs, driver license info, phone numbers',
      'cost': '\$350 million class-action settlement'
    }
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startSimulation() async {
    setState(() {
      _simulationStarted = true;
      _simulationOutput = '';
      _currentStep = 0;
      _simulationComplete = false;
    });

    _timer = Timer.periodic(Duration(milliseconds: 600), (timer) {
      if (_currentStep < _attackSteps.length) {
        setState(() {
          _simulationOutput += _attackSteps[_currentStep] + '\n';
          _currentStep++;
        });
        
        // Add haptic feedback for critical alerts
        if (_attackSteps[_currentStep - 1].contains('ALERT')) {
          HapticFeedback.heavyImpact();
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
      _simulationComplete = true;
    });
  }

  void _resetSimulation() {
    setState(() {
      _simulationStarted = false;
      _showEndButton = false;
      _simulationComplete = false;
      _simulationOutput = '';
      _currentStep = 0;
    });
    _timer?.cancel();
  }

  Widget _buildRealWorldExample(Map<String, String> example) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Color(0xFF21262D),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.business, color: Colors.red, size: 20),
                SizedBox(width: 8),
                Text(
                  example['company']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildDetailRow('Impact:', example['impact']!, Colors.orange),
            _buildDetailRow('Attack Method:', example['method']!, Colors.blue),
            _buildDetailRow('Data Compromised:', example['data']!, Colors.purple),
            _buildDetailRow('Financial Cost:', example['cost']!, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ),
        ],
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
            Text('Data Exfiltration Simulator'),
          ],
        ),
        actions: [
          if (_simulationStarted || _simulationComplete)
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
            if (!_simulationStarted && !_simulationComplete) ...[
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Icon(
                            Icons.cloud_download,
                            size: 80,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Data Exfiltration Attack Simulation',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Experience a realistic data breach scenario',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _startSimulation,
                      icon: Icon(Icons.play_arrow),
                      label: Text('Start Simulation'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_simulationStarted)
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
                        fontSize: 13,
                        color: Colors.green[400],
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
            if (_simulationComplete)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
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
                                  'Simulation Complete',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'This simulation demonstrated how attackers can infiltrate systems and exfiltrate sensitive data. The techniques shown are based on real-world attack patterns used by cybercriminals and nation-state actors.',
                              style: TextStyle(
                                color: Colors.grey[300],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Real-World Data Breaches',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Learn from major security incidents that have impacted millions of people:',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 16),
                      ..._realWorldExamples.map((example) => _buildRealWorldExample(example)).toList(),
                    ],
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
