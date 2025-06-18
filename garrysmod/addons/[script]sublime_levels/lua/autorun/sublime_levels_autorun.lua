if (Sublime and not Sublime.IsAuthentic) then
    error("Global table 'Sublime' is already in use by another addon, we're not continuing.")
end

Sublime = Sublime or {};
Sublime.Languages   = Sublime.Languages or {};
Sublime.Skills      = Sublime.Skills or {};
Sublime.IsAuthentic = true;

-- Track loaded directories to prevent infinite recursion
Sublime.LoadedDirs = Sublime.LoadedDirs or {}

function Sublime:LoadFile(path)
    local filename = path:GetFileFromFilename();
    filename = filename ~= "" and filename or path;

    local flagCL    = filename:StartWith("cl_");
    local flagSV    = filename:StartWith("sv_");
    local flagSH    = filename:StartWith("sh_");

    if file.Exists(path, "LUA") then
        if (SERVER) then
            if (flagCL or flagSH) then
                AddCSLuaFile(path);
            end

            if (flagSV or flagSH) then 
                include(path);
            end
        elseif (flagCL or flagSH) then
            include(path);
        end
    else
        print("[SUBLIME_LEVELS] ERROR: File not found - " .. path)
    end
end

function Sublime:LoadDirectory(dir, maxDepth)
    maxDepth = maxDepth or 10 -- Prevent infinite recursion
    if maxDepth <= 0 then
        print("[SUBLIME_LEVELS] ERROR: Maximum directory depth reached - " .. dir)
        return
    end
    
    -- Check if directory was already loaded
    if self.LoadedDirs[dir] then
        return
    end
    self.LoadedDirs[dir] = true
    
    local files, folders = file.Find(dir .. "/*", "LUA");

    if files then
        for _, v in ipairs(files) do 
            self:LoadFile(dir .. "/" .. v);
        end
    end

    if folders then
        for _, v in ipairs(folders) do 
            self:LoadDirectory(dir .. "/" .. v, maxDepth - 1);
        end
    end
end

Sublime:LoadDirectory("sublime_levels");