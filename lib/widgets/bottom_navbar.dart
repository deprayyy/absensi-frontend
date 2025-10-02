import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'dart:ui';

class BottomNavBarWidget extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<BottomNavBarWidget> createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  // Helper method untuk responsive values
  double _getResponsiveValue(
      BuildContext context, {
        required double small,
        required double medium,
        required double large,
      }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Breakpoints berdasarkan Material Design guidelines
    if (screenWidth < 360) {
      return small; // Small phones
    } else if (screenWidth < 600) {
      return medium; // Normal phones
    } else {
      return large; // Tablets and large screens
    }
  }

  bool _isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  bool _isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    // Responsive values menggunakan MediaQuery
    final double iconSize = _getResponsiveValue(
      context,
      small: MediaQuery.of(context).size.width * 0.055,
      medium: MediaQuery.of(context).size.width * 0.065,
      large: MediaQuery.of(context).size.width * 0.045,
    );

    final double navBarHeight = _getResponsiveValue(
      context,
      small: _isLandscape(context) ? 55.0 : 60.0,
      medium: _isLandscape(context) ? 65.0 : 70.0,
      large: _isLandscape(context) ? 70.0 : 80.0,
    );

    final double horizontalPadding = _getResponsiveValue(
      context,
      small: 10.0,
      medium: 14.0,
      large: 20.0,
    );

    final double verticalPadding = _getResponsiveValue(
      context,
      small: 6.0,
      medium: 10.0,
      large: 12.0,
    );

    final double blurSigma = _getResponsiveValue(
      context,
      small: 3.0,
      medium: 4.0,
      large: 6.0,
    );

    final double fontSize = _getResponsiveValue(
      context,
      small: 9.0,
      medium: 10.0,
      large: 11.0,
    );

    final double gapSize = _getResponsiveValue(
      context,
      small: 3.0,
      medium: 5.0,
      large: 6.0,
    );

    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: Container(
                height: navBarHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.withValues(alpha: 0.4),
                      Colors.pinkAccent.withValues(alpha: 0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: GNav(
                  selectedIndex: widget.selectedIndex,
                  onTabChange: (index) {
                    HapticFeedback.lightImpact();
                    widget.onItemTapped(index);
                  },
                  rippleColor: Colors.white.withValues(alpha: 0.05),
                  hoverColor: Colors.white.withValues(alpha: 0.02),
                  haptic: true,
                  tabBorderRadius: 16,
                  curve: Curves.easeOutExpo,
                  duration: const Duration(milliseconds: 500),
                  gap: gapSize,
                  color: Colors.white.withValues(alpha: 0.6),
                  activeColor: Colors.white,
                  iconSize: iconSize,
                  tabBackgroundColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(
                    horizontal: _getResponsiveValue(
                      context,
                      small: 10.0,
                      medium: 14.0,
                      large: 18.0,
                    ),
                    vertical: _getResponsiveValue(
                      context,
                      small: 6.0,
                      medium: 8.0,
                      large: 10.0,
                    ),
                  ),
                  tabs: [
                    _buildGButton(
                      context: context,
                      icon: Icons.home,
                      text: 'Home',
                      isSelected: widget.selectedIndex == 0,
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildGButton(
                      context: context,
                      icon: Icons.summarize,
                      text: 'Summary',
                      isSelected: widget.selectedIndex == 1,
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildGButton(
                      context: context,
                      icon: Icons.perm_contact_calendar,
                      text: 'Permit',
                      isSelected: widget.selectedIndex == 2,
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildGButton(
                      context: context,
                      icon: Icons.leave_bags_at_home_sharp,
                      text: 'Leave',
                      isSelected: widget.selectedIndex == 3,
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  GButton _buildGButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required bool isSelected,
    required double iconSize,
    required double fontSize,
  }) {
    final bool isSmallScreen = _isSmallScreen(context);
    final bool isLandscape = _isLandscape(context);

    final double horizontalPadding = _getResponsiveValue(
      context,
      small: 6.0,
      medium: 8.0,
      large: 12.0,
    );

    final double verticalPadding = _getResponsiveValue(
      context,
      small: 3.0,
      medium: 4.0,
      large: 6.0,
    );

    final double spaceBetween = _getResponsiveValue(
      context,
      small: 2.0,
      medium: 4.0,
      large: 6.0,
    );

    // Untuk landscape mode di small screen, sembunyikan text
    final bool showText = isSelected && (!isSmallScreen || !isLandscape);

    return GButton(
      icon: icon,
      iconColor: Colors.white.withValues(alpha: 0.6),
      iconActiveColor: Colors.white,
      backgroundColor: Colors.transparent,
      iconSize: iconSize,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      leading: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding * 1.5,
          vertical: verticalPadding * 1.5,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            colors: [Colors.blueAccent, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.pinkAccent.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: isSelected ? _getResponsiveValue(
                context,
                small: 2.0,
                medium: 3.0,
                large: 4.0,
              ) : 0,
              sigmaY: isSelected ? _getResponsiveValue(
                context,
                small: 2.0,
                medium: 3.0,
                large: 4.0,
              ) : 0,
            ),
            child: AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: iconSize,
                    color: Colors.white,
                  ),
                  if (showText) SizedBox(width: spaceBetween),
                  if (showText)
                    Text(
                      text,
                      style: GoogleFonts.poppins(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}