// server.js

const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const cors = require('cors');
require('dotenv').config();  // Load environment variables from .env file

// Initialize Express app
const app = express();
const port = process.env.PORT || 5000;  // Use port from .env or default to 5000

// Middleware
app.use(cors());
app.use(bodyParser.json());

// MySQL Database connection using environment variables
const db = mysql.createConnection({
    host: process.env.DB_HOST,   // Use DB_HOST from .env
    user: process.env.DB_USER,   // Use DB_USER from .env
    password: process.env.DB_PASSWORD,  // Use DB_PASSWORD from .env
    database: process.env.DB_NAME   // Use DB_NAME from .env
});

// Test DB connection
db.connect((err) => {
    if (err) {
        console.error('Error connecting to database: ', err);
        process.exit(1);
    }
    console.log('Connected to MySQL database');
});

// API routes
app.get('/api/lottery', (req, res) => {
    const query = 'SELECT * FROM staging_lottery';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching data: ', err);
            return res.status(500).json({ error: 'Database error' });
        }
        res.json(results);
    });
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});