// client/src/components/CategoryRow.jsx
import React from 'react';
import { Button } from 'react-bootstrap';
import { PencilSquare, Trash } from 'react-bootstrap-icons';
import './CategoryRow.css';

const CategoryRow = ({ cat, level, parentName, onEdit, onDelete }) => {
  const rowContent = (
    <>
      <td>{cat.DanhMucID}</td>
      <td>
        <span className="category-name-span">
          {level > 0 ? "↳ " : ""}
          <strong>{cat.TenDanhMuc}</strong>
          {level > 0 && (
            <span className="ms-2 badge bg-secondary">{parentName}</span>
          )}
        </span>
      </td>
      <td>{cat.Slug}</td>
      <td>
        <Button
          variant="warning"
          size="sm"
          className="me-2"
          onClick={() => onEdit(cat)}
        >
          <PencilSquare />
        </Button>
        <Button variant="danger" size="sm" onClick={() => onDelete(cat)}>
          <Trash />
        </Button>
      </td>
    </>
  );

  return (
    <>
      <tr key={cat.DanhMucID}>{rowContent}</tr>
      {cat.children && cat.children.map((child) => (
        <CategoryRow
          key={child.DanhMucID}
          cat={child}
          level={level + 1}
          parentName={cat.TenDanhMuc}
          onEdit={onEdit}
          onDelete={onDelete}
        />
      ))}
    </>
  );
};

export default CategoryRow;
