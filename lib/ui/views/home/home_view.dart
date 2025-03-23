import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../localization/app_localizations.dart';
import '../posts/posts_view.dart';
import '../saved_posts/saved_posts_view.dart';
import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) => model.initialize(),
      builder:
          (context, model, child) => Scaffold(
            body: IndexedStack(
              index: model.currentIndex,
              children: const [PostsView(), SavedPostsView()],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: model.currentIndex,
              onTap: model.setIndex,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.list),
                  label: AppLocalizations.of(
                    context,
                  ).translate('posts_list_title'),
                ),
                BottomNavigationBarItem(
                  icon:
                      model.savedPostsCount > 0
                          ? badges.Badge(
                            badgeContent: Text(
                              '${model.savedPostsCount}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            child: const Icon(Icons.bookmark),
                          )
                          : const Icon(Icons.bookmark),
                  label: AppLocalizations.of(
                    context,
                  ).translate('saved_posts_title'),
                ),
              ],
            ),
          ),
    );
  }
}
