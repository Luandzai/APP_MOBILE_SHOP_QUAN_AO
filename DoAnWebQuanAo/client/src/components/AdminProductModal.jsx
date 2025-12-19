// client/src/components/AdminProductModal.jsx (PHIÊN BẢN CUỐI CÙNG HOÀN CHỈNH)

import React, { useState, useEffect, useContext } from "react";
import {
  Modal,
  Button,
  Form,
  Alert,
  Spinner,
  Row,
  Col,
  InputGroup,
  Table,
  Image,
  Badge,
  Card,
} from "react-bootstrap";
import AuthContext from "../context/AuthContext";
import { toast } from "react-toastify";
import { Plus, Trash, XCircleFill } from "react-bootstrap-icons";
import slugify from "slugify";

// Component chính
const AdminProductModal = ({
  show,
  onHide,
  onProductUpdated,
  isEdit,
  productToEdit,
}) => {
  const { api } = useContext(AuthContext);

  const [formData, setFormData] = useState({
    TenSanPham: "",
    Slug: "",
    MoTa: "",
    DanhMucID: "",
    GiaGoc: 0,
    ThuongHieu: "",
    ChatLieu: "",
  });
  const [categories, setCategories] = useState([]);
  const [allAttributes, setAllAttributes] = useState([]); // Chứa TẤT CẢ thuộc tính
  const [relatedAttributes, setRelatedAttributes] = useState([]); // Thuộc tính lọc theo Danh mục

  const [loadingData, setLoadingData] = useState(true);
  const [submitLoading, setSubmitLoading] = useState(false);
  const [error, setError] = useState(null);

  const [versions, setVersions] = useState([]);
  const [selectedOptions, setSelectedOptions] = useState({});
  const [images, setImages] = useState([]);
  const [previewImages, setPreviewImages] = useState([]);
  const [existingImages, setExistingImages] = useState([]); // Trạng thái lưu trữ ảnh hiện có

  const [deletedVariantIds, setDeletedVariantIds] = useState([]); // <-- MỚI: Theo dõi ID phiên bản bị xóa

  // 1. Tải dữ liệu cần thiết (Danh mục, Thuộc tính)
  useEffect(() => {
    const fetchData = async () => {
      setLoadingData(true);
      try {
        const [catRes, attrRes] = await Promise.all([
          api.get("/categories"),
          api.get("/attributes"),
        ]);
        setCategories(catRes.data);
        setAllAttributes(attrRes.data); // Lưu tất cả
      } catch (err) {
        const errorMessage =
          err.response?.data?.message ||
          "Không thể tải danh mục hoặc thuộc tính.";
        setError(errorMessage);
        console.error("Error loading data:", err);
      } finally {
        setLoadingData(false);
      }
    };
    fetchData();
  }, [api]);

  // 2. Lọc Thuộc tính theo Danh mục
  // YÊU CẦU MỚI: Bỏ gợi ý sẵn, để người dùng tự chọn.
  useEffect(() => {
    // Khi đổi danh mục, reset lại danh sách thuộc tính đã chọn và options
    setRelatedAttributes([]);
    setSelectedOptions({}); 
  }, [formData.DanhMucID]);

  // --- MỚI: Hàm thêm thuộc tính thủ công ---
  const handleAddManualAttribute = (attributeId) => {
    const attrToAdd = allAttributes.find(
      (a) => a.ThuocTinhID === parseInt(attributeId)
    );
    if (
      attrToAdd &&
      !relatedAttributes.some((a) => a.ThuocTinhID === attrToAdd.ThuocTinhID)
    ) {
      setRelatedAttributes((prev) => [...prev, attrToAdd]);
    }
  };

  // --- MỚI: Hàm xóa thuộc tính khỏi danh sách ---
  const handleRemoveAttribute = (attributeId) => {
    setRelatedAttributes((prev) =>
      prev.filter((attr) => attr.ThuocTinhID !== attributeId)
    );
    // Xóa lựa chọn tương ứng trong selectedOptions nếu có
    const attrToRemove = relatedAttributes.find(
      (a) => a.ThuocTinhID === attributeId
    );
    if (attrToRemove) {
      setSelectedOptions((prev) => {
        const newOptions = { ...prev };
        delete newOptions[attrToRemove.TenThuocTinh];
        return newOptions;
      });
    }
  };

  // 3. Thiết lập dữ liệu khi mở modal (Chế độ CREATE)
  useEffect(() => {
    if (show) {
      // Reset tất cả state khi modal mở
      setError(null);
      setVersions([]);
      setImages([]);
      setPreviewImages([]);
      setSelectedOptions({});
      setExistingImages([]);
      setDeletedVariantIds([]);

      // Nếu là chế độ "Thêm mới", reset form
      if (!isEdit) {
        setFormData({
          TenSanPham: "",
          Slug: "",
          MoTa: "",
          DanhMucID: "",
          GiaGoc: 0,
          ThuongHieu: "",
          ChatLieu: "",
        });
      }
    }
  }, [show, isEdit]);

  // 4. Tải dữ liệu chi tiết khi ở chế độ EDIT
  useEffect(() => {
    const fetchProductDetailsForEdit = async () => {
      if (isEdit && productToEdit?.SanPhamID) {
        setLoadingData(true);
        try {
          const { data } = await api.get(
            `/admin/products/${productToEdit.SanPhamID}`
          );
          setFormData({
            TenSanPham: data.TenSanPham || "",
            Slug: data.Slug || "",
            MoTa: data.MoTa || "",
            DanhMucID: data.DanhMucID || "",
            GiaGoc: data.GiaGoc || 0,
            ThuongHieu: data.ThuongHieu || "",
            ChatLieu: data.ChatLieu || "",
          });
          setExistingImages(data.images || []);
          setVersions(data.versions || []);
        } catch (err) {
          setError("Không thể tải chi tiết sản phẩm để chỉnh sửa.");
          console.error("Error fetching product details for edit:", err);
        } finally {
          setLoadingData(false);
        }
      }
    };

    if (show && isEdit) {
      fetchProductDetailsForEdit();
    }
  }, [show, isEdit, productToEdit, api]);

  // Xử lý thay đổi form (Tạo Slug tự động)
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });

    if (name === "TenSanPham" && !isEdit) {
      setFormData((prev) => ({
        ...prev,
        Slug: slugify(value, {
          lower: true,
          locale: "vi",
          remove: /[*+~.()'"!:@]/g,
        }),
      }));
    }
  };

  const handleImageChange = (e) => {
    const files = Array.from(e.target.files);
    setImages(files);
    const previews = files.map((file) => URL.createObjectURL(file));
    setPreviewImages(previews);
    return () => previews.forEach((url) => URL.revokeObjectURL(url));
  };

  const handleRemoveNewImage = (index) => {
    const newImages = images.filter((_, i) => i !== index);
    setImages(newImages);
    const newPreviews = previewImages.filter((_, i) => i !== index);
    setPreviewImages(newPreviews);
  };

  // --- LOGIC VERSION ---
  const handleVersionOptionChange = (attrName, attrValue) => {
    setSelectedOptions((prev) => ({ ...prev, [attrName]: attrValue }));
  };

  const handleAddVersion = () => {
    // Kiểm tra đã chọn đủ options theo relatedAttributes chưa
    if (relatedAttributes.length !== Object.keys(selectedOptions).length) {
      toast.error("Vui lòng chọn đầy đủ thuộc tính liên quan đến danh mục.");
      return;
    }

    // Kiểm tra trùng lặp
    const currentVersionString = JSON.stringify(selectedOptions);
    const isDuplicate = versions.some(
      (v) => JSON.stringify(v.options) === currentVersionString
    );
    if (isDuplicate) {
      toast.warn("Phiên bản này đã tồn tại.");
      return;
    }

    setVersions((prev) => [
      ...prev,
      {
        options: selectedOptions,
        price: formData.GiaGoc || 0,
        stock: 10,
        sku: `SKU-${Date.now()}`,
      },
    ]);
    setSelectedOptions({});
  };

  const handleRemoveVersion = (index) => {
    const versionToRemove = versions[index];
    // Nếu phiên bản này đã có trong DB (có PhienBanID), thêm ID vào danh sách xóa
    if (versionToRemove.PhienBanID) {
      setDeletedVariantIds((prev) => [...prev, versionToRemove.PhienBanID]);
    }
    // Xóa khỏi state hiển thị
    setVersions((prev) => prev.filter((_, i) => i !== index));
  };
  // -----------------------

  // === HÀM SUBMIT CHÍNH (POST/PUT API) ===
  const handleSubmit = async (e) => {
    e.preventDefault();
    setSubmitLoading(true);
    setError(null);

    // Kiểm tra bắt buộc
    if (!isEdit && (images.length === 0 || versions.length === 0)) {
      setError("Vui lòng tải ảnh và thêm ít nhất một phiên bản.");
      setSubmitLoading(false);
      return;
    }
    // Kiểm tra tính hợp lệ của Versions
    if (versions.some((v) => !v.sku || v.price <= 0 || v.stock < 0)) {
      setError("SKU và Giá Bán phải hợp lệ (Giá > 0, Tồn kho >= 0).");
      setSubmitLoading(false);
      return;
    }

    // Khởi tạo FormData
    const data = new FormData();
    data.append("TenSanPham", formData.TenSanPham);
    data.append("Slug", formData.Slug);
    data.append("MoTa", formData.MoTa);
    data.append("DanhMucID", formData.DanhMucID);
    data.append("GiaGoc", formData.GiaGoc);
    data.append("ThuongHieu", formData.ThuongHieu || "");
    data.append("ChatLieu", formData.ChatLieu || "");
    data.append("versions", JSON.stringify(versions));

    // Gửi danh sách ảnh và phiên bản cần xóa (chỉ ở chế độ edit)
    if (isEdit) {
      const deletedImages = (formData.deletedImages || []).filter(
        (img) => img.HinhAnhID
      );
      if (deletedImages.length > 0) {
        data.append("deletedImages", JSON.stringify(deletedImages));
      }
      data.append("deletedVariantIds", JSON.stringify(deletedVariantIds));
    }

    if (images.length > 0) {
      images.forEach((file) => data.append("images", file));
    }

    try {
      let response;
      const apiEndpoint = isEdit
        ? `/products/${productToEdit.SanPhamID}`
        : "/products";
      const apiMethod = isEdit ? api.put : api.post;

      response = await apiMethod(apiEndpoint, data, {
        headers: { "Content-Type": "multipart/form-data" },
      });

      toast.success(response.data.message);
      onProductUpdated();
      onHide();
    } catch (err) {
      setError(err.response?.data?.message || "Lỗi server.");
    } finally {
      setSubmitLoading(false);
    }
  };

  if (loadingData) {
    return (
      <Modal show={show} onHide={onHide} centered>
        <div className="text-center p-5">
          <Spinner animation="border" /> Đang tải dữ liệu...
        </div>
      </Modal>
    );
  }

  // Render
  return (
    <Modal show={show} onHide={onHide} size="xl" centered>
      <Modal.Header closeButton>
        <Modal.Title>
          {isEdit ? "Cập nhật Sản phẩm" : "Thêm Sản phẩm mới"}
        </Modal.Title>
      </Modal.Header>
      <Form onSubmit={handleSubmit}>
        <Modal.Body>
          {error && <Alert variant="danger">{error}</Alert>}
          <Row>
            {/* CỘT TRÁI: THÔNG TIN CƠ BẢN & MEDIA */}
            <Col md={5}>
              <h5>Thông tin cơ bản</h5>
              <Form.Group className="mb-3">
                <Form.Label>Tên Sản phẩm</Form.Label>
                <Form.Control
                  type="text"
                  name="TenSanPham"
                  value={formData.TenSanPham}
                  onChange={handleInputChange}
                  required
                />
              </Form.Group>
              <Form.Group className="mb-3">
                <Form.Label>Slug (URL)</Form.Label>
                <Form.Control
                  type="text"
                  name="Slug"
                  value={formData.Slug}
                  onChange={handleInputChange}
                  required
                />
              </Form.Group>
              <Form.Group className="mb-3">
                <Form.Label>Danh mục</Form.Label>
                <Form.Select
                  name="DanhMucID"
                  value={formData.DanhMucID}
                  onChange={handleInputChange}
                  required
                >
                  <option value="">Chọn danh mục...</option>
                  {categories
                    .filter((c) => c.DanhMucChaID)
                    .map((c) => (
                      <option key={c.DanhMucID} value={c.DanhMucID}>
                        {c.TenDanhMuc} (
                        {
                          categories.find((p) => p.DanhMucID === c.DanhMucChaID)
                            ?.TenDanhMuc
                        }
                        )
                      </option>
                    ))}
                </Form.Select>
              </Form.Group>
              <Form.Group className="mb-3">
                <Form.Label>Giá gốc (VNĐ)</Form.Label>
                <Form.Control
                  type="number"
                  name="GiaGoc"
                  value={formData.GiaGoc || 0}
                  onChange={handleInputChange}
                  required
                />
              </Form.Group>
              <Form.Group className="mb-3">
                <Form.Label>Thương hiệu</Form.Label>
                <Form.Control
                  type="text"
                  name="ThuongHieu"
                  value={formData.ThuongHieu || ""}
                  onChange={handleInputChange}
                />
              </Form.Group>
              <Form.Group className="mb-3">
                <Form.Label>Chất liệu</Form.Label>
                <Form.Control
                  type="text"
                  name="ChatLieu"
                  value={formData.ChatLieu || ""}
                  onChange={handleInputChange}
                />
              </Form.Group>
              <Form.Group className="mb-3">
                <Form.Label>Mô tả</Form.Label>
                <Form.Control
                  as="textarea"
                  rows={3}
                  name="MoTa"
                  value={formData.MoTa || ""}
                  onChange={handleInputChange}
                />
              </Form.Group>

              <h5>Hình ảnh</h5>
              <Form.Group controlId="formFileMultiple" className="mb-3">
                <Form.Control
                  type="file"
                  multiple
                  name="images"
                  onChange={handleImageChange}
                  accept="image/*"
                />
              </Form.Group>
              <div className="d-flex flex-wrap gap-2 mb-3">
                {/* Display existing images first */}
                {existingImages.map((img, index) => (
                  <div
                    key={`existing-${index}`}
                    style={{
                      position: "relative",
                      width: "80px",
                      height: "80px",
                    }}
                  >
                    <Image
                      src={img.url}
                      style={{
                        width: "100%",
                        height: "100%",
                        objectFit: "cover",
                      }}
                      thumbnail
                    />
                    <Button
                      variant="danger"
                      size="sm"
                      style={{
                        position: "absolute",
                        top: "-10px",
                        right: "-10px",
                      }}
                      onClick={() => {
                        const newExistingImages = existingImages.filter(
                          (_, i) => i !== index
                        );
                        setExistingImages(newExistingImages);
                        // Add the image to deletedImages array in formData
                        const deletedImage = existingImages[index];
                        setFormData((prev) => ({
                          ...prev,
                          deletedImages: [
                            ...(prev.deletedImages || []),
                            deletedImage,
                          ],
                        }));
                      }}
                    >
                      <XCircleFill size={12} />
                    </Button>
                  </div>
                ))}

                {/* Your existing preview images code */}
                {previewImages.map((url, index) => (
                  <div
                    key={index}
                    style={{
                      position: "relative",
                      width: "80px",
                      height: "80px",
                    }}
                  >
                    <Image
                      src={url}
                      style={{
                        width: "100%",
                        height: "100%",
                        objectFit: "cover",
                      }}
                      thumbnail
                    />
                    <Button
                      variant="danger"
                      size="sm"
                      style={{
                        position: "absolute",
                        top: "-10px",
                        right: "-10px",
                      }}
                      onClick={() => handleRemoveNewImage(index)}
                    >
                      <XCircleFill size={12} />
                    </Button>
                  </div>
                ))}
              </div>
            </Col>

            {/* CỘT PHẢI: PHIÊN BẢN (VERSIONS) */}
            <Col md={7}>
              <h5>Quản lý Phiên bản (Variants)</h5>
              <Card body className="mb-3 bg-light">
                {/* MỚI: Dropdown thêm thuộc tính tùy chọn */}
                {formData.DanhMucID && (
                  <Row className="mb-3">
                    <Col md={12}>
                      <Form.Label className="text-muted small">
                        Thêm thuộc tính tùy chọn (nếu cần):
                      </Form.Label>
                      <Form.Select
                        size="sm"
                        onChange={(e) => {
                          if (e.target.value)
                            handleAddManualAttribute(e.target.value);
                          e.target.value = ""; // Reset sau khi chọn
                        }}
                      >
                        <option value="">+ Chọn thuộc tính để thêm...</option>
                        {allAttributes
                          .filter(
                            (attr) =>
                              !relatedAttributes.some(
                                (ra) => ra.ThuocTinhID === attr.ThuocTinhID
                              )
                          )
                          .map((attr) => (
                            <option
                              key={attr.ThuocTinhID}
                              value={attr.ThuocTinhID}
                            >
                              {attr.TenThuocTinh}
                            </option>
                          ))}
                      </Form.Select>
                    </Col>
                  </Row>
                )}

                <Row>
                  {relatedAttributes.map(
                    (
                      attr // Lọc theo Danh mục đã chọn
                    ) => (
                      <Col md={4} key={attr.ThuocTinhID} className="mb-3">
                        <div className="d-flex justify-content-between align-items-center mb-1">
                          <Form.Label className="fw-bold mb-0">
                            {attr.TenThuocTinh}
                          </Form.Label>
                          <Button
                            variant="link"
                            className="text-danger p-0 text-decoration-none"
                            size="sm"
                            onClick={() =>
                              handleRemoveAttribute(attr.ThuocTinhID)
                            }
                            title="Bỏ thuộc tính này"
                          >
                            <XCircleFill size={14} />
                          </Button>
                        </div>
                        <Form.Select
                          value={selectedOptions[attr.TenThuocTinh] || ""}
                          onChange={(e) =>
                            handleVersionOptionChange(
                              attr.TenThuocTinh,
                              e.target.value
                            )
                          }
                        >
                          <option value="">Chọn {attr.TenThuocTinh}</option>
                          {attr.GiaTri.map((val) => (
                            <option key={val.GiaTriID} value={val.GiaTri}>
                              {val.GiaTri}
                            </option>
                          ))}
                        </Form.Select>
                      </Col>
                    )
                  )}
                  <Col md={4} className="d-flex align-items-end">
                    <Button
                      onClick={handleAddVersion}
                      variant="success"
                      className="w-100"
                      disabled={
                        !formData.DanhMucID || relatedAttributes.length === 0
                      }
                    >
                      <Plus /> Thêm Phiên bản
                    </Button>
                  </Col>
                </Row>
                {!formData.DanhMucID && (
                  <p className="text-muted small mt-2">
                    Vui lòng chọn Danh mục để kích hoạt bộ chọn thuộc tính.
                  </p>
                )}
              </Card>

              {/* Bảng danh sách Versions đã thêm */}
              <Table striped bordered hover size="sm">
                <thead>
                  <tr>
                    <th>#</th>
                    <th>Phiên bản</th>
                    <th>SKU</th>
                    <th>Giá Bán</th>
                    <th>Tồn Kho</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  {versions.map((v, index) => (
                    <tr key={index}>
                      <td>{index + 1}</td>
                      <td>
                        {Object.entries(v.options).map(([name, value]) => (
                          <Badge key={name} bg="secondary" className="me-1">
                            {name}: {value}
                          </Badge>
                        ))}
                      </td>
                      <td>
                        <Form.Control
                          type="text"
                          size="sm"
                          // SỬA: Đảm bảo giá trị là chuỗi cho SKU
                          value={v.sku || ""}
                          onChange={(e) => {
                            const newVersions = [...versions];
                            newVersions[index].sku = e.target.value;
                            setVersions(newVersions);
                          }}
                        />
                      </td>
                        <td>
                        <Form.Control
                          type="number"
                          size="sm"
                          min="0"
                          // FIX: Use ?? for nullish coalescing (0 is valid, null/undefined become "")
                          value={v.price ?? ""}
                          onChange={(e) => {
                            const newVersions = [...versions];
                            newVersions[index].price = e.target.value;
                            setVersions(newVersions);
                          }}
                        />
                      </td>
                      <td>
                        <Form.Control
                          type="number"
                          size="sm"
                          min="0"
                          // FIX: Use ?? for nullish coalescing (0 is valid, null/undefined become "")
                          value={v.stock ?? ""}
                          onChange={(e) => {
                            const newVersions = [...versions];
                            newVersions[index].stock = e.target.value;
                            setVersions(newVersions);
                          }}
                        />
                      </td>
                      <td>
                        <Button
                          variant="danger"
                          size="sm"
                          onClick={() => handleRemoveVersion(index)}
                        >
                          <Trash size={12} />
                        </Button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </Table>
              {versions.length === 0 && (
                <Alert variant="warning" className="text-center">
                  Chưa có phiên bản nào được thêm.
                </Alert>
              )}
            </Col>
          </Row>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={onHide} disabled={submitLoading}>
            Hủy bỏ
          </Button>
          <Button type="submit" variant="primary" disabled={submitLoading}>
            {submitLoading ? (
              <Spinner as="span" animation="border" size="sm" />
            ) : isEdit ? (
              "Cập nhật Sản phẩm"
            ) : (
              "Tạo Sản phẩm"
            )}
          </Button>
        </Modal.Footer>
      </Form>
    </Modal>
  );
};

export default AdminProductModal;