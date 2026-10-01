class TicketPurchase {
  const TicketPurchase({
    required this.userId,
    required this.type,
    required this.duration,
    required this.amount,
    this.matchIds = const [],
  });

  final String userId;
  final String type;
  final String duration;
  final num amount;
  final List<String> matchIds;
}
