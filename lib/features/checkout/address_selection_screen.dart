import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/user_repository.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/loading_widget.dart';

class AddressSelectionScreen extends StatefulWidget {
  const AddressSelectionScreen({super.key});

  @override
  State<AddressSelectionScreen> createState() =>
      _AddressSelectionScreenState();
}

class _AddressSelectionScreenState
    extends State<AddressSelectionScreen> {
  List<Map<String, dynamic>> _addresses = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      final userId = LocalStorage.instance.getUserId();
      if (userId != null) {
        final userRepo = sl<UserRepository>();
        final addresses = await userRepo.getAddresses(userId);
        setState(() {
          _addresses = addresses;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go(AppRouter.checkout),
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
                  Text('Select Address', style: AppTextStyles.h3),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: _isLoading
                  ? const LoadingWidget()
                  : _addresses.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_off_outlined,
                        size: 80, color: AppColors.border),
                    const SizedBox(height: 16),
                    Text('No saved addresses',
                        style: AppTextStyles.h3.copyWith(
                            color: AppColors.textSecondary)),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40),
                      child: AppButton(
                        text: 'Add Address',
                        color: AppColors.error,
                        onPressed: () =>
                            context.go(AppRouter.deliveryAddress),
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20),
                itemCount: _addresses.length + 1,
                itemBuilder: (context, index) {
                  if (index == _addresses.length) {
                    return Padding(
                      padding:
                      const EdgeInsets.only(top: 8),
                      child: GestureDetector(
                        onTap: () => context
                            .go(AppRouter.deliveryAddress),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(
                                AppConstants.radiusLG),
                            border: Border.all(
                              color: AppColors.error,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add,
                                  color: AppColors.error),
                              const SizedBox(width: 8),
                              Text(
                                'Add New Address',
                                style: AppTextStyles.label
                                    .copyWith(
                                    color: AppColors.error),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final address = _addresses[index];
                  final isSelected = _selectedIndex == index;

                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.error.withValues(alpha: 0.05)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusLG),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.error
                              : AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          // ── Radio ──
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.error
                                    : AppColors.border,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration:
                                const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.error,
                                ),
                              ),
                            )
                                : null,
                          ),
                          const SizedBox(width: 12),

                          // ── Icon ──
                          Icon(
                            _getAddressIcon(
                                address['saveAs'] ?? 'Home'),
                            color: isSelected
                                ? AppColors.error
                                : AppColors.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),

                          // ── Info ──
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address['saveAs'] ?? 'Home',
                                  style: AppTextStyles.label
                                      .copyWith(
                                    color: isSelected
                                        ? AppColors.error
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${address['flat'] ?? ''}, ${address['area'] ?? ''}',
                                  style:
                                  AppTextStyles.bodySmall,
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Confirm Button ──
            if (_addresses.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: AppButton(
                  text: 'Deliver to this address',
                  color: AppColors.error,
                  onPressed: () {
                    final selected = _addresses[_selectedIndex];
                    context.pop(selected);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getAddressIcon(String type) {
    switch (type) {
      case 'Home':
        return Icons.home_outlined;
      case 'Work':
        return Icons.work_outline;
      case 'Hotel':
        return Icons.hotel_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }
}