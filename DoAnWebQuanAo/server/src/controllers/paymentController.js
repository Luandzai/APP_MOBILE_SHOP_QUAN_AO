// server/src/controllers/paymentController.js
const pool = require("../config/db");
const { verifyReturnUrl } = require("../utils/vnpay");
// 1. IMPORT TIỆN ÍCH CỦA MOMO
const { verifyIpnSignature, verifyReturnSignature } = require("../utils/momo");

// 1. Xử lý khi người dùng được VNPAY trả về (vnpay_return)
exports.vnpayReturn = async (req, res) => {
  const vnp_Params = req.query;
  const isVerified = verifyReturnUrl(vnp_Params);

  // === ĐÂY LÀ DÒNG ĐÃ ĐƯỢC CẤU HÌNH ===
  // Nó sẽ đọc CLIENT_URL từ .env, nếu không thấy, nó mới dùng localhost
  const clientReturnUrl = `${
    process.env.CLIENT_URL || "http://localhost:5173"
  }`;
  // ===================================

  if (isVerified) {
    const vnp_ResponseCode = vnp_Params["vnp_ResponseCode"];
    const vnp_TxnRef = vnp_Params["vnp_TxnRef"]; // Mã đơn hàng
    const vnp_TransactionNo = vnp_Params["vnp_TransactionNo"]; // Mã giao dịch VNPAY

    // === CẬP NHẬT DB NGAY TẠI ĐÂY (backup cho trường hợp IPN không tới được) ===
    const connection = await pool.getConnection();
    try {
      const [orders] = await connection.query(
        "SELECT * FROM donhang WHERE DonHangID = ?",
        [vnp_TxnRef]
      );

      if (orders.length > 0 && orders[0].TrangThai === "CHUA_THANH_TOAN") {
        if (vnp_ResponseCode === "00") {
          // Thanh toán thành công -> DANG_XU_LY
          await connection.query(
            "UPDATE donhang SET TrangThai = ? WHERE DonHangID = ?",
            ["DANG_XU_LY", vnp_TxnRef]
          );
          await connection.query(
            "UPDATE thanhtoan SET TrangThai = ?, MaGiaoDich = ? WHERE DonHangID = ?",
            ["SUCCESS", vnp_TransactionNo, vnp_TxnRef]
          );
        } else {
          // Thanh toán thất bại -> DA_HUY
          await connection.query(
            "UPDATE donhang SET TrangThai = ? WHERE DonHangID = ?",
            ["DA_HUY", vnp_TxnRef]
          );
          await connection.query(
            "UPDATE thanhtoan SET TrangThai = ?, MaGiaoDich = ? WHERE DonHangID = ?",
            ["FAILED", vnp_TransactionNo, vnp_TxnRef]
          );
        }
      }
    } catch (error) {
      console.error("Lỗi cập nhật DB trong vnpayReturn:", error);
    } finally {
      connection.release();
    }
    // === KẾT THÚC CẬP NHẬT DB ===

    if (vnp_ResponseCode === "00") {
      // Thanh toán thành công -> Chuyển hướng về trang Kết quả
      res.redirect(
        `${clientReturnUrl}/payment/result?success=true&orderId=${vnp_TxnRef}`
      );
    } else {
      // Thanh toán thất bại -> Chuyển hướng về trang Kết quả
      res.redirect(
        `${clientReturnUrl}/payment/result?success=false&orderId=${vnp_TxnRef}`
      );
    }
  } else {
    // Chữ ký không hợp lệ
    res.redirect(
      `${clientReturnUrl}/payment/result?success=false&message=InvalidSignature`
    );
  }
};

// 2. Xử lý khi VNPAY gọi IPN (Instant Payment Notification)
exports.vnpayIpn = async (req, res) => {
  const vnp_Params = req.query;
  const isVerified = verifyReturnUrl(vnp_Params);

  if (isVerified) {
    const vnp_ResponseCode = vnp_Params["vnp_ResponseCode"];
    const vnp_TxnRef = vnp_Params["vnp_TxnRef"]; // Mã đơn hàng (DonHangID)
    const vnp_TransactionNo = vnp_Params["vnp_TransactionNo"]; // Mã giao dịch VNPAY

    const connection = await pool.getConnection();
    try {
      // 1. Kiểm tra CSDL
      const [orders] = await connection.query(
        "SELECT * FROM donhang WHERE DonHangID = ?",
        [vnp_TxnRef]
      );
      if (orders.length === 0) {
        return res.json({ RspCode: "01", Message: "Order not found" });
      }

      const order = orders[0];
      // Chỉ xử lý nếu trạng thái là CHUA_THANH_TOAN
      if (order.TrangThai !== "CHUA_THANH_TOAN") {
        return res.json({ RspCode: "02", Message: "Order already confirmed" });
      }

      // 2. Nếu thanh toán thành công ("00")
      if (vnp_ResponseCode === "00") {
        // Cập nhật trạng thái đơn hàng -> DANG_XU_LY
        await connection.query(
          "UPDATE donhang SET TrangThai = ? WHERE DonHangID = ?",
          ["DANG_XU_LY", vnp_TxnRef]
        );
        // Cập nhật trạng thái thanh toán -> SUCCESS
        await connection.query(
          "UPDATE thanhtoan SET TrangThai = ?, MaGiaoDich = ? WHERE DonHangID = ?",
          ["SUCCESS", vnp_TransactionNo, vnp_TxnRef]
        );
      } else {
        // Nếu thanh toán thất bại -> DA_HUY
        await connection.query(
          "UPDATE donhang SET TrangThai = ? WHERE DonHangID = ?",
          ["DA_HUY", vnp_TxnRef]
        );
        await connection.query(
          "UPDATE thanhtoan SET TrangThai = ?, MaGiaoDich = ? WHERE DonHangID = ?",
          ["FAILED", vnp_TransactionNo, vnp_TxnRef]
        );
        // Lưu ý: Trigger 'trig_before_update_don_hang_huy' sẽ tự động hoàn kho
      }

      // 3. Phản hồi cho VNPAY
      res.json({ RspCode: "00", Message: "Success" });
    } catch (error) {
      console.error("Lỗi khi xử lý IPN:", error);
      res.json({ RspCode: "97", Message: "Internal Error" });
    } finally {
      connection.release();
    }
  } else {
    // Chữ ký không hợp lệ
    res.json({ RspCode: "97", Message: "Invalid Checksum" });
  }
};

