import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._(); // not meant to be instantiated

  // App bar and big page titles
  static TextStyle get appBarTitle =>
      GoogleFonts.chewy(fontSize: 24, letterSpacing: 0.5);

  // Card titles in the recipe list
  static TextStyle get cardTitle => GoogleFonts.chewy(fontSize: 20);

  // Section headings on the detail page ("Ingredients", "Steps")
  static TextStyle get sectionHeading => GoogleFonts.chewy(fontSize: 22);

  // Empty state message
  static TextStyle get emptyMessage => GoogleFonts.chewy(fontSize: 20);
}