import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/user_repository.dart';
import '../../core/di/injection.dart';
import '../../shared/widgets/app_button.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  List<Map<String, dynamic>> _addresses = [];
  bool _isLoading = true;

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

  Future<void> _deleteAddress(Map<String, dynamic> address) async {
    try {
      final userId = LocalStorage.instance.getUserId();
      if (userId != null) {
        final userRepo = sl<UserRepository>();
        await userRepo.removeAddress(
          userId: userId,
          addressId: address['id'] ?? '', // ← address এর id pass করো
        );
        await _loadAddresses();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete address'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
                  Text('Addresses', style: AppTextStyles.h3),
                ],
              ),
            ),

            // ── Address List ──
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.error,
                      ),
                    )
                  : _addresses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_off_outlined,
                                size: 80,
                                color: AppColors.border,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No addresses saved',
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add a delivery address',
                                style: AppTextStyles.bodySmall,
                              ),
                              const SizedBox(height: 24),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _addresses.length,
                          itemBuilder: (context, index) {
                            final address = _addresses[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusLG),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.shadow,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // ── Icon ──
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.error
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusSM),
                                    ),
                                    child: Icon(
                                      _getAddressIcon(
                                          address['saveAs'] ?? 'Home'),
                                      color: AppColors.error,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // ── Address Info ──
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          address['saveAs'] ?? 'Home',
                                          style: AppTextStyles.label,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${address['flat'] ?? ''}, ${address['area'] ?? ''}',
                                          style: AppTextStyles.bodySmall,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (address['landmark'] != null &&
                                            address['landmark']
                                                .toString()
                                                .isNotEmpty)
                                          Text(
                                            'Near: ${address['landmark']}',
                                            style: AppTextStyles.caption,
                                          ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => context.go(
                                      AppRouter.editAddress,
                                      extra: {
                                        'address': address,
                                        'addressId': address['id'],
                                      },
                                    ),
                                    child: const Icon(
                                      Icons.edit_outlined,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // ── Delete ──
                                  GestureDetector(
                                    onTap: () => _deleteAddress(address),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: AppColors.error,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),

            // ── Add New Address ──
            if (!_isLoading && _addresses.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: AppButton(
                  text: 'Add New Address',
                  color: AppColors.error,
                  onPressed: () => context.go(AppRouter.deliveryAddress),
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
