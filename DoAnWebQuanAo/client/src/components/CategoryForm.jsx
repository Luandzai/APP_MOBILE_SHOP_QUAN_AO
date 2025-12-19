// client/src/components/CategoryForm.jsx
import React from 'react';
import { Form, Button, Spinner, Alert } from 'react-bootstrap';

const CategoryForm = ({
  modalData,
  setModalData,
  handleSubmit,
  modalLoading,
  isEdit,
  parentCategories,
  modalError,
}) => {
  return (
    <>
      {modalError && <Alert variant="danger">{modalError}</Alert>}
      <Form onSubmit={handleSubmit}>
        <Form.Group className="mb-3">
          <Form.Label>Tên Danh mục</Form.Label>
          <Form.Control
            type="text"
            value={modalData.TenDanhMuc}
            onChange={(e) =>
              setModalData({ ...modalData, TenDanhMuc: e.target.value })
            }
            required
          />
        </Form.Group>
        <Form.Group className="mb-3">
          <Form.Label>Slug</Form.Label>
          <Form.Control
            type="text"
            value={modalData.Slug}
            onChange={(e) =>
              setModalData({ ...modalData, Slug: e.target.value })
            }
          />
        </Form.Group>
        <Form.Group className="mb-3">
          <Form.Label>Danh mục Cha (Tùy chọn)</Form.Label>
          <Form.Select
            value={modalData.DanhMucChaID}
            onChange={(e) =>
              setModalData({ ...modalData, DanhMucChaID: e.target.value })
            }
          >
            <option value="">-- Chọn Danh mục Cha --</option>
            {parentCategories.map((cat) => (
              <option key={cat.DanhMucID} value={cat.DanhMucID}>
                {cat.TenDanhMuc}
              </option>
            ))}
          </Form.Select>
        </Form.Group>

        <Button
          type="submit"
          variant="primary"
          className="w-100"
          disabled={modalLoading}
        >
          {modalLoading ? (
            <Spinner as="span" animation="border" size="sm" />
          ) : isEdit ? (
            "Cập nhật"
          ) : (
            "Thêm mới"
          )}
        </Button>
      </Form>
    </>
  );
};

export default CategoryForm;
