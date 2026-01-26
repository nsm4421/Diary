import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diary/components/round_card.dart';
import 'package:diary/core/core.dart';
import 'package:diary/providers/auth/app_auth/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'f_edit_avatar.dart';
part 'f_edit_username.dart';

@RoutePage()
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  String _fallbackInitial(String username) {
    final trimmed = username.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 수정')),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          final authUser = state.currentUser;
          final username = authUser?.username ?? '익명';
          final avatarUrl = authUser?.avatarUrl;

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              children: [
                _EditAvatar(
                  avatarUrl: avatarUrl,
                  fallback: _fallbackInitial(username),
                ),
                const SizedBox(height: 24),
                _EditUsername(initialUsername: username),
              ],
            ),
          );
        },
      ),
    );
  }
}
