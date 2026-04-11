import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_management_app/app.dart';
import 'package:team_management_app/core/bloc/app_bloc_observer.dart';
import 'package:team_management_app/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  Bloc.observer = AppBlocObserver();
  runApp(const MainApp());
}
