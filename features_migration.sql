CREATE TABLE IF NOT EXISTS articles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    content TEXT NOT NULL,
    author_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ticket_ratings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL UNIQUE,
    rating INT NOT NULL,
    feedback TEXT NULL,
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ticket_audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL,
    user_id INT NULL,
    action VARCHAR(100) NOT NULL,
    details TEXT NULL,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE
);

ALTER TABLE tickets ADD COLUMN category VARCHAR(50) DEFAULT 'General Support';

-- Insert standard Knowledge Base solution articles if empty
INSERT IGNORE INTO articles (id, title, category, content) VALUES
(1, 'How to connect to Corporate VPN', 'Network & VPN', '1. Open Cisco AnyConnect or GlobalProtect.\n2. Enter gateway: vpn.enterprise.corp\n3. Authenticate with your enterprise SSO credentials and accept 2FA prompt.'),
(2, 'Self-Service Password Reset Guide', 'Account Access', '1. Navigate to the self-service identity portal.\n2. Click "Forgot Password".\n3. Complete email verification code and enter new compliant password (minimum 12 characters, uppercase, numbers, symbols).'),
(3, 'Requesting Software Licenses (JetBrains, MS Office, Adobe)', 'Software', '1. Submit a helpdesk ticket with priority "Medium".\n2. Specify the exact software version and business justification.\n3. Your department manager approval will be processed automatically within 24 hours.'),
(4, 'Troubleshooting Office Wi-Fi Connectivity', 'Network & VPN', '1. Forget the "Enterprise-Secure" network from your device settings.\n2. Reconnect and select EAP method: PEAP, MSCHAPv2.\n3. Enter your domain username (without @company.com) and password.');
