// client/src/components/ImageUploader.jsx
import React from 'react';
import { Card } from 'react-bootstrap';

const ImageUploader = ({ title, onImageChange, preview, uploaderId }) => {
    return (
        <Card className="h-100">
            <Card.Body className="text-center d-flex flex-column">
                <h5 className="card-title mb-3">{title}</h5>
                <div className="image-container mb-3 flex-grow-1">
                    {preview ? (
                        <img src={preview} alt="Preview" className="img-fluid rounded" />
                    ) : (
                        <div className="placeholder-image d-flex align-items-center justify-content-center">
                            <span>Ảnh sẽ hiện ở đây</span>
                        </div>
                    )}
                </div>
                <label htmlFor={uploaderId} className="btn btn-secondary">
                    {preview ? 'Thay đổi ảnh' : 'Tải ảnh lên'}
                </label>
                <input
                    id={uploaderId}
                    type="file"
                    accept="image/*"
                    onChange={onImageChange}
                    className="d-none"
                />
            </Card.Body>
        </Card>
    );
};

export default ImageUploader;
