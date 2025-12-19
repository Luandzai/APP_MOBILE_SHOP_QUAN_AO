// client/src/services/tryOnService.js
import axios from 'axios';

const tryOnApi = axios.create({
    baseURL: import.meta.env.VITE_TRYON_API_URL || import.meta.env.VITE_API_URL,
});

export const uploadForTryOn = async (personImage, clothImage) => {
    const formData = new FormData();
    formData.append('personImage', personImage);
    formData.append('clothImage', clothImage);

    try {
        const response = await tryOnApi.post('/try-on', formData, {
            headers: {
                'Content-Type': 'multipart/form-data',
            },
        });
        return response.data;
    } catch (err) {
        // Re-throw a more specific error message
        const errorMessage = err.response?.data?.message || 'Đã có lỗi xảy ra từ server thử đồ ảo.';
        throw new Error(errorMessage);
    }
};
