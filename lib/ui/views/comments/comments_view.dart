import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../localization/app_localizations.dart';
import '../../../ui/widgets/comment_list_item.dart';
import '../../../ui/widgets/empty_comments_widget.dart';
import '../../../ui/widgets/error_widget.dart';
import '../../../ui/widgets/loading_widget.dart';
import 'comments_viewmodel.dart';

class CommentsView extends StatelessWidget {
  final int postId;

  const CommentsView({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommentsViewModel>.reactive(
      viewModelBuilder: () => CommentsViewModel(),
      onViewModelReady: (model) => model.loadComments(postId),
      builder:
          (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context).translate('post_comments_title'),
              ),
            ),
            body: Builder(
              builder: (context) {
                if (model.isBusy) {
                  return const LoadingWidget();
                } else if (model.hasError) {
                  return ErrorMessageWidget(
                    message: model.errorMessage,
                    onRetry: () => model.loadComments(postId),
                  );
                } else if (model.comments.isEmpty) {
                  return const EmptyCommentsWidget();
                } else {
                  return Column(
                    children: [
                      // Show offline indicator if data is from cache
                      if (model.isOfflineData)
                        Container(
                          color: Colors.amber.shade100,
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.offline_pin,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Showing offline comments',
                                style: TextStyle(
                                  color: Colors.amber.shade900,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: model.comments.length,
                          itemBuilder: (context, index) {
                            return CommentListItem(
                              comment: model.comments[index],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
    );
  }
}
