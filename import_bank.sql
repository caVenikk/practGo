CREATE DATABASE IF NOT EXISTS bank;

USE bank;

CREATE TABLE individuals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    patronymic VARCHAR(50),
    passport VARCHAR(20) NOT NULL,
    tin VARCHAR(12) NOT NULL,
    snils VARCHAR(11) NOT NULL,
    driver_license VARCHAR(20),
    additional_documents TEXT,
    notes TEXT
);

CREATE TABLE loan_funds (
    id INT AUTO_INCREMENT PRIMARY KEY,
    individual_id INT NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    interest_rate DECIMAL(5, 2) NOT NULL,
    duration INT NOT NULL,
    conditions TEXT,
    notes TEXT,
    FOREIGN KEY (individual_id) REFERENCES individuals(id)
);

CREATE TABLE organization_loans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    organization_id INT NOT NULL,
    individual_id INT NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    duration INT NOT NULL,
    interest_rate DECIMAL(5, 2) NOT NULL,
    conditions TEXT,
    notes TEXT,
    FOREIGN KEY (individual_id) REFERENCES individuals(id)
);



CREATE TABLE borrowers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tin VARCHAR(12) NOT NULL,
    is_individual BOOLEAN NOT NULL,
    address TEXT NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    conditions TEXT,
    legal_notes TEXT,
    contracts_list TEXT
);

ALTER TABLE individuals ADD borrower_id INT;

ALTER TABLE individuals
ADD CONSTRAINT fk_borrower_id
FOREIGN KEY (borrower_id) REFERENCES borrowers(id);