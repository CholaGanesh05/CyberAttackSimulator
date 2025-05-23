import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';

void main() {
  runApp(const AdvancedSecuritySimulator());
}

class ForensicEvent {
  final DateTime timestamp;
  final String type;
  final String title;
  final String details;
  final String severity;
  final int phase;

  const ForensicEvent({
    required this.timestamp,
    required this.type,
    required this.title,
    required this.details,
    required this.severity,
    required this.phase,
  });
}

class PreventiveMeasure {
  final String title;
  final String description;
  final String implementation;
  final String priority;
  final String cost;
  final int effectiveness;
  final String action;
  final String relatedVulnerability;

  const PreventiveMeasure({
    required this.title,
    required this.description,
    required this.implementation,
    required this.priority,
    required this.cost,
    required this.effectiveness,
    required this.action,
    required this.relatedVulnerability,
  });
}

class AttackAnalysis {
  final String attackVector;
  final List<String> exploitedVulnerabilities;
  final Map<String, dynamic> impactAssessment;
  final String attackSophistication;
  final String detectionTime;
  final String recoveryProbability;
  final String similarIncidentsIncrease;
  final List<int> relatedEventIndices;

  const AttackAnalysis({
    required this.attackVector,
    required this.exploitedVulnerabilities,
    required this.impactAssessment,
    required this.attackSophistication,
    required this.detectionTime,
    required this.recoveryProbability,
    required this.similarIncidentsIncrease,
    required this.relatedEventIndices,
  });
}

class AdvancedSecuritySimulator extends StatelessWidget {
  const AdvancedSecuritySimulator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Heist Forensics',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.cyan[300],
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        cardColor: const Color(0xFF1E1E1E),
        colorScheme: ColorScheme.dark(
          primary: Colors.cyan[300]!,
          secondary: Colors.amber[300]!,
          error: Colors.red[300]!,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
          labelMedium: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyan[600],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            foregroundColor: Colors.white,
          ),
        ),
        dialogTheme: DialogThemeData(
          titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          contentTextStyle: const TextStyle(fontSize: 16, color: Colors.black87),
          backgroundColor: Colors.white,
        ),
      ),
      home: const SecuritySimulatorDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SecuritySimulatorDashboard extends StatefulWidget {
  const SecuritySimulatorDashboard({super.key});

  @override
  SecuritySimulatorDashboardState createState() => SecuritySimulatorDashboardState();
}

