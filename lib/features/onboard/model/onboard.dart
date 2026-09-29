class _OnboardingItem {
  final String image;
  final String title;
  final String description;

  const _OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}

const items = [
  _OnboardingItem(
    image: 'assets/images/onboarding/onboarding_1.png',
    title: 'Tout le football\nau même endroit',
    description:
        'Créez et gérez vos tournois, équipes et matchs en quelques clics.',
  ),
  _OnboardingItem(
    image: 'assets/images/onboarding/onboarding_2.png',
    title: 'Suivez les scores et événements de chaque match en direct',
    description:
        'Scores en temps réel, buteurs, cartons et calendrier toujours à jour.',
  ),
  _OnboardingItem(
    image: 'assets/images/onboarding/onboarding_3.png',
    title: 'Classements et\nstatistiques',
    description:
        'Consultez les classements, les meilleurs buteurs et les performances.',
  ),
];
