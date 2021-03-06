local dumper = {}

local getpath = function(Obj, Target)
	local str = Obj.Name
	local obj, parent = Obj, Obj.Parent
	if parent and parent ~= Target then
		repeat
			obj, parent = parent, parent.Parent
			str = obj.Name .. "." .. str
		until parent == Target
	end
	return str
end

local dump = function(Settings, FolderName)
	makefolder("Exo Tool V3")
	makefolder("Exo Tool V3/Script Dumps")
	makefolder("Exo Tool V3/Script Dumps/" .. FolderName)
	function MakeFolder(Name)
		makefolder("Exo Tool V3/Script Dumps/" .. FolderName .. "/" .. Name)
	end
	function WriteScript(Folder, Script, PathEnd)
		pcall(function()
			if Script:IsA("LocalScript") then
				writefile("Exo Tool V3/Script Dumps/" .. FolderName .. "/" .. Folder .. "/LocalScripts/" .. getpath(Script, PathEnd) .. ".lua", decompile(Script))
			elseif Script:IsA("ModuleScript") then
				writefile("Exo Tool V3/Script Dumps/" .. FolderName .. "/" .. Folder .. "/ModuleScripts/" .. getpath(Script, PathEnd) .. ".lua", decompile(Script))
			end
		end)
	end
	for i, v in pairs(Settings) do
		if v == true then
			MakeFolder(i)
			MakeFolder(i .. "/LocalScripts")
			MakeFolder(i .. "/ModuleScripts")
		end
	end
	for a, b in pairs(Settings) do
		if a ~= "LocalPlayer" and a ~= "Nil" then
			local Service = game:GetService(a)
			for c, d in pairs(Service:GetDescendants()) do
				if d:IsA("LocalScript") or d:IsA("ModuleScript") then
					WriteScript(a, d, Service)
				end
			end
		end
	end
	if Settings["LocalPlayer"] == true then
		for i, v in pairs(game:GetService("Players").LocalPlayer:GetDescendants()) do
			if v:IsA("LocalScript") or v:IsA("ModuleScript") then
				WriteScript("LocalPlayer", v, game:GetService("Players").LocalPlayer)
			end
		end
	end
	if Settings["Nil"] == true then
		for i, v in pairs(getnilinstances()) do
			if v:IsA("LocalScript") or v:IsA("ModuleScript") then
				WriteScript("Nil", v)
			end
		end
	end
end

dumper.dump = dump

return dumper
