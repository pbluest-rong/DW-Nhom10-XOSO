import React, { useState, useEffect } from 'react';
import './Statistics.css';
import { Bar } from 'react-chartjs-2';
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend } from 'chart.js';

// Đăng ký các thành phần của Chart.js
ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend);

const Statistics = () => {
    const [data, setData] = useState({
        totalDraws: 0,
        totalPrizeValue: 0, // Khởi tạo giá trị giải thưởng ban đầu là 0
        monthlyData: [], // Dữ liệu xổ số theo tháng
        provinceMonthData: [] // Dữ liệu xổ số theo tỉnh và tháng
    });

    // Lấy thống kê từ API
    useEffect(() => {
        const fetchStatistics = async () => {
            try {
                // Giả sử dữ liệu trả về là một mảng các thống kê theo tháng và tỉnh
                const response = await fetch('http://localhost:5000/api/statistics');
                const result = await response.json();

                // Tính tổng số lần xổ số
                const totalDraws = result.reduce((acc, item) => acc + item.total_lottery_draws, 0);

                // Dữ liệu theo tháng
                const monthlyData = result.reduce((acc, item) => {
                    const month = `Tháng ${item.month}`;
                    if (!acc[month]) acc[month] = 0;
                    acc[month] += item.total_lottery_draws;
                    return acc;
                }, {});

                // Chuyển đổi từ object thành array cho chart
                const monthlyDataArray = Object.keys(monthlyData).map(month => ({
                    month,
                    totalDraws: monthlyData[month]
                }));

                // Dữ liệu theo tỉnh và tháng
                const provinceMonthData = result.map(item => ({
                    province: item.province_name,
                    month: item.month,
                    totalDraws: item.total_lottery_draws
                }));

                // Tính tổng giá trị giải thưởng = 5 tỷ VND * tổng số lần xổ số
                const totalPrizeValue = totalDraws * 5000000000; // 5 tỷ VND cho mỗi lần xổ số

                // Cập nhật state với dữ liệu đã xử lý
                setData({
                    totalDraws,
                    totalPrizeValue, // Cập nhật tổng giá trị giải thưởng
                    monthlyData: monthlyDataArray,
                    provinceMonthData
                });
            } catch (error) {
                console.error('Error fetching statistics:', error);
            }
        };

        fetchStatistics();
    }, []); // Chạy một lần khi component mount

    // Dữ liệu cho biểu đồ số lần xổ số theo tháng
    const chartData = {
        labels: data.monthlyData.map(item => item.month), // Các tháng
        datasets: [
            {
                label: 'Số lần xổ số',
                data: data.monthlyData.map(item => item.totalDraws),
                backgroundColor: '#007bff',
                borderColor: '#0056b3',
                borderWidth: 1
            }
        ]
    };

    // Nhóm dữ liệu theo tỉnh và tháng
    const groupedData = data.provinceMonthData.reduce((acc, item) => {
        const key = `${item.province} - Tháng ${item.month}`;
        if (!acc[key]) {
            acc[key] = 0;
        }
        acc[key] += item.totalDraws;
        return acc;
    }, {});

    // Chuyển đổi object thành array để hiển thị
    const groupedDataArray = Object.keys(groupedData).map(key => ({
        key,
        totalDraws: groupedData[key]
    }));

    // Chuẩn bị dữ liệu cho biểu đồ thống kê theo tỉnh và tháng
    const provinceMonthChartData = {
        labels: groupedDataArray.map(item => item.key), // Tỉnh và tháng
        datasets: [
            {
                label: 'Số lần xổ số',
                data: groupedDataArray.map(item => item.totalDraws),
                backgroundColor: '#28a745',
                borderColor: '#218838',
                borderWidth: 1
            }
        ]
    };

    return (
        <div className="statistics">
            <h2>Lottery Statistics</h2>

            {/* Dữ liệu xổ số theo tỉnh và tháng */}
            <div className="province-month-data">
                <h3>Dữ liệu xổ số theo tỉnh và tháng</h3>
                <ul>
                    {groupedDataArray.map((item, index) => (
                        <li key={index}>
                            {item.key}: {item.totalDraws} lần xổ số
                        </li>
                    ))}
                </ul>
            </div>

            {/* Hiển thị tổng số lần xổ số và tổng giá trị giải thưởng */}
            <div className="statistics-summary">
                <p><strong>Tổng số lần xổ số:</strong> {data.totalDraws}</p>
                <p><strong>Tổng giá trị giải thưởng:</strong> {data.totalPrizeValue.toLocaleString()} VND</p>
            </div>

            {/* Biểu đồ số lần xổ số theo tháng */}
            <div className="chart-container">
                <h3>Số lần xổ số theo tháng</h3>
                <Bar
                    data={chartData}
                    options={{
                        responsive: true,
                        plugins: {
                            title: {
                                display: true,
                                text: 'Số lần xổ số theo tháng'
                            }
                        }
                    }}
                />
            </div>

            {/* Biểu đồ số lần xổ số theo tỉnh và tháng */}
            <div className="chart-container">
                <h3>Số lần xổ số theo tỉnh và tháng</h3>
                <Bar
                    data={provinceMonthChartData}
                    options={{
                        responsive: true,
                        plugins: {
                            title: {
                                display: true,
                                text: 'Số lần xổ số theo tỉnh và tháng'
                            }
                        },
                        scales: {
                            x: {
                                ticks: {
                                    maxRotation: 90,
                                    minRotation: 45
                                }
                            }
                        }
                    }}
                />
            </div>
        </div>
    );
};

export default Statistics;
