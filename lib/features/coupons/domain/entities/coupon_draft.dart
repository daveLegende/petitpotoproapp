class CouponDraft {
  const CouponDraft({
    required this.userId,
    required this.selections,
    required this.amount,
  });

  final String userId;
  final List<CouponSelection> selections;
  final num amount;

  num get totalOdds =>
      selections.fold<num>(1, (total, item) => total * item.odd);
  num get potentialGains => totalOdds * amount;
}

class CouponSelection {
  const CouponSelection({
    required this.betId,
    required this.option,
    required this.odd,
  });

  final String betId;
  final String option;
  final num odd;
}
