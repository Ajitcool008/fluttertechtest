import 'package:flutter/material.dart';

// Vertical spacing
const Widget verticalSpaceTiny = SizedBox(height: 4.0);
const Widget verticalSpaceSmall = SizedBox(height: 8.0);
const Widget verticalSpaceMedium = SizedBox(height: 16.0);
const Widget verticalSpaceLarge = SizedBox(height: 24.0);
const Widget verticalSpaceXLarge = SizedBox(height: 32.0);

// Horizontal spacing
const Widget horizontalSpaceTiny = SizedBox(width: 4.0);
const Widget horizontalSpaceSmall = SizedBox(width: 8.0);
const Widget horizontalSpaceMedium = SizedBox(width: 16.0);
const Widget horizontalSpaceLarge = SizedBox(width: 24.0);
const Widget horizontalSpaceXLarge = SizedBox(width: 32.0);

// Screen Size Helpers
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenHeightFraction(BuildContext context, 
    {int dividedBy = 1, double offsetBy = 0}) =>
    (screenHeight(context) - offsetBy) / dividedBy;

double screenWidthFraction(BuildContext context, 
    {int dividedBy = 1, double offsetBy = 0}) =>
    (screenWidth(context) - offsetBy) / dividedBy;

// Padding
const EdgeInsets paddingTiny = EdgeInsets.all(4.0);
const EdgeInsets paddingSmall = EdgeInsets.all(8.0);
const EdgeInsets paddingMedium = EdgeInsets.all(16.0);
const EdgeInsets paddingLarge = EdgeInsets.all(24.0);
const EdgeInsets paddingXLarge = EdgeInsets.all(32.0);