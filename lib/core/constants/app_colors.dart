import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF1E3A8A);
  static const Color secondaryColor = Color(0xFFF97316);
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);
  
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);
  
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color dividerColor = Color(0xFFF3F4F6);
  
  static const Color shadowColor = Color(0x1A000000);
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2563EB),
      Color(0xFF1E3A8A),
    ],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFB923C),
      Color(0xFFF97316),
    ],
  );
  
  static Color getDocumentTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'license':
        return primaryColor;
      case 'medical':
        return successColor;
      case 'certification':
        return secondaryColor;
      case 'insurance':
        return infoColor;
      case 'training':
        return warningColor;
      default:
        return textSecondary;
    }
  }
}

class DarkAppColors {
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color secondaryColor = Color(0xFFFB923C);
  static const Color successColor = Color(0xFF34D399);
  static const Color errorColor = Color(0xFFF87171);
  static const Color warningColor = Color(0xFFFBBF24);
  static const Color infoColor = Color(0xFF60A5FA);
  
  static const Color backgroundColor = Color(0xFF0F172A);
  static const Color surfaceColor = Color(0xFF1E293B);
  static const Color cardColor = Color(0xFF1E293B);
  
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF64748B);
  
  static const Color borderColor = Color(0xFF334155);
  static const Color dividerColor = Color(0xFF1E293B);
  
  static const Color shadowColor = Color(0x4D000000);
}