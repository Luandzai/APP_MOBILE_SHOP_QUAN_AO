// client/src/components/UserVouchers.jsx

import React, { useState, useEffect, useContext } from "react";
import { Row, Col, Spinner, Alert, Card, Badge } from "react-bootstrap";
import AuthContext from "../context/AuthContext";
import "./UserVouchers.css";

const UserVouchers = () => {
  const [vouchers, setVouchers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { api } = useContext(AuthContext);

  useEffect(() => {
    const fetchVouchers = async () => {
      setLoading(true);
      setError(null);
      try {
        const { data } = await api.get("/user/my-vouchers");
        setVouchers(data);
      } catch (err) {
        setError("Không thể tải mã khuyến mãi của bạn.");
      } finally {
        setLoading(false);
      }
    };
    fetchVouchers();
  }, [api]);

  if (loading)
    return (
      <div className="text-center">
        <Spinner animation="border" />
      </div>
    );
  if (error) return <Alert variant="danger">{error}</Alert>;

  return (
    <>
      <h3 className="mb-4">Mã Khuyến Mãi Của Bạn</h3>
      {vouchers.length === 0 ? (
        <p>Bạn chưa lưu mã khuyến mãi nào.</p>
      ) : (
        <Row>
          {vouchers.map((v) => (
            <Col md={6} key={v.MaKhuyenMai} className="mb-3">
              <Card className="voucher-card shadow-sm h-100">
                <Card.Body className="d-flex justify-content-between align-items-center">
                  <div className="voucher-info">
                    <h5 className="voucher-code mb-1 fw-bold text-danger" title={v.MaKhuyenMai}>
                      {v.MaKhuyenMai}
                    </h5>
                    <p className="mb-0 small fw-bold text-body">
                      {v.TenKhuyenMai}
                    </p>
                    <p className="mb-0 text-muted small">
                      Hết hạn:{" "}
                      {new Date(v.NgayKetThuc).toLocaleDateString("vi-VN")}
                    </p>
                  </div>
                  <Badge bg="danger" className="voucher-badge ms-2">
                    {v.LoaiGiamGia === "SOTIEN"
                      ? `${parseFloat(v.GiaTriGiam) / 1000}K`
                      : `${parseFloat(v.GiaTriGiam)}%`}
                  </Badge>
                </Card.Body>
              </Card>
            </Col>
          ))}
        </Row>
      )}
    </>
  );
};

export default UserVouchers;

