// ============================================================================
// DTO (corps de requête) de l'API Zemoz — générés depuis le Swagger.
//
// - Chaque classe a un toJson() qui retire les champs null.
// - Les champs "binary" (avatar, logo, image) sont à envoyer en multipart
//   uniquement si le contrat de la route les prévoit.
// - ⚠️ = point à vérifier, voir le commentaire.
// - Les routes sont dans api_url.dart.
// ============================================================================

Map<String, dynamic> _compact(Map<String, dynamic> m) =>
    m..removeWhere((_, v) => v == null);

// =============================================================================
// ENUMS
// =============================================================================
enum Sex { male('MALE'), female('FEMALE'), unknow('UNKNOW'); const Sex(this.value); final String value; }

enum MatchType {
  phaseDePoule('PHASE DE POULE'), huitieme('1/8 FINALE'), quart('1/4 FINALE'),
  demi('1/2 FINALE'), finale('FINALE'), amical('AMICAL');
  const MatchType(this.value); final String value;
}

enum MatchEtat { aVenir('A_VENIR'), enCours('EN_COURS'), terminer('TERMINER'); const MatchEtat(this.value); final String value; }

enum ArbitreRole { principal('principal'), touche('touche'), varRole('var'); const ArbitreRole(this.value); final String value; }

enum ParisType { v1('V1'), x('X'), v2('V2'); const ParisType(this.value); final String value; }

enum ParisState { pending('Pending'), lost('Lost'), won('Won'); const ParisState(this.value); final String value; }

/// Coupon / TournoiCoupon
enum CouponEtat { gagner('GAGNER'), perdu('PERDU'), pending('PENDING'); const CouponEtat(this.value); final String value; }

/// CouponBet / TournoiCouponBet (⚠️ "GAGNE" ici, "GAGNER" pour Coupon)
enum CouponBetEtat { pending('PENDING'), gagne('GAGNE'), perdu('PERDU'); const CouponBetEtat(this.value); final String value; }

enum PronoEtat { gagner('GAGNER'), perdu('PERDU'), unknow('UNKNOW'); const PronoEtat(this.value); final String value; }

enum TicketType { standard('STANDARD'), vip('VIP'), recruteur('RECRUTEUR'); const TicketType(this.value); final String value; }

enum TicketDuree { simple('SIMPLE'), phaseDePoule('PHASE DE POULE'), tournoiComplet('TOURNOI COMPLET'); const TicketDuree(this.value); final String value; }

enum TicketEtat { valide('VALIDE'), utiliser('UTILISER'), supprimer('SUPPRIMER'); const TicketEtat(this.value); final String value; }

enum TicketPosition { entree('ENTREE'), sortie('SORTIE'); const TicketPosition(this.value); final String value; }

enum BetCategory {
  matchResult('MATCH_RESULT'), bothTeamsScore('BOTH_TEAMS_SCORE'),
  matchGoalScorer('MATCH_GOAL_SCORER'), matchTeamQualify('MATCH_TEAM_QUALIFY'),
  firstHalfResult('FIRST_HALF_RESULT'), secondHalfResult('SECOND_HALF_RESULT'),
  competitionWinner('COMPETITION_WINNER'), competitionTopScorer('COMPETITION_TOP_SCORER'),
  competitionTopAssist('COMPETITION_TOP_ASSIST'), yellowCard('YELLOW_CARD'), redCard('RED_CARD');
  const BetCategory(this.value); final String value;
}

enum TransactionType { depot('DEPOT'), retrait('RETRAIT'); const TransactionType(this.value); final String value; }

enum TournoiMemberRole {
  admin('ADMIN'), manager('MANAGER'), scoreKeeper('SCORE_KEEPER'),
  arbitreCoordinator('ARBITRE_COORDINATOR'), billetterie('BILLETTERIE'), tresorier('TRESORIER');
  const TournoiMemberRole(this.value); final String value;
}

// =============================================================================
// AUTH  /account/auth
// =============================================================================

/// POST /account/auth/login
class SigninAccountDto {
  final String? email, phone, identifier;
  final String password;
  const SigninAccountDto({this.email, this.phone, this.identifier, required this.password});
  Map<String, dynamic> toJson() => _compact({
        'email': email, 'phone': phone, 'identifier': identifier, 'password': password,
      });
}

