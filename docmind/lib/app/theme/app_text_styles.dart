import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static TextStyle display = GoogleFonts.manrope(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.paper,
  );

  static TextStyle h1 = GoogleFonts.manrope(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.paper,
  );

  static TextStyle h2 = GoogleFonts.manrope(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.paper,
  );

  static TextStyle title = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.paper,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.ice,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.lavender,
  );
}
