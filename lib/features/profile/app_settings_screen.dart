import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_cubit.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool _locationAccess = true;
  bool _analytics = true;
  bool _crashReports = true;
  String _selectedCurrency = 'INR (₹)';

  final List<String> _currencies = [
    'INR (₹)',
    'BDT (৳)',
    'USD (\$)',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locationAccess = prefs.getBool('setting_location') ?? true;
      _analytics = prefs.getBool('setting_analytics') ?? true;
      _crashReports = prefs.getBool('setting_crash_reports') ?? true;
      _selectedCurrency = prefs.getString('setting_currency') ?? 'INR (₹)';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusCircle),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('App Settings', style: AppTextStyles.h3),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Appearance ──
                    Text('Appearance', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      _buildSwitchTile(
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        subtitle: 'Switch to dark theme',
                        value: context.watch<ThemeCubit>().isDark,
                        onChanged: (_) =>
                            context.read<ThemeCubit>().toggleTheme(),
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // ── Currency ──
                    Text('Currency', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusSM),
                              ),
                              child: const Icon(
                                Icons.currency_exchange,
                                color: AppColors.error,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Currency',
                                style: AppTextStyles.bodyMedium,
                              ),
                            ),
                            DropdownButton<String>(
                              value: _selectedCurrency,
                              underline: const SizedBox(),
                              style: AppTextStyles.bodySmall,
                              items: _currencies
                                  .map((c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedCurrency = val);
                                  _saveSetting('setting_currency', val);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // ── Privacy ──
                    Text('Privacy', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      _buildSwitchTile(
                        icon: Icons.location_on_outlined,
                        title: 'Location Access',
                        subtitle: 'Allow app to access location',
                        value: _locationAccess,
                        onChanged: (val) {
                          setState(() => _locationAccess = val);
                          _saveSetting('setting_location', val);
                        },
                      ),
                      _buildSwitchTile(
                        icon: Icons.analytics_outlined,
                        title: 'Analytics',
                        subtitle: 'Help improve the app',
                        value: _analytics,
                        onChanged: (val) {
                          setState(() => _analytics = val);
                          _saveSetting('setting_analytics', val);
                        },
                      ),
                      _buildSwitchTile(
                        icon: Icons.bug_report_outlined,
                        title: 'Crash Reports',
                        subtitle: 'Send crash reports automatically',
                        value: _crashReports,
                        onChanged: (val) {
                          setState(() => _crashReports = val);
                          _saveSetting('setting_crash_reports', val);
                        },
                      ),
                    ]),
                    const SizedBox(height: 24),
                    // ── Cache ──
                    Text('Storage', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      GestureDetector(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Cache cleared!'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusSM),
                                ),
                                child: const Icon(
                                  Icons.cleaning_services_outlined,
                                  color: AppColors.error,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Clear Cache',
                                        style: AppTextStyles.bodyMedium),
                                    Text('Free up storage space',
                                        style: AppTextStyles.caption),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // ── App Info ──
                    Text('App Info', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      _buildInfoTile(
                        icon: Icons.info_outline,
                        title: 'App Version',
                        value: AppConstants.appVersion,
                      ),
                      _buildInfoTile(
                        icon: Icons.code_outlined,
                        title: 'Build Number',
                        value: AppConstants.buildNumber,
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          final isLast = index == children.length - 1;
          return Column(
            children: [
              child,
              if (!isLast) const Divider(height: 1, indent: 68),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSM),
            ),
            child: Icon(icon, color: AppColors.error, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.label),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.error,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSM),
            ),
            child: Icon(icon, color: AppColors.error, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: AppTextStyles.bodyMedium),
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