/// POST /account/auth/sendOtp
class SendOtpDto {
  final String? email, phone;
  const SendOtpDto({this.email, this.phone});
  Map<String, dynamic> toJson() => _compact({'email': email, 'phone': phone});
}

/// POST /account/auth/verifyOtp
class VerifyOtpDto {
  final String? email, phone;
  final String code;
  const VerifyOtpDto({this.email, this.phone, required this.code});
  Map<String, dynamic> toJson() => _compact({'email': email, 'phone': phone, 'code': code});
}

// =============================================================================
// USERS  /users
// =============================================================================

/// POST /users/register
class UserRegisterDto {
  final String firstname, lastname, phone, country, password, confirmPass;
  final Sex? sex;
  final String? email;
  const UserRegisterDto({
    required this.firstname, required this.lastname, this.sex, this.email,
    required this.phone, required this.country,
    required this.password, required this.confirmPass,
  });
  Map<String, dynamic> toJson() => _compact({
        'firstname': firstname, 'lastname': lastname, 'sex': sex?.value, 'email': email,
        'phone': phone, 'country': country,
        'password': password, 'confirmPass': confirmPass,
      });
}

/// PATCH /users/update  (multipart : avatar)
class UpdateUserDto {
  final String id;
  final String? firstname, lastname, email, phone, country;
  final Sex? sex;
  final Object? avatar;
  const UpdateUserDto({
    required this.id, this.firstname, this.lastname, this.sex, this.email,
    this.phone, this.country, this.avatar,
  });
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'firstname': firstname, 'lastname': lastname, 'sex': sex?.value,
        'email': email, 'phone': phone, 'country': country, 'avatar': avatar,
      });
}

/// POST /users/reinitialise-pass
class ReinitialisePassDto {
  final String email, password, confirm;
  const ReinitialisePassDto({required this.email, required this.password, required this.confirm});
  Map<String, dynamic> toJson() => {'email': email, 'password': password, 'confirm': confirm};
}

/// POST /users/change-pass
class ChangePassDto {
  final String id, oldpass, newpass, confirm;
  const ChangePassDto({required this.id, required this.oldpass, required this.newpass, required this.confirm});
  Map<String, dynamic> toJson() =>
      {'id': id, 'oldpass': oldpass, 'newpass': newpass, 'confirm': confirm};
}

/// POST /users/bet/delete
class DeleteUserBetDto {
  final String id, userId;
  const DeleteUserBetDto({required this.id, required this.userId});
  Map<String, dynamic> toJson() => {'id': id, 'userId': userId};
}

/// POST /users/ticket/delete
class DeleteUserTicketDto {
  final String id, userId;
  const DeleteUserTicketDto({required this.id, required this.userId});
  Map<String, dynamic> toJson() => {'id': id, 'userId': userId};
}

// =============================================================================
// PLAYERS  /players
// =============================================================================

/// POST /players  (multipart : avatar)
/// ⚠️ Le Swagger référence RegisterAccoutDTO (collision de noms) ; j'ai utilisé
/// PlayerAccoutDTO qui est le vrai DTO joueur.
class PlayerAccountDto {
  final String name, team; // team = id de l'équipe
  final int? age, numeroMaillot;
  final String? phone, poste, statut;
  final Object avatar;
  const PlayerAccountDto({
    required this.name, this.age, this.phone, required this.team,
    this.numeroMaillot, this.poste, this.statut, required this.avatar,
  });
  Map<String, dynamic> toJson() => _compact({
        'name': name, 'age': age, 'phone': phone, 'team': team,
        'numeroMaillot': numeroMaillot, 'poste': poste, 'statut': statut, 'avatar': avatar,
      });
}

/// PATCH /players
class UpdatePlayerDto {
  final String id;
  final String? name, phone, team, poste, statut;
  final int? age, numeroMaillot;
  final Object? avatar;
  const UpdatePlayerDto({
    required this.id, this.name, this.age, this.phone, this.team,
    this.numeroMaillot, this.poste, this.statut, this.avatar,
  });
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'name': name, 'age': age, 'phone': phone, 'team': team,
        'numeroMaillot': numeroMaillot, 'poste': poste, 'statut': statut, 'avatar': avatar,
      });
}

