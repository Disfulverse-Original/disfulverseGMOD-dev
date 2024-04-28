-- This file contains the database config for the addon. If you aren't using an
-- external MySQL connection, ignore this file :)

-- Requirements for external MySQL: 
--
-- 1) MySQLoo - Latest version pls https://github.com/FredyH/MySQLOO 
--
-- 2) MySQL 8.0 or later, as I use functions such as UUID_TO_BIN() and
--    BIN_TO_UUID()
--
-- If you don't meet these, don't come running to me in a support ticket that
-- the addon doesn't work. It's in the addon's requirements section on gmodstore
-- for a fucking reason.


-- This enables external MySQL support.

-- The actual details of the account.
YAWS.ManualConfig.Database.Username = "" -- Username
YAWS.ManualConfig.Database.Password = "" -- Password
YAWS.ManualConfig.Database.Host = "" -- Host
YAWS.ManualConfig.Database.Port = 3306 -- Port
YAWS.ManualConfig.Database.Schema = "" -- Schema (the database to use)

-- Table prefix. This is used if you are running multiple databases for the
-- addon on a single schema, ensure this is a valid SQL table name without
-- spaces or special chars. DON'T CHANGE THIS IF YOU WANT WARNS TO SYNC BETWEEN
-- SERVERS N SHIT. THE ADDON WILL HANDLE THAT ITSELF.
YAWS.ManualConfig.Database.TablePrefix = "yaws_"

-- This is the ID the addon uses to track this server when it's being used with
-- other servers. This can't be above 50 characters, and for certain tables will
-- be appended to the table prefix, so ensure it will work as a table name like
-- above.
YAWS.ManualConfig.Database.ServerID = "darkrp"

-- The "pretty" version of your server name. For displaying it. Can't be above
-- 100 chars.
YAWS.ManualConfig.Database.ServerName = "Server One"

-- The refresh rate the addon checks for updates in the database. If you don't
-- know what to make this value, leave it alone.
YAWS.ManualConfig.Database.RefreshRate = 10