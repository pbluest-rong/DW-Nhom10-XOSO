const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const cors = require('cors');

// Load environment variables
require('dotenv').config();

// Initialize Express app
const app = express();
const port = process.env.PORT || 5000; // Use the value from .env or default to 5000

// Middleware
app.use(cors());
app.use(bodyParser.json());

// MySQL Database connection
const db = mysql.createConnection({
    host: process.env.DB_HOST,   // Using environment variables
    user: process.env.DB_USER,   // Using environment variables
    password: process.env.DB_PASSWORD, // Using environment variables
    database: process.env.DB_NAME // Using environment variables
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
            res.status(500).json({ error: err.message });
            return;
        }
        res.json(results);
    });
});

app.post('/api/lottery', (req, res) => {
    const { prize_special, prize_one, prize_two, prize_three, prize_four, prize_five, prize_six, prize_seven, prize_eight } = req.body;

    const query = `
    INSERT INTO lottery (
      prize_special, prize_one, prize_two, prize_three, prize_four,
      prize_five, prize_six, prize_seven, prize_eight
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`;

    db.query(query, [prize_special, prize_one, prize_two, prize_three, prize_four, prize_five, prize_six, prize_seven, prize_eight], (err, result) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        res.status(201).json({ id: result.insertId, ...req.body });
    });
});

app.delete('/api/lottery/:id', (req, res) => {
    const query = 'DELETE FROM staging_lottery WHERE id = ?';
    db.query(query, [req.params.id], (err) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        res.status(204).send();
    });
});

// API to get lottery statistics from `summary_lottery`
app.get('/api/statistics', (req, res) => {
    const { province_name, year, month } = req.query; // Accept query parameters

    let query = 'SELECT * FROM summary_lottery WHERE 1=1'; // Base query

    // Add filters based on query parameters if provided
    if (province_name) {
        query += ' AND province_name = ?';
    }
    if (year) {
        query += ' AND year = ?';
    }
    if (month) {
        query += ' AND month = ?';
    }

    // Execute the query with the provided parameters
    db.query(query, [province_name, year, month], (err, results) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        res.json(results);
    });
});

// Start the server
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