/// POST /players/:id/inscriptions
class TeamPlayerInputDto {
  final String? playerId, poste, statut;
  final String teamId;
  final int? numeroMaillot;
  const TeamPlayerInputDto({this.playerId, required this.teamId, this.numeroMaillot, this.poste, this.statut});
  Map<String, dynamic> toJson() => _compact({
        'playerId': playerId, 'teamId': teamId, 'numeroMaillot': numeroMaillot,
        'poste': poste, 'statut': statut,
      });
}

/// PATCH /players/inscriptions
class UpdateTeamPlayerDto {
  final String id;
  final String? playerId, teamId, poste, statut;
  final int? numeroMaillot;
  const UpdateTeamPlayerDto({required this.id, this.playerId, this.teamId, this.numeroMaillot, this.poste, this.statut});
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'playerId': playerId, 'teamId': teamId,
        'numeroMaillot': numeroMaillot, 'poste': poste, 'statut': statut,
      });
}

// =============================================================================
// TEAMS  /teams
// =============================================================================

/// POST /teams  (multipart : logo)
/// ⚠️ Le Swagger n'expose pas le DTO de création (collision RegisterAccoutDTO).
/// Champs déduits de UpdateTeamDTO et DocTeamOutputDTO : à vérifier.
class TeamAccountDto {
  final String name, coach, commune;
  final int? points, matchJoues, butMarques, butConcedes;
  final List<Map<String, dynamic>>? joueurs;
  final Object? logo;
  final String? tournoiId;
  const TeamAccountDto({
    required this.name, required this.coach, required this.commune,
    this.points, this.matchJoues, this.butMarques, this.butConcedes,
    this.joueurs, this.logo, this.tournoiId,
  });
  Map<String, dynamic> toJson() => _compact({
        'name': name, 'coach': coach, 'commune': commune, 'points': points,
        'matchJoues': matchJoues, 'butMarques': butMarques, 'butConcedes': butConcedes,
        'joueurs': joueurs, 'logo': logo, 'tournoiId': tournoiId,
      });
}

/// PATCH /teams
class UpdateTeamDto {
  final String id;
  final String? name, coach, commune, tournoiId;
  final int? points, matchJoues, butMarques, butConcedes;
  final List<Map<String, dynamic>>? joueurs;
  final Object? logo;
  const UpdateTeamDto({
    required this.id, this.name, this.coach, this.commune, this.points,
    this.matchJoues, this.butMarques, this.butConcedes, this.joueurs,
    this.logo, this.tournoiId,
  });
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'name': name, 'coach': coach, 'commune': commune, 'points': points,
        'matchJoues': matchJoues, 'butMarques': butMarques, 'butConcedes': butConcedes,
        'joueurs': joueurs, 'logo': logo, 'tournoiId': tournoiId,
      });
}

// =============================================================================
// POULES  /poules
// =============================================================================
// ⚠️ La clé JSON s'appelle "nom de la poule" (avec espaces) dans le Swagger.
// Vérifie le vrai nom dans le DTO NestJS (probablement un @ApiProperty({name: ...})).

/// POST /poules
class PouleAccountDto {
  final String nomDeLaPoule;
  final List<String> equipes; // ids des équipes
  final String? tournoiId;
  const PouleAccountDto({required this.nomDeLaPoule, required this.equipes, this.tournoiId});
  Map<String, dynamic> toJson() => _compact({
        'nom de la poule': nomDeLaPoule, 'equipes': equipes, 'tournoiId': tournoiId,
      });
}

/// PATCH /poules
class UpdatePouleDto {
  final String id;
  final String? nomDeLaPoule, tournoiId;
  final List<String>? equipes;
  const UpdatePouleDto({required this.id, this.nomDeLaPoule, this.equipes, this.tournoiId});
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'nom de la poule': nomDeLaPoule, 'equipes': equipes, 'tournoiId': tournoiId,
      });
}

// =============================================================================
// ARBITRES  /arbitres   (⚠️ clé "nom de la Arbitre")
// =============================================================================

/// POST /arbitres  (multipart : avatar)
class ArbitreAccountDto {
  final String nomDeLaArbitre, phone;
  final Object avatar;
  final ArbitreRole? role; // défaut : principal
  const ArbitreAccountDto({required this.nomDeLaArbitre, required this.avatar, required this.phone, this.role});
  Map<String, dynamic> toJson() => _compact({
        'nom de la Arbitre': nomDeLaArbitre, 'avatar': avatar, 'phone': phone, 'role': role?.value,
      });
}

