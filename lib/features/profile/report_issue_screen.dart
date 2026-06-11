import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String? _selectedCategory;
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _submitted = false;

  final List<String> _categories = [
    'Order Issue',
    'Payment Problem',
    'App Bug',
    'Delivery Issue',
    'Restaurant Issue',
    'Account Problem',
    'Other',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_selectedCategory == null || _descriptionController.text.isEmpty)
      return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _submitted = true;
    });
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
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go(AppRouter.home),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusCircle),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 16, color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('Report Issue', style: AppTextStyles.h3),
                ],
              ),
            ),

            Expanded(
              child: _submitted
                  ? _buildSuccess(context)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Category ──
                          Text('Issue Category', style: AppTextStyles.h3),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _categories.map((category) {
                              final isSelected = _selectedCategory == category;
                              return GestureDetector(
                                onTap: () => setState(
                                    () => _selectedCategory = category),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.error
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusCircle),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.error
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Text(
                                    category,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),

                          // ── Description ──
                          Text('Description', style: AppTextStyles.h3),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radiusMD),
                            ),
                            child: TextField(
                              controller: _descriptionController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: 'Describe your issue in detail...',
                                hintStyle: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textHint,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ── Email ──
                          AppTextField(
                            hint: 'your@email.com',
                            label: 'Contact Email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 32),

                          // ── Submit ──
                          AppButton(
                            text: 'Submit Report',
                            color: AppColors.error,
                            isLoading: _isLoading,
                            onPressed: (_selectedCategory == null ||
                                    _descriptionController.text.isEmpty)
                                ? null
                                : _submitReport,
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text('Report Submitted!', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              'We\'ll look into this and get back to you within 24 hours.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Back to Home',
              color: AppColors.error,
              onPressed: () => context.go(AppRouter.home),
            ),
          ],
        ),
      ),
    );
  }
}
