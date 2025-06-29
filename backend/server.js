const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
const app = express();
const PORT = 3000;

// Nastavení připojení k databázi
const pool = mysql.createPool({
    host: process.env.MYSQLHOST || 'localhost',
    user: process.env.MYSQLUSER || 'root',
    password: process.env.MYSQLPASSWORD || 'demo123',
    database: process.env.MYSQLDATABASE || 'demoapp',
    port: process.env.MYSQLPORT ? parseInt(process.env.MYSQLPORT) : 3306,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
    res.send('<h2>Demo Backend (MySQL)</h2><p>API endpoint: <code>/api/message</code></p>');
});

app.get('/api/message', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT text FROM messages LIMIT 1');
        res.json({
            message: rows[0]?.text || 'Žádná zpráva v databázi.',
            time: new Date().toLocaleString()
        });
    } catch (err) {
        console.error('Chyba při čtení z databáze:', err);
        res.status(500).json({ message: 'Chyba při čtení z databáze.' });
    }
});

app.listen(PORT, () => {
    console.log(`Backend běží na http://localhost:${PORT}`);
});