/// PATCH /arbitres
class UpdateArbitreDto {
  final String id;
  final String? nomDeLaArbitre, phone;
  final Object? avatar;
  final ArbitreRole? role;
  const UpdateArbitreDto({required this.id, this.nomDeLaArbitre, this.avatar, this.phone, this.role});
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'nom de la Arbitre': nomDeLaArbitre, 'avatar': avatar,
        'phone': phone, 'role': role?.value,
      });
}

// =============================================================================
// INFOS  /infos   (⚠️ clés "titre de la Info" / "description de la Info")
// =============================================================================

/// POST /infos  (multipart : image)
class InfoAccountDto {
  final Object image;
  final String titre, description;
  const InfoAccountDto({required this.image, required this.titre, required this.description});
  Map<String, dynamic> toJson() => {
        'image': image, 'titre de la Info': titre, 'description de la Info': description,
      };
}

/// PATCH /infos
class UpdateInfoDto {
  final String id;
  final Object? image;
  final String? titre, description;
  const UpdateInfoDto({required this.id, this.image, this.titre, this.description});
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'image': image, 'titre de la Info': titre, 'description de la Info': description,
      });
}

// =============================================================================
// MATCHS  /matchs
// =============================================================================

/// Cotes 1X2 d'un match
class OddsDto {
  final num v1, x, v2;
  const OddsDto({required this.v1, required this.x, required this.v2});
  Map<String, dynamic> toJson() => {'V1': v1, 'X': x, 'V2': v2};
}

/// POST /matchs
/// ⚠️ `scores` et `events` : structure non détaillée dans le Swagger (objets vides).
class MatchAccountDto {
  final String lieu, home, away, teamQualify;
  final MatchType type;
  final MatchEtat? etat;
  final int? journee, homePenalty, awayPenalty;
  final DateTime date;
  final List<String> arbitres; // ids
  final Map<String, dynamic>? scores;
  final List<Map<String, dynamic>> events;
  final String? poule, tournoiId;
  final bool isProlongation, isTirAuxButs;
  final OddsDto odds;
  const MatchAccountDto({
    required this.lieu, required this.type, this.etat, this.journee,
    required this.date, required this.arbitres, required this.home, required this.away,
    this.scores, this.events = const [], this.poule,
    required this.isProlongation, required this.isTirAuxButs,
    this.homePenalty, this.awayPenalty, required this.teamQualify,
    required this.odds, this.tournoiId,
  });
  Map<String, dynamic> toJson() => _compact({
        'lieu': lieu, 'type': type.value, 'etat': etat?.value, 'journee': journee,
        'date': date.toIso8601String(), 'arbitres': arbitres, 'home': home, 'away': away,
        'scores': scores, 'events': events, 'poule': poule,
        'isProlongation': isProlongation, 'isTirAuxButs': isTirAuxButs,
        'homePenalty': homePenalty, 'awayPenalty': awayPenalty,
        'teamQualify': teamQualify, 'odds': odds.toJson(), 'tournoiId': tournoiId,
      });
}

/// PATCH /matchs
/// ⚠️ Le Swagger utilise aussi ce DTO pour POST /coupons/status.
class UpdateMatchDto {
  final String id;
  final String? lieu, home, away, teamQualify, poule, tournoiId;
  final MatchType? type;
  final MatchEtat? etat;
  final int? journee, homePenalty, awayPenalty;
  final DateTime? date;
  final List<String>? arbitres;
  final Map<String, dynamic>? scores;
  final List<Map<String, dynamic>>? events;
  final bool? isProlongation, isTirAuxButs;
  final OddsDto? odds;
  const UpdateMatchDto({
    required this.id, this.lieu, this.type, this.etat, this.journee, this.date,
    this.arbitres, this.home, this.away, this.scores, this.events, this.poule,
    this.isProlongation, this.isTirAuxButs, this.homePenalty, this.awayPenalty,
    this.teamQualify, this.odds, this.tournoiId,
  });
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'lieu': lieu, 'type': type?.value, 'etat': etat?.value, 'journee': journee,
        'date': date?.toIso8601String(), 'arbitres': arbitres, 'home': home, 'away': away,
        'scores': scores, 'events': events, 'poule': poule,
        'isProlongation': isProlongation, 'isTirAuxButs': isTirAuxButs,
        'homePenalty': homePenalty, 'awayPenalty': awayPenalty,
        'teamQualify': teamQualify, 'odds': odds?.toJson(), 'tournoiId': tournoiId,
      });
}

