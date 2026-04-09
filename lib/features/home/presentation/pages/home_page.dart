import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:team_management_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:team_management_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:team_management_app/injection.dart';
import 'package:team_management_app/core/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()..add(GetHomeDataRequested()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if desktop/wide screen
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar for Desktop
          if (isDesktop)
            Container(
              width: 280,
              color: AppTheme.surfaceColor,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const _LogoWidget(),
                  const SizedBox(height: 48),
                  _SidebarItem(icon: Icons.dashboard, label: "Dashboard", isActive: true),
                  _SidebarItem(icon: Icons.people, label: "Team Members"),
                  _SidebarItem(icon: Icons.settings, label: "Settings"),
                  const Spacer(),
                  _SidebarItem(
                    icon: Icons.logout, 
                    label: "Logout",
                    onTap: () => getIt<AuthBloc>().add(LogoutRequested()),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          
          // Main Content
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is HomeError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppTheme.errorColor),
                        const SizedBox(height: 16),
                        Text(state.message, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.read<HomeBloc>().add(GetHomeDataRequested()),
                          child: const Text("RETRY"),
                        ),
                      ],
                    ),
                  );
                }

                if (state is HomeLoaded) {
                  final homeData = state.homeData;
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 48 : 24,
                      vertical: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isDesktop) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const _LogoWidget(),
                              IconButton(
                                icon: const Icon(Icons.logout),
                                onPressed: () => getIt<AuthBloc>().add(LogoutRequested()),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                        
                        FadeIn(
                          child: Text(
                            homeData.message ?? "Good Morning,",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 18,
                              color: AppTheme.accentColor.withOpacity(0.8),
                            ),
                          ),
                        ),
                        FadeInDown(
                          child: Text(
                            homeData.user.name,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: isDesktop ? 56 : 32,
                              foreground: Paint()..shader = const LinearGradient(
                                colors: [AppTheme.accentColor, AppTheme.secondaryColor],
                              ).createShader(const Rect.fromLTWH(0.0, 0.0, 400.0, 70.0)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FadeInUp(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.history, size: 14, color: Colors.grey.withOpacity(0.6)),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Last login: ${homeData.user.lastLogin ?? 'Just now'}",
                                    style: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 14, color: Colors.grey.withOpacity(0.6)),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Member since: ${homeData.user.createdAt ?? 'N/A'}",
                                    style: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),
                        
                        // Production Data Section
                        FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.surfaceColor,
                                  AppTheme.primaryColor.withOpacity(0.05),
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ACCOUNT DETAILS",
                                  style: TextStyle(
                                    color: AppTheme.accentColor.withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _ProfileInfoRow(
                                  icon: Icons.alternate_email,
                                  label: "Email Address",
                                  value: homeData.user.email,
                                ),
                                const Divider(height: 32, color: Colors.white10),
                                _ProfileInfoRow(
                                  icon: Icons.fingerprint,
                                  label: "User ID",
                                  value: homeData.user.id,
                                ),
                                const Divider(height: 32, color: Colors.white10),
                                _ProfileInfoRow(
                                  icon: Icons.calendar_month,
                                  label: "Account Created",
                                  value: homeData.user.createdAt ?? "N/A",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LogoWidget extends StatelessWidget {
  const _LogoWidget();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.auto_graph, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Text(
          "TEAMFLOW",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.2),
        ),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({required this.icon, required this.label, this.isActive = false, this.onTap});
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isActive ? AppTheme.primaryColor : Colors.grey),
      title: Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.grey)),
      tileColor: isActive ? AppTheme.primaryColor.withOpacity(0.1) : null,
    );
  }
}
