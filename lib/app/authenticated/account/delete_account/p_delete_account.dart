import 'package:auto_route/annotations.dart';
import 'package:diary/components/round_card.dart';
import 'package:diary/core/core.dart';
import 'package:flutter/material.dart';

part 's_delete_account.dart';

part 'w_warning_card.dart';

part 'w_section_title.dart';

part 'w_info_row.dart';

part 'w_check_title.dart';

@RoutePage()
class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Screen();
  }
}
