RP_MySQLConfig = {} -- Ignore this line
--[[
Welcome to MySQL for DarkRP!
In this file you can find a manual for MySQL configuration and the MySQL config settings.
 ]]


RP_MySQLConfig.EnableMySQL = true -- Set to true if you want to use an external MySQL database, false if you want to use the built in SQLite database (garrysmod/sv.db) of Garry's mod.
RP_MySQLConfig.Host = "db.worldhosts.fun" -- This is the IP address of the MySQL host. Make sure the IP address is correct and in quotation marks (" ")
RP_MySQLConfig.Username = "u11329_7T3sUydFNW" -- This is the username to log in on the MySQL server.
                                -- contact the owner of the server about the username and password. Make sure it's in quotation marks! (" ")
RP_MySQLConfig.Password = "cC!1t03eHOKQtPbFs2p75^Ts" -- This is the Password to log in on the MySQL server,
                                    -- Everyone who has access to FTP on the server can read this password.
                                    -- Make sure you know who to trust. Make sure it's in quotation marks (" ")
RP_MySQLConfig.Database_name = "s11329_disfulversedb" -- This is the name of the Database on the MySQL server. Contact the MySQL server host to find out what this is
RP_MySQLConfig.Database_port = 3306 -- This is the port of the MySQL server. Again, contact the MySQL server host if you don't know this.
RP_MySQLConfig.Preferred_module = "tmysql4" -- Preferred module, case sensitive, must be either "mysqloo" or "tmysql4". Only applies when both are installed.
RP_MySQLConfig.MultiStatements = false -- Only available in tmysql4: allow multiple SQL statements per query. Has no effect if no scripts use it.