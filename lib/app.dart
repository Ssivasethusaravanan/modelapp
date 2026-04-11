import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_management_app/core/theme/app_theme.dart';
import 'package:team_management_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:team_management_app/injection.dart';
import 'package:team_management_app/routing/app_router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: MaterialApp.router(
        title: 'Team Management',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: getIt<AppRouter>().router,
      ),
    );
  }
}
