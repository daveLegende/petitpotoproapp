class UserTicket {
  const UserTicket({
    required this.id,
    required this.type,
    required this.duration,
    required this.status,
    required this.position,
    required this.amount,
    required this.date,
    required this.matchCount,
  });

  final String id;
  final String type;
  final String duration;
  final String status;
  final String position;
  final num? amount;
  final DateTime? date;
  final int matchCount;
}
