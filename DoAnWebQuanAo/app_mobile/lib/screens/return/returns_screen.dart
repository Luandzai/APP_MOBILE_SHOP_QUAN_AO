import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/formatters.dart';
import '../../models/return_request.dart';
import '../../services/return_service.dart';

/// Returns Screen - Danh sách yêu cầu hoàn trả
class ReturnsScreen extends StatefulWidget {
  const ReturnsScreen({super.key});

  @override
  State<ReturnsScreen> createState() => _ReturnsScreenState();
}

class _ReturnsScreenState extends State<ReturnsScreen> {
  final ReturnService _returnService = ReturnService();
  List<ReturnRequest> _returns = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReturns();
  }

  Future<void> _loadReturns() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _returns = await _returnService.getMyReturnRequests();
    } catch (e) {
      _error = 'Không thể tải danh sách hoàn trả';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Yêu cầu hoàn trả'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: AppColors.error)),
            const SizedBox(height: AppSizes.md),
            ElevatedButton(
              onPressed: _loadReturns,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_returns.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_return_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: AppSizes.md),
            Text(
              'Chưa có yêu cầu hoàn trả',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReturns,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        itemCount: _returns.length,
        itemBuilder: (context, index) => _buildReturnCard(_returns[index]),
      ),
    );
  }

  Widget _buildReturnCard(ReturnRequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đơn: ${request.maDonHang}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildStatusBadge(request.trangThai),
              ],
            ),
            const SizedBox(height: 8),
            
            // Date
            Text(
              'Ngày yêu cầu: ${Formatters.date(request.ngayYeuCau)}',
              style: const TextStyle(fontSize: 12, color: AppColors.textHint),
            ),
            
            const SizedBox(height: 8),
            
            // Reason
            Text(
              'Lý do: ${request.lyDoHoanTra}',
              style: const TextStyle(fontSize: 13),
            ),
            
            // Admin note
            if (request.ghiChuAdmin != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(request.ghiChuAdmin!, style: const TextStyle(fontSize: 12))),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String text;
    
    switch (status) {
      case 'CHO_XU_LY':
      case 'PENDING':  // Server có thể trả về tiếng Anh
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade800;
        text = 'Chờ xử lý';
        break;
      case 'DA_DUYET':
      case 'APPROVED':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        text = 'Đã duyệt';
        break;
      case 'TU_CHOI':
      case 'REJECTED':
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade800;
        text = 'Từ chối';
        break;
      case 'HOAN_THANH':
      case 'COMPLETED':
        bgColor = AppColors.success.withAlpha(25);
        textColor = AppColors.success;
        text = 'Hoàn thành';
        break;
      default:
        bgColor = AppColors.surfaceVariant;
        textColor = AppColors.textSecondary;
        text = status;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
