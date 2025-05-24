import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(PhishingSimulatorApp());
}

class PhishingSimulatorApp extends StatelessWidget {
  const PhishingSimulatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corporate Email System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      home: EmailInboxScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EmailInboxScreen extends StatefulWidget {
  const EmailInboxScreen({Key? key}) : super(key: key);

  @override
  EmailInboxScreenState createState() => EmailInboxScreenState();
}

class EmailInboxScreenState extends State<EmailInboxScreen>
    with TickerProviderStateMixin {
  bool simulationStarted = false;
  bool deviceCompromised = false;
  bool showingMaliciousContent = false;
  List<Email> clickedEmails = [];
  List<String> attackSteps = [];
  List<String> stolenData = [];
  
  late AnimationController _glitchController;
  late AnimationController _pulseController;
  late AnimationController _screenFlickerController;
  late AnimationController _textScrambleController;
  late AnimationController _errorPulseController;
  
  Timer? attackTimer;
  Timer? dataTheftTimer;
  Timer? screenCorruptionTimer;
  int attackProgress = 0;
  int dataTheftProgress = 0;
  
  Color backgroundColor = Colors.grey[50]!;
  bool screenCorrupted = false;
  String scrambledText = "";
  
  final Random _random = Random();

  final List<Email> emails = [
    // Ultra-realistic legitimate emails to throw people off
    Email(
      id: '1',
      sender: 'IT-Security@company.com',
      subject: 'Monthly Security Training Reminder',
      preview: 'Complete your mandatory cybersecurity training by Friday to maintain system access...',
      time: '2 hours ago',
      isPhishing: false,
      senderAvatar: '🛡️',
      priority: 'normal',
      isRead: false,
    ),
    Email(
      id: '2',
      sender: 'payroll@company.com',
      subject: 'Direct Deposit Confirmation - Pay Period 24',
      preview: 'Your salary of \$4,247.83 has been deposited to account ending in 7823...',
      time: '5 hours ago',
      isPhishing: false,
      senderAvatar: '💰',
      priority: 'normal',
      isRead: true,
    ),
    Email(
      id: '3',
      sender: 'facilities@company.com',
      subject: 'Building Maintenance - Elevator Inspection Tuesday',
      preview: 'Please use the stairs on Tuesday, March 12th from 9 AM to 2 PM during elevator maintenance...',
      time: '1 day ago',
      isPhishing: false,
      senderAvatar: '🏢',
      priority: 'normal',
      isRead: false,
    ),
    
    // THE TRAP - Extremely convincing phishing email that looks 100% legitimate
    Email(
      id: '4',
      sender: 'microsoft-security@company.com',
      subject: '🔐 URGENT: Suspicious Login Attempt Detected',
      preview: 'We detected an unauthorized login attempt from Russia. Please verify your identity immediately to secure your account...',
      time: '47 minutes ago',
      isPhishing: true,
      senderAvatar: '🚨',
      priority: 'urgent',
      isRead: false,
      phishingType: 'Advanced Persistent Threat (APT)',
      maliciousUrl: 'https://microsoft-verify-secure.auth-company.net/verify',
      phishingReasons: [
        'Domain spoofing: Uses company domain with Microsoft branding to appear internal',
        'Social engineering: Creates panic with "unauthorized login from Russia"',
        'Urgency manipulation: Uses "URGENT" and immediate action language',
        'Authority impersonation: Poses as Microsoft security team',
        'Credential harvesting: Designed to steal login credentials',
        'Sophisticated attack: Uses legitimate-looking subdomain structure'
      ],
    ),
    
    Email(
      id: '5',
      sender: 'benefits@company.com',
      subject: 'Open Enrollment Deadline Extended',
      preview: 'Good news! The health insurance open enrollment deadline has been extended to March 30th...',
      time: '2 days ago',
      isPhishing: false,
      senderAvatar: '📋',
      priority: 'normal',
      isRead: true,
    ),
    Email(
      id: '6',
      sender: 'ceo@company.com',
      subject: 'Q1 All-Hands Meeting - March 15th',
      preview: 'Join us for our quarterly all-hands meeting to discuss company performance and upcoming initiatives...',
      time: '3 days ago',
      isPhishing: false,
      senderAvatar: '👔',
      priority: 'high',
      isRead: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _glitchController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _screenFlickerController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _textScrambleController = AnimationController(
      duration: Duration(milliseconds: 50),
      vsync: this,
    );
    _errorPulseController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    startSimulation(); // Auto-start for immersion
  }

  @override
  void dispose() {
    _glitchController.dispose();
    _pulseController.dispose();
    _screenFlickerController.dispose();
    _textScrambleController.dispose();
    _errorPulseController.dispose();
    attackTimer?.cancel();
    dataTheftTimer?.cancel();
    screenCorruptionTimer?.cancel();
    super.dispose();
  }

  void startSimulation() {
    setState(() {
      simulationStarted = true;
      deviceCompromised = false;
      showingMaliciousContent = false;
      clickedEmails.clear();
      attackSteps.clear();
      stolenData.clear();
      attackProgress = 0;
      dataTheftProgress = 0;
      backgroundColor = Colors.grey[50]!;
      screenCorrupted = false;
    });
  }

  void onEmailClicked(Email email) {
    if (!simulationStarted) return;

    setState(() {
      clickedEmails.add(email);
      email.isRead = true;
    });

    if (email.isPhishing) {
      // Haptic feedback for visceral effect
      HapticFeedback.heavyImpact();
      
      // Brief delay to make it feel like loading
      Future.delayed(Duration(milliseconds: 300), () {
        simulateAdvancedAttack(email);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Legitimate email opened safely'),
          backgroundColor: Colors.green[600],
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void simulateAdvancedAttack(Email phishingEmail) {
    setState(() {
      deviceCompromised = true;
      showingMaliciousContent = true;
      attackSteps = [
        'Initializing malicious payload...',
        'Bypassing Windows Defender...',
        'Establishing backdoor connection...',
        'Injecting keylogger into system...',
        'Accessing browser saved passwords...',
        'Downloading financial data...',
        'Uploading files to command server...',
        'Installing persistent rootkit...',
        'Activating webcam and microphone...',
        'Stealing cryptocurrency wallets...',
        'Compromising email accounts...',
        'SYSTEM FULLY COMPROMISED',
      ];
      
      stolenData = [
        'Capturing login credentials...',
        'Bank account: ****7823 - \$47,293.82',
        'Credit card: ****4567 - Limit \$15,000',
        'SSN: ***-**-4829',
        'Driver License: D23948572',
        'Email passwords (12 accounts)',
        'Cryptocurrency wallet: 2.47 BTC',
        'Personal photos (847 files)',
        'Tax documents (2019-2024)',
        'Medical records accessed',
        'Work documents and emails',
        'Family contact information',
      ];
    });

    // Start screen corruption effects
    _startScreenCorruption();
    
    // Rapid attack progression
    attackTimer = Timer.periodic(Duration(milliseconds: 600), (timer) {
      if (attackProgress < attackSteps.length) {
        setState(() {
          attackProgress++;
        });
        
        // Haptic feedback for each step
        HapticFeedback.selectionClick();
        
        // Start data theft after attack begins
        if (attackProgress == 3) {
          _startDataTheft();
        }
        
        // Intensify effects as attack progresses
        if (attackProgress > 6) {
          _glitchController.forward().then((_) => _glitchController.reverse());
        }
        
      } else {
        timer.cancel();
        // Show the devastating results after a brief pause
        Future.delayed(Duration(seconds: 2), () {
          _showCatastrophicResults(phishingEmail);
        });
      }
    });
  }

  void _startScreenCorruption() {
    screenCorruptionTimer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (mounted && deviceCompromised) {
        setState(() {
          // Random background color corruption
          final colors = [Colors.red[900], Colors.grey[900], Colors.black, Colors.red[800]];
          backgroundColor = colors[_random.nextInt(colors.length)]!;
          screenCorrupted = !screenCorrupted;
        });
        
        _screenFlickerController.forward().then((_) => _screenFlickerController.reverse());
        
        // Occasionally trigger more severe glitch
        if (_random.nextInt(5) == 0) {
          HapticFeedback.heavyImpact();
        }
      }
    });
  }

  void _startDataTheft() {
    dataTheftTimer = Timer.periodic(Duration(milliseconds: 800), (timer) {
      if (dataTheftProgress < stolenData.length) {
        setState(() {
          dataTheftProgress++;
        });
        HapticFeedback.lightImpact();
      } else {
        timer.cancel();
      }
    });
  }

  void _showCatastrophicResults(Email phishingEmail) {
    // Stop all timers and animations
    attackTimer?.cancel();
    dataTheftTimer?.cancel();
    screenCorruptionTimer?.cancel();
    
    setState(() {
      backgroundColor = Colors.grey[50]!;
      screenCorrupted = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.grey[900],
        title: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.warning, color: Colors.white, size: 32),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SYSTEM COMPROMISED',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Advanced Persistent Threat Detected',
                      style: TextStyle(color: Colors.red[200], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        content: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(maxHeight: 600),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Devastating impact summary
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[900]?.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[400]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CRITICAL BREACH SUMMARY', 
                           style: TextStyle(color: Colors.red[300], fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 8),
                      Text('• Complete system access granted to attackers', 
                           style: TextStyle(color: Colors.white)),
                      Text('• Financial accounts compromised: 3 banks, 2 credit cards', 
                           style: TextStyle(color: Colors.white)),
                      Text('• Personal identity stolen: SSN, driver license, medical records', 
                           style: TextStyle(color: Colors.white)),
                      Text('• Estimated financial damage: \$67,000+', 
                           style: TextStyle(color: Colors.red[200], fontWeight: FontWeight.bold)),
                      Text('• Recovery time: 6-18 months', 
                           style: TextStyle(color: Colors.red[200], fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Phishing analysis
                Text('ATTACK VECTOR ANALYSIS', 
                     style: TextStyle(color: Colors.orange[300], fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[900]?.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[600]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Target Email: ${phishingEmail.subject}', 
                           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('Sender: ${phishingEmail.sender}', 
                           style: TextStyle(color: Colors.orange[200])),
                      Text('Malicious URL: ${phishingEmail.maliciousUrl}', 
                           style: TextStyle(color: Colors.red[300], fontSize: 12)),
                      SizedBox(height: 8),
                      Text('Attack Type: ${phishingEmail.phishingType}', 
                           style: TextStyle(color: Colors.orange[200], fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Red flags (what they missed)
                Text('RED FLAGS YOU MISSED', 
                     style: TextStyle(color: Colors.red[300], fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                ...phishingEmail.phishingReasons.map((reason) => Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.close, color: Colors.red[400], size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(reason, style: TextStyle(color: Colors.white, fontSize: 13)),
                      ),
                    ],
                  ),
                )),
                
                SizedBox(height: 20),
                
                // Prevention measures
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[900]?.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[400]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CRITICAL PREVENTION MEASURES', 
                           style: TextStyle(color: Colors.blue[300], fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('• ALWAYS verify sender email addresses character by character', 
                           style: TextStyle(color: Colors.white, fontSize: 13)),
                      Text('• Hover over links to see actual URLs before clicking', 
                           style: TextStyle(color: Colors.white, fontSize: 13)),
                      Text('• Be suspicious of urgent security alerts', 
                           style: TextStyle(color: Colors.white, fontSize: 13)),
                      Text('• Use multi-factor authentication on ALL accounts', 
                           style: TextStyle(color: Colors.white, fontSize: 13)),
                      Text('• Contact IT directly to verify suspicious internal emails', 
                           style: TextStyle(color: Colors.white, fontSize: 13)),
                      Text('• Keep systems updated and use endpoint protection', 
                           style: TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetSimulation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('RESTART SIMULATION - TRY AGAIN', 
                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void resetSimulation() {
    setState(() {
      simulationStarted = false;
      deviceCompromised = false;
      showingMaliciousContent = false;
      clickedEmails.clear();
      attackSteps.clear();
      stolenData.clear();
      attackProgress = 0;
      dataTheftProgress = 0;
      backgroundColor = Colors.grey[50]!;
      screenCorrupted = false;
    });
    
    // Reset email read status
    for (var email in emails) {
      email.isRead = false;
    }
    
    _glitchController.reset();
    attackTimer?.cancel();
    dataTheftTimer?.cancel();
    screenCorruptionTimer?.cancel();
    
    // Restart simulation
    Future.delayed(Duration(milliseconds: 500), () {
      startSimulation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      color: screenCorrupted ? backgroundColor : Colors.grey[50],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Corporate Email - Outlook', 
                     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          centerTitle: false,
          leading: Padding(
            padding: EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(Icons.email, color: Colors.white, size: 20),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search, color: Colors.grey[600]),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert, color: Colors.grey[600]),
            ),
          ],
        ),
        body: Stack(
          children: [
            // Main email list
            Column(
              children: [
                // Folder tabs
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    children: [
                      _buildTab('Inbox', true),
                      _buildTab('Sent', false),
                      _buildTab('Drafts', false),
                      _buildTab('Spam', false),
                    ],
                  ),
                ),
                
                // Email count and controls
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    children: [
                      Text('${emails.length} messages', 
                           style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                      Spacer(),
                      Icon(Icons.refresh, color: Colors.grey[600], size: 20),
                      SizedBox(width: 16),
                      Icon(Icons.select_all, color: Colors.grey[600], size: 20),
                    ],
                  ),
                ),
                
                // Email list
                Expanded(
                  child: ListView.builder(
                    itemCount: emails.length,
                    itemBuilder: (context, index) {
                      final email = emails[index];
                      final isClicked = clickedEmails.contains(email);
                      
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        child: Material(
                          color: email.isRead ? Colors.grey[50] : Colors.white,
                          child: InkWell(
                            onTap: () => onEmailClicked(email),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                                color: isClicked && email.isPhishing 
                                    ? Colors.red[50] 
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  // Read/unread indicator
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: email.isRead ? Colors.transparent : Colors.blue[600],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  
                                  // Avatar
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: email.priority == 'urgent' 
                                          ? Colors.red[100] 
                                          : Colors.blue[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(email.senderAvatar, style: TextStyle(fontSize: 16)),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  
                                  // Email content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                email.sender,
                                                style: TextStyle(
                                                  fontWeight: email.isRead ? FontWeight.normal : FontWeight.w600,
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              email.time,
                                              style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          email.subject,
                                          style: TextStyle(
                                            fontWeight: email.isRead ? FontWeight.normal : FontWeight.w600,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          email.preview,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Priority and status indicators
                                  Column(
                                    children: [
                                      if (email.priority == 'urgent') ...[
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.red[600],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '!',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                      ],
                                      if (isClicked)
                                        Icon(
                                          email.isPhishing ? Icons.dangerous : Icons.check_circle,
                                          color: email.isPhishing ? Colors.red : Colors.green,
                                          size: 18,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            
            // Attack overlay - this is where the magic happens
            if (deviceCompromised) ...[
              AnimatedBuilder(
                animation: _glitchController,
                builder: (context, child) {
                  return Container(
                    color: Colors.red[900]!.withOpacity(0.1 + 0.3 * _glitchController.value),
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Critical alert banner
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color.lerp(Colors.red[900], Colors.black, _pulseController.value),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.5 + 0.3 * _pulseController.value),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.warning, color: Colors.white, size: 28),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'CRITICAL SECURITY BREACH',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Text(
                                                'Advanced malware detected - System compromised',
                                                style: TextStyle(color: Colors.red[200], fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    
                                    // Attack progress
                                    Column(
                                      children: attackSteps.take(attackProgress).map((step) => 
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 6),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: Colors.red[400],
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  step,
                                                  style: TextStyle(color: Colors.white, fontSize: 13),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ).toList(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          
                          SizedBox(height: 16),
                          
                          // Data theft progress
                          if (dataTheftProgress > 0)
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange[900]!.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orange[600]!, width: 2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.download, color: Colors.orange[200], size: 24),
                                      SizedBox(width: 8),
                                      Text(
                                        'EXFILTRATING PERSONAL DATA',
                                        style: TextStyle(
                                          color: Colors.orange[200],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Column(
                                    children: stolenData.take(dataTheftProgress).map((data) => 
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 4),
                                        child: Row(
                                          children: [
                                            Icon(Icons.file_download, color: Colors.orange[300], size: 14),
                                            SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                data,
                                                style: TextStyle(color: Colors.white, fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.blue[600]! : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.blue[600] : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class Email {
  final String id;
  final String sender;
  final String subject;
  final String preview;
  final String time;
  final bool isPhishing;
  final String senderAvatar;
  final String priority;
  final String phishingType;
  final String maliciousUrl;
  final List<String> phishingReasons;
  bool isRead;

  Email({
    required this.id,
    required this.sender,
    required this.subject,
    required this.preview,
    required this.time,
    required this.isPhishing,
    required this.senderAvatar,
    required this.priority,
    this.phishingType = '',
    this.maliciousUrl = '',
    this.phishingReasons = const [],
    this.isRead = false,
  });
}
