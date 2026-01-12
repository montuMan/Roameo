import 'package:flutter/material.dart';

/// Spotify-style gradient navigation bar with fade effect
/// NO blur, NO glassmorphism - just a clean gradient fade
class SpotifyNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const SpotifyNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 140, // Taller for cinematic fade (was 100)
        decoration: BoxDecoration(
          // Cinematic 3-stop gradient scrim for perfect readability
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,                    // 0% - fully transparent
              Colors.black.withOpacity(0.6),         // ~70% - middle darkening
              Colors.black.withOpacity(0.95),        // 100% - solid dark base
            ],
            stops: [0.0, 0.5, 1.0], // Control gradient distribution
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20, // Position icons in darkest area (was 0)
            ),
            child: Align(
              alignment: Alignment.bottomCenter, // Anchor to bottom
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.explore_outlined,
                    activeIcon: Icons.explore,
                    label: 'Explore',
                    isSpecial: false,
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.auto_awesome_outlined,
                    activeIcon: Icons.auto_awesome,
                    label: 'Scenes',
                    isSpecial: true, // Glowing accent for Scenes
                  ),
                  _buildNavItem(
                    index: 2,
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Karma',
                    isSpecial: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSpecial,
  }) {
    final isSelected = selectedIndex == index;

    // Color logic: White when selected, grey when not (except Scenes which glows)
    Color iconColor;
    Color textColor;

    if (isSelected) {
      if (isSpecial) {
        // Scenes tab gets neon purple/cyan glow
        iconColor = Color(0xFFBB86FC); // Neon purple
        textColor = Color(0xFFBB86FC);
      } else {
        // Regular tabs are white when selected
        iconColor = Colors.white;
        textColor = Colors.white;
      }
    } else {
      // Inactive: Grey
      iconColor = Colors.grey[500]!;
      textColor = Colors.grey[500]!;
    }

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon (with optional glow for Scenes)
            Icon(
              isSelected ? activeIcon : icon,
              color: iconColor,
              size: 26,
              shadows: isSelected && isSpecial
                  ? [
                      Shadow(
                        color: Color(0xFFBB86FC).withOpacity(0.8),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),
            SizedBox(height: 2),
            // Tiny label text (Spotify style)
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: textColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Alias for clarity
typedef SpotifyGradientNav = SpotifyNavBar;
