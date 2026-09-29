import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String phoneDesc =
    "Saisissez votre numéro de téléphone. Un code vous sera envoyé sur ce numéro";
const String otpmsg =
    "Un message contenant un code de 4 chiffres vous a été envoyé sur ";
const String otpmsg2 = "Veuilez saisir le code dans le champ suivant";
const String infoperso =
    "Veuilez entrer vos informations personnelles pour la création de compte";
const String profile = "Veuilez ajouter une photo de profile pour votre compte (Optionnelle)";
const String security = "Veuilez définir un mot de passe pour sécurisé votre compte";

//
// Form Error
final RegExp nameRegExp = RegExp(r'^[a-zA-Z0-9_\- ]{3,}$');

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp passWordRegExp =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

final RegExp phoneRegExp =
    RegExp(r'\+994\s+\([0-9]{2}\)\s+[0-9]{3}\s+[0-9]{2}\s+[0-9]{2}');
// final RegExp passwordRegex = RegExp(r"^(?=.*[A-Za-z0-9]).{6,}$");
final RegExp passwordRegex = RegExp(r"^(?=.*[A-Za-z0-9]).{8,}$");

const String mEmailNullError = "Veuillez entrer votre email";
const String mInvalidEmailError = "Veuillez saisir un e-mail valide";
const String mInvalidNameError = "Veuillez saisir un nom valide";
const String mPassNullError = "Veuillez entrer votre mot de passe";
const String mConfirmPassNullError = "Veuillez confirmer votre mot de passe";
const String mChampVide = 'Ce champ ne peut pass être vide';
const String mShortPassError = "Le mot de passe est trop court";
const String mOldAndNewPassEqual = "Les mots de passe sont identiques";
const String mMatchPassError = "Les mots de passe ne correspondent pas";
const String mNamelNullError = "S'il vous plaît entrez votre nom";
const String mPhoneNumberNullError = "Veuillez entrer un numéro de téléphone";
const String mPhoneNumberInvalide = "Veuillez entrer un numéro valide";
const String mAddressNullError = "Veuillez entrer votre adresse";

var inputFormaters = <TextInputFormatter>[
  FilteringTextInputFormatter.allow(
    RegExp(r'[0-9]'),
  ),
  FilteringTextInputFormatter.digitsOnly,
];

ColorScheme colorScheme = const ColorScheme(
  primary: mColor5,
  primaryContainer: mColor5,
  secondary: mbSeconderedColor,
  secondaryContainer: Colors.white,
  surface: Colors.white,
  error: Colors.red,
  onPrimary: Colors.black,
  onSecondary: Colors.black,
  onSurface: Colors.black,
  onError: Colors.white,
  brightness: Brightness.light,
);

//
const mPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFA573FF), Color(0xFF645AFF)],
);
//
const mbackgGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF121016), Color(0xFF3F3C48)],
);
//
const mchateblueGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF2DC9EB), Color(0xFF14D2B8)],
);
//
const mchateredGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFF15887), Color(0xFFFE9B86)],
);
//
const mbuttonGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color.fromARGB(255, 1, 81, 151), Color(0xFF003E74)],
);
//0xFF1C162E
const mbackgrondColor = Color(0xFF131315);
const mbackgrondColordashbord = Color(0xFF131315);
const mbSeconderedColor = Color(0xFFFF2D55);
const mbSeconderedColorKbe = Color(0xFFFF5F01);
const mbleuColorKbe = Color.fromARGB(255, 1, 81, 151);
const mbSecondebleuColorKbe = Color(0xFF003E74);

const mbnotificationwritColor = Color(0xFF5A7BEF);
// const couleurViolet = Color(0xFF1C162E);

// const mbtnfofaitColor = Color(0xFF50A1FF);
const mblack = Colors.black;
const mtransparent = Colors.transparent;
const mwhite = Colors.white;
const mgrey = Colors.grey;
const mred = Color.fromARGB(255, 245, 20, 4);
const mBotomColor = Color(0xFF1C162E);
const mTextColor = Color(0xFF757575);
const mBeige = Color.fromARGB(255, 252, 245, 232);

const mcardColor = Color(0xFFBEC2CE);
const mcardbtnColor = Color(0xFF242A37);

//
const appBarColor = Color(0xFF1C162E);
// const appFooterColor = Color(0xFF1C162E);

// liste des coloreur du profilr
const mColor1 = Color(0xFF50E3C2);
const mColor2 = Color(0xFF5856D6);
const mColor3 = Color.fromARGB(169, 243, 239, 18);
const mColor4 = Color(0xFF5AC8FA);
const mColor5 = Color(0xFF2E74B5);
const mColor6 = Color.fromARGB(255, 0, 140, 255);
const mColor7 = Color(0xFF000000);
const mColor8 = Color(0xFF4CD964);
const mColor9 = Colors.tealAccent;
