import 'package:flutter/material.dart';

import '../../domain/entities/comment.dart';
import '../common/app_colors.dart';
import '../common/ui_helpers.dart';

class CommentListItem extends StatelessWidget {
  final Comment comment;

  const CommentListItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddingMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(child: Icon(Icons.person)),
              horizontalSpaceMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    verticalSpaceSmall,
                    Text(
                      comment.email,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    verticalSpaceMedium,
                    Text(
                      comment.body,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpaceMedium,
          const Divider(thickness: 1, color: AppColors.divider),
        ],
      ),
    );
  }
}