/// PATCH /matchs/:id/penalty-scores
class UpdateMatchPenaltyScoreDto {
  final String id;
  final int homePenalty, awayPenalty;
  const UpdateMatchPenaltyScoreDto({required this.id, required this.homePenalty, required this.awayPenalty});
  Map<String, dynamic> toJson() => {'id': id, 'homePenalty': homePenalty, 'awayPenalty': awayPenalty};
}

/// PATCH /matchs/:id/tir-aux-buts
class UpdateMatchPenaltyStateDto {
  final String id;
  const UpdateMatchPenaltyStateDto({required this.id});
  Map<String, dynamic> toJson() => {'id': id};
}

// =============================================================================
// PARIS  /paris
// =============================================================================

/// POST /paris
class ParisAccountDto {
  final String match, user; // ids
  final num odd, amount, potentialGain;
  final ParisType type;
  final ParisState state;
  final bool isWon, isPaid;
  const ParisAccountDto({
    required this.match, required this.odd, required this.type, required this.state,
    required this.amount, required this.potentialGain, required this.isWon,
    required this.isPaid, required this.user,
  });
  Map<String, dynamic> toJson() => {
        'match': match, 'odd': odd, 'type': type.value, 'state': state.value,
        'amount': amount, 'potentialGain': potentialGain, 'isWon': isWon,
        'isPaid': isPaid, 'user': user,
      };
}

/// PATCH /paris
class UpdateParisDto {
  final String id;
  final String? match, user;
  final num? odd, amount, potentialGain;
  final ParisType? type;
  final ParisState? state;
  final bool? isWon, isPaid;
  const UpdateParisDto({
    required this.id, this.match, this.odd, this.type, this.state, this.amount,
    this.potentialGain, this.isWon, this.isPaid, this.user,
  });
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'match': match, 'odd': odd, 'type': type?.value, 'state': state?.value,
        'amount': amount, 'potentialGain': potentialGain, 'isWon': isWon,
        'isPaid': isPaid, 'user': user,
      });
}

// =============================================================================
// BETS  /bets
// =============================================================================

/// POST /bets   (⚠️ `odds` : objet non détaillé dans le Swagger)
class BetAccountDto {
  final BetCategory category;
  final String? matchId, competitionId;
  final Map<String, dynamic> odds;
  const BetAccountDto({required this.category, this.matchId, this.competitionId, required this.odds});
  Map<String, dynamic> toJson() => _compact({
        'category': category.value, 'matchId': matchId,
        'competitionId': competitionId, 'odds': odds,
      });
}

/// PATCH /bets
class UpdateBetDto {
  final String id;
  final BetCategory? category;
  final String? matchId, competitionId;
  final Map<String, dynamic>? odds;
  const UpdateBetDto({required this.id, this.category, this.matchId, this.competitionId, this.odds});
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'category': category?.value, 'matchId': matchId,
        'competitionId': competitionId, 'odds': odds,
      });
}

// =============================================================================
// COUPONS  /coupons
// =============================================================================

/// POST /coupons   (⚠️ `couponBets` : structure non détaillée dans le Swagger)
class CouponAccountDto {
  final String user;
  final Object couponBets;
  final num totalOdds, amount, gains;
  final CouponEtat etat;
  final bool isDeleted, isPaid;
  const CouponAccountDto({
    required this.user, required this.couponBets, required this.totalOdds,
    required this.amount, required this.gains, required this.etat,
    required this.isDeleted, required this.isPaid,
  });
  Map<String, dynamic> toJson() => {
        'user': user, 'couponBets': couponBets, 'totalOdds': totalOdds, 'amount': amount,
        'gains': gains, 'etat': etat.value, 'isDeleted': isDeleted, 'isPaid': isPaid,
      };
}

