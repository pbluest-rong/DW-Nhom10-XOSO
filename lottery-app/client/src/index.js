// src/index.js

import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';  // Optional: To add some global styles if needed
import App from './App';  // Import the main App component


ReactDOM.render(
    <React.StrictMode>
        <App />  {/* Render the main App component */}
    </React.StrictMode>,
    document.getElementById('root')  // The root div in your public/index.html
);
