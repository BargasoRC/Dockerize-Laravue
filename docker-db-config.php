<?php
// Docker database configuration override
// This file should be included in your legacy PHP application

// Override database connection settings for Docker environment
if (!defined('DB_HOST')) {
    define('DB_HOST', $_ENV['DB_HOST'] ?? $_ENV['MYSQL_HOST'] ?? 'db');
}
if (!defined('DB_USER')) {
    define('DB_USER', $_ENV['DB_USERNAME'] ?? $_ENV['MYSQL_USER'] ?? 'root');
}
if (!defined('DB_PASSWORD')) {
    define('DB_PASSWORD', $_ENV['DB_PASSWORD'] ?? $_ENV['MYSQL_PASSWORD'] ?? '');
}
if (!defined('DB_NAME')) {
    define('DB_NAME', $_ENV['DB_DATABASE'] ?? $_ENV['MYSQL_DATABASE'] ?? 'pens_admin_us');
}
if (!defined('DB_PORT')) {
    define('DB_PORT', $_ENV['DB_PORT'] ?? $_ENV['MYSQL_PORT'] ?? 3306);
}

// Legacy variable assignments (if your code uses variables instead of constants)
$db_host = DB_HOST;
$db_user = DB_USER;
$db_password = DB_PASSWORD;
$db_name = DB_NAME;
$db_port = DB_PORT;

// Alternative variable names that legacy code might use
$mysql_host = DB_HOST;
$mysql_user = DB_USER;
$mysql_password = DB_PASSWORD;
$mysql_database = DB_NAME;
$mysql_port = DB_PORT;

$database_host = DB_HOST;
$database_user = DB_USER;
$database_password = DB_PASSWORD;
$database_name = DB_NAME;
$database_port = DB_PORT;
?>