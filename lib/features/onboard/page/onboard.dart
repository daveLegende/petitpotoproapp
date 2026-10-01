import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petitpotopro/common/helpers/constant.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/core/storage/secure_storage.dart';
import 'package:petitpotopro/features/home/home.dart';
import 'package:petitpotopro/features/onboard/model/onboard.dart';
import 'package:petitpotopro/features/onboard/widgets/dot.dart';

class OnboardingScreen extends StatefulWidget {
  static const route = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  bool get _isLast => _index == items.length - 1;

  void _goTo(int page) {
    if (page < 0 || page >= items.length) return;
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _finish() async {
    await sl<SecureStorage>().markOnboardingSeen();
    if (mounted) context.go(HomeScreen.route);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = items[_index];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: items.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => Image.asset(
              items[i].image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primaryDark, AppColors.darkBackground],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.sports_soccer, size: 96, color: mwhite),
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            right: 20,
            child: SafeArea(
              child: TextButton(
                onPressed: _finish,
                child: const Text('Passer'),
              ),
            ),
          ),

          // ── Dégradé sombre en bas ─────────────────────
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.45, 1.0],
                  colors: [
                    mblack.withValues(alpha: 0.25),
                    mtransparent,
                    mblack.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
          ),

          // ── Carte glassmorphism ───────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.8,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: GestureDetector(
                    onHorizontalDragEnd: (d) {
                      final v = d.primaryVelocity ?? 0;
                      if (v < -200) _goTo(_index + 1);
                      if (v > 200) _goTo(_index - 1);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: mwhite.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: mwhite.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Column(
                                  key: ValueKey(_index),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: StyleText().title.copyWith(
                                        color: mwhite,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.description,
                                      style: StyleText().body.copyWith(
                                        color: mwhite.withValues(alpha: 0.75),
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Dots(count: items.length, index: _index),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: _isLast
                                        ? _finish
                                        : () => _goTo(_index + 1),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(140, 52),
                                      backgroundColor: AppColors.secondary,
                                      foregroundColor: mwhite,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text(
                                      _isLast ? 'Commencer' : 'Suivant',
                                      style: StyleText().button.copyWith(
                                        color: mwhite,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
