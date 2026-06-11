import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/user_repository.dart';
import '../../shared/widgets/app_button.dart';

class EditAddressScreen extends StatefulWidget {
  final Map<String, dynamic>? existingAddress;
  final String? addressId;

  const EditAddressScreen({
    super.key,
    this.existingAddress,
    this.addressId,
  });

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final MapController _mapController = MapController();
  final _flatController = TextEditingController();
  final _areaController = TextEditingController();
  final _landmarkController = TextEditingController();

  LatLng _currentLocation = const LatLng(23.8103, 90.4125);
  bool _isLoading = false;
  String _orderFor = 'Myself';
  String _saveAs = 'Home';

  final List<String> _saveAsOptions = ['Home', 'Work', 'Hotel', 'Others'];

  @override
  void initState() {
    super.initState();
    if (widget.existingAddress != null) {
      _flatController.text = widget.existingAddress!['flat'] ?? '';
      _areaController.text = widget.existingAddress!['area'] ?? '';
      _landmarkController.text = widget.existingAddress!['landmark'] ?? '';
      _orderFor = widget.existingAddress!['orderFor'] ?? 'Myself';
      _saveAs = widget.existingAddress!['saveAs'] ?? 'Home';
      final lat = widget.existingAddress!['lat'];
      final lng = widget.existingAddress!['lng'];
      if (lat != null && lng != null) {
        _currentLocation = LatLng(lat.toDouble(), lng.toDouble());
      }
    }
  }

  @override
  void dispose() {
    _flatController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (_flatController.text.isEmpty || _areaController.text.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final userId = LocalStorage.instance.getUserId();
      if (userId != null) {
        final userRepo = sl<UserRepository>();

        // ── Delete old address if editing ──
        if (widget.addressId != null) {
          await userRepo.removeAddress(
            userId: userId,
            addressId: widget.addressId!,
          );
        }

        // ── Add new/updated address ──
        await userRepo.addAddress(
          userId: userId,
          address: {
            'flat': _flatController.text,
            'area': _areaController.text,
            'landmark': _landmarkController.text,
            'orderFor': _orderFor,
            'saveAs': _saveAs,
            'lat': _currentLocation.latitude,
            'lng': _currentLocation.longitude,
          },
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.existingAddress != null
                  ? 'Address updated!'
                  : 'Address saved!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.canPop()
              ? context.pop()
              : context.go(AppRouter.addresses);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save address'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        : context.go(AppRouter.addresses),
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
                  Text(
                    widget.existingAddress != null
                        ? 'Edit Address'
                        : 'Add Address',
                    style: AppTextStyles.h3,
                  ),
                ],
              ),
            ),

            // ── Map ──
            SizedBox(
              height: 200,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentLocation,
                  initialZoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.hungryhub.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: AppColors.error,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Form ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Who are you ordering for ──
                    Text('Who are you ordering for?',
                        style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Myself', 'Someone else'].map((option) {
                        final isSelected = _orderFor == option;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _orderFor = option),
                          child: Row(
                            children: [
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
                              const SizedBox(width: 6),
                              Text(option,
                                  style: AppTextStyles.bodySmall),
                              const SizedBox(width: 16),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // ── Save address as ──
                    Text('Save address as *',
                        style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _saveAsOptions.map((option) {
                        final isSelected = _saveAs == option;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _saveAs = option),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.error.withValues(alpha: 0.1)
                                  : Colors.white,
                              borderRadius:
                              BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.error
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              option,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isSelected
                                    ? AppColors.error
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // ── Flat ──
                    TextFormField(
                      controller: _flatController,
                      decoration: InputDecoration(
                        labelText: 'Flat / House no / Floor / Building *',
                        labelStyle: AppTextStyles.caption,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.error),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Area ──
                    TextFormField(
                      controller: _areaController,
                      decoration: InputDecoration(
                        labelText: 'Area / Sector / Locality *',
                        labelStyle: AppTextStyles.caption,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.error),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Landmark ──
                    TextFormField(
                      controller: _landmarkController,
                      decoration: InputDecoration(
                        labelText: 'Nearby landmark (optional)',
                        labelStyle: AppTextStyles.caption,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.error),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Save Button ──
                    AppButton(
                      text: widget.existingAddress != null
                          ? 'Update Address'
                          : 'Save Address',
                      color: AppColors.error,
                      isLoading: _isLoading,
                      onPressed: _saveAddress,
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