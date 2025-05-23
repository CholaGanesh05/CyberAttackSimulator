import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

// --- Constants ---
const Duration _kBgAnimationDuration = Duration(seconds: 30);
const Duration _kOptionAnimationBaseDuration = Duration(milliseconds: 700);
const Duration _kOptionAnimationStagger = Duration(milliseconds: 150);
const Duration _kOptionEntryDelay = Duration(milliseconds: 400);
const int _kNumBackgroundStars = 40;
const double _kStarBaseRadius = 250.0;
const double _kStarRadiusIncrement = 25.0;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulation Selection',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: const SimulationSelectionPage(),
    );
  }
}

class SimulationSelectionPage extends StatefulWidget {
  const SimulationSelectionPage({super.key});

  @override
  _SimulationSelectionPageState createState() => _SimulationSelectionPageState();
}

class _SimulationSelectionPageState extends State<SimulationSelectionPage>
    with TickerProviderStateMixin {
  late List<AnimationController> _optionControllers;
  late List<Animation<double>> _optionScaleAnimations;
  late List<Animation<double>> _optionFadeAnimations;

  late AnimationController _bgController;
  late Animation<double> _rotationAnimation;

  late List<AnimationController> _starPulseControllers;
  late List<Animation<double>> _starPulseAnimations;
  final math.Random _random = math.Random();

  int? _selectedIndex;
  bool _showDetails = false;

  final List<SimulationOption> _options = [
    SimulationOption(
      title: "Phishing Simulation",
      icon: Icons.phishing_rounded,
      description: "Simulate sophisticated email phishing attacks and user awareness.",
      color: Colors.lightBlueAccent.shade400,
      details: """
      This simulation will test your ability to identify phishing attempts in emails. 
      You'll receive simulated emails that may contain suspicious links, attachments, 
      or requests for sensitive information. Your goal is to identify which emails 
      are legitimate and which are phishing attempts.
      """,
    ),
    SimulationOption(
      title: "SMS Scam",
      icon: Icons.sms_failed_rounded,
      description: "Replicate modern SMS phishing (smishing) techniques.",
      color: Colors.tealAccent.shade400,
      details: """
      In this simulation, you'll encounter text messages designed to trick you into 
      revealing personal information or downloading malicious content. These may appear 
      to come from banks, delivery services, or other trusted sources. Stay vigilant 
      against unexpected requests for information.
      """,
    ),
    SimulationOption(
      title: "Data Exfiltration",
      icon: Icons.security_rounded,
      description: "Simulate sensitive data extraction and endpoint compromise.",
      color: Colors.purpleAccent.shade400,
      details: """
      This scenario simulates attempts to steal sensitive data from your device. 
      You'll encounter situations where malware or unauthorized processes try to 
      access and transmit your files. Your task is to detect and prevent these 
      data exfiltration attempts.
      """,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      duration: _kBgAnimationDuration,
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(CurvedAnimation(parent: _bgController, curve: Curves.linear));

    _optionControllers = List.generate(
        _options.length,
        (index) => AnimationController(
              duration: _kOptionAnimationBaseDuration +
                  (_kOptionAnimationStagger * index),
              vsync: this,
            ));

    _optionScaleAnimations = _optionControllers
        .map<Animation<double>>((controller) => CurvedAnimation(
              parent: controller,
              curve: Curves.elasticOut,
            ))
        .toList();

    _optionFadeAnimations = _optionControllers
        .map<Animation<double>>((controller) => Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: controller,
                curve: Curves.easeOut,
              ),
            ))
        .toList();

    // Background Star Pulse Animations
    _starPulseControllers = List.generate(_kNumBackgroundStars, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 1500 + _random.nextInt(1000)),
        vsync: this,
      )..repeat(reverse: true);
    });

    _starPulseAnimations = _starPulseControllers.map<Animation<double>>((controller) {
      return Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    Future.delayed(_kOptionEntryDelay, () {
      _optionControllers.forEach((controller) => controller.forward());
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _optionControllers.forEach((controller) => controller.dispose());
    _starPulseControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _handleSelection(int index) {
    HapticFeedback.mediumImpact();
    setState(() {
      if (_selectedIndex == index) {
        // Toggle details if same option is clicked again
        _showDetails = !_showDetails;
      } else {
        _selectedIndex = index;
        _showDetails = true;
      }
    });
  }

  void _closeDetails() {
    setState(() {
      _showDetails = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final isLargeScreen = screenSize.width > 700;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_bgController, ..._starPulseControllers]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Colors.deepPurple.shade900.withOpacity(0.2),
                  Colors.black87,
                  Colors.black,
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Animated background stars
                ...List.generate(_kNumBackgroundStars, (index) {
                  final angle = (index * (360.0 / _kNumBackgroundStars)) +
                      (_rotationAnimation.value * 180 / math.pi * 0.5);
                  final distanceFactor = 0.8 + (_random.nextDouble() * 0.4);
                  final radius = (_kStarBaseRadius + (index % 10 * _kStarRadiusIncrement)) * distanceFactor;
                  final starSize = 1.5 + _random.nextDouble() * 2.5;

                  return Positioned(
                    left: screenSize.width / 2 +
                        (radius * 0.7) * math.cos(angle * math.pi / 180) -
                        starSize / 2,
                    top: screenSize.height / 2 +
                        (radius * 0.5) * math.sin(angle * math.pi / 180) -
                        starSize / 2,
                    child: FadeTransition(
                      opacity: _starPulseAnimations[index],
                      child: Container(
                        width: starSize,
                        height: starSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent.withOpacity(0.3 + _random.nextDouble() * 0.3),
                        ),
                      ),
                    ),
                  );
                }),

                // Content
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBar(
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white70),
                            onPressed: () => SystemNavigator.pop(),
                          ),
                          title: Text('Select Simulation Scenario',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.5)),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          centerTitle: true,
                        ),
                        
                        if (_showDetails && _selectedIndex != null) ...[
                          _buildDetailsPanel(context, _options[_selectedIndex!]),
                          SizedBox(height: 20),
                        ],
                        
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 30,
                                runSpacing: 30,
                                children: List.generate(_options.length, (index) {
                                  final isSelected = _selectedIndex == index;
                                  return FadeTransition(
                                    opacity: _optionFadeAnimations[index],
                                    child: ScaleTransition(
                                      scale: _optionScaleAnimations[index],
                                      child: SimulationCard(
                                        option: _options[index],
                                        isSelected: isSelected,
                                        onTap: () => _handleSelection(index),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildDetailsPanel(BuildContext context, SimulationOption option) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900]!.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: option.color.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: option.color.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                option.title,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white70),
                onPressed: _closeDetails,
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(color: option.color.withOpacity(0.5)),
          SizedBox(height: 15),
          Text(
            option.details,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 16,
              height: 1.6,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Start simulation logic would go here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Starting ${option.title}...'),
                    backgroundColor: option.color,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: option.color.withOpacity(0.2),
                foregroundColor: option.color,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: option.color.withOpacity(0.8)),
                ),
                elevation: 5,
                shadowColor: option.color.withOpacity(0.3),
              ),
              child: Text(
                'Start Simulation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SimulationCard extends StatefulWidget {
  final SimulationOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const SimulationCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  _SimulationCardState createState() => _SimulationCardState();
}

class _SimulationCardState extends State<SimulationCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final option = widget.option;
    final isSelected = widget.isSelected;
    final cardWidth = MediaQuery.sizeOf(context).width > 700 ? 320.0 : 280.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: cardWidth,
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: _isHovered || isSelected
                ? Colors.grey[850]!.withOpacity(0.8)
                : Colors.grey[900]!.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: option.color.withOpacity(
                _isHovered || isSelected ? 0.7 : 0.4),
              width: _isHovered || isSelected ? 2.5 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: option.color.withOpacity(
                  _isHovered || isSelected ? 0.4 : 0.25),
                blurRadius: _isHovered || isSelected ? 25 : 15,
                spreadRadius: _isHovered || isSelected ? 4 : 2,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 5),
              )
            ],
            gradient: (_isHovered || isSelected) ? LinearGradient(
              colors: [option.color.withOpacity(0.1), Colors.grey[850]!.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ) : null,
          ),
          transform: (_isHovered || isSelected) 
              ? (Matrix4.identity()..scale(1.03)) 
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(option.icon,
                  size: 50,
                  color: option.color.withOpacity(
                    _isHovered || isSelected ? 1.0 : 0.8)),
              SizedBox(height: 20),
              Text(
                option.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white.withOpacity(0.95),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 15),
              Text(
                option.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: option.color.withOpacity(
                    _isHovered || isSelected ? 0.25 : 0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: option.color.withOpacity(0.5))
                ),
                child: Text(
                  "Start Simulation",
                  style: TextStyle(
                    color: option.color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimulationOption {
  final String title;
  final IconData icon;
  final String description;
  final String details;
  final Color color;

  SimulationOption({
    required this.title,
    required this.icon,
    required this.description,
    required this.color,
    required this.details,
  });
}