// client/src/hooks/useContactForm.js
import { useState } from 'react';
import axios from 'axios';

export const useContactForm = () => {
    const [formData, setFormData] = useState({
        name: "",
        email: "",
        phone: "",
        message: "",
    });
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");

    const onChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const onSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError("");
        setSuccess("");
        try {
            const res = await axios.post(
                `${import.meta.env.VITE_API_URL}/contact`,
                formData
            );
            setSuccess(res.data.message);
            setFormData({ name: "", email: "", phone: "", message: "" }); // Reset form
        } catch (err) {
            setError(err.response?.data?.message || "Đã có lỗi xảy ra. Vui lòng thử lại.");
        } finally {
            setLoading(false);
        }
    };

    return {
        formData,
        loading,
        error,
        success,
        onChange,
        onSubmit,
    };
};
