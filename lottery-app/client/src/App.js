// src/App.js

import React, { useState } from 'react';
import LotteryList from './components/LotteryList';
import Statistics from './components/Statistics'; // Import component thống kê
import './App.css'
const App = () => {
    // State để quản lý tab hiện tại
    const [activeTab, setActiveTab] = useState('lottery'); // 'lottery' hoặc 'statistics'

    return (
        <div className="App">
            <h1>Lottery App</h1>

            {/* Tabs */}
            <div className="tabs">
                <button
                    onClick={() => setActiveTab('lottery')}
                    className={activeTab === 'lottery' ? 'active' : ''}
                >
                    Lottery List
                </button>
                <button
                    onClick={() => setActiveTab('statistics')}
                    className={activeTab === 'statistics' ? 'active' : ''}
                >
                    Statistics
                </button>
            </div>

            {/* Render tab content based on activeTab */}
            {activeTab === 'lottery' && <LotteryList />}
            {activeTab === 'statistics' && <Statistics />} {/* Render Statistics component */}
        </div>
    );
};

export default App;
