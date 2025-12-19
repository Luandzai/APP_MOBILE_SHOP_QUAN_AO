import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';

/// Edit Profile Screen - Cập nhật thông tin cá nhân
/// 
/// Cho phép user chỉnh sửa họ tên, SĐT, địa chỉ, ngày sinh
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  DateTime? _selectedDate;
  String? _selectedGender;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final user = context.read<AuthProvider>().user;
      _nameController = TextEditingController(text: user?.hoTen ?? '');
      _phoneController = TextEditingController(text: user?.dienThoai ?? '');
      _addressController = TextEditingController(text: user?.diaChi ?? '');
      _selectedDate = user?.ngaySinh;
      _selectedGender = user?.gioiTinh;
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('vi', 'VN'),
    );
    
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    
    final success = await auth.updateProfile(
      hoTen: _nameController.text.trim(),
      dienThoai: _phoneController.text.trim().isNotEmpty 
          ? _phoneController.text.trim() 
          : null,
      diaChi: _addressController.text.trim().isNotEmpty 
          ? _addressController.text.trim() 
          : null,
      ngaySinh: _selectedDate,
      gioiTinh: _selectedGender,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thông tin thành công!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cập nhật tài khoản'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.user == null) {
            return const Center(child: Text('Vui lòng đăng nhập'));
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        auth.user!.initials,
                        style: const TextStyle(
                          color: AppColors.textOnPrimary,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.xl),
                  
                  // Email (disabled)
                  TextFormField(
                    initialValue: auth.user!.email,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: AppStrings.email,
                      prefixIcon: Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.md),
                  
                  // Full name
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: AppStrings.fullName,
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: Validators.fullName,
                  ),
                  
                  const SizedBox(height: AppSizes.md),
                  
                  // Phone
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: AppStrings.phoneNumber,
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      return Validators.phone(value);
                    },
                  ),
                  
                  const SizedBox(height: AppSizes.md),
                  
                  // Address
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: AppStrings.address,
                      prefixIcon: Icon(Icons.location_on_outlined),
                      alignLabelWithHint: true,
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.md),
                  
                  // Date of birth
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: AppStrings.dateOfBirth,
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                          hintText: _selectedDate != null 
                              ? _formatDate(_selectedDate!) 
                              : 'Chọn ngày sinh',
                        ),
                        controller: TextEditingController(
                          text: _selectedDate != null 
                              ? _formatDate(_selectedDate!) 
                              : '',
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.md),
                  
                  // Gender
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: AppStrings.gender,
                      prefixIcon: Icon(Icons.wc_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'NAM', child: Text('Nam')),
                      DropdownMenuItem(value: 'NU', child: Text('Nữ')),
                      DropdownMenuItem(value: 'KHAC', child: Text('Khác')),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedGender = value);
                    },
                  ),
                  
                  const SizedBox(height: AppSizes.xxl),
                  
                  // Save button
                  ElevatedButton(
                    onPressed: auth.isLoading ? null : _handleSave,
                    child: auth.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.textOnPrimary,
                              ),
                            ),
                          )
                        : const Text(AppStrings.save),
                  ),
                  
                  const SizedBox(height: AppSizes.md),
                  
                  // Error message
                  if (auth.error != null)
                    Container(
                      padding: const EdgeInsets.all(AppSizes.sm),
                      decoration: BoxDecoration(
                        color: AppColors.error.withAlpha(25),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, 
                            color: AppColors.error, 
                            size: AppSizes.iconSm,
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Expanded(
                            child: Text(
                              auth.error!,
                              style: const TextStyle(color: AppColors.error),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: AppSizes.iconSm),
                            onPressed: () => auth.clearError(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
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
    );
  }
}
