-- Initialize admin user
INSERT INTO users VALUES (NULL, 'admin', 'password123', 0, 0, 0, 0, -1, 1, 30, '');

-- Add test user  
INSERT INTO users VALUES (NULL, 'testuser', 'test123', 3600, 30, 0, 0, 1000, 0, 30, '');

-- Show created users
SELECT id, username, admin, max_bots FROM users;