/// PATCH /coupons
class UpdateCouponDto {
  final String id;
  final String? user;
  final Object? couponBets;
  final num? totalOdds, amount, gains;
  final CouponEtat? etat;
  final bool? isDeleted, isPaid;
  const UpdateCouponDto({
    required this.id, this.user, this.couponBets, this.totalOdds, this.amount,
    this.gains, this.etat, this.isDeleted, this.isPaid,
  });
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'user': user, 'couponBets': couponBets, 'totalOdds': totalOdds,
        'amount': amount, 'gains': gains, 'etat': etat?.value,
        'isDeleted': isDeleted, 'isPaid': isPaid,
      });
}

// =============================================================================
// COUPON BETS  /coupon-bets
// =============================================================================

/// POST /coupon-bets   (selectedOptions ex. {"V1": 1.85, "X": 3.2})
class CouponBetAccountDto {
  final String bet, coupon;
  final Map<String, num> selectedOptions;
  final CouponBetEtat? etat; // défaut : PENDING
  const CouponBetAccountDto({required this.bet, required this.coupon, required this.selectedOptions, this.etat});
  Map<String, dynamic> toJson() => _compact({
        'bet': bet, 'coupon': coupon, 'selectedOptions': selectedOptions, 'etat': etat?.value,
      });
}

/// PATCH /coupon-bets
class UpdateCouponBetDto {
  final String id;
  final String? bet, coupon;
  final Map<String, num>? selectedOptions;
  final CouponBetEtat? etat;
  const UpdateCouponBetDto({required this.id, this.bet, this.coupon, this.selectedOptions, this.etat});
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'bet': bet, 'coupon': coupon,
        'selectedOptions': selectedOptions, 'etat': etat?.value,
      });
}

// =============================================================================
// PRONOS  /pronos
// =============================================================================

/// POST /pronos
class PrononsticAccountDto {
  final String user, match;
  final int homeScore, awayScore;
  final DateTime? date;
  final PronoEtat etat;
  const PrononsticAccountDto({
    required this.user, required this.match, required this.homeScore,
    required this.awayScore, this.date, required this.etat,
  });
  Map<String, dynamic> toJson() => _compact({
        'user': user, 'match': match, 'homeScore': homeScore, 'awayScore': awayScore,
        'date': date?.toIso8601String(), 'etat': etat.value,
      });
}

/// PATCH /pronos
class UpdatePrononsticDto {
  final String id;
  final String? user, match;
  final int? homeScore, awayScore;
  final DateTime? date;
  final PronoEtat? etat;
  const UpdatePrononsticDto({
    required this.id, this.user, this.match, this.homeScore, this.awayScore, this.date, this.etat,
  });
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'user': user, 'match': match, 'homeScore': homeScore, 'awayScore': awayScore,
        'date': date?.toIso8601String(), 'etat': etat?.value,
      });
}

// =============================================================================
// TICKETS  /tickets
// =============================================================================

/// POST /tickets
/// ⚠️ Le DTO de création n'apparaît pas dans le Swagger (collision RegisterAccoutDTO).
/// Champs déduits de UpdateTicketDTO : vérifie lesquels sont obligatoires.
class TicketAccountDto {
  final TicketType? type;
  final TicketDuree? duree;
  final TicketEtat? etat;
  final TicketPosition? position;
  final String? user;
  final num? amount;
  final DateTime? date, lastScanDate;
  final List<String>? matchs;
  final bool? isDeleted;
  const TicketAccountDto({
    this.type, this.duree, this.etat, this.position, this.user, this.amount,
    this.date, this.lastScanDate, this.matchs, this.isDeleted,
  });
  Map<String, dynamic> toJson() => _compact({
        'type': type?.value, 'duree': duree?.value, 'etat': etat?.value,
        'position': position?.value, 'user': user, 'amount': amount,
        'date': date?.toIso8601String(), 'lastScanDate': lastScanDate?.toIso8601String(),
        'matchs': matchs, 'isDeleted': isDeleted,
      });
}

