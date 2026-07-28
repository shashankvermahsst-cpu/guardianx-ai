-- ==========================================================
-- GuardianX AI - PostgreSQL Database Schema
-- Protect. Monitor. Guide.
-- ==========================================================

-- Enable Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Enum Definitions
CREATE TYPE user_role AS ENUM ('parent', 'child', 'admin');
CREATE TYPE device_platform AS ENUM ('android', 'ios');
CREATE TYPE network_type AS ENUM ('wifi', '4g', '5g', 'cellular', 'offline');
CREATE TYPE alert_severity AS ENUM ('low', 'medium', 'high', 'critical');
CREATE TYPE alert_type AS ENUM (
    'new_app_installed',
    'app_removed',
    'low_battery',
    'device_offline',
    'sim_changed',
    'vpn_enabled',
    'root_detected',
    'factory_reset_attempt',
    'dangerous_website',
    'unknown_location',
    'speed_exceeded',
    'geofence_exit',
    'geofence_entry'
);
CREATE TYPE sub_plan AS ENUM ('free_trial', 'monthly', 'quarterly', 'yearly', 'family_plan');

-- 1. Users Table (Parents & Admins)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    phone_number VARCHAR(50),
    role user_role DEFAULT 'parent',
    is_2fa_enabled BOOLEAN DEFAULT FALSE,
    two_factor_secret VARCHAR(255),
    is_email_verified BOOLEAN DEFAULT FALSE,
    profile_image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Children Profile Table
CREATE TABLE children (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parent_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    age INT,
    avatar_url TEXT,
    pairing_code VARCHAR(10) UNIQUE NOT NULL,
    is_paired BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Child Devices Table
CREATE TABLE devices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    child_id UUID UNIQUE NOT NULL REFERENCES children(id) ON DELETE CASCADE,
    device_name VARCHAR(100) NOT NULL,
    model VARCHAR(100),
    os_version VARCHAR(50),
    platform device_platform DEFAULT 'android',
    fcm_token TEXT,
    device_fingerprint VARCHAR(255) UNIQUE NOT NULL,
    is_online BOOLEAN DEFAULT FALSE,
    battery_level INT DEFAULT 100,
    is_charging BOOLEAN DEFAULT FALSE,
    temperature DECIMAL(5, 2) DEFAULT 35.0,
    network_type network_type DEFAULT 'wifi',
    is_vpn_active BOOLEAN DEFAULT FALSE,
    is_rooted BOOLEAN DEFAULT FALSE,
    last_seen TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Location History & Telemetry
CREATE TABLE locations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    altitude DECIMAL(8, 2),
    accuracy DECIMAL(6, 2),
    speed DECIMAL(5, 2) DEFAULT 0.0,
    address TEXT,
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_locations_device_time ON locations(device_id, recorded_at DESC);

-- 5. Safe Zones / GeoFences
CREATE TABLE geofences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    child_id UUID NOT NULL REFERENCES children(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    radius_meters INT DEFAULT 200,
    alert_on_entry BOOLEAN DEFAULT TRUE,
    alert_on_exit BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Installed Apps & Usage Statistics
CREATE TABLE installed_apps (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
    package_name VARCHAR(255) NOT NULL,
    app_name VARCHAR(150) NOT NULL,
    icon_url TEXT,
    category VARCHAR(100) DEFAULT 'General',
    is_blocked BOOLEAN DEFAULT FALSE,
    daily_limit_minutes INT DEFAULT 0, -- 0 means no limit
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(device_id, package_name)
);

CREATE TABLE app_usages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
    package_name VARCHAR(255) NOT NULL,
    usage_date DATE NOT NULL DEFAULT CURRENT_DATE,
    screen_time_seconds INT DEFAULT 0,
    launch_count INT DEFAULT 0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(device_id, package_name, usage_date)
);

-- 7. Content Filtering & Web Blocking Rules
CREATE TABLE content_filters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    child_id UUID NOT NULL REFERENCES children(id) ON DELETE CASCADE,
    block_adult BOOLEAN DEFAULT TRUE,
    block_gambling BOOLEAN DEFAULT TRUE,
    block_violence BOOLEAN DEFAULT TRUE,
    block_social_media BOOLEAN DEFAULT FALSE,
    safe_search_enabled BOOLEAN DEFAULT TRUE,
    custom_blocked_urls TEXT[], -- Array of domain strings
    custom_allowed_urls TEXT[],
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. Screen Time Schedules
CREATE TABLE screen_time_schedules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    child_id UUID NOT NULL REFERENCES children(id) ON DELETE CASCADE,
    daily_limit_minutes INT DEFAULT 180,
    bedtime_start TIME DEFAULT '21:30:00',
    bedtime_end TIME DEFAULT '06:30:00',
    school_mode_enabled BOOLEAN DEFAULT FALSE,
    school_start TIME DEFAULT '08:00:00',
    school_end TIME DEFAULT '15:00:00',
    reward_minutes_bank INT DEFAULT 0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 9. Security Alerts & System Events
CREATE TABLE alerts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    child_id UUID NOT NULL REFERENCES children(id) ON DELETE CASCADE,
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    type alert_type NOT NULL,
    severity alert_severity DEFAULT 'medium',
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 10. AI Analytics & Predictive Risk Reports
CREATE TABLE ai_insights (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    child_id UUID NOT NULL REFERENCES children(id) ON DELETE CASCADE,
    report_date DATE DEFAULT CURRENT_DATE,
    addiction_risk_score INT DEFAULT 20, -- 0 to 100
    gaming_hours DECIMAL(4, 2) DEFAULT 0.0,
    education_hours DECIMAL(4, 2) DEFAULT 0.0,
    social_media_hours DECIMAL(4, 2) DEFAULT 0.0,
    sleep_score INT DEFAULT 90, -- 0 to 100
    risk_level VARCHAR(50) DEFAULT 'Low Risk',
    ai_summary TEXT,
    recommended_actions TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 11. Subscriptions & Payment Transactions
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    plan sub_plan DEFAULT 'free_trial',
    purchase_token TEXT,
    order_id VARCHAR(255),
    amount_usd DECIMAL(8, 2) DEFAULT 0.0,
    status VARCHAR(50) DEFAULT 'active',
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Seed Initial Super Admin
INSERT INTO users (id, email, password_hash, full_name, role, is_email_verified)
VALUES (
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    'admin@guardianx.ai',
    '$2b$10$e8W/Yl.J9nZ3cK4Uf7rB/e8fX6vE3m2y.1Z0g9w8x7y6z5a4b3c2d', -- Mock hashed password
    'GuardianX Super Admin',
    'admin',
    TRUE
) ON CONFLICT (email) DO NOTHING;
