// client/src/components/Sidebar.jsx (Đã nâng cấp Thuộc tính ĐỘNG)

import React from "react";
import { Accordion, Form, Button, ButtonGroup, Spinner } from "react-bootstrap";
import "./Sidebar.css";

// XÓA BỎ 'filterData' (dữ liệu giả)

const Sidebar = ({
  onFilterChange,
  activeFilters,
  categoryTree,
  attributes, // Nhận 'attributes' (thuộc tính) từ props
  isLoading,
}) => {
  const handleCheckboxChange = (e) => {
    const { name: filterType, value, checked } = e.target;
    onFilterChange(filterType, value, checked);
  };

  const handleToggleChange = (filterType, value) => {
    // Kiểm tra an toàn, vì 'filters' có thể chưa khởi tạo key
    const currentValues = activeFilters[filterType] || [];
    const isChecked = currentValues.includes(value);
    onFilterChange(filterType, value, !isChecked);
  };

  // Render Cây Danh Mục (giữ nguyên)
  const renderCategoryTree = (categories) => {
    return categories.map((parentCat, index) => (
      <Accordion.Item eventKey={String(index)} key={parentCat.DanhMucID}>
        <Accordion.Header>{parentCat.TenDanhMuc}</Accordion.Header>
        <Accordion.Body>
          <Form>
            <Form.Check
              type="checkbox"
              id={`cat-${parentCat.Slug}`}
              label={`Tất cả ${parentCat.TenDanhMuc}`}
              value={parentCat.Slug}
              name="danhMuc"
              checked={activeFilters.danhMuc.includes(parentCat.Slug)}
              onChange={handleCheckboxChange}
              className="fw-bold"
            />
            {parentCat.children && parentCat.children.length > 0 && (
              <hr className="my-2" />
            )}
            {parentCat.children &&
              parentCat.children.map((childCat) => (
                <Form.Check
                  key={childCat.DanhMucID}
                  type="checkbox"
                  id={`cat-${childCat.Slug}`}
                  label={childCat.TenDanhMuc}
                  value={childCat.Slug}
                  name="danhMuc"
                  checked={activeFilters.danhMuc.includes(childCat.Slug)}
                  onChange={handleCheckboxChange}
                  className="ms-2"
                />
              ))}
          </Form>
        </Accordion.Body>
      </Accordion.Item>
    ));
  };

  // === COMPONENT MỚI: Render Bộ lọc Thuộc tính ===
  const renderAttributeFilters = (attrs) => {
    // Lọc và render các thuộc tính (bỏ qua 'Màu Sắc' vì ta render riêng)
    const sizeAttributes = attrs.filter((attr) =>
      attr.TenThuocTinh.includes("Kích Cỡ")
    );
    const colorAttribute = attrs.find(
      (attr) => attr.TenThuocTinh === "Màu Sắc"
    );

    return (
      <>
        {/* 1. Render Màu Sắc */}
        {colorAttribute && (
          <div className="mt-4" key={colorAttribute.ThuocTinhID}>
            <h6 className="fw-bold mb-3">{colorAttribute.TenThuocTinh}</h6>
            <div className="color-swatch-group">
              {colorAttribute.GiaTri.map((val) => (
                <span
                  key={val.GiaTriID}
                  className={`color-swatch ${
                    activeFilters[colorAttribute.Slug]?.includes(val.GiaTri)
                      ? "active"
                      : ""
                  }`}
                  style={{
                    backgroundColor:
                      val.GiaTri === "Trắng"
                        ? "#FFF"
                        : val.GiaTri === "Đen"
                        ? "#000"
                        : val.GiaTri === "Xanh"
                        ? "#0047AB"
                        : val.GiaTri === "Đỏ"
                        ? "#FF0000"
                        : val.GiaTri === "Vàng"
                        ? "#FFFF00"
                        : val.GiaTri === "Nâu"
                        ? "#8B4513"
                        : "#EEE",
                  }}
                  title={val.GiaTri}
                  onClick={() =>
                    handleToggleChange(colorAttribute.Slug, val.GiaTri)
                  }
                />
              ))}
            </div>
          </div>
        )}

        {/* 2. Render các loại Kích Cỡ */}
        {sizeAttributes.map((attr) => (
          <div className="mt-4" key={attr.ThuocTinhID}>
            <h6 className="fw-bold mb-3">{attr.TenThuocTinh}</h6>
            <ButtonGroup className="size-btn-group">
              {attr.GiaTri.map((val) => (
                <Button
                  key={val.GiaTriID}
                  variant="outline-secondary"
                  className="size-btn"
                  active={activeFilters[attr.Slug]?.includes(val.GiaTri)}
                  onClick={() => handleToggleChange(attr.Slug, val.GiaTri)}
                >
                  {val.GiaTri}
                </Button>
              ))}
            </ButtonGroup>
          </div>
        ))}
      </>
    );
  };
  // ======================================

  return (
    <div className="sidebar-container">
      <h3 className="sidebar-title">Bộ lọc</h3>

      {isLoading ? (
        <div className="text-center p-3">
          <Spinner size="sm" /> Đang tải bộ lọc...
        </div>
      ) : (
        <>
          {/* 1. Accordion Danh mục (ĐỘNG) */}
          <Accordion 
            defaultActiveKey={
              // Tìm index của danh mục được chọn trong activeFilters.danhMuc
              categoryTree
                .map((cat, index) => {
                  // Check nếu danh mục cha hoặc bất kỳ danh mục con nào được chọn
                  const isParentSelected = activeFilters.danhMuc?.includes(cat.Slug);
                  const isChildSelected = cat.children?.some(child => 
                    activeFilters.danhMuc?.includes(child.Slug)
                  );
                  return (isParentSelected || isChildSelected) ? String(index) : null;
                })
                .filter(Boolean)
                .concat(["0"]) // Fallback: mở danh mục đầu tiên nếu không có gì được chọn
                .slice(0, 1) // Chỉ lấy 1 accordion mở
            } 
            alwaysOpen
          >
            {renderCategoryTree(categoryTree)}

            {/* 2. Accordion Khoảng giá (Tĩnh) */}
            <Accordion.Item eventKey="99">
              <Accordion.Header>Khoảng giá</Accordion.Header>
              <Accordion.Body>
                <Form>
                  <Form.Check
                    type="checkbox"
                    id="price-1"
                    label="Từ 0 - 150.000"
                    value="0-150000"
                    name="khoangGia"
                    checked={activeFilters.khoangGia.includes("0-150000")}
                    onChange={handleCheckboxChange}
                  />
                  <Form.Check
                    type="checkbox"
                    id="price-2"
                    label="Từ 150.001 - 350.000"
                    value="150001-350000"
                    name="khoangGia"
                    checked={activeFilters.khoangGia.includes("150001-350000")}
                    onChange={handleCheckboxChange}
                  />
                  <Form.Check
                    type="checkbox"
                    id="price-3"
                    label="Trên 350.000"
                    value="350001-99999999"
                    name="khoangGia"
                    checked={activeFilters.khoangGia.includes(
                      "350001-99999999"
                    )}
                    onChange={handleCheckboxChange}
                  />
                </Form>
              </Accordion.Body>
            </Accordion.Item>
          </Accordion>

          {/* 3. Render Thuộc tính (ĐỘNG) */}
          {renderAttributeFilters(attributes)}
        </>
      )}
    </div>
  );
};

export default Sidebar;
