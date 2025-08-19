import 'package:flutter/material.dart';

/// Utility class for responsive design calculations and breakpoints
class ResponsiveUtils {
  // Screen size breakpoints
  static const double mobileSmall = 360;  // Small phones (iPhone SE)
  static const double mobileMedium = 375; // iPhone 12/13/14/15/16
  static const double mobileLarge = 414;  // iPhone Plus/Pro Max
  static const double tablet = 768;       // iPad Mini
  static const double desktop = 1024;     // Desktop/iPad Pro

  // Height breakpoints for vertical space
  static const double heightSmall = 667;  // iPhone SE, iPhone 8
  static const double heightMedium = 812; // iPhone X/11/12/13/14
  static const double heightLarge = 896;  // iPhone 14 Pro Max
  static const double heightXLarge = 932; // iPhone 15/16 Pro Max

  /// Get device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < mobileMedium) return DeviceType.mobileSmall;
    if (width < mobileLarge) return DeviceType.mobileMedium;
    if (width < tablet) return DeviceType.mobileLarge;
    if (width < desktop) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  /// Get screen size category based on height
  static ScreenSize getScreenSize(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    
    if (height < heightSmall) return ScreenSize.small;
    if (height < heightMedium) return ScreenSize.medium;
    if (height < heightLarge) return ScreenSize.large;
    return ScreenSize.xlarge;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Get responsive value based on screen size
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      default:
        return mobile;
    }
  }

  /// Get responsive padding based on screen size
  static EdgeInsets responsivePadding(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobileSmall:
        return const EdgeInsets.all(12);
      case DeviceType.mobileMedium:
      case DeviceType.mobileLarge:
        return const EdgeInsets.all(16);
      case DeviceType.tablet:
        return const EdgeInsets.all(24);
      case DeviceType.desktop:
        return const EdgeInsets.all(32);
    }
  }

  /// Get responsive font size
  static double responsiveFontSize(
    BuildContext context, {
    required double base,
    double? small,
    double? large,
  }) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        return small ?? base * 0.9;
      case ScreenSize.medium:
        return base;
      case ScreenSize.large:
      case ScreenSize.xlarge:
        return large ?? base * 1.1;
    }
  }

  /// Get responsive spacing
  static double responsiveSpacing(
    BuildContext context, {
    required double base,
  }) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        return base * 0.8;
      case ScreenSize.medium:
        return base;
      case ScreenSize.large:
      case ScreenSize.xlarge:
        return base * 1.2;
    }
  }

  /// Calculate grid cross axis count based on screen width
  static int getGridCrossAxisCount(
    BuildContext context, {
    int baseCount = 2,
    double itemWidth = 180,
  }) {
    final width = MediaQuery.of(context).size.width;
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobileSmall:
      case DeviceType.mobileMedium:
        return baseCount;
      case DeviceType.mobileLarge:
        return baseCount;
      case DeviceType.tablet:
        return (width / itemWidth).floor().clamp(3, 4);
      case DeviceType.desktop:
        return (width / itemWidth).floor().clamp(4, 6);
    }
  }

  /// Get responsive grid aspect ratio
  static double getGridAspectRatio(
    BuildContext context, {
    double baseRatio = 1.5,
  }) {
    final screenSize = getScreenSize(context);
    final isLandscape = ResponsiveUtils.isLandscape(context);
    
    if (isLandscape) {
      return baseRatio * 1.3; // More width in landscape
    }
    
    switch (screenSize) {
      case ScreenSize.small:
        return baseRatio * 0.8; // More height for small screens
      case ScreenSize.medium:
        return baseRatio * 0.9;
      case ScreenSize.large:
        return baseRatio;
      case ScreenSize.xlarge:
        return baseRatio * 1.1;
    }
  }
}

enum DeviceType {
  mobileSmall,
  mobileMedium,
  mobileLarge,
  tablet,
  desktop,
}

enum ScreenSize {
  small,
  medium,
  large,
  xlarge,
}