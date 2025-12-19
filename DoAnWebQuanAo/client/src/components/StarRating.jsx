// client/src/components/StarRating.jsx

import React from "react";
// KHÔNG CẦN IMPORT 'react-bootstrap-icons' NỮA

// Component này nhận vào 2 props:
// value: Điểm số (ví dụ: 4)
// text: Văn bản đi kèm (ví dụ: "(84 đánh giá)")
const StarRating = ({ value, text }) => {
  return (
    <div className="d-flex align-items-center my-2">
      <span className="me-1" style={{ color: "#f8e825", fontSize: "1.1rem" }}>
        {" "}
        {/* Màu vàng */}
        {/* Logic hiển thị 5 ngôi sao (dùng ký tự Unicode) */}
        {[1, 2, 3, 4, 5].map((star) => (
          <span key={star} style={{ margin: "0 1px" }}>
            {/* ★ là ngôi sao đầy (U+2605)
              ☆ là ngôi sao rỗng (U+2606)
              Nếu value (điểm) >= số sao hiện tại (1, 2, 3...), thì tô đầy
            */}
            {value >= star ? "★" : "☆"}
          </span>
        ))}
      </span>
      {/* Hiển thị văn bản (số lượt đánh giá) */}
      {text && (
        <span className="ms-1 text-muted" style={{ fontSize: "0.9rem" }}>
          {text}
        </span>
      )}
    </div>
  );
};

export default StarRating;
