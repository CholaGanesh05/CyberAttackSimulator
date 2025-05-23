import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'fake_link_screen.dart';

class SmsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Shimmer.fromColors(
          baseColor: Colors.blueAccent,
          highlightColor: Colors.white,
          child: Text("📱 Suspicious Inbox")),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.black],
              stops: [0.3, 1.0],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.blue.shade900.withOpacity(0.3), Colors.transparent],
            radius: 1.5,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: HoverCard(
              elevation: 20,
              shadowColor: Colors.red.withOpacity(0.5),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.blueGrey.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  leading: LiquidCircularProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.black,
                    valueColor: AlwaysStoppedAnimation(Colors.red),
                    borderWidth: 2,
                    borderColor: Colors.red,
                  ),
                  title: Text("⚠️ URGENT MESSAGE ⚠️",
                      style: Theme.of(context).textTheme.headline6),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: Colors.red.withOpacity(0.3)),
                      SizedBox(height: 10),
                      Text("Account Compromised!",
                          style: TextStyle(color: Colors.red, fontSize: 18)),
                      Text("Click immediately to secure →",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
                  trailing: FloatingActionButton(
                    backgroundColor: Colors.red.shade900,
                    child: Icon(Icons.bolt, size: 30),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FakeLinkScreen()),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HoverCard extends StatefulWidget {
  final Widget child;
  final double elevation;
  final Color shadowColor;

  HoverCard({required this.child, this.elevation = 4, this.shadowColor = Colors.black});

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _controller.value * 4),
          child: Card(
            elevation: widget.elevation + _controller.value * 6,
            shadowColor: widget.shadowColor.withOpacity(0.3 + _controller.value * 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
            color: Colors.transparent,
            child: widget.child,
          ),
        );
      },
    );
  }
}
