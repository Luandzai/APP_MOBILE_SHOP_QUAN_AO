// client/src/components/ReturnDetailModal.jsx
import React, { useState, useEffect, useContext, useMemo } from 'react';
import { Modal, Spinner, Alert, Row, Col, Card, ListGroup, Badge, Button, Form, InputGroup } from 'react-bootstrap';
import { toast } from 'react-toastify';
import AuthContext from '../context/AuthContext';
import ConfirmModal from './ConfirmModal';

const STATUS_OPTIONS = {
    PENDING: { name: "Chờ xử lý", color: "warning" },
    APPROVED: { name: "Đã phê duyệt", color: "primary" },
    REJECTED: { name: "Đã từ chối", color: "danger" },
    COMPLETED: { name: "Đã hoàn tất", color: "success" },
};

const ReturnDetailModal = ({ show, onHide, returnId, onUpdate }) => {
    const [returnDetail, setReturnDetail] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);
    const { api } = useContext(AuthContext);

    // States for confirmation and update logic
    const [showConfirmModal, setShowConfirmModal] = useState(false);
    const [pendingUpdate, setPendingUpdate] = useState(null); // { newStatus, refundAmount }
    const [updating, setUpdating] = useState(false);
    const [refundAmount, setRefundAmount] = useState(0);
    const [restoreInventory, setRestoreInventory] = useState(false); // Checkbox for inventory restore

    const formatCurrency = (amount) => new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(amount || 0);
    const formatDate = (dateString) => new Date(dateString).toLocaleString("vi-VN");

    useEffect(() => {
        const fetchReturnDetail = async () => {
            if (!returnId) return;

            setLoading(true);
            setError(null);
            setReturnDetail(null);

            try {
                const { data } = await api.get(`/admin/returns/${returnId}`);
                setReturnDetail(data);

                // Initialize refund amount
                const maxRefund = data.items.reduce((sum, item) => sum + item.SoLuongTra * item.GiaHoanTra, 0);
                setRefundAmount(data.RefundAmount || maxRefund);

            } catch (err) {
                setError(err.response?.data?.message || "Không thể tải chi tiết yêu cầu.");
            } finally {
                setLoading(false);
            }
        };

        if (show) {
            fetchReturnDetail();
        }
    }, [show, returnId, api]);

    const handleStatusUpdate = (targetStatus) => {
        let initialRefund = 0;
        if (targetStatus === 'APPROVED' && returnDetail?.items) {
            initialRefund = returnDetail.items.reduce((sum, item) => sum + item.SoLuongTra * item.GiaHoanTra, 0);
        } else if (targetStatus === 'COMPLETED' && returnDetail?.RefundAmount) {
            initialRefund = parseFloat(returnDetail.RefundAmount);
        }
        setRefundAmount(initialRefund);
        setRestoreInventory(false); // Reset checkbox when opening modal
        setPendingUpdate({ newStatus: targetStatus });
        setShowConfirmModal(true);
    };

    const handleConfirmUpdate = async () => {
        if (!pendingUpdate) return;
        setUpdating(true);

        try {
            const payload = {
                newStatus: pendingUpdate.newStatus,
                refundAmount: pendingUpdate.newStatus === "APPROVED" ? parseFloat(refundAmount) : undefined,
                restoreInventory: pendingUpdate.newStatus === "COMPLETED" ? restoreInventory : undefined,
            };

            const response = await api.put(`/admin/returns/${returnId}/status`, payload);
            toast.success(response.data.message);
            
            onUpdate(); // Callback to refresh the list on the parent page
            onHide();   // Close the detail modal
            
        } catch (error) {
            toast.error(error.response?.data?.message || "Cập nhật trạng thái thất bại.");
        } finally {
            setUpdating(false);
            setShowConfirmModal(false);
            setPendingUpdate(null);
        }
    };
    
    const maxRefund = returnDetail?.items ? returnDetail.items.reduce((sum, item) => sum + item.SoLuongTra * item.GiaHoanTra, 0) : 0;

    const modalContent = useMemo(() => {
        if (!pendingUpdate) return {};

        const { newStatus } = pendingUpdate;
        const baseText = `yêu cầu trả hàng #${returnId} của khách hàng **${returnDetail?.TenKhachHang}**`;

        if (newStatus === "APPROVED") {
            return {
                title: "Xác nhận Phê duyệt Yêu cầu",
                message: (
                    <div>
                        <p>Bạn có chắc muốn **PHÊ DUYỆT** {baseText}?</p>
                        <p className="mt-2">**Lưu ý:** Thao tác này sẽ cập nhật số tiền hoàn trả và chuẩn bị cho bước hoàn tất.</p>
                        <Form.Group className="mt-3">
                            <Form.Label>Số tiền hoàn trả (Tối đa: {formatCurrency(maxRefund)})</Form.Label>
                            <InputGroup>
                                <Form.Control type="number" value={refundAmount} onChange={(e) => setRefundAmount(parseFloat(e.target.value) || 0)} min="0" max={maxRefund} />
                                <InputGroup.Text>VND</InputGroup.Text>
                            </InputGroup>
                        </Form.Group>
                    </div>
                ),
                confirmText: "Phê duyệt",
                variant: "primary",
            };
        }
        // Other statuses...
        if (newStatus === "REJECTED") {
            return {
              title: "Xác nhận Từ chối Yêu cầu",
              message: `Bạn có chắc muốn **TỪ CHỐI** ${baseText}?`,
              confirmText: "Từ chối",
              variant: "danger",
            };
        }
        if (newStatus === "COMPLETED") {
              return {
                title: "Xác nhận Hoàn tất Thủ tục",
                message: (
                    <div>
                        <p>Xác nhận <strong>ĐÃ HOÀN TẤT</strong> thủ tục và đã hoàn trả <strong>{formatCurrency(returnDetail?.RefundAmount || 0)}</strong> cho khách hàng.</p>
                        <Form.Check 
                            type="checkbox"
                            id="restoreInventory"
                            label="Hàng còn nguyên vẹn, có thể tiếp tục bán (cập nhật tồn kho)"
                            checked={restoreInventory}
                            onChange={(e) => setRestoreInventory(e.target.checked)}
                            className="mt-3"
                        />
                        {restoreInventory && (
                            <small className="text-success d-block mt-2">
                                <i className="bi bi-check-circle-fill me-1"></i>
                                Số lượng sản phẩm sẽ được cộng lại vào tồn kho sau khi hoàn tất.
                            </small>
                        )}
                    </div>
                ),
                confirmText: "Hoàn tất",
                variant: "success",
              };
        }
        return {};
    }, [pendingUpdate, refundAmount, returnDetail, returnId, maxRefund, restoreInventory]);


    return (
        <>
            <Modal show={show} onHide={onHide} size="lg" scrollable centered>
                <Modal.Header closeButton>
                    <Modal.Title>Chi tiết Yêu cầu #{returnId}</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    {loading && <div className="text-center py-5"><Spinner animation="border" /></div>}
                    {error && <Alert variant="danger">{error}</Alert>}
                    {returnDetail && (
                         <>
                            <Row className="mb-4">
                                <Col md={6}>
                                    <h6>Thông tin Yêu cầu</h6>
                                    <p><strong>Trạng thái: </strong><Badge bg={STATUS_OPTIONS[returnDetail.Status]?.color}>{STATUS_OPTIONS[returnDetail.Status]?.name}</Badge></p>
                                    <p><strong>Ngày yêu cầu:</strong> {formatDate(returnDetail.NgayYeuCau)}</p>
                                    <p><strong>Lý do:</strong> {returnDetail.Reason}</p>
                                </Col>
                                <Col md={6} className="text-md-end">
                                    <h6>Tóm tắt Thanh toán</h6>
                                    <p><strong>Đơn hàng gốc:</strong> #{returnDetail.DonHangID}</p>
                                    <p><strong>Số tiền Hoàn trả:</strong>
                                        {returnDetail.RefundAmount ? <strong className="text-success ms-2">{formatCurrency(returnDetail.RefundAmount)}</strong> : <span className="text-muted ms-2">Chưa xác định</span>}
                                    </p>
                                </Col>
                            </Row>
                            <h6>Chi tiết Sản phẩm</h6>
                            <ListGroup variant="flush">
                                {returnDetail.items?.map((item, index) => (
                                    <ListGroup.Item key={index} className="d-flex justify-content-between align-items-center">
                                        <div>
                                            <strong>{item.TenSanPham}</strong>
                                            <div className="text-muted small">{item.ThuocTinh} | Số lượng trả: {item.SoLuongTra}</div>
                                        </div>
                                        <div className="text-end">{formatCurrency(item.GiaHoanTra)}</div>
                                    </ListGroup.Item>
                                ))}
                            </ListGroup>
                        </>
                    )}
                </Modal.Body>
                <Modal.Footer>
                    <div className="w-100 d-flex justify-content-between">
                         <div>
                            {returnDetail?.Status === 'PENDING' && (
                                <>
                                    <Button variant="primary" className="me-2" disabled={updating} onClick={() => handleStatusUpdate('APPROVED')}>Phê duyệt</Button>
                                    <Button variant="danger" disabled={updating} onClick={() => handleStatusUpdate('REJECTED')}>Từ chối</Button>
                                </>
                            )}
                            {returnDetail?.Status === 'APPROVED' && (
                                <Button variant="success" disabled={updating} onClick={() => handleStatusUpdate('COMPLETED')}>Đã hoàn tất thủ tục</Button>
                            )}
                        </div>
                        <Button variant="secondary" onClick={onHide}>Đóng</Button>
                    </div>
                </Modal.Footer>
            </Modal>
            
            <ConfirmModal
                show={showConfirmModal}
                onHide={() => setShowConfirmModal(false)}
                onConfirm={handleConfirmUpdate}
                title={modalContent.title}
                message={modalContent.message}
                confirmText={modalContent.confirmText}
                confirmVariant={modalContent.variant}
                isProcessing={updating}
            />
        </>
    );
};

export default ReturnDetailModal;
