import 'package:flutter/material.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';

/// Largeur max du contenu : évite un rendu étiré sur tablette / web.
const double kAuthMaxWidth = 420;

/// En-tête : pastille d'icône, titre et sous-titre.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.subtitleSpan,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  /// Permet de mettre une partie du sous-titre en gras (ex. le contact).
  final InlineSpan? subtitleSpan;

  @override
  Widget build(BuildContext context) {
    final style = StyleText();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppColors.primary, size: 28),
        ),
        const SizedBox(height: 20),
        Text(title, style: style.title),
        const SizedBox(height: 8),
        subtitleSpan == null
            ? Text(subtitle, style: style.desc)
            : Text.rich(subtitleSpan!, style: style.desc),
      ],
    );
  }
}

/// Bannière d'erreur animée. N'occupe aucune place si [message] est null.
class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final text = message;
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.topCenter,
      child: text == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 18,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        text,
                        style: StyleText().caption.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// « Pas encore de compte ? [Créer un compte] » sur une seule ligne.
class AuthLinkRow extends StatelessWidget {
  const AuthLinkRow({
    super.key,
    required this.text,
    required this.action,
    required this.onTap,
  });

  final String text;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = StyleText();
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(text, style: style.caption),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            minimumSize: const Size(0, 40),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(action, style: style.link),
        ),
      ],
    );
  }
}

/// Petit titre de groupe de champs (« IDENTITÉ », « SÉCURITÉ »...).
class AuthSectionLabel extends StatelessWidget {
  const AuthSectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 12),
    child: Text(
      label.toUpperCase(),
      style: StyleText().captionBold.copyWith(
        letterSpacing: 0.8,
        color: AppColors.primary,
      ),
    ),
  );
}