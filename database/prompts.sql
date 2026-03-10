-- Prompts table
-- Stores user input text and CBT responses

CREATE TABLE prompts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    user_text TEXT NOT NULL,
    cbt_response TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user
      FOREIGN KEY (user_id)
      REFERENCES users(id)
      ON DELETE SET NULL
);
