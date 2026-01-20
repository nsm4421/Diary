import 'package:auto_route/auto_route.dart';
import 'package:diary/core/core.dart';
import 'package:diary/providers/display/bloc.dart';
import 'package:diary/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vote/vote.dart';

import '../../../components/auth_required_dialog.dart';
import '../../../providers/authentication/bloc.dart';
import '../../../providers/display_agendas/bloc.dart';

part 'f_feed_list.dart';

part 'w_agenda_card.dart';

part 'w_filter_chips.dart';

class DisplayAgendasScreen extends StatelessWidget {
  const DisplayAgendasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: context.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            scrolledUnderElevation: 0,
            title: Text(
              'VOTE',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  final isAuth = await context
                      .read<AuthenticationBloc>()
                      .resolveIsAuth();
                  if (!context.mounted) return;
                  if (isAuth) {
                    context.router.push(const CreateAgendaRoute());
                    return;
                  }
                  final shouldLogin = await AuthRequiredDialog.show(context);
                  if (!context.mounted) return;
                  if (shouldLogin) {
                    context.router.root.push(const AuthRoute());
                  }
                },
                icon: const Icon(Icons.add),
                tooltip: '투표 만들기',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: SafeArea(
                bottom: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),
                        const _FilterChips(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
            sliver: _FeedList(),
          ),
        ],
      ),
    );
  }
}
