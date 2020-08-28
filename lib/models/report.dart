class Report {
  String uid;
  Map topics;
  int total;

  Report({
    this.uid,
    this.topics,
    this.total,
  });

  factory Report.fromMap(Map data) {
    return Report(
      uid: data['uid'] ?? '',
      total: data['total'] ?? 0,
      topics: data['topics'] ?? {},
    );
  }
}
