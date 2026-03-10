-- Images table
-- Stores metadata of predefined images (not image files)

CREATE TABLE images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    image_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
