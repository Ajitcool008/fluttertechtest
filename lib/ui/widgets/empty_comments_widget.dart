import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../common/app_colors.dart';
import '../common/ui_helpers.dart';

class EmptyCommentsWidget extends StatelessWidget {
  const EmptyCommentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppColors.divider,
          ),
          verticalSpaceMedium,
          Text(
            AppLocalizations.of(context).translate('no_comments'),
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
