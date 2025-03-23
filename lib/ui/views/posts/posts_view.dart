import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../di/manual_locator.dart';
import '../../../localization/app_localizations.dart';
import '../../../ui/widgets/error_widget.dart';
import '../../../ui/widgets/loading_widget.dart';
import '../../../ui/widgets/post_list_item.dart';
import 'posts_viewmodel.dart';

class PostsView extends StatelessWidget {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostsViewModel>.reactive(
      viewModelBuilder: () => locator<PostsViewModel>(), // Use singleton
      disposeViewModel: false, // Don't dispose
      fireOnViewModelReadyOnce: false, // Fire every time view is shown
      onViewModelReady: (model) => model.loadPosts(),
      builder:
          (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context).translate('posts_list_title'),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () => model.loadPosts(),
              child: Builder(
                builder: (context) {
                  if (model.isBusy) {
                    return const LoadingWidget();
                  } else if (model.hasError) {
                    return ErrorMessageWidget(
                      message: model.errorMessage,
                      onRetry: model.loadPosts,
                    );
                  } else if (model.posts.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context).translate('no_posts'),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: model.posts.length,
                      itemBuilder: (context, index) {
                        final post = model.posts[index];
                        return PostListItem(
                          post: post,
                          onTap: () => model.navigateToPostDetails(post.id),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
    );
  }
}