/// PATCH /tickets
class UpdateTicketDto {
  final String id;
  final TicketType? type;
  final TicketDuree? duree;
  final TicketEtat? etat;
  final TicketPosition? position;
  final String? user;
  final num? amount;
  final DateTime? date, lastScanDate;
  final List<String>? matchs;
  final bool? isDeleted;
  const UpdateTicketDto({
    required this.id, this.type, this.duree, this.etat, this.position, this.user,
    this.amount, this.date, this.lastScanDate, this.matchs, this.isDeleted,
  });
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'type': type?.value, 'duree': duree?.value, 'etat': etat?.value,
        'position': position?.value, 'user': user, 'amount': amount,
        'date': date?.toIso8601String(), 'lastScanDate': lastScanDate?.toIso8601String(),
        'matchs': matchs, 'isDeleted': isDeleted,
      });
}

// =============================================================================
// TRANSACTIONS  /transactions
// =============================================================================

/// POST /transactions  et  POST /transactions/user-transaction
class TransactionAccountDto {
  final num amount, frais;
  final TransactionType type;
  final String phone, admin, user, pass;
  const TransactionAccountDto({
    required this.amount, required this.frais, required this.type,
    required this.phone, required this.admin, required this.user, required this.pass,
  });
  Map<String, dynamic> toJson() => {
        'amount': amount, 'frais': frais, 'type': type.value,
        'phone': phone, 'admin': admin, 'user': user, 'pass': pass,
      };
}

/// PATCH /transactions
class UpdateTransactionDto {
  final String id;
  final num? amount, frais;
  final TransactionType? type;
  final String? phone, admin, user, pass;
  const UpdateTransactionDto({
    required this.id, this.amount, this.frais, this.type, this.phone,
    this.admin, this.user, this.pass,
  });
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'amount': amount, 'frais': frais, 'type': type?.value,
        'phone': phone, 'admin': admin, 'user': user, 'pass': pass,
      });
}

// =============================================================================
// FORGOT PASS / OTP
// =============================================================================

/// POST /forgotpass  et  POST /forgotpass/verify-code
class ForgotPassAccountDto {
  final String code, email;
  const ForgotPassAccountDto({required this.code, required this.email});
  Map<String, dynamic> toJson() => {'code': code, 'email': email};
}

/// POST /otp
/// ⚠️ Le Swagger indique un simple "string" comme corps ; OtpAccountDto est le
/// DTO existant, à confirmer.
class OtpAccountDto {
  final String code;
  final String? phone, email;
  final bool isVerified;
  final DateTime expiresAt;
  const OtpAccountDto({
    required this.code, this.phone, this.email, this.isVerified = false, required this.expiresAt,
  });
  Map<String, dynamic> toJson() => _compact({
        'code': code, 'phone': phone, 'email': email,
        'isVerified': isVerified, 'expiresAt': expiresAt.toIso8601String(),
      });
}

// =============================================================================
// TOURNOIS  /tournois
// =============================================================================

/// POST /tournois
/// ⚠️ Le DTO de création n'apparaît pas dans le Swagger (collision RegisterAccoutDTO).
/// Champs déduits de UpdateTournoiDTO / DocTournoiOutputDTO : à vérifier.
class TournoiAccountDto {
  final String name, editionName;
  final int? edition;
  final DateTime? annee;
  const TournoiAccountDto({required this.name, required this.editionName, this.edition, this.annee});
  Map<String, dynamic> toJson() => _compact({
        'name': name, 'editionName': editionName, 'edition': edition,
        'annee': annee?.toIso8601String(),
      });
}

/// PATCH /tournois
class UpdateTournoiDto {
  final String id;
  final String? name, editionName;
  final int? edition;
  final DateTime? annee;
  const UpdateTournoiDto({required this.id, this.name, this.editionName, this.edition, this.annee});
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'name': name, 'editionName': editionName, 'edition': edition,
        'annee': annee?.toIso8601String(),
      });
}

/// POST /tournois/:tournoiId/members
class AddTournoiMemberDto {
  final String accountId;
  final TournoiMemberRole role;
  const AddTournoiMemberDto({required this.accountId, required this.role});
  Map<String, dynamic> toJson() => {'accountId': accountId, 'role': role.value};
}

/// PATCH /tournois/:tournoiId/members/:memberId
class UpdateTournoiMemberDto {
  final TournoiMemberRole? role;
  final bool? isActive;
  const UpdateTournoiMemberDto({this.role, this.isActive});
  Map<String, dynamic> toJson() => _compact({'role': role?.value, 'isActive': isActive});
}

