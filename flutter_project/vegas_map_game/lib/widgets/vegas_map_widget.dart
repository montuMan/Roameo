import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../engine/game_engine.dart';

class VegasMapWidget extends StatefulWidget {
  final Function(VegasLocation) onLocationSelected;

  const VegasMapWidget({super.key, required this.onLocationSelected});

  @override
  State<VegasMapWidget> createState() => _VegasMapWidgetState();
}

class _VegasMapWidgetState extends State<VegasMapWidget> {
  final GameEngine _gameEngine = GameEngine();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange[100]!, Colors.amber[50]!, Colors.brown[100]!],
        ),
        border: Border.all(color: Colors.amber[800]!, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Background pattern
          CustomPaint(size: Size.infinite, painter: MapBackgroundPainter()),

          // Player position
          Positioned(
            left:
                _gameEngine.player.currentX *
                (MediaQuery.of(context).size.width - 100),
            top: _gameEngine.player.currentY * 300,
            child: GestureDetector(
              onTap: () => _onMapTap(
                _gameEngine.player.currentX,
                _gameEngine.player.currentY,
              ),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.person, size: 12, color: Colors.white),
              ),
            ),
          ),

          // Locations
          ..._gameEngine.locations.map(
            (location) => Positioned(
              left: location.x * (MediaQuery.of(context).size.width - 100),
              top: location.y * 300,
              child: GestureDetector(
                onTap: () => widget.onLocationSelected(location),
                child: _buildLocationMarker(location),
              ),
            ),
          ),

          // Tap handler for movement
          GestureDetector(
            onTapDown: (details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final Offset localPosition = box.globalToLocal(
                details.globalPosition,
              );
              final double relativeX = localPosition.dx / box.size.width;
              final double relativeY = localPosition.dy / box.size.height;
              _onMapTap(relativeX, relativeY);
            },
            child: Container(
              width: double.infinity,
              height: 300,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMarker(VegasLocation location) {
    Color markerColor;
    Widget icon;

    if (location.isVisited) {
      markerColor = Colors.green;
      icon = Text('✅', style: TextStyle(fontSize: 16));
    } else if (location.isDiscovered) {
      markerColor = Colors.amber;
      icon = Text(location.iconPath, style: TextStyle(fontSize: 16));
    } else {
      markerColor = Colors.grey;
      icon = Icon(Icons.help_outline, size: 16, color: Colors.white);
    }

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: markerColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Center(child: icon),
    );
  }

  void _onMapTap(double x, double y) {
    setState(() {
      _gameEngine.movePlayer(x, y);
    });
  }
}

class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown[200]!.withOpacity(0.3)
      ..strokeWidth = 1;

    // Draw grid pattern
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw Vegas strip representation
    final stripPaint = Paint()
      ..color = Colors.amber[600]!.withOpacity(0.3)
      ..strokeWidth = 8;

    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.2),
      Offset(size.width * 0.6, size.height * 0.8),
      stripPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
