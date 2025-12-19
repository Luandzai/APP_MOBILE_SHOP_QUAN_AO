// server/src/utils/momo.js
const crypto = require("crypto");
const axios = require("axios"); // Đảm bảo bạn đã cài: npm install axios
require("dotenv").config();

// Hàm tạo chữ ký HMAC-SHA256
function createSignature(rawSignature, secretKey) {
  return crypto
    .createHmac("sha256", secretKey)
    .update(rawSignature)
    .digest("hex");
}

// Hàm sắp xếp (giống VNPAY)
function sortObject(obj) {
  let sorted = {};
  let str = [];
  let key;
  // Sửa lỗi hasOwnProperty
  str = Object.keys(obj);

  str.sort(); // Sắp xếp mảng các key

  for (key = 0; key < str.length; key++) {
    const sortedKey = str[key];
    sorted[sortedKey] = encodeURIComponent(obj[sortedKey]).replace(/%20/g, "+");
  }
  return sorted;
}

/**
 * @param {string} DonHangID Mã đơn hàng
 * @param {number} TongThanhToan Tổng số tiền
 * @param {string} orderInfo Mô tả đơn hàng
 */
exports.createPaymentRequest = async (
  DonHangID,
  TongThanhToan,
  orderInfo = "Thanh toan don hang"
) => {
  const partnerCode = process.env.MOMO_PARTNER_CODE;
  const accessKey = process.env.MOMO_ACCESS_KEY;
  const secretKey = process.env.MOMO_SECRET_KEY;
  const apiEndpoint = process.env.MOMO_API_ENDPOINT;

  // URL backend của bạn (dùng cho IPN và Return)
  // (Sử dụng ngrok hoặc domain thật khi deploy)
  const backendUrl = process.env.BACKEND_URL || "http://localhost:5000";

  const redirectUrl = `${backendUrl}/api/payment/momo_return`;
  const ipnUrl = `${backendUrl}/api/payment/momo_ipn`;
  const amount = TongThanhToan.toString();
  const orderId = DonHangID.toString() + "_" + new Date().getTime(); // MoMo yêu cầu orderId duy nhất
  const requestId = orderId;
  const requestType = "captureWallet"; // Loại thanh toán QR
  const extraData = ""; // Có thể để trống

  // 1. Chuỗi (string) để tạo chữ ký
  const rawSignature =
    `accessKey=${accessKey}` +
    `&amount=${amount}` +
    `&extraData=${extraData}` +
    `&ipnUrl=${ipnUrl}` +
    `&orderId=${orderId}` +
    `&orderInfo=${orderInfo}` +
    `&partnerCode=${partnerCode}` +
    `&redirectUrl=${redirectUrl}` +
    `&requestId=${requestId}` +
    `&requestType=${requestType}`;

  // 2. Tạo chữ ký
  const signature = createSignature(rawSignature, secretKey);

  // 3. Body của request
  const requestBody = {
    partnerCode: partnerCode,
    accessKey: accessKey,
    requestId: requestId,
    amount: amount,
    orderId: orderId,
    orderInfo: orderInfo,
    redirectUrl: redirectUrl,
    ipnUrl: ipnUrl,
    requestType: requestType,
    extraData: extraData,
    signature: signature,
    lang: "vi",
  };

  try {
    const response = await axios.post(apiEndpoint, requestBody);
    // Trả về payUrl từ MoMo
    return response.data;
  } catch (error) {
    console.error("Lỗi khi tạo yêu cầu MoMo:", error.response.data);
    throw new Error("Không thể tạo yêu cầu thanh toán MoMo.");
  }
};

/**
 * @param {object} body Body của IPN request
 * MoMo IPN signature format (captureWallet):
 * accessKey=$accessKey&amount=$amount&extraData=$extraData&message=$message
 * &orderId=$orderId&orderInfo=$orderInfo&orderType=$orderType&partnerCode=$partnerCode
 * &payType=$payType&requestId=$requestId&responseTime=$responseTime
 * &resultCode=$resultCode&transId=$transId
 */
exports.verifyIpnSignature = (body) => {
  const accessKey = process.env.MOMO_ACCESS_KEY;
  const secretKey = process.env.MOMO_SECRET_KEY;
  const { signature } = body;

  // Tạo rawSignature theo đúng format MoMo yêu cầu
  const rawSignature =
    `accessKey=${accessKey}` +
    `&amount=${body.amount}` +
    `&extraData=${body.extraData || ""}` +
    `&message=${body.message}` +
    `&orderId=${body.orderId}` +
    `&orderInfo=${body.orderInfo}` +
    `&orderType=${body.orderType}` +
    `&partnerCode=${body.partnerCode}` +
    `&payType=${body.payType}` +
    `&requestId=${body.requestId}` +
    `&responseTime=${body.responseTime}` +
    `&resultCode=${body.resultCode}` +
    `&transId=${body.transId}`;

  // Tạo chữ ký mới
  const expectedSignature = createSignature(rawSignature, secretKey);

  // So sánh
  return signature === expectedSignature;
};

/**
 * @param {object} queryParams Query params từ MoMo trả về (Return URL)
 * Cùng format với IPN
 */
exports.verifyReturnSignature = (queryParams) => {
  const accessKey = process.env.MOMO_ACCESS_KEY;
  const secretKey = process.env.MOMO_SECRET_KEY;
  const { signature } = queryParams;

  // Tạo rawSignature theo đúng format MoMo yêu cầu
  const rawSignature =
    `accessKey=${accessKey}` +
    `&amount=${queryParams.amount}` +
    `&extraData=${queryParams.extraData || ""}` +
    `&message=${decodeURIComponent(queryParams.message || "")}` +
    `&orderId=${queryParams.orderId}` +
    `&orderInfo=${decodeURIComponent(queryParams.orderInfo || "")}` +
    `&orderType=${queryParams.orderType}` +
    `&partnerCode=${queryParams.partnerCode}` +
    `&payType=${queryParams.payType}` +
    `&requestId=${queryParams.requestId}` +
    `&responseTime=${queryParams.responseTime}` +
    `&resultCode=${queryParams.resultCode}` +
    `&transId=${queryParams.transId}`;

  const expectedSignature = createSignature(rawSignature, secretKey);

  return signature === expectedSignature;
};