// =============================================================================
// TOURNOI COUPONS  /tournoi-coupons
// =============================================================================

/// POST /tournoi-coupons   (⚠️ `tournoiCouponBets` : structure non détaillée)
class TournoiCouponAccountDto {
  final String user;
  final Object tournoiCouponBets;
  final num totalOdds, amount, gains;
  final CouponEtat etat;
  final bool isDeleted, isPaid;
  const TournoiCouponAccountDto({
    required this.user, required this.tournoiCouponBets, required this.totalOdds,
    required this.amount, required this.gains, required this.etat,
    required this.isDeleted, required this.isPaid,
  });
  Map<String, dynamic> toJson() => {
        'user': user, 'tournoiCouponBets': tournoiCouponBets, 'totalOdds': totalOdds,
        'amount': amount, 'gains': gains, 'etat': etat.value,
        'isDeleted': isDeleted, 'isPaid': isPaid,
      };
}

/// PATCH /tournoi-coupons
class UpdateTournoiCouponDto {
  final String id;
  final String? user;
  final Object? tournoiCouponBets;
  final num? totalOdds, amount, gains;
  final CouponEtat? etat;
  final bool? isDeleted, isPaid;
  const UpdateTournoiCouponDto({
    required this.id, this.user, this.tournoiCouponBets, this.totalOdds, this.amount,
    this.gains, this.etat, this.isDeleted, this.isPaid,
  });
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'user': user, 'tournoiCouponBets': tournoiCouponBets, 'totalOdds': totalOdds,
        'amount': amount, 'gains': gains, 'etat': etat?.value,
        'isDeleted': isDeleted, 'isPaid': isPaid,
      });
}

// =============================================================================
// TOURNOI COUPON BETS  /tournoi-coupon-bets
// =============================================================================

/// POST /tournoi-coupon-bets
class TournoiCouponBetAccountDto {
  final String bet, tournoiCoupon;
  final Map<String, num> selectedOptions;
  final CouponBetEtat? etat; // défaut : PENDING
  const TournoiCouponBetAccountDto({
    required this.bet, required this.tournoiCoupon, required this.selectedOptions, this.etat,
  });
  Map<String, dynamic> toJson() => _compact({
        'bet': bet, 'tournoiCoupon': tournoiCoupon,
        'selectedOptions': selectedOptions, 'etat': etat?.value,
      });
}

/// PATCH /tournoi-coupon-bets
class UpdateTournoiCouponBetDto {
  final String id;
  final String? bet, tournoiCoupon;
  final Map<String, num>? selectedOptions;
  final CouponBetEtat? etat;
  const UpdateTournoiCouponBetDto({
    required this.id, this.bet, this.tournoiCoupon, this.selectedOptions, this.etat,
  });
  Map<String, dynamic> toJson() => _compact({
        'id': id, 'bet': bet, 'tournoiCoupon': tournoiCoupon,
        'selectedOptions': selectedOptions, 'etat': etat?.value,
      });
}

// =============================================================================
// MVP  /mvp
// =============================================================================

/// POST /mvp
class MvpAccountDto {
  final String matchId, teamPlayerId, userId;
  final String? playerId;
  const MvpAccountDto({required this.matchId, required this.teamPlayerId, this.playerId, required this.userId});
  Map<String, dynamic> toJson() => _compact({
        'matchId': matchId, 'teamPlayerId': teamPlayerId,
        'playerId': playerId, 'userId': userId,
      });
}

// =============================================================================
// QUERY PARAMS (GET / DELETE / PATCH sans corps)
// =============================================================================
// Pagination (toutes les listes GET) : ?page=1&limit=20
// Filtre tournoi : ?tournoiId=...
//   - optionnel : GET /teams, /poules, /matchs
//   - OBLIGATOIRE : GET/DELETE/PATCH state  →  /teams/:id, /poules/:id, /matchs/:id,
//     /teams/state/:id, /poules/state/:id, /matchs/state/:id, /matchs/events/:id
// GET /teams/search     : name, coach, commune (requis), points, matchJoues,
//                         butMarques, butConcedes, logo, tournoiId
// GET /tournois/search  : name, editionName (requis), edition, annee
// GET /users/search     : email, phone
// GET /arbitres/search  : nom de la Arbitre, avatar, phone (requis), role
