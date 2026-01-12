import 'dart:ui';
import 'package:flutter/material.dart';

/// Cyberpunk neon hotspot pin with glassmorphism and glow effects
class NeonHotspotPin extends StatefulWidget {
  final String name;
  final IconData icon;
  final Color neonColor;
  final bool isLive;

  const NeonHotspotPin({
    super.key,
    required this.name,
    required this.icon,
    required this.neonColor,
    this.isLive = false,
  });

  @override
  State<NeonHotspotPin> createState() => _NeonHotspotPinState();
}

class _NeonHotspotPinState extends State<NeonHotspotPin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    // Create floating animation (bob up and down)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -3.0,
      end: 3.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Live" badge (optional)
          if (widget.isLive)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.6),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          
          SizedBox(height: 4),
          
          // Main hotspot pin
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7), // Glassmorphism
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.neonColor,
                    width: 2,
                  ),
                  boxShadow: [
                    // Neon glow effect
                    BoxShadow(
                      color: widget.neonColor.withOpacity(0.6),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                    // Inner highlight
                    BoxShadow(
                      color: widget.neonColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Circular icon with glow
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.neonColor.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                            color: widget.neonColor.withOpacity(0.8),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 16,
                        shadows: [
                          Shadow(
                            color: widget.neonColor,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(width: 8),
                    
                    // Place name
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: widget.neonColor.withOpacity(0.8),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Floating pin stem
          Container(
            width: 2,
            height: 12,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.neonColor.withOpacity(0.8),
                  widget.neonColor.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
