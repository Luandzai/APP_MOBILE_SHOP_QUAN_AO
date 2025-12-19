// client/src/components/ReviewTable.jsx
import React from "react";
import {
  Table,
  Spinner,
  Alert,
  Pagination,
  Button,
  Badge,
} from "react-bootstrap";
import {
  Trash,
  Film,
  Image as ImageIcon,
  ChatDots,
} from "react-bootstrap-icons";
import StarRating from "./StarRating";

const ReviewTable = ({
  reviews,
  loading,
  error,
  pagination,
  setCurrentPage,
  onDelete,
  onReply,
  isProcessing,
}) => {
  const renderPagination = () => {
    if (!pagination.totalPages || pagination.totalPages <= 1) return null;

    const { page, totalPages } = pagination;
    const items = [];
    const maxVisiblePages = 5;
    const sidePages = Math.floor(maxVisiblePages / 2);

    let startPage = Math.max(1, page - sidePages);
    let endPage = Math.min(totalPages, page + sidePages);

    if (endPage - startPage + 1 < maxVisiblePages) {
      if (startPage === 1) {
        endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
      } else if (endPage === totalPages) {
        startPage = Math.max(1, endPage - maxVisiblePages + 1);
      }
    }

    if (startPage > 1) {
      items.push(<Pagination.Item key={1} onClick={() => setCurrentPage(1)}>1</Pagination.Item>);
      if (startPage > 2) {
        items.push(<Pagination.Ellipsis key="ellipsis-start" disabled />);
      }
    }

    for (let number = startPage; number <= endPage; number++) {
      items.push(
        <Pagination.Item key={number} active={number === page} onClick={() => setCurrentPage(number)}>
          {number}
        </Pagination.Item>
      );
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        items.push(<Pagination.Ellipsis key="ellipsis-end" disabled />);
      }
      items.push(<Pagination.Item key={totalPages} onClick={() => setCurrentPage(totalPages)}>{totalPages}</Pagination.Item>);
    }

    return (
      <div className="d-flex justify-content-center p-3 border-top">
        <Pagination>
          <Pagination.First onClick={() => setCurrentPage(1)} disabled={page === 1} />
          <Pagination.Prev onClick={() => setCurrentPage(page - 1)} disabled={page === 1} />
          {items}
          <Pagination.Next onClick={() => setCurrentPage(page + 1)} disabled={page === totalPages} />
          <Pagination.Last onClick={() => setCurrentPage(totalPages)} disabled={page === totalPages} />
        </Pagination>
      </div>
    );
  };

  if (loading) {
    return (
      <div className="text-center py-5">
        <Spinner animation="border" /> Đang tải...
      </div>
    );
  }

  if (error) {
    return (
      <Alert variant="danger" className="m-3">
        {error}
      </Alert>
    );
  }

  if (reviews.length === 0) {
    return (
      <div className="text-center py-5">
        <p className="mb-0 text-muted">Không tìm thấy đánh giá nào.</p>
      </div>
    );
  }

  return (
    <>
      <div key={pagination.page} className="table-content-wrapper">
        <Table hover responsive className="align-middle mb-0">
          <thead className="bg-light">
            <tr>
              <th>ID</th>
              <th>Sản phẩm</th>
              <th>Người dùng</th>
              <th>Đánh giá</th>
              <th>Bình luận</th>
              <th>Media</th>
              <th>Phản hồi</th>
              <th>Ngày tạo</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
          {reviews.map((r) => (
            <tr key={r.DanhGiaID}>
              <td>
                <strong>#{r.DanhGiaID}</strong>
              </td>
              <td>{r.TenSanPham}</td>
              <td>{r.TenNguoiDung}</td>
              <td>
                <StarRating value={r.DiemSo} />
              </td>
              <td>
                <small>{r.BinhLuan.substring(0, 50)}...</small>
              </td>
              <td>
                {r.HinhAnhURL && (
                  <ImageIcon size={20} className="me-2" title="Có hình ảnh" />
                )}
                {r.VideoURL && <Film size={20} title="Có video" />}
              </td>
              {/* [MỚI] Hiển thị trạng thái phản hồi */}
              <td>
                {r.PhanHoi ? (
                  <Badge bg="success">Đã trả lời</Badge>
                ) : (
                  <Badge bg="secondary">Chưa</Badge>
                )}
              </td>
              <td>{new Date(r.NgayTao).toLocaleDateString("vi-VN")}</td>
              <td>
                {/* [MỚI] Nút Trả lời */}
                <Button
                  variant="primary"
                  size="sm"
                  className="me-2"
                  onClick={() => onReply(r)}
                  title="Trả lời"
                >
                  <ChatDots />
                </Button>
                {/* [MỚI] Nút Xóa */}
                <Button
                  variant="danger"
                  size="sm"
                  onClick={() => onDelete(r.DanhGiaID)}
                  disabled={isProcessing}
                  title="Xóa"
                >
                  <Trash />
                </Button>
              </td>
            </tr>
          ))}
          </tbody>
        </Table>
      </div>
      {renderPagination()}
    </>
  );
};

export default ReviewTable;
