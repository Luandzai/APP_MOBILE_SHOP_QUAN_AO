// client/src/pages/VirtualTryOnPage.jsx (Refactored)
import React from "react";
import { useVirtualTryOn } from "../hooks/useVirtualTryOn";
import ImageUploader from "../components/ImageUploader";
import "./VirtualTryOnPage.css";

const ResultDisplay = ({ loading, resultImage }) => (
  <div className="card h-100">
    <div className="card-body text-center d-flex flex-column">
      <h5 className="card-title mb-3">3. Kết Quả</h5>
      <div className="image-container mb-3 flex-grow-1">
        {loading ? (
          <div className="placeholder-image d-flex align-items-center justify-content-center h-100">
            <span className="spinner-border text-primary" role="status">
              <span className="visually-hidden">Loading...</span>
            </span>
          </div>
        ) : resultImage ? (
          <img src={resultImage} alt="Kết quả" className="img-fluid rounded" />
        ) : (
          <div className="placeholder-image d-flex align-items-center justify-content-center">
            <span>Ảnh ghép sẽ hiện ở đây</span>
          </div>
        )}
      </div>
    </div>
  </div>
);

const VirtualTryOnPage = () => {
  const {
    personPreview,
    clothPreview,
    loading,
    resultImage,
    error,
    handleImageChange,
    handleTryOn,
  } = useVirtualTryOn();

  return (
    <div className="container mt-5 mb-5">
      <div className="text-center mb-4">
        <h1 className="fw-bold">Virtual Try-On</h1>
        <p className="text-muted">Thử trang phục ảo với công nghệ AI</p>
      </div>

      <div className="row g-4">
        <div className="col-lg-4">
          <ImageUploader
            title="1. Tải Lên Ảnh Của Bạn"
            onImageChange={(e) => handleImageChange(e, "person")}
            preview={personPreview}
            uploaderId="person-upload"
          />
        </div>
        <div className="col-lg-4">
          <ImageUploader
            title="2. Tải Lên Ảnh Trang Phục"
            onImageChange={(e) => handleImageChange(e, "cloth")}
            preview={clothPreview}
            uploaderId="cloth-upload"
          />
        </div>
        <div className="col-lg-4">
          <ResultDisplay loading={loading} resultImage={resultImage} />
        </div>
      </div>

      <div className="text-center mt-4">
        {error && <div className="alert alert-danger">{error}</div>}
        <button
          onClick={handleTryOn}
          className="btn btn-primary btn-lg"
          disabled={loading}
        >
          {loading ? (
            <>
              <span
                className="spinner-border spinner-border-sm"
                role="status"
                aria-hidden="true"
              ></span>{" "}
              Đang xử lý...
            </>
          ) : (
            "Bắt Đầu Thử Đồ"
          )}
        </button>
      </div>
    </div>
  );
};

export default VirtualTryOnPage;
