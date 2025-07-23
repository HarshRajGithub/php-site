/*
  # Add OTP and Email System

  1. New Tables
    - `otp_verifications`
      - `id` (int, primary key)
      - `email` (varchar, email address)
      - `otp` (varchar, 6-digit code)
      - `type` (enum, registration/password_reset)
      - `expires_at` (timestamp)
      - `is_used` (boolean)
      - `created_at` (timestamp)
    
    - `email_logs`
      - `id` (int, primary key)
      - `to_email` (varchar)
      - `subject` (varchar)
      - `message` (text)
      - `email_type` (varchar)
      - `order_id` (int, nullable)
      - `status` (enum, sent/failed)
      - `created_at` (timestamp)

  2. Security
    - No RLS needed as these are system tables
*/

-- Create OTP verifications table
CREATE TABLE IF NOT EXISTS `otp_verifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `otp` varchar(6) NOT NULL,
  `type` enum('registration','password_reset') NOT NULL,
  `expires_at` timestamp NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `email_type` (`email`, `type`),
  KEY `expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create email logs table
CREATE TABLE IF NOT EXISTS `email_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `to_email` varchar(255) NOT NULL,
  `subject` varchar(500) NOT NULL,
  `message` text NOT NULL,
  `email_type` varchar(50) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `status` enum('sent','failed') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `email_type` (`email_type`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Add foreign key constraint for email_logs
ALTER TABLE `email_logs` 
ADD CONSTRAINT `email_logs_order_fk` 
FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL;