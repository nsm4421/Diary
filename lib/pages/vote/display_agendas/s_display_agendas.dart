part of 'p_display_agendas.dart';

class _Screen extends StatelessWidget {
  const _Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final agendaFeed = _mockAgendaFeed();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: context.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            scrolledUnderElevation: 0,
            title: Text(
              '안건 피드',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.router.push(const CreateAgendaRoute());
                },
                icon: const Icon(Icons.add),
                tooltip: '안건 만들기',
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
                        Text(
                          '총 ${agendaFeed.length}건의 안건이 공유되고 있어요.',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
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

          SliverFillRemaining(
            hasScrollBody: true,
            child: ListView.builder(
              primary: false,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
              itemCount: agendaFeed.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _AgendaCard(agenda: agendaFeed[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<AgendaFeedModel> _mockAgendaFeed() {
  final now = DateTime.now();
  final authors = [
    ProfileModel(id: 'u-01', username: '민지'),
    ProfileModel(id: 'u-02', username: '서준'),
    ProfileModel(id: 'u-03', username: '하린'),
  ];

  return [
    AgendaFeedModel(
      id: 'ag-01',
      createdAt: now.subtract(const Duration(hours: 2)),
      updatedAt: now.subtract(const Duration(hours: 1)),
      title: '회의실 예약 정책 개선',
      description: '예약 시간 단위를 30분으로 조정하고, 피크 타임에는 자동 승인으로 전환해요.',
      likeCount: 18,
      dislikeCount: 2,
      commentCount: 6,
      latestComment: AgendaCommentModel(
        id: 'cm-01',
        createdAt: now.subtract(const Duration(minutes: 40)),
        updatedAt: now.subtract(const Duration(minutes: 40)),
        agendaId: 'ag-01',
        content: '피크 타임 기준을 명확히 적어두면 더 좋겠어요.',
        createdBy: 'u-02',
      ),
      author: authors[0],
    ),
    AgendaFeedModel(
      id: 'ag-02',
      createdAt: now.subtract(const Duration(hours: 6)),
      updatedAt: now.subtract(const Duration(hours: 3)),
      title: '팀 위클리 공유 시간 조정',
      description: '월요일 오전 회의를 수요일 오후로 옮겨 집중 시간을 확보해요.',
      likeCount: 9,
      dislikeCount: 1,
      commentCount: 2,
      latestComment: AgendaCommentModel(
        id: 'cm-02',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        agendaId: 'ag-02',
        content: '수요일 오후에는 외부 미팅이 많아서 조정이 필요할 듯해요.',
        createdBy: 'u-03',
      ),
      author: authors[1],
    ),
    AgendaFeedModel(
      id: 'ag-07',
      createdAt: now.subtract(const Duration(hours: 10)),
      updatedAt: now.subtract(const Duration(hours: 9)),
      title: '공지 전달 경험 개선안',
      description:
          '현재 공지 채널이 너무 많아 팀원들이 정보를 놓치는 경우가 잦아요. '
          '공지의 유형을 나누고, 반드시 확인해야 하는 항목은 요약 카드로 상단에 노출하면 어떨까요. '
          '또한 매주 금요일에 지난 공지를 자동으로 리마인드하는 방식도 검토해요.',
      likeCount: 5,
      dislikeCount: 0,
      commentCount: 1,
      latestComment: AgendaCommentModel(
        id: 'cm-07',
        createdAt: now.subtract(const Duration(hours: 8)),
        updatedAt: now.subtract(const Duration(hours: 8)),
        agendaId: 'ag-07',
        content: '요약 카드 위치가 중요할 것 같아요.',
        createdBy: 'u-01',
      ),
      author: authors[2],
    ),
    AgendaFeedModel(
      id: 'ag-03',
      createdAt: now.subtract(const Duration(days: 1, hours: 2)),
      updatedAt: now.subtract(const Duration(days: 1, hours: 1)),
      title: '사내 공지 전달 채널 통합',
      description: '중복 공지를 줄이기 위해 슬랙과 이메일을 통합해요.',
      likeCount: 24,
      dislikeCount: 5,
      commentCount: 8,
      latestComment: AgendaCommentModel(
        id: 'cm-03',
        createdAt: now.subtract(const Duration(hours: 7)),
        updatedAt: now.subtract(const Duration(hours: 7)),
        agendaId: 'ag-03',
        content: '공지 템플릿을 함께 만들면 정착이 빠를 것 같아요.',
        createdBy: 'u-01',
      ),
      author: authors[2],
    ),
    AgendaFeedModel(
      id: 'ag-04',
      createdAt: now.subtract(const Duration(days: 2, hours: 3)),
      updatedAt: now.subtract(const Duration(days: 2)),
      title: '집중 근무 시간대 도입',
      description: '오전 10시부터 12시까지는 미팅을 제한해요.',
      likeCount: 31,
      dislikeCount: 3,
      commentCount: 11,
      latestComment: AgendaCommentModel(
        id: 'cm-04',
        createdAt: now.subtract(const Duration(days: 1, hours: 5)),
        updatedAt: now.subtract(const Duration(days: 1, hours: 5)),
        agendaId: 'ag-04',
        content: '고객 대응 팀은 예외 규칙이 필요해요.',
        createdBy: 'u-02',
      ),
      author: authors[0],
    ),
    AgendaFeedModel(
      id: 'ag-05',
      createdAt: now.subtract(const Duration(days: 3, hours: 5)),
      updatedAt: now.subtract(const Duration(days: 2, hours: 4)),
      title: '리모트 데이 체크인 방식 개선',
      description: '체크인 메시지를 간단 템플릿으로 통일해요.',
      likeCount: 14,
      dislikeCount: 0,
      commentCount: 1,
      latestComment: AgendaCommentModel(
        id: 'cm-05',
        createdAt: now.subtract(const Duration(days: 2, hours: 1)),
        updatedAt: now.subtract(const Duration(days: 2, hours: 1)),
        agendaId: 'ag-05',
        content: '짧게 공유할 수 있어서 좋아요.',
        createdBy: 'u-03',
      ),
      author: authors[1],
    ),
    AgendaFeedModel(
      id: 'ag-06',
      createdAt: now.subtract(const Duration(days: 4)),
      updatedAt: now.subtract(const Duration(days: 3, hours: 6)),
      title: '업무 요청 우선순위 라벨링',
      description: null,
      likeCount: 7,
      dislikeCount: 1,
      commentCount: 0,
      latestComment: null,
      author: authors[2],
    ),
  ];
}
