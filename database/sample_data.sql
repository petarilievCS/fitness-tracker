-- Sample Users
INSERT INTO users (first_name, last_name, birth_date, weight, height, gender, goal, activity_level, email, password_hash)
VALUES
('John', 'Doe', '1990-05-14', 75.5, 180.0, 'Male', 'Maintain', 'Moderately Active', 'john.doe@example.com', 'hashedpassword123'),
('Jane', 'Smith', '1985-09-23', 68.0, 165.0, 'Female', 'Cut', 'Lightly Active', 'jane.smith@example.com', 'hashedpassword456'),
('Alice', 'Brown', '1995-07-11', 60.2, 170.5, 'Female', 'Bulk', 'Very Active', 'alice.brown@example.com', 'hashedpassword789'),
('Bob', 'Johnson', '2000-01-30', 90.0, 190.0, 'Male', 'Cut', 'Sedentary', 'bob.johnson@example.com', 'hashedpassword321'),
('Emily', 'Davis', '1992-03-15', 72.3, 175.2, 'Female', 'Maintain', 'Super Active', 'emily.davis@example.com', 'hashedpassword654');

-- Sample Entries
INSERT INTO entries (name, calories, protein, fat, carbs, serving_size, num_servings, time, user_id)
VALUES
('Oatmeal with Berries', 500, 25, 10, 60, 'Cup', 1.0, '2024-12-14 08:00:00+00', 1),
('Chicken Salad', 750, 35, 15, 80, 'Bowl', 1.5, '2024-12-14 12:30:00+00', 1),
('Avocado Toast', 400, 20, 8, 50, 'Slice', 2.0, '2024-12-14 19:00:00+00', 1),
('Protein Bar', 300, 15, 5, 40, 'Piece', 1.2, '2024-12-14 10:00:00+00', 2),
('Beef Stir Fry', 600, 30, 12, 70, 'Pack', 1.0, '2024-12-14 13:45:00+00', 2),
('Greek Yogurt with Nuts', 550, 28, 10, 65, 'Cup', 1.0, '2024-12-14 18:00:00+00', 3),
('Pasta with Chicken', 800, 40, 20, 90, 'Plate', 2.0, '2024-12-14 07:00:00+00', 3),
('Banana', 200, 10, 3, 25, 'Piece', 1.0, '2024-12-14 15:00:00+00', 4),
('Rice and Beans', 450, 22, 8, 50, 'Bowl', 1.5, '2024-12-14 20:00:00+00', 4),
('Granola Bar', 300, 18, 5, 35, 'Pack', 1.2, '2024-12-14 11:00:00+00', 5),
('Grilled Salmon with Vegetables', 700, 33, 14, 80, 'Plate', 1.0, '2024-12-14 19:30:00+00', 5);