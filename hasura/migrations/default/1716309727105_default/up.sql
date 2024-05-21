CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    phone_number VARCHAR(20),
    full_name VARCHAR(255),
    username VARCHAR(255),
    birthdate DATE
);