// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_theme.dart';
import 'package:petitpotopro/core/widgets/auth_required_view.dart';

void main() {
  test('AppTheme maps text roles to StyleText', () {
    final lightBody = AppTheme.lightTheme.textTheme.bodyMedium!;
    final expectedLightBody = StyleText().body;
    expect(lightBody.fontFamily, expectedLightBody.fontFamily);
    expect(lightBody.fontSize, expectedLightBody.fontSize);
    expect(lightBody.color, expectedLightBody.color);

    final darkTitle = AppTheme.darkTheme.textTheme.titleLarge!;
    final expectedDarkTitle = StyleText(isDark: true).title;
    expect(darkTitle.fontFamily, expectedDarkTitle.fontFamily);
    expect(darkTitle.fontSize, expectedDarkTitle.fontSize);
    expect(darkTitle.color, expectedDarkTitle.color);
  });

  testWidgets('AuthRequiredView ouvre la connexion', (tester) async {
    var didRequestSignIn = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AuthRequiredView(
            message: 'Connectez-vous pour continuer.',
            onSignIn: () => didRequestSignIn = true,
          ),
        ),
      ),
    );

    expect(find.text('Connectez-vous pour continuer.'), findsOneWidget);
    await tester.tap(find.text('Se connecter'));
    expect(didRequestSignIn, isTrue);
  });
}
