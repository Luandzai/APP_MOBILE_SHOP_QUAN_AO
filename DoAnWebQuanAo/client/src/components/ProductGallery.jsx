// client/src/components/ProductGallery.jsx
import React, { useState } from 'react';
import { Row, Col, Image, Button, Modal } from 'react-bootstrap';
import { ChevronLeft, ChevronRight } from 'react-bootstrap-icons';

const ProductGallery = ({ images, selectedImage, onThumbnailClick, onPrev, onNext }) => {
    const [showImageModal, setShowImageModal] = useState(false);
    const [modalImageUrl, setModalImageUrl] = useState("");

    const handleShowImageModal = (url) => {
        setModalImageUrl(url);
        setShowImageModal(true);
    };

    if (!images || images.length === 0) {
        return <Image src="https://placehold.co/600x600?text=No+Image" fluid />;
    }

    return (
        <>
            <div className="product-gallery-wrapper">
                {/* Thumbnails */}
                <div className="product-gallery-thumbnails">
                    {images.map((img, index) => (
                        <Image
                            key={img.HinhAnhID}
                            src={img.URL}
                            className={`thumbnail-image ${selectedImage === img.URL ? 'active' : ''}`}
                            onClick={() => onThumbnailClick(index)}
                        />
                    ))}
                </div>

                {/* Main Image */}
                <div className="product-image-main-wrapper">
                    <Image 
                        src={selectedImage} 
                        fluid 
                        className="product-image-main" 
                        onClick={() => handleShowImageModal(selectedImage)}
                    />
                    <Button variant="link" className="image-nav-btn prev" onClick={onPrev}><ChevronLeft size={24} /></Button>
                    <Button variant="link" className="image-nav-btn next" onClick={onNext}><ChevronRight size={24} /></Button>
                </div>
            </div>

            {/* Image Preview Modal */}
            <Modal show={showImageModal} onHide={() => setShowImageModal(false)} centered size="lg" className="image-preview-modal">
                <Modal.Body><Image src={modalImageUrl} fluid /></Modal.Body>
            </Modal>
        </>
    );
};

export default ProductGallery;
