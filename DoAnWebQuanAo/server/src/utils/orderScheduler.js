// server/src/utils/orderScheduler.js
const cron = require("node-cron");
const pool = require("../config/db");

// Thời gian timeout thanh toán (phút)
const PAYMENT_TIMEOUT_MINUTES = 15;

/**
 * Tự động hủy đơn hàng CHUA_THANH_TOAN khi:
 * - Đã quá 15 phút kể từ khi đặt hàng mà vẫn chưa thanh toán
 * 
 * Khi hủy sẽ:
 * - Cập nhật trạng thái đơn hàng thành DA_HUY
 * - Cập nhật trạng thái thanh toán thành FAILED
 * - Hoàn lại tồn kho cho các sản phẩm trong đơn
 */
const startOrderScheduler = () => {
  // Chạy mỗi phút: "* * * * *"
  cron.schedule("* * * * *", async () => {
    const connection = await pool.getConnection();
    try {
      // Tìm các đơn hàng CHUA_THANH_TOAN quá 15 phút
      const [expiredOrders] = await connection.query(
        `SELECT DonHangID FROM donhang 
         WHERE TrangThai = 'CHUA_THANH_TOAN' 
         AND TIMESTAMPDIFF(MINUTE, NgayDatHang, NOW()) >= ?`,
        [PAYMENT_TIMEOUT_MINUTES]
      );

      for (const order of expiredOrders) {
        await connection.beginTransaction();
        try {
          // Cập nhật trạng thái đơn hàng -> DA_HUY
          await connection.query(
            "UPDATE donhang SET TrangThai = 'DA_HUY' WHERE DonHangID = ?",
            [order.DonHangID]
          );

          // Cập nhật thanh toán -> FAILED
          await connection.query(
            "UPDATE thanhtoan SET TrangThai = 'FAILED' WHERE DonHangID = ?",
            [order.DonHangID]
          );

          // Hoàn tồn kho
          const [items] = await connection.query(
            "SELECT PhienBanID, SoLuong FROM chitietdonhang WHERE DonHangID = ?",
            [order.DonHangID]
          );

          for (const item of items) {
            await connection.query(
              "UPDATE phienbansanpham SET SoLuongTonKho = SoLuongTonKho + ? WHERE PhienBanID = ?",
              [item.SoLuong, item.PhienBanID]
            );
          }

          // Thêm vào lịch sử đơn hàng
          await connection.query(
            `INSERT INTO lichsudonhang (DonHangID, TrangThaiCu, TrangThaiMoi, ThoiGian, GhiChu) 
             VALUES (?, 'CHUA_THANH_TOAN', 'DA_HUY', NOW(), ?)`,
            [order.DonHangID, `Tự động hủy do quá ${PAYMENT_TIMEOUT_MINUTES} phút không thanh toán`]
          );

          await connection.commit();
          console.log(
            `[OrderScheduler] Đã tự động hủy đơn hàng #${order.DonHangID} do quá thời gian thanh toán.`
          );
        } catch (err) {
          await connection.rollback();
          console.error(
            `[OrderScheduler] Lỗi hủy đơn #${order.DonHangID}:`,
            err.message
          );
        }
      }
    } catch (error) {
      console.error("[OrderScheduler] Lỗi:", error.message);
    } finally {
      connection.release();
    }
  });

  console.log(
    `✅ Order Scheduler đã khởi động (chạy mỗi phút, hủy đơn chưa thanh toán sau ${PAYMENT_TIMEOUT_MINUTES} phút)`
  );
};

module.exports = { startOrderScheduler, PAYMENT_TIMEOUT_MINUTES };