class SecuritySimulatorDashboardState extends State<SecuritySimulatorDashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _phoneController;
  late AnimationController _alertController;
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;
  late AnimationController _balanceController;
  late Animation<double> _balanceAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _trustScoreController;
  late Animation<Color?> _trustScoreColorAnimation;

  bool _simulationActive = false;
  int _currentPhase = 0;
  final String _victimName = "Rajesh Kumar";
  double _victimBalance = 45000.0;
  double _stolenAmount = 0.0;
  AttackAnalysis? _attackAnalysis;
  int _quizScore = 0;
  bool _qrScanned = false;
  bool _transactionConfirmed = false;
  final Random _random = Random();
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer();
  final List<ForensicEvent> _forensicTimeline = [];
  int _highlightedEventIndex = -1;

  final Map<String, dynamic> _deviceState = {
    'isScreenOn': true,
    'currentApp': 'Home',
    'locationServicesOn': true,
    'wifiConnected': true,
    'batteryLevel': 78,
    'notifications': <String>[],
    'recentApps': ['WhatsApp', 'Instagram', 'Chrome'],
    'locationLat': 28.7041,
    'locationLng': 77.1025,
    'trustScore': 95,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _phoneController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _alertController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _scanController = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    _scanAnimation = Tween<double>(begin: 0, end: 200).animate(CurvedAnimation(parent: _scanController, curve: Curves.easeInOut));
    _balanceController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _balanceAnimation = Tween<double>(begin: _victimBalance, end: _victimBalance).animate(CurvedAnimation(parent: _balanceController, curve: Curves.easeOut));
    _pulseController = AnimationController(duration: const Duration(seconds: 1), vsync: this)..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _trustScoreController = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _trustScoreColorAnimation = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(CurvedAnimation(parent: _trustScoreController, curve: Curves.easeInOut));

    _initializeAudio();
  }

  void _initializeAudio() {
    try {
      _audioPlayer.open(
        Audio('assets/alert.mp3'),
        autoStart: false,
        showNotification: false,
      );
      _audioPlayer.open(
        Audio('assets/beep.mp3'),
        autoStart: false,
        showNotification: false,
      );
      _audioPlayer.open(
        Audio('assets/error.mp3'),
        autoStart: false,
        showNotification: false,
      );
    } catch (e) {
      debugPrint('Failed to load audio: $e');
    }
  }

  void _playSound(String type) {
    try {
      _audioPlayer.open(
        Audio('assets/$type.mp3'),
        autoStart: true,
        showNotification: false,
      );
    } catch (e) {
      debugPrint('Failed to play sound: $e');
    }
  }

  void _startAdvancedSimulation() async {
    if (_simulationActive) return;
    setState(() {
      _simulationActive = true;
      _currentPhase = 0;
      _stolenAmount = 0.0;
      _victimBalance = 45000.0;
      _attackAnalysis = null;
      _quizScore = 0;
      _qrScanned = false;
      _transactionConfirmed = false;
      _forensicTimeline.clear();
      _deviceState['notifications'].clear();
      _deviceState['trustScore'] = 95;
      _deviceState['currentApp'] = 'Home';
      _deviceState['locationLat'] = 28.7041;
      _deviceState['locationLng'] = 77.1025;
      _highlightedEventIndex = -1;
    });

    try {
      await _simulatePhase1();
      await _simulatePhase2();
      await _simulatePhase3();
      await _simulatePhase4();
    } catch (e) {
      debugPrint('Simulation error: $e');
      setState(() {
        _deviceState['notifications'].add('ERROR: Simulation failed');
        _playSound('error');
      });
    }

    setState(() {
      _simulationActive = false;
      _tabController.animateTo(2);
    });
  }

  Future<void> _simulatePhase1() async {
    setState(() => _currentPhase = 1);
    _addForensicEvent("RECON_START", "Attack preparation initiated", details: "Attacker scans Delhi Metro Station Rajiv Chowk for targets", phase: 1);
    await Future.delayed(const Duration(seconds: 2));
    _addForensicEvent("TARGET_IDENTIFIED", "Victim device detected", details: "Samsung Galaxy S21, Android 13, HDFC Banking App v4.2.1 installed", phase: 1);
    await Future.delayed(const Duration(seconds: 1));
    _addForensicEvent("SOCIAL_ENGINEERING", "Fake QR codes deployed", details: "Printed stickers: 'HDFC Bank - Scan for ₹500 Cashback!'", phase: 1);
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _simulatePhase2() async {
    setState(() {
      _currentPhase = 2;
      _deviceState['currentApp'] = 'Camera';
    });
    _phoneController.forward();
    _playSound('beep');
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _qrScanned = true;
      _deviceState['notifications'].add('Camera accessed QR code');
    });
    _addForensicEvent("QR_SCAN", "Malicious QR code scanned", details: "QR payload: hdfc://transfer?amt=25000&to=ACC789456123&ref=CASHBACK", phase: 2);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _deviceState['currentApp'] = 'HDFC Bank';
      _deviceState['trustScore'] = 85;
      _trustScoreController.forward();
    });
    _addForensicEvent("DEEPLINK_TRIGGER", "Banking app auto-launched", details: "Deep link bypassed user confirmation, app opened with pre-filled transfer form", phase: 2);
    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> _simulatePhase3() async {
    setState(() => _currentPhase = 3);
    _addForensicEvent("GPS_SPOOF_START", "Location manipulation initiated", details: "Fake GPS coordinates: 28.6129, 77.2295 (HDFC Corporate Office)", phase: 3);
    setState(() {
      _deviceState['locationLat'] = 28.6129;
      _deviceState['locationLng'] = 77.2295;
      _deviceState['trustScore'] = 60;
      _trustScoreController.forward();
    });
    await Future.delayed(const Duration(seconds: 2));
    _addForensicEvent("GEOFENCE_BYPASS", "Trusted location spoofed", details: "Device appears to be at HDFC HQ, security protocols relaxed", phase: 3);
    await Future.delayed(const Duration(seconds: 1));
    _stolenAmount = (_random.nextInt(41) + 10) * 1000.0;
    _addForensicEvent("FORM_PREFILL", "Transfer form auto-populated", details: "Amount: ₹${_stolenAmount.toStringAsFixed(0)}, Recipient: 789456123@paytm, Reference: CASHBACK", phase: 3);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _transactionConfirmed = true;
      _deviceState['trustScore'] = 25;
      _trustScoreController.forward();
    });
    _addForensicEvent("SESSION_HIJACK", "Authentication bypassed", details: "Cached biometric token exploited, 2FA skipped due to 'trusted location'", phase: 3);
    await Future.delayed(const Duration(seconds: 2));
    _alertController.forward();
    _playSound('error');
    _addForensicEvent("TRANSACTION_EXECUTED", "Fraudulent transfer completed", details: "₹${_stolenAmount.toStringAsFixed(0)} transferred to attacker's mule account", severity: "CRITICAL", phase: 3);
    setState(() {
      _balanceAnimation = Tween<double>(begin: _victimBalance, end: _victimBalance - _stolenAmount).animate(CurvedAnimation(parent: _balanceController, curve: Curves.easeOut));
    });
    _balanceController.forward();
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _victimBalance -= _stolenAmount;
      _deviceState['notifications'].add('Transaction Successful: ₹${_stolenAmount.toStringAsFixed(0)} sent');
      _deviceState['trustScore'] = 15;
      _trustScoreController.forward();
    });
    _addForensicEvent("EVIDENCE_CLEANUP", "Attack traces obscured", details: "Transaction categorized as 'cashback promotion', logs modified", phase: 3);
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _simulatePhase4() async {
    setState(() => _currentPhase = 4);
    _addForensicEvent("FRAUD_DISCOVERY", "Victim discovers unauthorized transaction", details: "SMS alert received 45 minutes post-transaction", phase: 4);
    setState(() {
      _deviceState['notifications'].add('ALERT: Unusual activity detected');
    });
    await Future.delayed(const Duration(seconds: 2));
    _generateAttackAnalysis();
    _addForensicEvent("FORENSIC_ANALYSIS", "Post-incident investigation initiated", details: "Digital forensics team analyzes attack vector and evidence", phase: 4);
    await Future.delayed(const Duration(seconds: 3));
  }

  void _generateAttackAnalysis() {
    setState(() {
      _attackAnalysis = AttackAnalysis(
        attackVector: 'QR Code Phishing + GPS Spoofing',
        exploitedVulnerabilities: [
          'Unvalidated deep link parameters (Event #${_forensicTimeline.indexWhere((e) => e.type == "DEEPLINK_TRIGGER") + 1})',
          'Geo-fence reliance without multi-factor verification (Event #${_forensicTimeline.indexWhere((e) => e.type == "GEOFENCE_BYPASS") + 1})',
          'Cached authentication token exploitation (Event #${_forensicTimeline.indexWhere((e) => e.type == "SESSION_HIJACK") + 1})',
          'Insufficient user confirmation for high-value transactions (Event #${_forensicTimeline.indexWhere((e) => e.type == "FORM_PREFILL") + 1})',
        ],
        impactAssessment: {
          'financialLoss': _stolenAmount,
          'dataCompromised': ['Banking credentials', 'Location data', 'Transaction history'],
          'reputationalDamage': 'High',
          'regulatoryImplications': 'PCI DSS violation, RBI guidelines breach',
        },
        attackSophistication: 'Advanced',
        detectionTime: '45 minutes',
        recoveryProbability: '35%',
        similarIncidentsIncrease: '340% in last 6 months',
        relatedEventIndices: _forensicTimeline.asMap().entries.where((e) => ['QR_SCAN', 'DEEPLINK_TRIGGER', 'GPS_SPOOF_START', 'GEOFENCE_BYPASS', 'FORM_PREFILL', 'SESSION_HIJACK', 'TRANSACTION_EXECUTED'].contains(e.value.type)).map((e) => e.key).toList(),
      );
    });
  }

  void _addForensicEvent(String type, String title, {String? details, String severity = "INFO", required int phase}) {
    setState(() {
      _forensicTimeline.add(ForensicEvent(
        timestamp: DateTime.now(),
        type: type,
        title: title,
        details: details ?? "",
        severity: severity,
        phase: phase,
      ));
      _highlightedEventIndex = _forensicTimeline.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Heist Forensics Platform'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.cyan[300],
          unselectedLabelColor: Colors.grey[300],
          tabs: const [
            Tab(icon: Icon(Icons.phone_android), text: 'Victim Device'),
            Tab(icon: Icon(Icons.timeline), text: 'Attack Timeline'),
            Tab(icon: Icon(Icons.analytics), text: 'Forensic Analysis'),
            Tab(icon: Icon(Icons.security), text: 'Prevention'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0A0A), Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: Column(
          children: [
            _buildControlHeader(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildVictimDeviceView(),
                  _buildTimelineView(),
                  _buildForensicAnalysisView(),
                  _buildPreventionView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red[900]!.withValues(alpha: 0.3 * 255),
            Colors.orange[800]!.withValues(alpha: 0.3 * 255),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[300]!.withValues(alpha: 0.3 * 255)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.security, color: Colors.red[300], size: 28),
              const SizedBox(width: 12),
              const Text('Advanced Mobile Security Simulation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const Spacer(),
              if (_simulationActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2 * 255),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[300]!),
                  ),
                  child: Text('PHASE $_currentPhase ACTIVE', style: TextStyle(color: Colors.red[300])),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _simulationActive ? null : _startAdvancedSimulation,
                  icon: const Icon(Icons.play_circle_filled),
                  label: const Text('Start Simulation'),
                ),
              ),
              const SizedBox(width: 12),
              AnimatedBuilder(
                animation: _balanceAnimation,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green[800]!.withValues(alpha: 0.3 * 255),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[300]!),
                    ),
                    child: Text(
                      'Balance: ₹${_balanceAnimation.value.toStringAsFixed(0)}',
                      style: TextStyle(color: Colors.green[300], fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVictimDeviceView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 300,
            height: 600,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey[800]!, width: 8),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withValues(alpha: 0.3 * 255),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Column(
                children: [
                  Container(
                    height: 30,
                    color: Colors.black,
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        Text(
                          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const Spacer(),
                        const Icon(Icons.signal_cellular_4_bar, color: Colors.white70, size: 12),
                        const Icon(Icons.wifi, color: Colors.white70, size: 12),
                        Text('${_deviceState['batteryLevel']}%', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        const Icon(Icons.battery_full, color: Colors.white70, size: 12),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: const Color(0xFF1E1E1E),
                      child: _buildPhoneScreen(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildDeviceStatusCards(),
        ],
      ),
    );
  }

  Widget _buildPhoneScreen() {
    switch (_deviceState['currentApp']) {
      case 'Camera':
        return _buildCameraScreen();
      case 'HDFC Bank':
        return _buildBankingScreen();
      default:
        return _buildHomeScreen();
    }
  }

  Widget _buildHomeScreen() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text('Home Screen', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            children: [
              _buildAppIcon('HDFC Bank', Icons.account_balance, Colors.blue),
              _buildAppIcon('Camera', Icons.camera_alt, Colors.grey, onTap: () {
                if (_currentPhase == 2 && !_qrScanned) {
                  setState(() => _deviceState['currentApp'] = 'Camera');
                }
              }),
              _buildAppIcon('WhatsApp', Icons.chat, Colors.green),
              _buildAppIcon('Chrome', Icons.web, Colors.orange),
              _buildAppIcon('Settings', Icons.settings, Colors.grey),
              _buildAppIcon('Maps', Icons.map, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraScreen() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyan[300]!, width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        GridView.count(
                          crossAxisCount: 10,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(100, (index) {
                            return Container(
                              color: _random.nextBool() ? Colors.black : Colors.white,
                            );
                          }),
                        ),
                        AnimatedBuilder(
                          animation: _scanAnimation,
                          builder: (context, child) {
                            return Positioned(
                              top: _scanAnimation.value,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 2,
                                color: Colors.cyan[300]!.withValues(alpha: 0.5 * 255),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: _qrScanned
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[900]!.withValues(alpha: 0.8 * 255),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('⚠ QR Code Scanned!', style: TextStyle(color: Colors.white)),
                    )
                  : ElevatedButton(
                      onPressed: _currentPhase == 2 && !_qrScanned
                          ? () {
                              setState(() {
                                _qrScanned = true;
                                _deviceState['notifications'].add('Camera accessed QR code');
                                _playSound('beep');
                              });
                            }
                          : null,
                      child: const Text('Scan QR Code'),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankingScreen() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 60,
            color: Colors.blue[800],
            child: Center(
              child: Text(
                'HDFC Bank - $_victimName',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[900]!.withValues(alpha: 0.3 * 255),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[300]!),
            ),
            child: Column(
              children: [
                const Text('Transfer Money', style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 16),
                _buildTextField('To Account', '789456123@paytm'),
                _buildTextField('Amount', '₹${_stolenAmount.toStringAsFixed(0)}'),
                _buildTextField('Reference', 'CASHBACK'),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _currentPhase == 3 && !_transactionConfirmed
                        ? () {
                            setState(() {
                              _transactionConfirmed = true;
                              _deviceState['trustScore'] = 25;
                              _trustScoreController.forward();
                              _playSound('error');
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _transactionConfirmed ? Colors.grey : Colors.red[600],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(_transactionConfirmed ? 'Transfer Completed' : 'Confirm ₹${_stolenAmount.toStringAsFixed(0)}'),
                  ),
                ),
              ],
            ),
          ),
          if (_stolenAmount > 0 && _transactionConfirmed) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[800]!.withValues(alpha: 0.3 * 255),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[300]!),
              ),
              child: Text(
                '⚠ Unauthorized Transaction: ₹${_stolenAmount.toStringAsFixed(0)} Deducted',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red[300], fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[300], fontSize: 12)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[600]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildAppIcon(String name, IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildDeviceStatusCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _trustScoreController,
                builder: (context, child) {
                  return _buildStatusCard(
                    'Trust Score',
                    '${_deviceState['trustScore']}%',
                    _trustScoreColorAnimation.value ?? Colors.green,
                    Icons.security,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatusCard(
                'Location',
                '${_deviceState['locationLat'].toStringAsFixed(4)}, ${_deviceState['locationLng'].toStringAsFixed(4)}',
                Colors.blue,
                Icons.location_on,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900]!.withValues(alpha: 0.5 * 255),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[700]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Recent Notifications', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              ...(_deviceState['notifications'] as List<String>).take(3).map((notification) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('• $notification', style: TextStyle(color: Colors.grey[300], fontSize: 12)),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1 * 255),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3 * 255)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.grey[300], fontSize: 12)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTimelineView() {
    final phaseNames = {
      1: 'Reconnaissance',
      2: 'Initial Access',
      3: 'Execution & Exfiltration',
      4: 'Discovery & Analysis',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Attack Timeline & Digital Forensics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _forensicTimeline.length + phaseNames.length,
              itemBuilder: (context, index) {
                int eventIndex = index;
                int offset = 0;

                if (index == 0) {
                  return _buildPhaseHeader(phaseNames[1]!, 1);
                }
                if (index > 0 && index < _forensicTimeline.length) {
                  for (int i = 2; i <= 4; i++) {
                    int phaseStart = _forensicTimeline.indexWhere((e) => e.phase == i);
                    if (phaseStart != -1 && eventIndex >= phaseStart + offset) {
                      if (eventIndex == phaseStart + offset) {
                        return _buildPhaseHeader(phaseNames[i]!, i);
                      }
                      eventIndex--;
                      offset++;
                    }
                  }
                }
                final event = _forensicTimeline[eventIndex - offset];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _highlightedEventIndex = eventIndex - offset;
                      if (['QR_SCAN', 'DEEPLINK_TRIGGER', 'FORM_PREFILL', 'TRANSACTION_EXECUTED'].contains(event.type)) {
                        _tabController.animateTo(0);
                        _deviceState['currentApp'] = event.type == 'QR_SCAN' ? 'Camera' : 'HDFC Bank';
                      } else if (['FORENSIC_ANALYSIS'].contains(event.type)) {
                        _tabController.animateTo(2);
                      }
                    });
                  },
                  child: _buildTimelineItem(event, eventIndex - offset),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseHeader(String title, int phase) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.cyan[900]!.withValues(alpha: 0.3 * 255),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.cyan[300]!),
      ),
      child: Text('Phase $phase: $title', style: TextStyle(color: Colors.cyan[300], fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTimelineItem(ForensicEvent event, int index) {
    Color severityColor;
    switch (event.severity) {
      case 'CRITICAL':
        severityColor = Colors.red[300]!;
        break;
      case 'HIGH':
        severityColor = Colors.orange[300]!;
        break;
      case 'MEDIUM':
        severityColor = Colors.yellow[300]!;
        break;
      default:
        severityColor = Colors.cyan[300]!;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: severityColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: severityColor.withValues(alpha: 0.5 * 255),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              if (index < _forensicTimeline.length - 1)
                Container(
                  width: 2,
                  height: 60,
                  color: Colors.grey[700],
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _highlightedEventIndex == index ? Colors.cyan[900]!.withValues(alpha: 0.7 * 255) : Colors.grey[900]!.withValues(alpha: 0.5 * 255),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: severityColor.withValues(alpha: 0.3 * 255)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: severityColor.withValues(alpha: 0.2 * 255),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(event.severity, style: TextStyle(color: severityColor, fontSize: 10)),
                      ),
                      const Spacer(),
                      Text(
                        '${event.timestamp.hour}:${event.timestamp.minute.toString().padLeft(2, '0')}:${event.timestamp.second.toString().padLeft(2, '0')}',
                        style: TextStyle(color: Colors.grey[300], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  if (event.details.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(event.details, style: TextStyle(color: Colors.grey[300], fontSize: 12)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForensicAnalysisView() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Forensic Analysis Report', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            if (_attackAnalysis == null)
              const Text('No analysis available. Run the simulation to generate a report.', style: TextStyle(color: Colors.grey, fontSize: 16))
            else ...[
              _buildAnalysisSection('Attack Vector', _attackAnalysis!.attackVector),
              _buildAnalysisSection('Exploited Vulnerabilities', _attackAnalysis!.exploitedVulnerabilities.join('\n'), prefix: ''),
              _buildAnalysisSection(
                'Impact Assessment',
                'Financial Loss: ₹${_attackAnalysis!.impactAssessment['financialLoss'].toStringAsFixed(0)}\n'
                    'Data Compromised: ${_attackAnalysis!.impactAssessment['dataCompromised'].join(', ')}\n'
                    'Reputational Damage: ${_attackAnalysis!.impactAssessment['reputationalDamage']}\n'
                    'Regulatory Implications: ${_attackAnalysis!.impactAssessment['regulatoryImplications']}',
              ),
              _buildAnalysisSection('Attack Sophistication', _attackAnalysis!.attackSophistication),
              _buildAnalysisSection('Detection Time', _attackAnalysis!.detectionTime),
              _buildAnalysisSection('Recovery Probability', _attackAnalysis!.recoveryProbability),
              _buildAnalysisSection('Similar Incidents Trend', _attackAnalysis!.similarIncidentsIncrease),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Quiz Score', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.cyan)),
                  Text('Score: $_quizScore/30', style: TextStyle(color: Colors.green[300], fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  _showQuizDialog();
                },
                child: const Text('Take Security Quiz'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _tabController.animateTo(3);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600]),
                child: const Text('View Preventive Measures'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showQuizDialog() {
    int tempScore = _quizScore;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Security Quiz'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('1. Which vulnerability allowed the banking app to open automatically?', style: TextStyle(color: Colors.black87)),
              ElevatedButton(
                onPressed: () {
                  setState(() => tempScore += 10);
                  _playSound('beep');
                  Navigator.pop(context);
                  _showQuizQuestion2(tempScore);
                },
                child: const Text('Unvalidated deep links'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showQuizQuestion2(tempScore);
                },
                child: const Text('Slow server response'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showQuizQuestion2(int tempScore) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Security Quiz'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('2. What enabled the attacker to bypass 2FA?', style: TextStyle(color: Colors.black87)),
            ElevatedButton(
              onPressed: () {
                setState(() => tempScore += 10);
                _playSound('beep');
                Navigator.pop(context);
                _showQuizQuestion3(tempScore);
              },
              child: const Text('Geo-fence spoofing'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showQuizQuestion3(tempScore);
              },
              child: const Text('Weak password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showQuizQuestion3(int tempScore) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Security Quiz'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('3. What can prevent QR code phishing attacks?', style: TextStyle(color: Colors.black87)),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _quizScore = tempScore + 10;
                });
                _playSound('beep');
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Quiz Completed!'),
                    content: Text('Final Score: $_quizScore/30\nGreat job! Check the Prevention tab for mitigation strategies.', style: const TextStyle(color: Colors.black87)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK', style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('QR code source verification'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _quizScore = tempScore);
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Quiz Completed!'),
                    content: Text('Final Score: $_quizScore/30\nReview the Prevention tab for mitigation strategies.', style: const TextStyle(color: Colors.black87)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK', style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Faster internet speed'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection(String title, String content, {String prefix = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.cyan[300])),
        const SizedBox(height: 8),
        Text('$prefix$content', style: TextStyle(color: Colors.grey[300], fontSize: 14)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPreventionView() {
    final preventiveMeasures = [
      const PreventiveMeasure(
        title: "Deep Link Validation",
        description: "Validate app deep links to prevent unauthorized actions.",
        implementation: "Add intent filters with strict pattern matching.",
        priority: "CRITICAL",
        cost: "Low",
        effectiveness: 95,
        action: "Enable deep link validation in banking app settings (per RBI guidelines).",
        relatedVulnerability: 'Unvalidated deep link parameters',
      ),
      const PreventiveMeasure(
        title: "Multi-Factor Location Verification",
        description: "Verify location using multiple data sources to detect spoofing.",
        implementation: "Use ML models to Juno detect location spoofing patterns.",
        priority: "HIGH",
        cost: "Medium",
        effectiveness: 88,
        action: "Activate location-based security in UPI apps like PhonePe.",
        relatedVulnerability: 'Geo-fence reliance without multi-factor verification',
      ),
      const PreventiveMeasure(
        title: "Behavioral Biometrics",
        description: "Monitor user behavior to detect anomalies.",
        implementation: "Track touch pressure, swipe speed, and app usage.",
        priority: "HIGH",
        cost: "High",
        effectiveness: 92,
        action: "Enable biometric authentication in device settings.",
        relatedVulnerability: 'Cached authentication token exploitation',
      ),
      const PreventiveMeasure(
        title: "Real-time Transaction Monitoring",
        description: "Use AI to detect and alert on suspicious transactions.",
        implementation: "Deploy ML models for transaction risk scoring.",
        priority: "CRITICAL",
        cost: "High",
        effectiveness: 97,
        action: "Set up instant transaction alerts via SMS/email (RBI mandate).",
        relatedVulnerability: 'Insufficient user confirmation for high-value transactions',
      ),
      const PreventiveMeasure(
        title: "QR Code Source Verification",
        description: "Verify QR code authenticity before scanning.",
        implementation: "Use digital signatures and trusted source validation.",
        priority: "MEDIUM",
        cost: "Low",
        effectiveness: 78,
        action: "Only scan QR codes from verified merchants or banks.",
        relatedVulnerability: 'Unvalidated deep link parameters',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Preventive Measures', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: preventiveMeasures.length,
              itemBuilder: (context, index) {
                final measure = preventiveMeasures[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900]!.withValues(alpha: 0.5 * 255),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.cyan[300]!.withValues(alpha: 0.3 * 255)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(measure.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(measure.description, style: TextStyle(color: Colors.grey[300], fontSize: 12)),
                      Text('Priority: ${measure.priority}', style: TextStyle(color: Colors.grey[300], fontSize: 12)),
                      Text('Effectiveness: ${measure.effectiveness}%', style: TextStyle(color: Colors.grey[300], fontSize: 12)),
                      Text('Addresses: ${measure.relatedVulnerability}', style: TextStyle(color: Colors.grey[300], fontSize: 12)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(measure.title),
                              content: Text('Action: ${measure.action}\nImplementation: ${measure.implementation}', style: const TextStyle(color: Colors.black87)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close', style: TextStyle(color: Colors.blue)),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Learn More'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneController.dispose();
    _alertController.dispose();
    _scanController.dispose();
    _balanceController.dispose();
    _pulseController.dispose();
    _trustScoreController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
