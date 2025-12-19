// client/src/components/SizeGuideModal.jsx
import React, { useState, useEffect, useContext } from "react";
import { Modal, Spinner, Alert } from "react-bootstrap";
import AuthContext from "../context/AuthContext";

const SizeGuideModal = ({ show, onHide, categoryId }) => {
  const [content, setContent] = useState(null);
  const [isJson, setIsJson] = useState(false);
  const [loading, setLoading] = useState(false);
  const { api } = useContext(AuthContext);

  useEffect(() => {
    if (show && categoryId) {
      const fetchSizeChart = async () => {
        setLoading(true);
        setContent(null);
        setIsJson(false);
        try {
          const { data } = await api.get(`/sizecharts/${categoryId}`);
          const rawData = data.MoTa;

          if (rawData) {
            try {
              const parsed = JSON.parse(rawData);
              if (parsed && parsed.type === "freesize") {
                 setContent(parsed);
                 setIsJson(false); // We handle this separately in the render
              } else if (parsed && Array.isArray(parsed.headers) && Array.isArray(parsed.rows)) {
                setContent(parsed);
                setIsJson(true);
              } else {
                setContent(rawData);
                setIsJson(false);
              }
            } catch (e) {
              setContent(rawData);
              setIsJson(false);
            }
          }
        } catch (error) {
          console.error("Lỗi tải size chart:", error);
        } finally {
          setLoading(false);
        }
      };
      fetchSizeChart();
    }
  }, [show, categoryId, api]);

  return (
    <Modal show={show} onHide={onHide} centered size="lg">
      <Modal.Header closeButton>
        <Modal.Title>Hướng dẫn chọn size</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {loading ? (
          <div className="text-center py-4">
            <Spinner animation="border" />
          </div>
        ) : content ? (
          isJson ? (
            <div className="table-responsive">
              <table className="table table-bordered table-striped text-center align-middle">
                <thead className="table-dark">
                  <tr>
                    {content.headers.map((header, index) => (
                      <th key={index}>{header}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {content.rows.map((row, rowIndex) => (
                    <tr key={rowIndex}>
                      {row.map((cell, colIndex) => (
                        <td key={colIndex}>{cell}</td>
                      ))}
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ) : content && content.type === "freesize" ? (
             <Alert variant="info" className="text-center">
               <h5 className="alert-heading">Thông tin kích cỡ</h5>
               <p className="mb-0">{content.content}</p>
             </Alert>
          ) : (
            <div dangerouslySetInnerHTML={{ __html: content }} />
          )
        ) : (
          <Alert variant="warning">
            Chưa có hướng dẫn chọn size cụ thể cho sản phẩm này.
            <br />
            Vui lòng tham khảo bảng size chung hoặc liên hệ CSKH.
          </Alert>
        )}
        <p className="text-muted small mt-3">
          * Số đo có thể chênh lệch 1-2cm tùy thuộc vào độ co giãn của vải.
        </p>
      </Modal.Body>
    </Modal>
  );
};

export default SizeGuideModal;
