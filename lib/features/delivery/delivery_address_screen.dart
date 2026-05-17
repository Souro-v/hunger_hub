import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/user_repository.dart';
import '../../shared/widgets/app_button.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final MapController _mapController = MapController();
  final _flatController = TextEditingController();
  final _areaController = TextEditingController();
  final _landmarkController = TextEditingController();

  LatLng _currentLocation = const LatLng(23.8103, 90.4125); // Dhaka default
  bool _isLoadingLocation = false;
  bool _showForm = false;
  String _orderFor = 'Myself';
  String _saveAs = 'Home';

  final List<String> _saveAsOptions = ['Home', 'Work', 'Hotel', 'Others'];

  @override
  void dispose() {
    _flatController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _accessLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _showForm = true;
        });
        _mapController.move(_currentLocation, 15);
      }
    } catch (e) {
      setState(() => _showForm = true);
    }

    setState(() => _isLoadingLocation = false);
  }

  void _saveAddress() async {
    if (_flatController.text.isEmpty || _areaController.text.isEmpty) return;
    setState(() => _isLoadingLocation = true);

    try {
      final userId = LocalStorage.instance.getUserId();
      if (userId != null) {
        final userRepo = sl<UserRepository>();
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
      }
    } catch (e) {
      // ignore error, still navigate
    }

    setState(() => _isLoadingLocation = false);
    if (mounted) context.go(AppRouter.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Map ──
          SizedBox(
            height: _showForm ? 250 : 420,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation,
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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

          // ── Access Location Button ──
          if (!_showForm)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                      text: 'ACCESS LOCATION',
                      isLoading: _isLoadingLocation,
                      color: AppColors.secondary,
                      icon: Icons.location_on_outlined,
                      onPressed: _accessLocation,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'DFOOD WILL ACCESS YOUR LOCATION\nONLY WHILE USING THE APP',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

          // ── Address Form ──
          if (_showForm)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter complete address', style: AppTextStyles.h2),
                    const SizedBox(height: 16),

                    // ── Who are you ordering for ──
                    // ── Who are you ordering for ──
                    Text('Who are you ordering for?',
                        style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Myself', 'Someone else'].map((option) {
                        final isSelected = _orderFor == option;
                        return GestureDetector(
                          onTap: () => setState(() => _orderFor = option),
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
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.error,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 6),
                              Text(option, style: AppTextStyles.bodySmall),
                              const SizedBox(width: 16),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // ── Save address as ──
                    Text('Save address as *', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _saveAsOptions.map((option) {
                        final isSelected = _saveAs == option;
                        return GestureDetector(
                          onTap: () => setState(() => _saveAs = option),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.error.withValues(alpha: 0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
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
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // ── Flat/House ──
                    TextFormField(
                      controller: _flatController,
                      style: AppTextStyles.bodySmall,
                      decoration: InputDecoration(
                        labelText: 'Flat / House no / Floor / Building *',
                        labelStyle: AppTextStyles.caption,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Area ──
                    TextFormField(
                      controller: _areaController,
                      style: AppTextStyles.bodySmall,
                      decoration: InputDecoration(
                        labelText: 'Area / Sector / Locality *',
                        labelStyle: AppTextStyles.caption,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Landmark ──
                    TextFormField(
                      controller: _landmarkController,
                      style: AppTextStyles.bodySmall,
                      decoration: InputDecoration(
                        labelText: 'Nearby landmark (optional)',
                        labelStyle: AppTextStyles.caption,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Save Button ──
                    AppButton(
                      text: 'Save address',
                      color: AppColors.error,
                      onPressed: _saveAddress,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
