--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local function LoadSQLFiles()
    for k, v in ipairs( file.Find( "projectzero/*.lua", "LUA" ) ) do
        if( not string.StartWith( v, "sv_sql" ) ) then continue end
        include( "projectzero/" .. v )
    end
end

if( not file.Exists( "projectzero/mysql.txt", "DATA" ) ) then
    file.Write( "projectzero/mysql.txt", util.TableToJSON( {
        Enabled = false,
        Host = "localhost",
        Username = "root",
        Password = "",
        DatabaseName = "garrysmod",
        DatabasePort = 3306
    }, true ) )
end

local mySqlInfo = util.JSONToTable( file.Read( "projectzero/mysql.txt", "DATA" ) or "" ) or {}
if( mySqlInfo.Enabled ) then
    require( "mysqloo" )

    PROJECT0_SQL_DB = mysqloo.connect( mySqlInfo.Host, mySqlInfo.Username, mySqlInfo.Password, mySqlInfo.DatabaseName, mySqlInfo.DatabasePort )
    PROJECT0_SQL_DB.onConnected = function() 
        print( "[PROJECT0 MySQL] Database has connected!" ) 
        LoadSQLFiles()
    end
    PROJECT0_SQL_DB.onConnectionFailed = function( db, err ) print( "[PROJECT0 MySQL] Connection to database failed! Error: " .. err ) end
    PROJECT0_SQL_DB:connect()
    
    function PROJECT0.FUNC.SQLQuery( queryStr, func, singleRow )
        local query = PROJECT0_SQL_DB:query( queryStr )
        if( func ) then
            function query:onSuccess( data ) 
                if( singleRow ) then
                    data = data[1]
                end
    
                func( data ) 
            end
        end
        function query:onError( err ) print( "[PROJECT0 MySQL] An error occured while executing the query: " .. err ) end
        query:start()
    end

    function PROJECT0.FUNC.SQLCreateTable( tableName, sqlLiteQuery, mySqlQuery )
        PROJECT0.FUNC.SQLQuery( "CREATE TABLE IF NOT EXISTS " .. tableName .. " ( " .. (mySqlQuery or sqlLiteQuery) .. " );" )
        print( "[PROJECT0 MySQL] " .. tableName .. " table validated!" )
    end    
else
    function PROJECT0.FUNC.SQLQuery( queryStr, func, singleRow )
        local query
        if( not singleRow ) then
            query = sql.Query( queryStr )
        else
            query = sql.QueryRow( queryStr, 1 )
        end
        
        if( query == false ) then
            print( "[PROJECT0 SQLLite] ERROR", sql.LastError() )
        elseif( func ) then
            func( query )
        end
    end    

    function PROJECT0.FUNC.SQLCreateTable( tableName, sqlLiteQuery, mySqlQuery )
        if( not sql.TableExists( tableName ) ) then
            PROJECT0.FUNC.SQLQuery( "CREATE TABLE " .. tableName .. " ( " .. (sqlLiteQuery or mySqlQuery) .. " );" )
        end

        print( "[PROJECT0 SQLLite] " .. tableName .. " table validated!" )
    end

    LoadSQLFiles()
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
