-- Enums
CREATE TYPE GENDER AS ENUM ('Male', 'Female');
CREATE TYPE ACTIVITY_LEVEL AS ENUM ('Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active', 'Super Active');
CREATE TYPE GOAL AS ENUM ('Cut', 'Maintain', 'Bulk');

-- Users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    weight NUMERIC(4,1) CHECK (weight >= 0) NOT NULL, -- in kg
    height NUMERIC(4,1) CHECK (height >= 0) NOT NULL, -- in cm
    gender GENDER NOT NULL, 
    goal GOAL NOT NULL,
    activity_level ACTIVITY_LEVEL NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    password_hash TEXT NOT NULL
);

-- Entries
CREATE TABLE entries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    calories INTEGER CHECK (calories >= 0) NOT NULL,
    protein INTEGER CHECK (protein >= 0) NOT NULL,
    fat INTEGER CHECK (fat >= 0) NOT NULL,
    carbs INTEGER CHECK (carbs >= 0) NOT NULL,
    serving_size VARCHAR(25) NOT NULL,
    num_servings NUMERIC(7,3) CHECK (num_servings >= 0) NOT NULL,
    time TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP, 
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);