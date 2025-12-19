// client/src/pages/AdminDashboardPage.jsx (Refactored)
import React from "react";
import { Row, Col, Alert, Card, Spinner, Badge, Table } from "react-bootstrap";
import { PersonWorkspace } from "react-bootstrap-icons";
import AdminLayout from "../components/AdminLayout";
import StatCard from "../components/StatCard";
import SalesChart from "../components/SalesChart";
import TopProductsTable from "../components/TopProductsTable";
import LowStockTable from "../components/LowStockTable";
import { useDashboardStats } from "../hooks/useDashboardStats";

const AdminDashboardPage = () => {
    const {
        stats,
        loading,
        error,
        salesData,
        selectedYear,
        setSelectedYear,
        chartLoading,
        currentYear,
    } = useDashboardStats();

    const formatCurrency = (amount) => {
        return new Intl.NumberFormat("vi-VN", {
            style: "currency",
            currency: "VND",
            minimumFractionDigits: 0,
        }).format(amount);
    };

    const statCards = [
        { title: 'Doanh số tháng này', value: stats.totalSales, variant: 'primary' },
        { title: 'Đơn hàng mới', value: stats.newOrdersCount, variant: 'info' },
        { title: 'Sản phẩm tồn kho thấp', value: stats.lowStockCount, variant: 'warning' },
        { title: 'Tổng Người dùng', value: stats.totalUsersCount, variant: 'success' },
    ];

    return (
        <AdminLayout>
            <h2 className="mb-4">Dashboard</h2>
            {error && <Alert variant="danger">{error}</Alert>}

            {/* 1. Stat Cards Section */}
            <Row className="mb-4">
                {statCards.map((stat, index) => (
                    <Col md={3} key={index}>
                        <StatCard
                            title={stat.title}
                            value={stat.value}
                            loading={loading}
                            variant={stat.variant}
                        />
                    </Col>
                ))}
            </Row>

            {/* 2. Sales Chart Section */}
            <SalesChart
                salesData={salesData}
                selectedYear={selectedYear}
                onYearChange={setSelectedYear}
                loading={chartLoading}
                currentYear={currentYear}
            />

            {/* 3. Detailed Stats Section */}
            <Row className="mt-4 g-4">
                <Col md={6}>
                    <TopProductsTable products={stats.topSellingProducts} loading={loading} />
                </Col>
                <Col md={6}>
                    <LowStockTable products={stats.lowStockProducts} loading={loading} />
                </Col>
            </Row>

            {/* 4. Top Customer & Latest Orders Section */}
            <Row className="mt-4">
                <Col md={12}>
                    <Card className="shadow-sm">
                        <Card.Header className="d-flex align-items-center">
                            <PersonWorkspace className="me-2 text-info" />
                            Khách hàng tiềm năng nhất
                        </Card.Header>
                        <Card.Body className="text-center">
                            {loading ? (
                                <Spinner animation="border" size="sm" />
                            ) : stats.topCustomer ? (
                                <>
                                    <h5 className="card-title">{stats.topCustomer.HoTen}</h5>
                                    <p className="card-text text-muted">{stats.topCustomer.Email}</p>
                                    <h4 className="text-primary">
                                        {formatCurrency(stats.topCustomer.totalSpent)}
                                    </h4>
                                    <p className="text-muted mb-0">Tổng chi tiêu</p>
                                </>
                            ) : (
                                <p className="text-muted mb-0">Chưa có dữ liệu.</p>
                            )}
                        </Card.Body>
                    </Card>
                </Col>
            </Row>

            {/* 5. Latest Orders Table */}
            <Card className="shadow-sm mt-4">
                <Card.Header>Đơn hàng chờ xử lý (5 đơn gần nhất)</Card.Header>
                <Card.Body>
                    {loading ? (
                        <div className="text-center py-3"><Spinner animation="border" size="sm" /></div>
                    ) : stats.latestOrders.length === 0 ? (
                        <p>Không có đơn hàng mới nào cần xử lý.</p>
                    ) : (
                        <Table responsive hover size="sm">
                            <thead>
                                <tr>
                                    <th>Mã ĐH</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày đặt</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                {stats.latestOrders.map((order) => (
                                    <tr key={order.DonHangID}>
                                        <td>ORD_{order.DonHangID}</td>
                                        <td>{order.HoTen}</td>
                                        <td>
                                            {new Date(order.NgayDatHang).toLocaleDateString("vi-VN")}
                                        </td>
                                        <td>{formatCurrency(order.TongThanhToan)}</td>
                                        <td>
                                            <Badge bg="info">{order.TrangThai}</Badge>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </Table>
                    )}
                </Card.Body>
            </Card>
        </AdminLayout>
    );
};

export default AdminDashboardPage;
