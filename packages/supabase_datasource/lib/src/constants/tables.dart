enum SupabaseTables {
  diary("diary"),
  diaryListView("diary_list_view"),
  story("diary_story"),
  media("story_media");

  final String name;

  const SupabaseTables(this.name);
}
