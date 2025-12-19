import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import 'star_rating.dart';

/// Review Form - Form tạo/chỉnh sửa đánh giá
class ReviewForm extends StatefulWidget {
  final int? initialRating;
  final String? initialContent;
  final List<String>? initialImages;
  final Future<void> Function(int rating, String content, List<String> images) onSubmit;
  final VoidCallback? onCancel;
  final bool isEditing;

  const ReviewForm({
    super.key,
    this.initialRating,
    this.initialContent,
    this.initialImages,
    required this.onSubmit,
    this.onCancel,
    this.isEditing = false,
  });

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  late int _rating;
  late TextEditingController _contentController;
  List<String> _images = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating ?? 5;
    _contentController = TextEditingController(text: widget.initialContent);
    _images = widget.initialImages?.toList() ?? [];
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating
        const Text(
          'Đánh giá của bạn',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSizes.sm),
        Center(
          child: StarRatingInput(
            rating: _rating,
            onChanged: (value) => setState(() => _rating = value),
            size: 40,
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            _getRatingText(_rating),
            style: TextStyle(
              color: _getRatingColor(_rating),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        const SizedBox(height: AppSizes.lg),
        
        // Content
        const Text(
          'Nội dung đánh giá',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSizes.sm),
        TextField(
          controller: _contentController,
          maxLines: 4,
          maxLength: 500,
          decoration: const InputDecoration(
            hintText: 'Chia sẻ trải nghiệm của bạn về sản phẩm...',
            border: OutlineInputBorder(),
          ),
        ),
        
        const SizedBox(height: AppSizes.md),
        
        // Images
        const Text(
          'Hình ảnh (tối đa 5)',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSizes.sm),
        _buildImagePicker(),
        
        const SizedBox(height: AppSizes.lg),
        
        // Buttons
        Row(
          children: [
            if (widget.onCancel != null)
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  child: const Text('Hủy'),
                ),
              ),
            if (widget.onCancel != null)
              const SizedBox(width: AppSizes.sm),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.isEditing ? 'Cập nhật' : 'Gửi đánh giá'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      children: [
        // Existing images
        ..._images.map((url) => _buildImageItem(url)),
        
        // Add button (if less than 5 images)
        if (_images.length < 5)
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider, width: 2),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.textHint,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageItem(String url) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            image: DecorationImage(
              image: url.startsWith('http')
                  ? NetworkImage(url) as ImageProvider
                  : AssetImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => setState(() => _images.remove(url)),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null && _images.length < 5) {
      setState(() {
        _images.add(image.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn số sao')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await widget.onSubmit(_rating, _contentController.text, _images);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1: return 'Rất tệ';
      case 2: return 'Tệ';
      case 3: return 'Bình thường';
      case 4: return 'Tốt';
      case 5: return 'Tuyệt vời';
      default: return '';
    }
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
      case 2: return Colors.red;
      case 3: return Colors.orange;
      case 4:
      case 5: return Colors.green;
      default: return AppColors.textPrimary;
    }
  }
}
