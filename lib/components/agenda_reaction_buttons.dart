import 'package:diary/core/core.dart';
import 'package:diary/providers/auth/app_auth/bloc.dart';
import 'package:diary/providers/vote/agenda_reaction/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vote/vote.dart';

import 'icon_with_text.dart';

class AgendaReactionButtons extends StatefulWidget {
  const AgendaReactionButtons({super.key});

  @override
  State<AgendaReactionButtons> createState() => _AgendaReactionButtonsState();
}

class _AgendaReactionButtonsState extends State<AgendaReactionButtons> {
  late VoteReactionCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<VoteReactionCubit>();
  }

  Function() _handleReaction(VoteReaction tapped) => () async {
    // 인증여부 검사
    final isAuth = await context.read<AuthenticationBloc>().resolveIsAuth();
    if (!isAuth) {
      ToastUtil.warning('로그인후에 사용할 수 있어요');
      return;
    }
    if (!context.mounted) return;
    final currentUid = context.read<AuthenticationBloc>().state.currentUser?.id;
    if (currentUid == null) return;

    await _cubit.handleReaction(tapped: tapped, currentUid: currentUid);
  };

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoteReactionCubit, VoteReactonState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _handleReaction(VoteReaction.like),
              child: IconWithTextWidget(
                icon: state.isLike ? Icons.thumb_up : Icons.thumb_up_outlined,
                label: state.likeCount.toString(),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _handleReaction(VoteReaction.dislike),
              child: IconWithTextWidget(
                icon: state.isDislike
                    ? Icons.thumb_down
                    : Icons.thumb_down_outlined,
                label: state.dislikeCount.toString(),
              ),
            ),
          ],
        );
      },
    );
  }
}
