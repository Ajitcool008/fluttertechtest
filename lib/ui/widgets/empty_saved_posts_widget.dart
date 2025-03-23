import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../common/app_colors.dart';
import '../common/ui_helpers.dart';

class EmptySavedPostsWidget extends StatelessWidget {
  const EmptySavedPostsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bookmark_border, size: 80, color: AppColors.divider),
          verticalSpaceMedium,
          Text(
            AppLocalizations.of(context).translate('no_saved_posts'),
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
