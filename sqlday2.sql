CREATE SCHEMA guvi;
-- 1. Users Table: Stores user information
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student', 'trainer', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Courses Table: Stores course information
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    trainer_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (trainer_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- 3. Enrollments Table: Tracks student enrollments
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    course_id INT,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- 4. Schedules Table: Manages course schedules
CREATE TABLE Schedules (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    class_time TIME,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- 5. Assignments Table: Stores assignments for courses
CREATE TABLE Assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    title VARCHAR(100),
    description TEXT,
    due_date DATE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- 6. Submissions Table: Stores student assignment submissions
CREATE TABLE Submissions (
    submission_id INT PRIMARY KEY AUTO_INCREMENT,
    assignment_id INT,
    user_id INT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    grade VARCHAR(10),
    FOREIGN KEY (assignment_id) REFERENCES Assignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
-- Insert Users
INSERT INTO Users (name, email, password_hash, role) VALUES
('John Doe', 'john@example.com', 'hashedpassword123', 'student'),
('Alice Smith', 'alice@example.com', 'hashedpassword456', 'trainer');

-- Insert Courses
INSERT INTO Courses (course_name, description, category, trainer_id) VALUES
('Full Stack Development', 'Learn MERN Stack', 'Web Development', 2),
('Data Science', 'Intro to Data Analysis', 'Data', 2);

-- Insert Enrollments
INSERT INTO Enrollments (user_id, course_id) VALUES
(1, 1);

-- Insert Schedules
INSERT INTO Schedules (course_id, start_date, end_date, class_time) VALUES
(1, '2024-11-01', '2025-01-31', '10:00:00');

-- Insert Assignments
INSERT INTO Assignments (course_id, title, description, due_date) VALUES
(1, 'React Project', 'Create a project using React', '2024-12-15');

-- Insert Submissions
INSERT INTO Submissions (assignment_id, user_id, grade) VALUES
(1, 1, 'A');

-- Get all students enrolled in a course
SELECT u.name, c.course_name
FROM Enrollments e
JOIN Users u ON e.user_id = u.user_id
JOIN Courses c ON e.course_id = c.course_id;

-- Get all assignments for a course
SELECT a.title, a.due_date
FROM Assignments a
JOIN Courses c ON a.course_id = c.course_id
WHERE c.course_id = 1;
