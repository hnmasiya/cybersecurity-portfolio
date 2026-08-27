-- Author: Hazvinei Nomatter Masiya
-- Purpose: Investigate failed login attempts outside business hours
SELECT * FROM log_in_attempts WHERE login_time > '18:00:00' AND success = 0;
