import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diary/components/round_card.dart';
import 'package:diary/core/core.dart';
import 'package:diary/providers/auth/app_auth/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 's_edit_profile.dart';

part 'f_edit_avatar.dart';

part 'f_edit_username.dart';

@RoutePage()
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Screen();
  }
}
