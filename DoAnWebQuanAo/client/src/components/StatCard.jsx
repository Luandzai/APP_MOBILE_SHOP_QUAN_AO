// client/src/components/StatCard.jsx
import React from 'react';
import { Card, Spinner } from 'react-bootstrap';

const StatCard = ({ title, value, loading, variant = 'primary' }) => {
    const formatCurrency = (amount) => {
        return new Intl.NumberFormat("vi-VN", {
            style: "currency",
            currency: "VND",
            minimumFractionDigits: 0,
        }).format(amount);
    };
    
    const formatValue = (val) => {
        if (typeof val === 'number' && title.toLowerCase().includes('doanh')) {
            return formatCurrency(val);
        }
        if (typeof val === 'number') {
            return new Intl.NumberFormat("vi-VN").format(val);
        }
        return val;
    };

    return (
        <Card className={`shadow-sm border-0 h-100`}>
            <Card.Body>
                <Card.Title className="text-muted">{title}</Card.Title>
                {loading ? (
                    <Spinner animation="border" size="sm" />
                ) : (
                    <h3 className={`text-${variant}`}>{formatValue(value)}</h3>
                )}
            </Card.Body>
        </Card>
    );
};

export default StatCard;
