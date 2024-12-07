// src/components/LotteryList.js

import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './LotteryList.css'; // Importing the CSS file

const LotteryList = () => {
    const [lotteries, setLotteries] = useState([]);
    const [currentPage, setCurrentPage] = useState(1); // Track current page
    const [itemsPerPage] = useState(10); // Set items per page
    const [totalPages, setTotalPages] = useState(0); // Track total number of pages
    const [searchTerm, setSearchTerm] = useState(''); // Track the search term
    const [filteredLotteries, setFilteredLotteries] = useState([]); // Store filtered lotteries

    useEffect(() => {
        // Fetch the lottery data from the API
        axios.get('http://localhost:5000/api/lottery')
            .then(response => {
                setLotteries(response.data);  // Set the data into state
                setFilteredLotteries(response.data); // Set the filtered data
                setTotalPages(Math.ceil(response.data.length / itemsPerPage)); // Calculate total pages
            })
            .catch(error => {
                console.error('Error fetching lottery data:', error);
            });
    }, []);  // Empty dependency array means this runs once when the component mounts

// Filter lotteries based on the search term
    useEffect(() => {
        const filtered = lotteries.filter(lottery => {
            // Safely handle null or undefined values by converting them to empty strings
            return (
                (String(lottery.prize_special).toLowerCase().includes(searchTerm)) ||
                (String(lottery.prize_one).toLowerCase().includes(searchTerm)) ||
                (String(lottery.prize_two).toLowerCase().includes(searchTerm)) ||
                (String(lottery.prize_three).toLowerCase().includes(searchTerm)) ||
                (String(lottery.prize_four).toLowerCase().includes(searchTerm)) ||
                (String(lottery.prize_five).toLowerCase().includes(searchTerm)) ||
                (String(lottery.prize_six).toLowerCase().includes(searchTerm)) ||
                (String(lottery.prize_seven).toLowerCase().includes(searchTerm)) ||
                (String(lottery.prize_eight).toLowerCase().includes(searchTerm))
            );
        });

        setFilteredLotteries(filtered); // Update filtered data based on search
        setTotalPages(Math.ceil(filtered.length / itemsPerPage)); // Recalculate total pages after filtering
        setCurrentPage(1); // Reset to page 1 when search changes
    }, [searchTerm, lotteries]);  // Run the filter when searchTerm or lotteries data changes

    // Get the current page's lotteries
    const indexOfLastLottery = currentPage * itemsPerPage;
    const indexOfFirstLottery = indexOfLastLottery - itemsPerPage;
    const currentLotteries = filteredLotteries.slice(indexOfFirstLottery, indexOfLastLottery);

    // Handle page change
    const handlePageChange = (page) => {
        if (page >= 1 && page <= totalPages) {
            setCurrentPage(page);
        }
    };

    return (
        <div className="lottery-container">

            {/* Search Input */}
            <div className="search-container">
                <input
                    type="text"
                    placeholder="Search by prize..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="search-input"
                />
            </div>

            {filteredLotteries.length === 0 ? (
                <p className="no-lottery">No lotteries available.</p>
            ) : (
                <>
                    <table className="lottery-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Prize Special</th>
                            <th>Prize One</th>
                            <th>Prize Two</th>
                            <th>Prize Three</th>
                            <th>Prize Four</th>
                            <th>Prize Five</th>
                            <th>Prize Six</th>
                            <th>Prize Seven</th>
                            <th>Prize Eight</th>
                            <th>Date Deleted</th>
                            <th>Modify Date</th>
                        </tr>
                        </thead>
                        <tbody>
                        {currentLotteries.map((lottery) => (
                            <tr key={lottery.id}>
                                <td>{lottery.id}</td>
                                <td>{lottery.prize_special}</td>
                                <td>{lottery.prize_one}</td>
                                <td>{lottery.prize_two}</td>
                                <td>{lottery.prize_three}</td>
                                <td>{lottery.prize_four}</td>
                                <td>{lottery.prize_five}</td>
                                <td>{lottery.prize_six}</td>
                                <td>{lottery.prize_seven}</td>
                                <td>{lottery.prize_eight}</td>
                                <td>{lottery.date_delete ? new Date(lottery.date_delete).toLocaleString() : 'N/A'}</td>
                                <td>{lottery.modify_date ? new Date(lottery.modify_date).toLocaleString() : 'N/A'}</td>
                            </tr>
                        ))}
                        </tbody>
                    </table>

                    {/* Pagination Controls */}
                    <div className="pagination">
                        <button
                            onClick={() => handlePageChange(currentPage - 1)}
                            disabled={currentPage === 1}>
                            Previous
                        </button>

                        <span className="page-info">
                            Page {currentPage} of {totalPages}
                        </span>

                        <button
                            onClick={() => handlePageChange(currentPage + 1)}
                            disabled={currentPage === totalPages}>
                            Next
                        </button>
                    </div>
                </>
            )}
        </div>
    );
};

export default LotteryList;