// === 3. THÊM HÀM MỚI CHO MOMO RETURN ===
exports.momoReturn = async (req, res) => {
  // MoMo trả về qua query params
  const queryParams = req.query;
  const clientReturnUrl = `${
    process.env.CLIENT_URL || "http://localhost:5173"
  }`;

  // Tách orderId từ chuỗi "ID_timestamp"
  const donHangID = queryParams.orderId
    ? queryParams.orderId.split("_")[0]
    : null;

  try {
    // 1. Xác thực chữ ký (sử dụng hàm đã import từ utils/momo.js)
    const isVerified = verifyReturnSignature(queryParams);
    if (!isVerified) {
      console.error("Lỗi xác thực chữ ký MoMo Return");
      return res.redirect(
        `${clientReturnUrl}/payment/result?success=false&message=InvalidSignature`
      );
    }

    // 2. Kiểm tra kết quả (so sánh cả string và number vì MoMo có thể trả về cả 2)
    if (queryParams.resultCode === "0" || queryParams.resultCode === 0) {
      // Thành công
      // Chúng ta không cập nhật CSDL ở đây, chúng ta chờ IPN
      // Chỉ chuyển hướng người dùng
      res.redirect(
        `${clientReturnUrl}/payment/result?success=true&orderId=${donHangID}`
      );
    } else {
      // Thất bại
      res.redirect(
        `${clientReturnUrl}/payment/result?success=false&orderId=${donHangID}`
      );
    }
  } catch (error) {
    console.error("Lỗi xử lý MoMo Return:", error);
    res.redirect(
      `${clientReturnUrl}/payment/result?success=false&message=ServerError`
    );
  }
};

// === 4. THÊM HÀM MỚI CHO MOMO IPN (POST) ===
exports.momoIpn = async (req, res) => {
  // MoMo IPN gửi bằng POST, body là JSON
  const requestBody = req.body;

  try {
    // 1. Xác thực chữ ký (sử dụng hàm đã import từ utils/momo.js)
    const isVerified = verifyIpnSignature(requestBody);
    if (!isVerified) {
      console.error("Lỗi xác thực chữ ký MoMo IPN");
      return res.status(400).send("Invalid Signature");
    }

    const { orderId, resultCode, transId } = requestBody;
    const donHangID = orderId.split("_")[0]; // Tách ID đơn hàng

    const connection = await pool.getConnection();
    try {
      const [orders] = await connection.query(
        "SELECT * FROM donhang WHERE DonHangID = ?",
        [donHangID]
      );
      if (orders.length === 0) {
        return res.status(400).send("Order not found");
      }
      if (orders[0].TrangThai !== "CHUA_THANH_TOAN") {
        return res.status(204).send(); // Bỏ qua nếu đơn hàng đã được xử lý
      }

      if (resultCode === 0 || resultCode === "0") {
        // Thành công
        await connection.query(
          "UPDATE donhang SET TrangThai = ? WHERE DonHangID = ?",
          ["DANG_XU_LY", donHangID]
        );
        await connection.query(
          "UPDATE thanhtoan SET TrangThai = ?, MaGiaoDich = ? WHERE DonHangID = ?",
          ["SUCCESS", transId, donHangID]
        );
      } else {
        // Thất bại
        await connection.query(
          "UPDATE donhang SET TrangThai = ? WHERE DonHangID = ?",
          ["DA_HUY", donHangID]
        );
        await connection.query(
          "UPDATE thanhtoan SET TrangThai = ?, MaGiaoDich = ? WHERE DonHangID = ?",
          ["FAILED", transId, donHangID]
        );
      }

      // Phản hồi 204 No Content cho MoMo
      res.status(204).send();
    } catch (error) {
      console.error("Lỗi CSDL khi xử lý MoMo IPN:", error);
      res.status(500).send("Internal Server Error");
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error("Lỗi xử lý MoMo IPN:", error);
    res.status(500).send("Internal Server Error");
  }
};
