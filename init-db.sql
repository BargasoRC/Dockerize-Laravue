-- Create the admin database
CREATE DATABASE IF NOT EXISTS `pens_admin_us`;

-- Grant privileges (optional, since we're using root with empty password)
GRANT ALL PRIVILEGES ON `pens_admin_us`.* TO 'root'@'%';
FLUSH PRIVILEGES;