// client/src/pages/ReturnListPage.jsx
import React from "react";
import { Table, Spinner, Alert, Badge } from "react-bootstrap";
import { useUserReturns } from "../hooks/useUserReturns";

const STATUS_BADGE = {
    PENDING: { bg: 'warning', text: 'Chờ xử lý' },
    APPROVED: { bg: 'primary', text: 'Đã phê duyệt' },
    REJECTED: { bg: 'danger', text: 'Đã từ chối' },
    COMPLETED: { bg: 'success', text: 'Đã hoàn tất' },
}

const ReturnListPage = () => {
    const { returns, loading, error } = useUserReturns();

    if (loading) {
        return <div className="text-center"><Spinner animation="border" /></div>;
    }
    
    if (error) {
        return <Alert variant="danger">{error}</Alert>;
    }

    return (
        <>
            <h3 className="mb-4">Lịch sử Đổi/Trả</h3>
            {returns.length === 0 ? (
                <Alert variant="info">Bạn chưa có yêu cầu đổi/trả nào.</Alert>
            ) : (
                <Table striped bordered hover responsive size="sm">
                    <thead>
                        <tr>
                            <th>ID Yêu Cầu</th>
                            <th>Mã Đơn Hàng</th>
                            <th>Ngày Yêu Cầu</th>
                            <th>Trạng Thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        {returns.map((req) => (
                            <tr key={req.ReturnID}>
                                <td>RET_{req.ReturnID}</td>
                                <td>ORD_{req.DonHangID}</td>
                                <td>{new Date(req.NgayYeuCau).toLocaleDateString("vi-VN")}</td>
                                <td>
                                    <Badge bg={STATUS_BADGE[req.Status]?.bg || 'secondary'}>
                                        {STATUS_BADGE[req.Status]?.text || req.Status}
                                    </Badge>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </Table>
            )}
        </>
    );
};

export default ReturnListPage;
