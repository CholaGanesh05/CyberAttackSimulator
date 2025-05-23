import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math'; // For potential future random delays, not heavily used yet

void main() => runApp(DataExfiltrationSimApp());

// --- Data Models ---
enum LogType { action, info, alert, network, file, mitigation }

class AttackStep {
  final String displayText;
  final String? mitreId;
  final String? mitreName;
  final bool isCriticalAlert;
  final Duration delayAfter;
  final LogType logType;
  final String? details; // Optional additional details for the step

  AttackStep({
    required this.displayText,
    this.mitreId,
    this.mitreName,
    this.isCriticalAlert = false,
    this.delayAfter = const Duration(milliseconds: 600), // Default delay
    this.logType = LogType.info,
    this.details,
  });
}

class DataExfiltrationSimApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enhanced Data Exfiltration Simulator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Color(0xFF0D1117),
        cardColor: Color(0xFF161B22), // For cards
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.grey[300]),
          bodyMedium: TextStyle(color: Colors.grey[400]),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF161B22),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.redAccent),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF238636), // Green for start
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.redAccent, // Default icon color
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
  List<AttackStep> _simulationOutputSteps = [];
  int _currentStepIndex = 0;
  Timer? _timer;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Enhanced Attack Steps with MITRE ATT&CK Mapping and Log Types
  final List<AttackStep> _scenarioAttackSteps = [
    AttackStep(displayText: '[INITIATION] Connecting to compromised endpoint: WORKSTATION-7834...', logType: LogType.network),
    AttackStep(displayText: '[PERSISTENCE] Establishing persistence via registry modification...', mitreId: 'T1547.001', mitreName: 'Boot or Logon Autostart Execution: Registry Run Keys', logType: LogType.action),
    AttackStep(displayText: '[DEFENSE EVASION] Attempting to bypass Windows Defender real-time protection...', mitreId: 'T1562.001', mitreName: 'Impair Defenses: Disable or Modify Tools', logType: LogType.action),
    AttackStep(displayText: '[DEFENSE EVASION] Defender bypass successful. Real-time monitoring temporarily disabled.', logType: LogType.info),
    AttackStep(displayText: '[EXECUTION] Injecting stealth payload into explorer.exe process (PID: 1788)...', mitreId: 'T1055', mitreName: 'Process Injection', logType: LogType.action),
    AttackStep(displayText: '[PRIVILEGE ESCALATION] Escalating privileges using UAC bypass technique (SilentCleanup task)...', mitreId: 'T1548.002', mitreName: 'Abuse Elevation Control Mechanism: Bypass User Account Control', logType: LogType.action),
    AttackStep(displayText: '[PRIVILEGE ESCALATION] Achieved SYSTEM level privileges.', logType: LogType.info),
    AttackStep(displayText: '[DISCOVERY] Enumerating network shares and mapped drives (Net Share, Net Use)...', mitreId: 'T1135', mitreName: 'Network Share Discovery', logType: LogType.discovery),
    AttackStep(displayText: '[DISCOVERY] Scanning C:\\Users\\%USERNAME%\\Documents for sensitive files (keywords: confidential, private, report)...', mitreId: 'T1083', mitreName: 'File and Directory Discovery', logType: LogType.discovery),
    AttackStep(displayText: '[COLLECTION] Located: customer_database.xlsx (2.1 MB)', logType: LogType.file, details: "Contains PII and financial data."),
    AttackStep(displayText: '[COLLECTION] Located: financial_records_q4_2024.pdf (854 KB)", logType: LogType.file, details: "Quarterly financial statements."),
    AttackStep(displayText: '[COLLECTION] Located: employee_ssn_list_encrypted.csv.aes (234 KB)', logType: LogType.file, details: "AES encrypted, requires key."),
    AttackStep(displayText: '[COLLECTION] Located: credit_card_data_archive.zip (67 KB)', logType: LogType.file, details: "Protected with weak password 'password123'."),
    AttackStep(displayText: '[COLLECTION] Located: project_phoenix_contracts.zip (1.8 MB)', logType: LogType.file, details: "Sensitive R&D contracts."),
    AttackStep(displayText: '[COLLECTION] Attempting to decrypt employee_ssn_list_encrypted.csv.aes using common keys... Failed.', logType: LogType.action),
    AttackStep(displayText: '[COLLECTION] Brute-forcing credit_card_data_archive.zip password... Success! Password: password123', logType: LogType.action),
    AttackStep(displayText: '[COMMAND & CONTROL] Staging selected files for exfiltration in C:\\Windows\\Temp\\stage\\...', mitreId: 'T1074', mitreName: 'Data Staged', logType: LogType.action),
    AttackStep(displayText: '[COMMAND & CONTROL] Compressing staged files using 7zip with AES-256 encryption (password: ComplexP@$$w0rd!)...', logType: LogType.action),
    AttackStep(displayText: '[COMMAND & CONTROL] Compressed archive: exfil_data.7z (3.9 MB)', logType: LogType.file),
    AttackStep(displayText: '[EXFILTRATION] Splitting archive into 8x 512KB chunks to evade DLP detection...', mitreId: 'T1030', mitreName: 'Data Transfer Size Limits', logType: LogType.action),
    AttackStep(displayText: '[COMMAND & CONTROL] Establishing encrypted tunnel to C&C server 185.220.101.47:443 (HTTPS)...', mitreId: 'T1573.002', mitreName: 'Encrypted Channel: Asymmetric Cryptography', logType: LogType.network),
    AttackStep(displayText: '[EXFILTRATION] Using HTTPS traffic to blend with normal web activity (User-Agent: Chrome/99.0.4844.84)...', mitreId: 'T1071.001', mitreName: 'Application Layer Protocol: Web Protocols', logType: LogType.network),
    // Simulate chunk uploads
    ...List.generate(8, (i) => AttackStep(displayText: '[EXFILTRATION] Uploading chunk ${i+1}/8... [${"█".padRight(i+1, "█")}${" ".padRight(8-(i+1), " ")}] ${((i+1)/8*100).toStringAsFixed(0)}%', logType: LogType.network, delayAfter: Duration(milliseconds: 300))),
    AttackStep(displayText: '[EXFILTRATION] All chunks uploaded successfully.', logType: LogType.network),
    AttackStep(displayText: '[IMPACT] Total data exfiltrated: 3.9 MB over 52 seconds.', logType: LogType.info),
    AttackStep(displayText: '[DEFENSE EVASION] Clearing event logs (System, Security, Application)...', mitreId: 'T1070.001', mitreName: 'Indicator Removal: Clear Windows Event Logs', logType: LogType.action),
    AttackStep(displayText: '[DEFENSE EVASION] Removing temporary files and staging directory (C:\\Windows\\Temp\\stage\\)...', mitreId: 'T1070.004', mitreName: 'Indicator Removal: File Deletion', logType: LogType.action),
    AttackStep(displayText: '[DEFENSE EVASION] Restoring Windows Defender settings and terminating malicious processes...', logType: LogType.action),
    AttackStep(displayText: '[COMPLETION] Exfiltration complete. Connection to C&C server closed. Footprints minimized.', logType: LogType.info, delayAfter: Duration(milliseconds: 1500)),
    AttackStep(displayText: '', logType: LogType.info), // Spacer
    AttackStep(displayText: '🔴🔴🔴 SECURITY OPERATIONS CENTER (SOC) ALERT TRIGGERED 🔴🔴🔴', isCriticalAlert: true, logType: LogType.alert, delayAfter: Duration(milliseconds: 1000)),
    AttackStep(displayText: '', logType: LogType.info),
    AttackStep(displayText: 'INCIDENT ID: INC-2024-0715-003', logType: LogType.alert),
    AttackStep(displayText: 'SEVERITY: CRITICAL', logType: LogType.alert),
    AttackStep(displayText: 'CLASSIFICATION: Confirmed Data Breach | Active Exfiltration', logType: LogType.alert),
    AttackStep(displayText: '', logType: LogType.info),
    AttackStep(displayText: 'Anomalous Activity Detected:', logType: LogType.alert),
    AttackStep(displayText: '  • Unusual outbound HTTPS traffic volume to untrusted IP (185.220.101.47)', logType: LogType.alert),
    AttackStep(displayText: '  • Multiple sensitive file accesses from non-standard process (explorer.exe child)', logType: LogType.alert),
    AttackStep(displayText: '  • Process injection detected: explorer.exe -> [random_name].exe', logType: LogType.alert),
    AttackStep(displayText: '  • Registry modifications in HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\Run', logType: LogType.alert),
    AttackStep(displayText: '  • Windows Event Logs cleared or tampered.', logType: LogType.alert),
    AttackStep(displayText: '', logType: LogType.info),
    AttackStep(displayText: '[MITIGATION] RECOMMENDATION: Activate Level 1 Incident Response Protocol IMMEDIATELY.', logType: LogType.mitigation),
    AttackStep(displayText: '[MITIGATION] NEXT STEPS: Isolate WORKSTATION-7834, preserve forensic evidence, block C&C IP.', logType: LogType.mitigation),
  ];


  final List<Map<String, String>> _realWorldExamples = [
    {
      'company': 'Equifax (2017)',
      'impact': '147 million records compromised',
      'method': 'Web application vulnerability (Apache Struts)',
      'data': 'SSNs, birth dates, addresses, credit card numbers',
      'cost': '\$1.4 billion+ in total costs',
      'lesson': 'Importance of timely patching and vulnerability management.'
    },
    {
      'company': 'Capital One (2019)',
      'impact': '100 million+ customers affected',
      'method': 'Misconfigured AWS S3 bucket (SSRF to WAF)',
      'data': 'Credit applications, SSNs, bank account numbers',
      'cost': '\$270 million in fines and costs',
      'lesson': 'Cloud security misconfigurations are a major risk. Proper IAM and WAF tuning is crucial.'
    },
    {
      'company': 'SolarWinds (SUNBURST - 2020)',
      'impact': '18,000+ organizations compromised (incl. US Gov)',
      'method': 'Supply chain attack via trojanized software update',
      'data': 'Varied government and corporate sensitive data',
      'cost': 'Estimated \$100+ billion global impact',
      'lesson': 'Supply chain attacks are sophisticated and hard to detect. Trust but verify software updates.'
    },
    {
      'company': 'Colonial Pipeline (2021)',
      'impact': 'US fuel supply disrupted for days',
      'method': 'Ransomware (DarkSide) via compromised VPN (single-factor auth)',
      'data': 'Operational systems and business data',
      'cost': '\$4.4 million ransom paid + significant operational losses',
      'lesson': 'Critical infrastructure is a target. Multi-Factor Authentication (MFA) is essential everywhere.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 1), // Faster pulse
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
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
      _simulationOutputSteps = [];
      _currentStepIndex = 0;
      _simulationComplete = false;
      _showEndButton = false;
    });

    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) { // Base interval
      if (!mounted) { // Check if widget is still in tree
        timer.cancel();
        return;
      }
      if (_currentStepIndex < _scenarioAttackSteps.length) {
        final currentStep = _scenarioAttackSteps[_currentStepIndex];
        setState(() {
          _simulationOutputSteps.add(currentStep);
          _currentStepIndex++;
        });

        if (currentStep.isCriticalAlert) {
          HapticFeedback.heavyImpact();
        }
        // Adjust timer for next step based on currentStep.delayAfter if needed
        // For simplicity, we'll keep the base interval, but this is where more complex timing could go
      } else {
        timer.cancel();
        if (mounted) {
          setState(() {
            _showEndButton = true;
          });
        }
      }
    });
  }

  void _endSimulation() {
    _timer?.cancel();
    if (mounted) {
      setState(() {
        _simulationStarted = false;
        _showEndButton = false;
        _simulationComplete = true;
      });
    }
  }

  void _resetSimulation() {
    _timer?.cancel();
    if (mounted) {
      setState(() {
        _simulationStarted = false;
        _showEndButton = false;
        _simulationComplete = false;
        _simulationOutputSteps = [];
        _currentStepIndex = 0;
      });
    }
  }

  Widget _buildRealWorldExample(Map<String, String> example) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 24),
                SizedBox(width: 10),
                Text(
                  example['company']!,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, color: Colors.orangeAccent),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildDetailRow('Impact:', example['impact']!, Colors.redAccent.shade100),
            _buildDetailRow('Attack Method:', example['method']!, Colors.blueAccent.shade100),
            _buildDetailRow('Data Compromised:', example['data']!, Colors.purpleAccent.shade100),
            _buildDetailRow('Financial Cost:', example['cost']!, Colors.red.shade300),
            if (example['lesson'] != null && example['lesson']!.isNotEmpty)
              _buildDetailRow('Key Lesson:', example['lesson']!, Colors.greenAccent.shade100, isLesson: true),

          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color labelColor, {bool isLesson = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isLesson ? 90 : 130, // Shorter label for "Key Lesson"
            child: Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 13.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getLogColor(LogType logType) {
    switch (logType) {
      case LogType.action:
        return Colors.cyanAccent.shade400;
      case LogType.info:
        return Colors.grey.shade400;
      case LogType.alert:
        return Colors.redAccent.shade400;
      case LogType.network:
        return Colors.lightBlueAccent.shade200;
      case LogType.file:
        return Colors.amberAccent.shade400;
      case LogType.discovery:
        return Colors.limeAccent.shade400;
      case LogType.mitigation:
        return Colors.greenAccent.shade400;
      default:
        return Colors.green.shade300; // Fallback
    }
  }

  Widget _buildSimulationOutput() {
    ScrollController _scrollController = ScrollController();

    // Scroll to bottom when new content is added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF0A0C10), // Even darker for terminal
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[850]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          )
        ]
      ),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _simulationOutputSteps.length,
        itemBuilder: (context, index) {
          final step = _simulationOutputSteps[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.displayText,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    color: step.isCriticalAlert ? Colors.red.shade400 : _getLogColor(step.logType),
                    fontWeight: step.isCriticalAlert ? FontWeight.bold : FontWeight.normal,
                    height: 1.4,
                  ),
                ),
                if (step.mitreId != null && step.mitreName != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 1.0, bottom: 2.0),
                    child: Text(
                      '└── MITRE: ${step.mitreId} - ${step.mitreName}',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11.5,
                        color: Colors.tealAccent.shade400.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                if (step.details != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 1.0, bottom: 2.0),
                    child: Text(
                      '    └── Details: ${step.details}',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11.5,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AnimatedBuilder( // Pulse for app bar icon too
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _simulationStarted ? _pulseAnimation.value : 1.0,
                    child: Icon(Icons.security_update_warning_rounded, size: 28),
                  );
                }),
            SizedBox(width: 10),
            Text('Cyber Attack Simulator'),
          ],
        ),
        actions: [
          if (_simulationStarted || _simulationComplete)
            IconButton(
              icon: Icon(Icons.refresh_rounded),
              onPressed: _resetSimulation,
              tooltip: 'Reset Simulation',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_simulationStarted && !_simulationComplete) ...[
              Expanded(
                child: Center(
                  child: SingleChildScrollView( // Make intro screen scrollable if content overflows
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Icon(
                                Icons.gpp_maybe_outlined, // More threat-like icon
                                size: 90,
                                color: Colors.red.shade400,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Data Exfiltration & Attack Simulation',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 26),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Witness a simulated cyber attack sequence and learn about real-world breach impacts. For educational purposes only.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16, color: Colors.grey[500]),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40),
                        ElevatedButton.icon(
                          onPressed: _startSimulation,
                          icon: Icon(Icons.play_circle_fill_rounded),
                          label: Text('Launch Simulation'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            if (_simulationStarted)
              Expanded(
                child: _buildSimulationOutput(),
              ),
            if (_simulationComplete)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 3,
                        margin: EdgeInsets.only(bottom: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.blueAccent.withOpacity(0.5), width: 1.5)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.task_alt_rounded, color: Colors.blueAccent, size: 28),
                                  SizedBox(width: 12),
                                  Text(
                                    'Simulation Complete: Post-Incident Analysis',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20, color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'The preceding simulation demonstrated a multi-stage cyber attack leading to data exfiltration. Key phases included initial access, persistence, privilege escalation, discovery, collection, command & control, exfiltration, and defense evasion.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Detection & Prevention Opportunities:',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '• Endpoint Detection & Response (EDR) for process injection and anomalous behavior.\n'
                                '• Network monitoring/IDS/IPS for C&C traffic and large data outflows.\n'
                                '• Strong multi-factor authentication (MFA) to prevent initial access.\n'
                                '• Regular patching of vulnerabilities.\n'
                                '• User Account Control (UAC) hardening and principle of least privilege.\n'
                                '• Log monitoring and SIEM for early detection of suspicious activities.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5, fontSize: 13.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'Notable Real-World Data Breaches',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Learn from major security incidents that have impacted millions worldwide:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.5),
                      ),
                      SizedBox(height: 16),
                      ..._realWorldExamples.map((example) => _buildRealWorldExample(example)).toList(),
                      SizedBox(height: 20),
                       Center(
                         child: ElevatedButton.icon(
                           icon: Icon(Icons.refresh_rounded),
                           label: Text('Run Simulation Again'),
                           onPressed: _resetSimulation,
                           style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                         ),
                       ),
                       SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            if (_showEndButton && !_simulationComplete) // Show "View Analysis" button only after simulation output is done
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: AnimatedBuilder(
                    animation: _pulseController, // Re-use pulse for this button
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseController.value * 0.05 + 0.975, // Smaller pulse effect
                        child: ElevatedButton.icon(
                          onPressed: _endSimulation,
                          icon: Icon(Icons.assessment_rounded),
                          label: Text('View Post-Incident Analysis'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
      floatingActionButton: _simulationStarted && !_showEndButton && !_simulationComplete
          ? FloatingActionButton.extended(
              onPressed: () { // Emergency Stop or Skip to End
                _timer?.cancel();
                if(mounted){
                  setState(() {
                    _showEndButton = true; // Go directly to "View Analysis"
                  });
                }
              },
              backgroundColor: Colors.red.shade700,
              icon: Icon(Icons.stop_circle_outlined, color: Colors.white),
              label: Text('Skip to End', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              tooltip: 'Emergency Stop & View Analysis',
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
