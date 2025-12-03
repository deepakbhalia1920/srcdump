CREATE SCHEMA IF NOT EXISTS alloydb_demo;
CREATE TABLE IF NOT EXISTS alloydb_demo.fashion_products_tmp1 (
    id INT PRIMARY KEY,
    gender TEXT,
    masterCategory TEXT,
    subCategory TEXT,
    articleType TEXT,
    baseColour TEXT,
    season TEXT,
    year INT,
    usage TEXT,
    productDisplayName TEXT,
    link TEXT,
    unitPrice NUMERIC(10,2),
    discount INT,
    finalPrice NUMERIC(10,2),
    rating NUMERIC(3,1),
    stockCode VARCHAR(20),
    stockStatus TEXT
);