// client/src/components/UserWishlist.jsx

import React, { useState, useEffect, useContext } from "react";
import { Row, Col, Spinner, Alert } from "react-bootstrap";
import AuthContext from "../context/AuthContext";
import ProductCard from "./ProductCard"; // Tái sử dụng ProductCard

const UserWishlist = () => {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { api } = useContext(AuthContext);

  useEffect(() => {
    const fetchWishlist = async () => {
      setLoading(true);
      setError(null);
      try {
        // Gọi API mới
        const { data } = await api.get("/user/wishlist");
        setItems(data);
      } catch (err) {
        setError("Không thể tải danh sách yêu thích.");
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    fetchWishlist();
  }, [api]);

  if (loading) {
    return (
      <div className="text-center">
        <Spinner animation="border" />
      </div>
    );
  }

  if (error) {
    return <Alert variant="danger">{error}</Alert>;
  }

  return (
    <>
      <h3 className="mb-4">Sản phẩm yêu thích</h3>
      {items.length === 0 ? (
        <p>Bạn chưa có sản phẩm yêu thích nào.</p>
      ) : (
        <Row>
          {items.map((item) => (
            <Col key={item.PhienBanID} md={6} lg={4}>
              {/* API đã trả về dữ liệu (PascalCase) khớp với ProductCard */}
              <ProductCard product={item} />
            </Col>
          ))}
        </Row>
      )}
    </>
  );
};

export default UserWishlist;
