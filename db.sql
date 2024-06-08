CREATE DATABASE bus_booking;

USE bus_booking;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL
);

CREATE TABLE tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    from_location VARCHAR(50),
    to_location VARCHAR(50),
    journey_date DATE,
    coach VARCHAR(50),
    ticket_price DECIMAL(10, 2),
    booking_date DATE,
    ticket_code VARCHAR(6) UNIQUE
);

CREATE TABLE user_emails (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    email VARCHAR(100) UNIQUE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

