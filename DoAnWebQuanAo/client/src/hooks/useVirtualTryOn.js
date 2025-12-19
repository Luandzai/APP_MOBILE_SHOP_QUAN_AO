// client/src/hooks/useVirtualTryOn.js
import { useState } from 'react';
import { uploadForTryOn } from '../services/tryOnService';

export const useVirtualTryOn = () => {
    const [personImage, setPersonImage] = useState(null);
    const [personPreview, setPersonPreview] = useState(null);
    const [clothImage, setClothImage] = useState(null);
    const [clothPreview, setClothPreview] = useState(null);

    const [loading, setLoading] = useState(false);
    const [resultImage, setResultImage] = useState(null);
    const [error, setError] = useState('');

    const handleImageChange = (e, type) => {
        const file = e.target.files[0];
        if (file) {
            if (type === 'person') {
                setPersonImage(file);
                setPersonPreview(URL.createObjectURL(file));
            } else {
                setClothImage(file);
                setClothPreview(URL.createObjectURL(file));
            }
            setResultImage(null); // Clear previous result
            setError('');
        }
    };

    const handleTryOn = async () => {
        if (!personImage) {
            setError('Vui lòng tải lên ảnh của bạn.');
            return;
        }
        if (!clothImage) {
            setError('Vui lòng tải lên ảnh trang phục.');
            return;
        }

        setLoading(true);
        setError('');
        setResultImage(null);

        try {
            const data = await uploadForTryOn(personImage, clothImage);
            if (data.resultUrl) {
                setResultImage(data.resultUrl);
            } else {
                setError('Không nhận được ảnh kết quả từ server.');
            }
        } catch (err) {
            setError(err.message || 'Đã có lỗi xảy ra.');
        } finally {
            setLoading(false);
        }
    };

    return {
        personPreview,
        clothPreview,
        loading,
        resultImage,
        error,
        handleImageChange,
        handleTryOn,
    };
};
