// server/src/utils/vnpay.js
const crypto = require("crypto");
const qs = require("qs");
require("dotenv").config();

// Hàm sắp xếp key của object
function sortObject(obj) {
  let sorted = {};
  let str = [];
  let key; // Biến này sẽ được dùng làm index

  // === SỬA LỖI TẠI ĐÂY ===
  // Thay thế vòng lặp for...in và hasOwnProperty
  // bằng Object.keys() để lấy mảng các key một cách an toàn
  str = Object.keys(obj);
  // ======================

  str.sort(); // Sắp xếp mảng các key

  for (key = 0; key < str.length; key++) {
    // Lấy tên key từ mảng đã sắp xếp
    const sortedKey = str[key];

    // Gán giá trị vào object mới
    sorted[sortedKey] = encodeURIComponent(obj[sortedKey]).replace(/%20/g, "+");
  }
  return sorted;
}

/**
 * @param {string} DonHangID Mã đơn hàng (ví dụ: 1011)
 * @param {number} TongThanhToan Tổng số tiền (ví dụ: 399000)
 * @param {string} ipAddr Địa chỉ IP của khách
 * @param {string} orderInfo Mô tả đơn hàng
 */
exports.createPaymentUrl = (
  DonHangID,
  TongThanhToan,
  ipAddr,
  orderInfo = "Thanh toan don hang"
) => {
  const tmnCode = process.env.VNPAY_TMN_CODE;
  const secretKey = process.env.VNPAY_HASH_SECRET;
  const vnpUrl = process.env.VNPAY_URL;
  const returnUrl = process.env.VNPAY_RETURN_URL;

  const date = new Date();
  // Định dạng ngày theo YYYYMMDDHHmmss
  const createDate =
    date.getFullYear() +
    ("0" + (date.getMonth() + 1)).slice(-2) +
    ("0" + date.getDate()).slice(-2) +
    ("0" + date.getHours()).slice(-2) +
    ("0" + date.getMinutes()).slice(-2) +
    ("0" + date.getSeconds()).slice(-2);

  const currCode = "VND";
  const locale = "vn";

  let vnp_Params = {};
  vnp_Params["vnp_Version"] = "2.1.0";
  vnp_Params["vnp_Command"] = "pay";
  vnp_Params["vnp_TmnCode"] = tmnCode;
  vnp_Params["vnp_Locale"] = locale;
  vnp_Params["vnp_CurrCode"] = currCode;
  vnp_Params["vnp_TxnRef"] = DonHangID.toString(); // Mã đơn hàng
  vnp_Params["vnp_OrderInfo"] = orderInfo;
  vnp_Params["vnp_OrderType"] = "other";
  vnp_Params["vnp_Amount"] = TongThanhToan * 100; // * 100 theo yêu cầu của VNPAY
  vnp_Params["vnp_ReturnUrl"] = returnUrl;
  vnp_Params["vnp_IpAddr"] = ipAddr;
  vnp_Params["vnp_CreateDate"] = createDate;
  // vnp_Params['vnp_BankCode'] = 'NCB'; // Có thể bỏ trống

  // Sắp xếp và tạo chuỗi query
  vnp_Params = sortObject(vnp_Params);
  const signData = qs.stringify(vnp_Params, { encode: false });

  // Tạo checksum
  const hmac = crypto.createHmac("sha512", secretKey);
  const signed = hmac.update(new Buffer(signData, "utf-8")).digest("hex");

  vnp_Params["vnp_SecureHash"] = signed;

  // Tạo URL thanh toán
  const paymentUrl = vnpUrl + "?" + qs.stringify(vnp_Params, { encode: false });

  return paymentUrl;
};

/**
 * @param {object} vnp_Params Query params từ VNPAY trả về
 */
exports.verifyReturnUrl = (vnp_Params) => {
  const secretKey = process.env.VNPAY_HASH_SECRET;
  const secureHash = vnp_Params["vnp_SecureHash"];

  // Xóa hash ra khỏi params
  delete vnp_Params["vnp_SecureHash"];
  delete vnp_Params["vnp_SecureHashType"];

  // Sắp xếp lại
  const sortedParams = sortObject(vnp_Params);
  const signData = qs.stringify(sortedParams, { encode: false });

  // Tạo checksum
  const hmac = crypto.createHmac("sha512", secretKey);
  const signed = hmac.update(new Buffer(signData, "utf-8")).digest("hex");

  return signed === secureHash;
};
