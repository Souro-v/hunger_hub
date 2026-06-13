import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';

class TipScreen extends StatefulWidget {
  const TipScreen({super.key});

  @override
  State<TipScreen> createState() => _TipScreenState();
}

class _TipScreenState extends State<TipScreen> {
  double _selectedTip = 0;
  final _customTipController = TextEditingController();
  bool _isCustom = false;

  final List<double> _tipOptions = [10, 20, 30, 50];

  @override
  void dispose() {
    _customTipController.dispose();
    super.dispose();
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go(AppRouter.cart),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusCircle),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 16, color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('Tip for Delivery', style: AppTextStyles.h3),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ── Delivery Person ──
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusLG),
                        boxShadow: const[
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 36,
                            backgroundColor: AppColors.divider,
                            child: Icon(Icons.delivery_dining,
                                size: 36, color: AppColors.error),
                          ),
                          const SizedBox(height: 12),
                          Text('Sam Curver', style: AppTextStyles.h3),
                          Text('Your Delivery Partner',
                              style: AppTextStyles.caption),
                          const SizedBox(height: 8),
                          Text(
                            'Show appreciation for your delivery partner\'s hard work!',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Tip Options ──
                    Text('Select Tip Amount', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    Row(
                      children: _tipOptions.map((tip) {
                        final isSelected =
                            _selectedTip == tip && !_isCustom;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _selectedTip = tip;
                              _isCustom = false;
                            }),
                            child: Container(
                              margin: EdgeInsets.only(
                                right: tip != _tipOptions.last ? 8 : 0,
                              ),
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.error
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusMD),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.error
                                      : AppColors.border,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '₹${tip.toStringAsFixed(0)}',
                                    style: AppTextStyles.label.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),

                    // ── No Tip ──
                    GestureDetector(
                      onTap: () => setState(() {
                        _selectedTip = 0;
                        _isCustom = false;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedTip == 0 && !_isCustom
                              ? AppColors.divider
                              : Colors.white,
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusMD),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Center(
                          child: Text('No Tip',
                              style: AppTextStyles.bodyMedium),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Custom Tip ──
                    GestureDetector(
                      onTap: () =>
                          setState(() => _isCustom = !_isCustom),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: _isCustom
                              ? AppColors.error.withValues(alpha:0.05)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusMD),
                          border: Border.all(
                            color: _isCustom
                                ? AppColors.error
                                : AppColors.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text('Custom Amount',
                                style: AppTextStyles.bodyMedium),
                            const Spacer(),
                            if (_isCustom)
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: _customTipController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.right,
                                  decoration: const InputDecoration(
                                    prefixText: '₹',
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  onChanged: (val) {
                                    final parsed = double.tryParse(val);
                                    if (parsed != null) {
                                      setState(
                                              () => _selectedTip = parsed);
                                    }
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Confirm ──
                    AppButton(
                      text: _selectedTip > 0
                          ? 'Add Tip ₹${_selectedTip.toStringAsFixed(0)}'
                          : 'Continue without Tip',
                      color: AppColors.error,
                      onPressed: () => context.pop(_selectedTip),
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
}