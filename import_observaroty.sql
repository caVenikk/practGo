CREATE DATABASE IF NOT EXISTS observatory;

USE observatory;

CREATE TABLE sectors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    coordinates VARCHAR(100),
    light_intensity DECIMAL(10, 5),
    foreign_objects INT,
    num_objects INT,
    num_undefined INT,
    num_defined INT,
    notes TEXT
);

CREATE TABLE objects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50),
    accuracy DECIMAL(10, 5),
    quantity INT,
    time TIME,
    date DATE,
    notes TEXT
);

CREATE TABLE natural_objects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50),
    galaxy VARCHAR(100),
    accuracy DECIMAL(10, 5),
    light_flux DECIMAL(10, 5),
    associated_objects VARCHAR(100),
    notes TEXT
);

CREATE TABLE positions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    earth_position VARCHAR(100),
    sun_position VARCHAR(100),
    moon_position VARCHAR(100)
);

CREATE TABLE observations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sector_id INT,
    object_id INT,
    natural_object_id INT,
    position_id INT,
    observation_time DATETIME,
    FOREIGN KEY (sector_id) REFERENCES sectors(id),
    FOREIGN KEY (object_id) REFERENCES objects(id),
    FOREIGN KEY (natural_object_id) REFERENCES natural_objects(id),
    FOREIGN KEY (position_id) REFERENCES positions(id)
);
