// client/src/components/SalesChart.jsx
import React, { useMemo } from 'react';
import { Card, Form, Spinner } from 'react-bootstrap';
import { Bar } from 'react-chartjs-2';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
} from "chart.js";

// Register Chart.js components
ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
);

const SalesChart = ({ salesData, selectedYear, onYearChange, loading, currentYear }) => {
    const formatCurrency = (amount) => {
        return new Intl.NumberFormat("vi-VN", {
          style: "currency",
          currency: "VND",
          minimumFractionDigits: 0,
        }).format(amount);
    };

    const availableYears = useMemo(() => {
        const years = [];
        for (let i = currentYear - 3; i <= currentYear + 1; i++) {
            years.push(i);
        }
        return years;
    }, [currentYear]);

    const chartData = {
        labels: ["T1", "T2", "T3", "T4", "T5", "T6", "T7", "T8", "T9", "T10", "T11", "T12"],
        datasets: [
            {
                label: "Doanh thu (VND)",
                data: salesData.map((item) => item.revenue),
                backgroundColor: "rgba(54, 162, 235, 0.6)",
                borderColor: "rgba(54, 162, 235, 1)",
                borderWidth: 1,
            },
        ],
    };

    const chartOptions = {
        responsive: true,
        plugins: {
            legend: { position: "top" },
            title: {
                display: true,
                text: `DOANH THU THEO THÁNG NĂM ${selectedYear}`,
            },
            tooltip: {
                callbacks: {
                    label: function (context) {
                        let label = context.dataset.label || "";
                        if (label) {
                            label += ": ";
                        }
                        if (context.parsed.y !== null) {
                            label += formatCurrency(context.parsed.y);
                        }
                        return label;
                    },
                },
            },
        },
        scales: {
            y: {
                beginAtZero: true,
                ticks: {
                    callback: function (value) {
                        return formatCurrency(value);
                    },
                },
            },
        },
    };

    return (
        <Card className="shadow-sm mt-4">
            <Card.Header className="d-flex justify-content-between align-items-center">
                Doanh thu theo tháng
                <Form.Group controlId="selectYear" className="mb-0">
                    <Form.Select
                        size="sm"
                        value={selectedYear}
                        onChange={(e) => onYearChange(parseInt(e.target.value))}
                    >
                        {availableYears.map((year) => (
                            <option key={year} value={year}>
                                Năm {year}
                            </option>
                        ))}
                    </Form.Select>
                </Form.Group>
            </Card.Header>
            <Card.Body>
                {loading ? (
                    <div className="text-center py-5">
                        <Spinner animation="border" />
                    </div>
                ) : (
                    <Bar options={chartOptions} data={chartData} />
                )}
            </Card.Body>
        </Card>
    );
};

export default SalesChart;
