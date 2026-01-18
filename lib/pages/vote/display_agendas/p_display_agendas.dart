import 'package:auto_route/auto_route.dart';
import 'package:diary/core/core.dart';
import 'package:diary/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:vote/vote.dart';

part 's_display_agendas.dart';
part 'w_agenda_card.dart';
part 'w_filter_chips.dart';
part 'w_feed_header.dart';

@RoutePage()
class DisplayAgendasPage extends StatelessWidget {
  const DisplayAgendasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Screen();
  }
}
