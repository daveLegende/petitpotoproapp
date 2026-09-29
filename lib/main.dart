import 'package:flutter/material.dart';
import 'package:petitpotopro/app.dart';
import 'package:petitpotopro/core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const PetitpotoApp());
}
