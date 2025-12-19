// server/src/utils/voucherScheduler.js
const cron = require("node-cron");
const pool = require("../config/db");

/**
 * Tự động cập nhật trạng thái voucher về INACTIVE khi:
 * 1. Ngày kết thúc (NgayKetThuc) đã qua
 * 2. Số lượng tối đa (SoLuongToiDa) <= 0
 *
 * Lưu ý: Admin vẫn có thể kích hoạt lại voucher bằng cách:
 * - Sử dụng API enableVoucher
 * - Cập nhật NgayKetThuc hoặc SoLuongToiDa qua updateVoucher
 */
const startVoucherScheduler = () => {
  // Chạy mỗi 5 phút: "*/5 * * * *"
  cron.schedule("*/5 * * * *", async () => {
    try {
      const [result] = await pool.query(
        `UPDATE khuyenmai 
         SET TrangThai = 'INACTIVE'
         WHERE TrangThai = 'ACTIVE' 
           AND (NgayKetThuc < NOW() OR SoLuongToiDa <= 0)`
      );

      if (result.affectedRows > 0) {
        console.log(
          `[VoucherScheduler] Đã vô hiệu hóa ${result.affectedRows} voucher hết hạn/hết lượt.`
        );
      }
    } catch (error) {
      console.error("[VoucherScheduler] Lỗi:", error.message);
    }
  });

  console.log("✅ Voucher Scheduler đã khởi động (chạy mỗi 5 phút)");
};

module.exports = { startVoucherScheduler };
