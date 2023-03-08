if not game:IsLoaded() then game.Loaded:Wait() end
if not Entri getgenv().Entri = {} end
setfflag("AvatarEditorServiceEnabled2", "true")
setfflag("AvatarEditorServiceEnabled2_PlaceFilter", "True;"..game.PlaceId)
Entri["Settings"] = {
	Version = "DevBuild";
	Invite = "wpSY2GChEG";
	Seperator = "/";
	Output = {
		Enabled = true;
		Send = function(Type, Output, BypassOutput)
			if type(Type) == "function" and (Type == print or Type == warn or Type == error) and type(Output) == "string" and (type(BypassOutput) == "nil" or type(BypassOutput) == "boolean") then
				if Entri["Settings"]["Output"].Enabled == true or BypassOutput == true then
					Type("- [ENTRI] "..Output)
				end
			elseif Entri["Settings"]["Output"].Enabled == true then
				error("[ENTRI] Output Send Error : Invalid syntax.")
			end
		end;
	};
	Mode = {
		Build = {
			ExitWords = {"build","corrupt","roli","proto","false","moment","distro","dm","exploit","tubers","vr","beamed","fr","lol","trollge","hard","gooby","cmd","archive","fe","fe","web3","crypto","mods","hacker","feds","meme","noob","vuln","dog","entry","harked","osint","hax0r","agent","scam","larp","true","gui","1337","cult","fan","funny","forced","skid","troll","hack","spy","nsa","copy","popbob","based","edr","db","hacksor","man","bool","rep","techie","trolleybus","door","nerd","when","network","go","socket","nn","beam","fake","paste","access","cat","bigname","lib","dwc","netless","123","post","void","report","cyc","hide","edgy","straker","lol","abuse","broke","astro","forum","no","bloxxed","test","xss","de","rekt","get","cookie","phrase","cracked","how","lua","hacks","reverse","v3rm","rich","novirus","mod","script","vsb","put","bro","sus","inject","seo","funnies","meme","gist","modded","syn","free","hot","fedded","git","web","bin","celery","breach","edge","vc","newgen","blox","method","rolimon","leet","encrypt","leaked","cia","krnl","pwnd","pls","bypass","2023","audios","best","haxer","ownership","geecee","shown","ong","noname","logs","haxor","hax","sw","swat","the","boolean","crack","entri","dupe","real","net"}
			Enabled = false;
			ScriptName = "";
			ExitPhrase = "";
		};
		Testing = {
			Baseplate = nil;
			Walls = nil;
		};
	};
	SafeMode = false; -- boolean, enable if anticheat
	GetPlayerBy = "DisplayName"; -- DisplayName, Name, UserId
	RespawnLocation = CFrame.new(0, 0, 0);
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Character)
		if Player.TeamColor == LocalPlayer.TeamColor then
			repeat task.wait() until (Character.PrimaryPart and Character:FindFirstChildOfClass("Humanoid")) or Player.Character ~= Character
			if Character.PrimaryPart and Player.Character == Character then
				Entri["Settings"].RespawnLocation = Character.PrimaryPart.CFrame
			end
		end
	end)
end)

Entri["InstanceStorage"] = Instance.new("Folder")
Entri.InstanceStorage.Name = "Entri InstanceStorage"
Entri.InstanceStorage.Parent = workspace
Entri["UI"] = {}
--Entri Internal UI Library
Entri["Libraries"] = {
	Network = {}
};
Entri["Settings"]["Output"].Send(print, ": Entri loading...")

Entri["Functions"] = {}
Entri["AddFunction"] = function(FuncName, FuncArgs, FuncExec)
	if type(FuncName) == "string" and type(FuncArgs) == "table" and type(FuncExec) == "function" then
		if not Entri["Functions"][FuncName] then
			Entri["Functions"][FuncName] = {}
			local NewFunction = Entri["Functions"][FuncName]
			NewFunction["Arguments"] = table.clone(FuncArgs)
			NewFunction["Execute"] = function(Args)
				if type(Args) == "table" then
					if #Args > #NewFunction.Arguments+1 and not table.find(NewFunction.Arguments, "...") then
						Entri["Settings"]["Output"].Send(error, FuncName.." Error : Invalid syntax.")
						return
					end
					local Success, Output = pcall(FuncExec, table.unpack(Args))
					local OutputTable = {}
					OutputTable.Output = {}
					OutputTable.Warnings = {}
					OutputTable.Errors = {}
					if Success == true then
						table.insert(OutputTable.Output, Output)
					else
						if Output and type(Output) == "string" then
							if Output :find("\n") then
								local OutTable = Output :split("\n")
								for i, Out in pairs(OutTable) do
									if i ~= #OutTable then
										Entri["Settings"]["Output"].Send(warn, FuncName.." Warning : "..Out)
										table.insert(OutputTable.Warnings, Out)
									else
										Entri["Settings"]["Output"].Send(error, FuncName.." Error : "..Out)
										table.insert(OutputTable.Errors, Out)
									end
								end
							else
								Entri["Settings"]["Output"].Send(error, FuncName.." Error : "..Output)
								table.insert(OutputTable.Errors, Output)
							end
						end
					end
					return OutputTable
				else
					Entri["Settings"]["Output"].Send(warn, FuncName.." Execute Error : Invalid syntax.")
				end
			end
		else
			Entri["Settings"]["Output"].Send(warn, "AddFunction Warning : Function \""..FuncName.."\" already exists. Remove it to reset it. Alternatively, create a new function.")
		end
	else
		Entri["Settings"]["Output"].Send(warn, "AddFunction Error : Invalid syntax.")
	end
end

Entri["Prefixes"] = {}
Entri["FuncPrefixes"] = {}
Entri["PrefixAliases"] = {}

Entri["AddPrefix"] = function(Prefix, Description, FuncPrefix)
	if type(Prefix) == "string" and type(Description) == "string" and (type(FuncPrefix) == "function" or type(FuncPrefix) == "nil") then
		local Prefix = string.lower(Prefix)
		if not Entri["Prefixes"][Prefix] then
			Entri["Prefixes"][Prefix] = {}
			local PrefixTable = Entri["Prefixes"][Prefix]
			PrefixTable["Name"] = Prefix
			PrefixTable["VarStorage"] = {}
			PrefixTable["Description"] = Description
			Entri["FuncPrefixes"][Prefix] = (type(FuncPrefix) == "function")
			if FuncPrefix then
				PrefixTable["Execute"] = FuncPrefix
			else
				PrefixTable["Commands"] = {}
				PrefixTable["Aliases"] = {}

			end
			Entri["Settings"]["Output"].Send(print, "AddPrefix Output : Prefix: \""..Prefix.."\" has been created.")
		else
			Entri["Settings"]["Output"].Send(warn, "AddPrefix Warning : Prefix \""..Prefix.."\" already exists. Remove it to reset it. Alternatively, create a new prefix.")
		end
	else
		Entri["Settings"]["Output"].Send(warn, "AddPrefix Error : Invalid syntax.")
	end
end

Entri["AddPrefixAlias"] = function(Alias, Prefix)
	if type(Alias) == "string" and type(Alias) == "string" then
		local Alias, Prefix = string.lower(Alias), string.lower(Prefix)
		if Entri["Prefixes"][Prefix] then
			if not Entri["PrefixAliases"][Alias] then
				Entri["PrefixAliases"][Alias] = Prefix
				Entri["Settings"]["Output"].Send(print, "AddPrefixAlias Output : Alias: \""..Alias.."\" for prefix: \""..Prefix.."\" has been created.")
			else
				Entri["Settings"]["Output"].Send(warn, "AddPrefixAlias Warning : Alias: \""..Alias.."\" for prefix: \""..Prefix.."\" already exists. Remove it to reset it. Alternatively, create a new alias.")
			end
		else
			Entri["Settings"]["Output"].Send(warn, "AddPrefixAlias Warning : Prefix: \""..Prefix.."\" does not exist. Make the prefix using \"Entri.AddPrefix(Prefix)\"")
		end
	else
		Entri["Settings"]["Output"].Send(error, "AddPrefixAlias Error : Invalid syntax.")
	end
end

Entri["AddCommand"] = function(Prefix, CMDName, CMDDesc, CMDArgs, CMDExec) --Add minimum rank
	if type(Prefix) == "string" and type(CMDName) == "string" and type(CMDDesc) == "string" and type(CMDArgs) == "table" and (type(CMDExec) == "function" or type(CMDExec) == "nil") then
		local Prefix, CMDName = string.lower(Prefix), string.lower(CMDName)
		if Entri["Prefixes"][Prefix] and not table.find(Entri["FuncPrefixes"], Prefix) then
			if not Entri["Prefixes"][Prefix]["Commands"][CMDName] then
				Entri["Prefixes"][Prefix]["Commands"][CMDName] = {}
				local NewCommand = Entri["Prefixes"][Prefix]["Commands"][CMDName]
				NewCommand["Description"] = CMDDesc
				NewCommand["Arguments"] = table.clone(CMDArgs)
				if CMDExec then
					NewCommand["Execute"] = function(Player, Silent, Args)
						Args = Args or {}
						if type(Player) == "userdata" and Player:IsA("Player") and type(Args) == "table" then
							if #Args > #NewCommand.Arguments + 1 and not table.find(NewCommand.Arguments, "...") then
								Entri["Settings"]["Output"].Send(error, Prefix.." "..CMDName.." Error : Invalid syntax.")
								return
							end
							--local MinimumRank = Entri["Settings"]["Ranks"][Rank]
							--local PlayerRank = Entri["Settings"]["Ranks"][Player:GetAttribute("EntriRank")]
							--if MinimumRank >= PlayerRank then
								if not Silent then
									Entri["Settings"]["Output"].Send(print, "Execute: Command \""..CMDName.."\" with prefix: \""..Prefix.."\" executed by player: "..Player.Name..".")
								end
								local Success, Output = pcall(CMDExec, Player, table.unpack(Args))
								local OutputTable = {}
								OutputTable.Output = {}
								OutputTable.Warnings = {}
								OutputTable.Errors = {}
								if Success == true then
									table.insert(OutputTable.Output, Output)
								else
									if Output and type(Output) == "string" then
										if Output :find("\n") then
											local OutTable = Output :split("\n")
											for i, Out in pairs(OutTable) do
												if i ~= #OutTable then
													Entri["Settings"]["Output"].Send(warn, Prefix.." "..CMDName.." Warning : "..Out)
													table.insert(OutputTable.Warnings, Out)
												else
													Entri["Settings"]["Output"].Send(error, Prefix.." "..CMDName.." Error : "..Out)
													table.insert(OutputTable.Errors, Out)
												end
											end
										else
											Entri["Settings"]["Output"].Send(error, Prefix.." "..CMDName.." Error : "..Output)
											table.insert(OutputTable.Errors, Output)
										end
									end
								end
								return OutputTable
							--end
						else
							Entri["Settings"]["Output"].Send(error, Prefix.." "..CMDName.." Execute Error : Invalid syntax.")
						end
					end
				end
				Entri["Settings"]["Output"].Send(print, "AddCommand Output : Command: \""..CMDName.."\" with prefix: \""..Prefix.."\" has been created.")
			else
				Entri["Settings"]["Output"].Send(warn, "AddCommand Warning : Command: \""..CMDName.."\" with prefix: \""..Prefix.."\" already exists. Remove it to reset it. Alternatively, create a new command.")
			end
		else
			Entri["Settings"]["Output"].Send(warn, "AddCommand Error : Prefix: \""..Prefix.."\" does not exist or is a function prefix. If it does not exist, make the prefix using \"Entri.AddPrefix(Prefix)\".")
		end
	else
		Entri["Settings"]["Output"].Send(error, "AddCommand Error : Invalid syntax.")
	end
end

Entri["AddCommandAlias"] = function(Prefix, Alias, CMDName)
	if type(Prefix) == "string" and type(Alias) == "string" and type(CMDName) == "string" then
		local Prefix, Alias, CMDName = string.lower(Prefix), string.lower(Alias), string.lower(CMDName)
		if Entri["Prefixes"][Prefix]["Commands"][CMDName] and (Entri["Prefixes"][Prefix]["Commands"][Alias] == nil or Entri["Prefixes"][Prefix]["Commands"][Alias].Execute == nil) then
			if not Entri["Prefixes"][Prefix]["Aliases"][Alias] then
				Entri["Prefixes"][Prefix]["Aliases"][Alias] = {}
				table.insert(Entri["Prefixes"][Prefix]["Aliases"][Alias], CMDName)
			else
				table.insert(Entri["Prefixes"][Prefix]["Aliases"][Alias], CMDName)
				Entri["Settings"]["Output"].Send(warn, "AddCommandAlias Warning : Alias: \""..Alias.."\" with prefix : \""..Prefix.."\" already exists.")
			end
			Entri["Settings"]["Output"].Send(print, "AddCommandAlias Output : Alias : \""..Alias.."\" for command : \""..CMDName.."\" with prefix : \""..Prefix.."\" has been created.")
		else
			Entri["Settings"]["Output"].Send(warn, "AddCommandAlias Warning : Command : \""..CMDName.."\" with prefix : \""..Prefix.."\" does not exist. Make the command using \"Entri.AddCommand(Prefix, CmdName, CmdArgs, CmdExec)\".")
		end
	else
		Entri["Settings"]["Output"].Send(error, "AddCommandAlias Error : Invalid syntax.")
	end
end

Entri.AddFunction("PartialConcatenate", { "OldTable", "Index0", "Index1", "Seperator" }, function(OldTable, Index0, Index1, Seperator)
	if type(OldTable) == "table" and type(Index0) == "number" and type(Index1) == "number" and type(Seperator) == "string" then
		local NewTable = {}
		for i = Index0, Index1 do
			table.insert(NewTable, OldTable[i])
		end
		return table.concat(NewTable, Seperator)
	else
		error("Invalid syntax.")
	end
end)

Entri.AddFunction("ParseCMDArgs", {"Prefix", "CMDString", "Table"}, function(Prefix, CMDString, Table)
	if type(Prefix) ~= "string" or type(CMDString) ~= "string" or type(Table) ~= "table" then
		error("Invalid syntax.")
	end
	Prefix = string.lower(Prefix)
	if CMDString == "" then
		return Table
	end
	local PArgs = CMDString:split(" ")
	local CMDGivenName = string.lower(PArgs[1])
	local CMDNames = {}
	if Entri["Prefixes"][Prefix]["Commands"][CMDGivenName] then
		table.insert(CMDNames, CMDGivenName)
	end
	local CMDAliases = Entri["Prefixes"][Prefix]["Aliases"][CMDGivenName]
	if CMDAliases then
		for _, CMDName in pairs(CMDAliases) do
			if Entri["Prefixes"][Prefix]["Commands"][CMDName] then
				table.insert(CMDNames, CMDName)
			end
		end
	end
	if #CMDNames > 0 then
		local NextCMDString = ""
		for _, CMDName in pairs(CMDNames) do
			local CMD = Entri["Prefixes"][Prefix]["Commands"][CMDName]
			local Args = CMD["Arguments"]
			local CMDArgString = Entri["Functions"]["PartialConcatenate"].Execute({PArgs, 2, #Args+1, " "}).Output[1]
			local CMDString = CMDName
			if CMDArgString ~= "" then
				CMDString = CMDString.." "..CMDArgString
			end
			table.insert(Table, CMDString)

			local PossibleNextCMDString = Entri["Functions"]["PartialConcatenate"].Execute({PArgs, #Args+2, #PArgs, " "}).Output[1]
			if #PossibleNextCMDString > #NextCMDString then
				NextCMDString = PossibleNextCMDString
			end
		end
		if NextCMDString == "" then
			return Table
		end
		Table = Entri["Functions"]["ParseCMDArgs"].Execute({Prefix, NextCMDString, Table}).Output[1]
		return Table
	end
end)


Entri.AddFunction("ProcessCMD", {"CMD", "Player"}, function(CMD, Player)
	local Build = Entri["Settings"]["Mode"]["Build"]
	if Build.Enabled and Player == LocalPlayer then
		if CMD == Build.ExitPhrase then
			Build.Enabled = false
			Build.ScriptName = ""
			Build.ExitPhrase = ""
			Entri["Settings"]["Output"].Send(print, ": Exited buildmode.")
		else
			Entri["Scripts"].AppendScript(Build.ScriptName, CMD)
		end
	else
		if string.find(CMD, Entri["Settings"].Seperator) then
			local PArgs = CMD:split(Entri["Settings"].Seperator)
			local FoundPrefix = string.lower(PArgs[1])
			local Prefix = Entri["Prefixes"][FoundPrefix] or Entri["PrefixAliases"][FoundPrefix] and Entri["Prefixes"][Entri["PrefixAliases"][FoundPrefix]]
			if Prefix then
				local SArgString = Entri["Functions"]["PartialConcatenate"].Execute({PArgs, 2, #PArgs, Entri["Settings"].Seperator}).Output[1]
				if Entri["FuncPrefixes"][Prefix.Name] then	
					Prefix.Execute(Player, SArgString)
				else
					local SArgTable = {}
					Entri["Functions"]["ParseCMDArgs"].Execute({Prefix.Name, SArgString, SArgTable})
					for _, TArgString in pairs(SArgTable) do
						local TArgs = TArgString:split(" ")
						local CMDS = string.lower(TArgs[1])
						local TArgs = Entri["Functions"]["PartialConcatenate"].Execute({TArgs, 2, #TArgs, " "}).Output[1]
						local CMDE = Prefix["Commands"][CMDS] or Prefix["Aliases"][CMDS] and Prefix["Commands"][Prefix["Aliases"][CMDS]]
						if CMDE.Execute then
							CMDE.Execute(Player, false, TArgs:split(" "))
						end
					end
				end
			end
		end
	end
end)

 
LocalPlayer.Chatted:Connect(function(Message)
	Entri["Functions"]["ProcessCMD"].Execute({Message, LocalPlayer})
end)

Entri["FileSystem"] = {}
Entri["FileSystem"].Enabled = false
if readfile and writefile and appendfile and delfile and isfile and listfiles and makefolder and delfolder and isfolder then
	Entri["FileSystem"].Enabled = true
	makefolder("Entri")
	makefolder("Entri/Storage")
	makefolder("Entri/Scripts")
	makefolder("Entri/Plugins")
	Entri["Settings"]["Output"].Send(print, "Output : Checked/Made Entri folders.")
	Entri["FileSystem"]["LoadPlugin"] = function()
	end
end

Entri["Scripts"] = {
	List = {};
	History = {};
}
Entri["Scripts"]["CreateScript"] = function(ScriptName, Content) --done
	if type(ScriptName) == "string" and (type(Content) == "string" or type(Content) == "nil") then
		if Entri["Scripts"]["List"][ScriptName] then
			Entri["Settings"]["Output"].Send(warn, "RemoveScript Warning : Script : \""..ScriptName.."\"already exists.")
		else
			if Content == nil then
				Content = ""
			end
			Entri["Scripts"]["List"][ScriptName] = {
				Type = "Unsaved";
				Contents = ""..Content;
			}
			Entri["Settings"]["Output"].Send(print, ": Script : \""..ScriptName.."\" created.")
		end
	else
		Entri["Settings"]["Output"].Send(error, "CreateScript Error : Invalid syntax.")
	end
end
Entri["Scripts"]["RemoveScript"] = function(ScriptName)
	if type(ScriptName) == "string" then
		if Entri["Scripts"]["List"][ScriptName] then
			if Entri["FileSystem"].Enabled == true and Entri["Scripts"]["List"][ScriptName].Type == "Saved" then
				delfile("Entri/Scripts/"..ScriptName..".lua")
			end
			table.remove(Entri["Scripts"]["List"], table.find(Entri["Scripts"]["List"], ScriptName))
			Entri["Settings"]["Output"].Send(print, ": Script : \""..ScriptName.."\" removed.")
		else
			Entri["Settings"]["Output"].Send(warn, "RemoveScript Warning : Script \""..ScriptName.."\" does not exist, and therefore was not removed.")
		end
	else
		Entri["Settings"]["Output"].Send(error, "RemoveScript Error : Invalid syntax.")
	end
end
Entri["Scripts"]["AppendScript"] = function(ScriptName, Content)
	if type(ScriptName) == "string" and type(Content) == "string" then
		if Entri["Scripts"]["List"][ScriptName] then
			Entri["Scripts"]["List"][ScriptName].Contents = Entri["Scripts"]["List"][ScriptName].Contents.."\n"..Content
			if Entri["FileSystem"].Enabled == true and Entri["Scripts"]["List"][ScriptName].Type == "Saved" then
				writefile("Entri/Scripts/"..ScriptName..".lua", Entri["Scripts"]["List"][ScriptName].Contents.."\n"..Content)
			end
			Entri["Settings"]["Output"].Send(print, ": Script : \""..ScriptName.."\" appended to with text : \""..Content.."\".")
		else
			Entri["Settings"]["Output"].Send(warn, "AppendScript Warning : Script \""..ScriptName.."\" does not exist, and therefore was not appended to.")
		end
	else
		Entri["Settings"]["Output"].Send(error, "AppendScript Error : Invalid syntax.")
	end
end
Entri["Scripts"]["RenameScript"] = function(ScriptName, NewName)
	if type(ScriptName) == "string" and type(NewName) == "string" then
		if Entri["Scripts"]["List"][ScriptName] then
			if not Entri["Scripts"]["List"][NewName] then
				Entri["Scripts"]["List"][NewName] = Entri["Scripts"]["List"][ScriptName]
				table.remove(Entri["Scripts"]["List"], table.find(Entri["Scripts"]["List"], ScriptName))
				if Entri["FileSystem"].Enabled == true and Entri["Scripts"]["List"][ScriptName].Type == "Saved" then
					delfile("Entri/Scripts/"..ScriptName..".lua")
					writefile("Entri/Scripts/"..NewName..".lua", Entri["Scripts"]["List"][NewName].Contents)
				end
				Entri["Settings"]["Output"].Send(print, ": Script : \""..ScriptName.."\" renamed to \""..NewName.."\".")
			else
				Entri["Settings"]["Output"].Send(warn, "RenameScript Warning : Script \""..NewName.."\" already exists, and therefore, script: \""..ScriptName.."\" was not renamed.")
			end
		else
			Entri["Settings"]["Output"].Send(warn, "RenameScript Warning : Script \""..ScriptName.."\" does not exist, and therefore was not renamed.")
		end
	else
		Entri["Settings"]["Output"].Send(error, "RenameScript Error : Invalid syntax.")
	end
end
Entri["Scripts"]["SaveScript"] = function(ScriptName)
	if type(ScriptName) == "string" then
		if Entri["FileSystem"].Enabled == true then
			if Entri["Scripts"]["List"][ScriptName] then
				writefile("Entri/Scripts/"..ScriptName..".lua", Entri["Scripts"]["List"][ScriptName].Contents)
				Entri["Scripts"]["List"][ScriptName].Type = "Saved"
				Entri["Settings"]["Output"].Send(print, ": Script : \""..ScriptName.."\" saved.")
			else
				Entri["Settings"]["Output"].Send(warn, "SaveScript Warning : Script \""..ScriptName.."\" does not exist, and therefore was not saved.") 
			end
		else
			Entri["Settings"]["Output"].Send(warn, "RemoveScript Warning : Your exploit does not support Entri' FileSystem library, and therefore, your file could not be saved.")
		end
	else
		Entri["Settings"]["Output"].Send(error, "SaveScript Error : Invalid syntax.")
	end
end
Entri["Scripts"]["UnsaveScript"] = function(ScriptName)
	if type(ScriptName) == "string" then
		if Entri["FileSystem"].Enabled == true then
			if Entri["Scripts"]["List"][ScriptName] then
				delfile("Entri/Scripts/"..ScriptName..".lua")
				Entri["Scripts"]["List"][ScriptName].Type = "Unsaved"
				Entri["Settings"]["Output"].Send(print, ": Script : \""..ScriptName.."\" unsaved.")
			else
				Entri["Settings"]["Output"].Send(warn, "SaveScript Warning : Script \""..ScriptName.."\" does not exist, and therefore was not saved.") 
			end
		else
			Entri["Settings"]["Output"].Send(warn, "RemoveScript Warning : Your exploit does not support Entri' FileSystem library, and therefore, your file could not be saved.")
		end
	else
		Entri["Settings"]["Output"].Send(error, "SaveScript Error : Invalid syntax.")
	end
end
Entri["Scripts"]["RunScript"] = function(ScriptName, Player)
	if type(ScriptName) == "string" and type(Player) == "userdata" and Player:IsA("Player") then
		Entri["Settings"]["Output"].Send(print, ": Script : \""..ScriptName.."\" ran by player : \""..Player.Name.."\".")
		if Player == LocalPlayer then
			local Success, Output
			Success, Output = pcall(function()
				local Task = task.spawn(function()
					loadstring(Entri["Scripts"]["List"][ScriptName].Contents)()
				end)
				table.insert(Entri["Scripts"]["History"], Task)
			end)
			if Success ~= true then
				if Output and type(Output) == "string" then
					if Output:find("\n") then
						local OutTable = Output:split("\n")
						for i, Out in pairs(OutTable) do
							if i ~= #OutTable then
								Entri["Settings"]["Output"].Send(warn, "Script: Warning : "..Out)
							else
								Entri["Settings"]["Output"].Send(error, "Script: Error : "..Out)
							end
						end
					else
						Entri["Settings"]["Output"].Send(error, "Script: Error : "..Out)
					end
				end
			else
				--print(Output)
			end
		else
			--gonna add crossclient here
		end
	else
		Entri["Settings"]["Output"].Send(error, "RunScript "..ScriptName.." Error : Invalid syntax.")
	end
end
Entri["Scripts"]["ShareScript"] = function(ScriptName, Player)
	if type(ScriptName) == "string" and type(Player) == "userdata" and Player:IsA("Player") then
		Entri["Settings"]["Output"].Send(print, ": Script : \""..ScriptName.."\" shared to player : \""..Player.Name.."\".")
		--gonna add crossclient sharing here
	else
		Entri["Settings"]["Output"].Send(error, "ShareScript Error : Invalid syntax.")
	end
end
for _, Script in pairs(listfiles("Entri/Scripts")) do
	local FileTable = string.split(Script, "\\")
	local FullFileName = Entri["Functions"]["PartialConcatenate"].Execute({FileTable, 2, #FileTable, "\\"}).Output[1]
	local FileNameTable = string.split(FullFileName, ".")
	local FileName = Entri["Functions"]["PartialConcatenate"].Execute({FileNameTable, 1, #FileNameTable-1, "."}).Output[1]
	local FileExt = FileNameTable[#FileNameTable]
	Entri["Scripts"]["List"][FileName] = {
		Type = "Saved";
		Contents = readfile(Script);
	}
	Entri["Settings"]["Output"].Send(print, ": Script : \""..FileName.."\" imported from save.")
end

Entri.AddFunction("GetPlayerBy", {"PlayerString"}, function(FullPlayerString)
	local TPlayers = {}
	local PlayerStrings = FullPlayerString:lower():split(", ")
	for _, PlayerString in pairs(PlayerStrings) do
		if PlayerString == "all" then
			TPlayers = Players:GetPlayers()
		elseif PlayerString == "others" then
			for _, Player in pairs(Players:GetPlayers()) do
				if Player ~= LocalPlayer then
					table.insert(TPlayers, Player)
				end
			end
		elseif PlayerString == "random" then
			local PlayerList = Players:GetPlayers()
			table.insert(TPlayers, PlayerList[math.random(1, #PlayerList)])
		elseif PlayerString == "me" then
			table.insert(TPlayers, LocalPlayer)
		else
			for _, Player in pairs(Players:GetPlayers()) do
				if Player[Entri.Settings.GetPlayerBy]:lower():sub(1, #PlayerString) == PlayerString then
					table.insert(TPlayers, Player)
				end
			end
		end
	end
	return TPlayers
end)

Entri.AddFunction("JointSearch", {"Part1", "Part2"}, function(Part1, Part2, Seen, Table)
	Seen = Seen or {}
	Table = Table or {[Part1] = Part1}
	if Part1 == Part2 then
		return true
	end
	if #Part1:GetJoints() == 0 then
		return false
	end
	for _, Joint in pairs(Part1:GetJoints()) do
		local NextPart = Joint.Part1 == Part1 and Joint.Part0 or Joint.Part1
		if Seen[NextPart] then
			continue
		end
		Seen[NextPart] = true
		local Recursive = jointSearch(NextPart, Part2, Seen, Table)
		if Recursive then
			if not Table[NextPart] then
				Table[NextPart] = NextPart
			end
			return Table
		end
	end
	return false
end)

Entri.AddFunction("EnumCheck", {"EnumList", "EnumName"}, function(EnumListName, EnumName)
	for _, EnumList in pairs(Enum:GetEnums()) do
		if tostring(EnumList) ==	EnumListName then
			for _, EnumItem in pairs(EnumList:GetEnumItems()) do
				if EnumItem.Name == EnumName then
					return true
				end
			end
		end
	end
	return false
end)

Entri.AddFunction("GetInstanceFromPath", {"STR"}, function(STR) -- Example: GetInstanceFromPath("ReplicatedStorage.RemoteEvent") -> RemoteEvent (instance)
    local Current = game
    for _ , Index in pairs ( STR:split(".") ) do
        assert(Current:FindFirstChild(Index) ~= nil, "Error: Instance path is invalid")
        Current = Current[Index] -- Continue forward
    end
    return Current
end)

Entri.AddPrefix("share", "Shares script (Arg1) with said player (Arg2).", function(Player, Args)
	if Player == LocalPlayer then
		Args = string.split(Args, Entri["Settings"].Seperator)
		if #Args > 2 then
			error("Run Error : Invalid syntax.")
			return
		end
		if Args[2] and Args[2] ~= "" then
			Args[2] = Entri["Functions"]["GetPlayerBy"].Execute({Args[2]}).Output[1]
		else
			Args[2] = {LocalPlayer}
		end
		if Args[1] ~= nil and Args[1] ~= "" then
			for _, Player in pairs(Args[2]) do
				Entri["Scripts"].ShareScript(Args[1], Player)
			end
		end
	end
end)
Entri.AddPrefixAlias("sh", "share")

Entri.AddPrefix("save", "Saves a script (Arg1) with said name.", function(Player, Args)
	if Player == LocalPlayer then
	 	Args = string.split(Args, Entri["Settings"].Seperator)
		if #Args > 1 then
			error("HTTPS Error : Invalid syntax.")
			return
		end
		if Args[1] ~= nil and Args[1] ~= "" then
			Entri["Scripts"].SaveScript(Args[1])
		end
	end
end)
Entri.AddPrefixAlias("sv", "save")

Entri.AddPrefix("remove", "Removes a script (Arg1) with said name.", function(Player, Args)
	if Player == LocalPlayer then
	 	Args = string.split(Args, Entri["Settings"].Seperator)
		if #Args > 1 then
			error("HTTPS Error : Invalid syntax.")
			return
		end
		if Args[1] ~= nil and Args[1] ~= "" then
			Entri["Scripts"].RemoveScript(Args[1])
		end
	end
end)
Entri.AddPrefixAlias("rem", "remove")
Entri.AddPrefixAlias("rm", "remove")
	
Entri.AddPrefix("https", "Executes script with URL (Arg1) for said player (Arg2).", function(Player, Args)
	if Player == LocalPlayer then
		Args = string.split(Args, Entri["Settings"].Seperator)
		if #Args > 2 then
			error("HTTPS Error : Invalid syntax.")
			return
		end
		if Args[2] ~= nil and Args[2] ~= "" then
			Args[2] = Entri["Functions"]["GetPlayerBy"].Execute({Args[2]}).Output[1]
		else
			Args[2] = {LocalPlayer}
		end
		if Args[1] ~= nil and Args[1] ~= "" then
			for _, TPlayer in pairs(Args[2]) do
				if TPlayer == LocalPlayer then
					local Success, Output = pcall(function()
						game:HttpGet(Args[1])
					end)
					if Success and Task then
						Success, Output = pcall(function()
							local Task = task.spawn(function()
								loadstring(game:HttpGet(Args[1]))()
							end)
							table.insert(Entri["Scripts"]["History"], Task)
						end)
						if Success ~= true then
							if Output and type(Output) == "string" then
								if Output:find("\n") then
									local OutTable = Output:split("\n")
									for i, Out in pairs(OutTable) do
										if i ~= #OutTable then
											Entri["Settings"]["Output"].Send(warn, "Script: Warning : "..Out)
										else
											Entri["Settings"]["Output"].Send(error, "Script: Error : "..Out)
										end
									end
								else
									Entri["Settings"]["Output"].Send(error, "Script: Error : "..Out)
								end
							end
						end
					end
				else
					--gonna add crossclient stuff here
				end
			end
		end
	end
end)
Entri.AddPrefixAlias("http", "https")
Entri.AddPrefixAlias("h", "https")

--[[
Entri.AddPrefix("insert", "Inserts model (Arg1) with assetid on client.", function(Player, Args)
end)
Entri.AddPrefixAlias("i", "insert")
--]]

Entri.AddPrefix("get", "Gets a command (Args1-#Args).")
Entri.AddPrefixAlias("g", "get")

Entri.AddPrefix("run", "Runs a script (Arg1) with said name for said player (Arg2).", function(Player, Args)
	if Player == LocalPlayer then
		Args = string.split(Args, Entri["Settings"].Seperator)
		if #Args > 2 then
			error("Run Error : Invalid syntax.")
			return
		end
		if Args[2] ~= nil and Args[2] ~= "" then
			Args[2] = Entri["Functions"]["GetPlayerBy"].Execute({Args[2]}).Output[1]
		else
			Args[2] = {LocalPlayer}
		end
		if Args[1] ~= nil and Args[1] ~= "" then
			for _, TPlayer in pairs(Args[2]) do
				Entri["Scripts"].RunScript(Args[1], TPlayer)
			end
		end
	end
end)
Entri.AddPrefixAlias("r", "run")

Entri.AddPrefix("rename", "Renames a script (Arg1) with said name to the new name (Arg2).", function(Player, Args)
	if Player == LocalPlayer then
		Args = string.split(Args, Entri["Settings"].Seperator)
		if #Args > 2 then
			error("Run Error : Invalid syntax.")
			return
		end
		if Args[1] ~= nil and Args[1] ~= "" and Args[2] ~= nil and Args[2] ~= "" then
			Entri["Scripts"].RenameScript(Args[1], Args[2])
		end
	end
end)
Entri.AddPrefixAlias("ren", "rename")
Entri.AddPrefixAlias("rn", "remove")

Entri.AddPrefix("createsource", "Creates a script (Arg1) with said name and enters builder mode.", function(Player, Args)
	if Player == LocalPlayer then
		Args = string.split(Args, Entri["Settings"].Seperator)
		if #Args > 1 then
			print(#Args)
			error("CreateSource Error : Invalid syntax.")
			return
		end
		if Args[1] ~= nil and Args[1] ~= "" then
			local ExitWords = Entri["Settings"]["Mode"]["Build"]["ExitWords"]
			Entri["Scripts"].CreateScript(Args[1])
			Entri["Settings"]["Mode"]["Build"].Enabled = true
			Entri["Settings"]["Mode"]["Build"].ScriptName = Args[1]
			Entri["Settings"]["Mode"]["Build"].ExitPhrase = ""
			for i=1, math.random(3, 5) do
				Entri["Settings"]["Mode"]["Build"].ExitPhrase = Entri["Settings"]["Mode"]["Build"].ExitPhrase..ExitWords[math.random(1, #ExitWords)]:gsub("^%l", string.upper)
			end
			game.StarterGui:SetCore( "ChatMakeSystemMessage", {Text = "[ENTRI] You have entered buildmode, meaning all of what would've been processed is now being appended to the scriptname argument you supplied. Type \""..Entri["Settings"]["Mode"]["Build"].ExitPhrase.."\" to exit buildmode.", Color = Color3.fromRGB(0, 0, 255), FontSize = Enum.FontSize.Size24})
		end
	end
end)
Entri.AddPrefixAlias("cs", "createsource")

--[[
Entri.AddPrefix("runnew", "Runs new script (Arg1) with said name and said contents (Arg2).", function(Player, Args)
end)
Entri.AddPrefixAlias("m", "runnew")
--]]

--[[
Entri.AddPrefix("edithttps", "Edits HTTPS script with given name (Arg1) to execute specified URL (Arg2).", function(Player, Args)
end)
Entri.AddPrefixAlias("edithttp", "edithttps")
Entri.AddPrefixAlias("edith", "edithttps")
Entri.AddPrefixAlias("eh", "edithttps")
--]]

Entri.AddPrefix("createhttps", "Creates HTTPS script with given name (Arg1) to execute specified URL (Arg2).", function(Player, Args)
	if Player == LocalPlayer then
		Args = string.split(Args, Entri["Settings"].Seperator)
		if #Args > 2 then
			error()
			return
		end
		if Args[1] ~= nil and Args[1] ~= "" and Args[2] ~= nil and Args[2] ~= "" then
			local Success, Error = pcall(function()
				game:HttpGet(Args[2])
			end)
			if Success == true then
				Entri["Scripts"].CreateScript(Args[1], game:HttpGet(URL))
			else
				error("CreateHTTPS: Invalid URL.")
			end
		end
	end
end)
Entri.AddPrefixAlias("createhttp", "createhttps")
Entri.AddPrefixAlias("ch", "createhttps")

--[[
Entri.AddPrefix("editsource", "Edits a script (Arg1) with said name and enters build mode.", function(Player, Args)
end)
Entri.AddPrefixAlias("edit", "editsource")
Entri.AddPrefixAlias("es", "editsource")
Entri.AddPrefixAlias("e", "editsource")
--]]

Entri.AddPrefix("stop", "Stops Entri (and your client).", function(Player, Args)
	LocalPlayer:Kick()
end)

Entri.AddPrefix("script", "Executes a script with Args.", function(Player, Args)
	if Player == LocalPlayer then
		local Ran
		local Success, Output = pcall(function()
			Ran = {
				ID = #Entri["Scripts"]["History"]+1, 
				Running = true, 
				Task = task.spawn(function()
					loadstring(Args)()
				end)
			}
			table.insert(Entri["Scripts"]["History"], Ran)
		end)
		if Success ~= true then
			if Output and type(Output) == "string" then
				if Output:find("\n") then
					local OutTable = Output:split("\n")
					for i, Out in pairs(OutTable) do
						if i ~= #OutTable then
							Entri["Settings"]["Output"].Send(warn, "Script: Warning : "..Out)
						else
							Entri["Settings"]["Output"].Send(error, "Script: Error : "..Out)
						end
					end
				else
					Entri["Settings"]["Output"].Send(error, "Script: Error : "..Out)
				end
			end
		else
			Ran.Running = false
			Entri["Settings"]["Output"].Send(print, "Script: Error : "..Out)
		end
	end
end)
Entri.AddPrefixAlias("do", "script")
Entri.AddPrefixAlias("c", "script")

Entri.AddPrefix("unsave", "Unsaves a script (Arg1) with said name.", function(Player, Args)
	if Player == LocalPlayer then
		Args = string.split(Args, Entri["Settings"].Seperator)
		if #Args > 1 then
			error("Run Error : Invalid syntax.")
			return
		end
		if Args[1] ~= nil and Args[1] ~= "" then
			Entri["Scripts"].UnsaveScript(Args[1])
		end
	end
end)
Entri.AddPrefixAlias("unsv", "unsave")

Entri.AddPrefix("create", "Creates a script (Arg1) with said name.", function(Player, Args)
	if Player == LocalPlayer then
		Args = string.split(Args, Entri["Settings"].Seperator)
	end
end)

--get commands

Entri.AddCommand("get", "commandlist", "Shows you the commands.", {}, function(Player)
	if Player == LocalPlayer then
		local ToPrint = ""
		for Prefix1, PrefixTable in pairs(Entri["Prefixes"]) do
			local UsablePrefixes = Prefix1
			for PrefixAlias, Prefix2 in pairs(Entri["PrefixAliases"]) do
				if Prefix2 == Prefix1 then
					UsablePrefixes = UsablePrefixes..", "..PrefixAlias
				end
			end
			if ToPrint == "" then
				ToPrint = ToPrint..UsablePrefixes..Entri["Settings"].Seperator.." (Prefix) ["..PrefixTable.Description.."]\n"
			else
				ToPrint = ToPrint.."\n"..UsablePrefixes..Entri["Settings"].Seperator.." (Prefix) ["..PrefixTable.Description.."]\n"
			end
			if not Entri["FuncPrefixes"][Prefix1] then
				for Command1, CommandTable in pairs(PrefixTable["Commands"]) do
					local UsableCommands = Command1
					for CommandAlias, CommandList in pairs(PrefixTable["Aliases"]) do
						for _, Command2 in pairs(CommandList) do
							if Command2 == Command1 then
								UsableCommands = UsableCommands..", "..tostring(CommandAlias)
							end
						end
					end
					ToPrint = ToPrint..UsablePrefixes..Entri["Settings"].Seperator..UsableCommands.." (Command) ["..PrefixTable["Commands"][Command1].Description.."]".."\n"
				end
			end
		end
		Entri["Settings"]["Output"].Send(print, [[Commands (Aliases seperated by ", ") : \n\n]]..ToPrint, true)
	else
		warn("Cannot run commandlist for non LocalPlayers.")
	end
end)
Entri.AddCommandAlias("get", "commands", "commandlist")
Entri.AddCommandAlias("get", "helplist", "commandlist")
Entri.AddCommandAlias("get", "cmdlist", "commandlist")
Entri.AddCommandAlias("get", "cmds", "commandlist")
Entri.AddCommandAlias("get", "help", "commandlist")

Entri.AddCommand("get", "discord", "Prompts you to join the discord (if your exploit supports it) and copies the link to your clipboard.", {}, function(Player)
	if Player == LocalPlayer then
		local httprequest = syn.request or request or http_request
		httprequest(
			{
				Url = "http://localhost:6463/rpc?v=1", 
				Method = "POST", 
				Headers = {
				["Content-Type"] = "application/json", 
				["origin"] = "https://discord.com", 
			}, 
			Body =game:GetService("HttpService"):JSONEncode({
				["args"] = {
					["code"] = Entri["Settings"].Invite, 
				}, 
				["cmd"] = "INVITE_BROWSER", 
				["nonce"] = "."
			})	
		})
		setclipboard("https://discord.gg/"..Entri["Settings"].Invite)
	end
end)
Entri.AddCommandAlias("get", "dis", "discord")
Entri.AddCommandAlias("get", "cord", "discord")

Entri.AddCommand("get", "rejoin", "Rejoins the game.", {}, function(Player)
	if Player == LocalPlayer then
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
		LocalPlayer:Kick("Rejoining...")
	end
end)
Entri.AddCommandAlias("get", "rj", "rejoin")

Entri.AddCommand("get", "rejoindifferent", "Rejoins the game in a different server.", {}, function(Player)
	if Player == LocalPlayer then
		local Servers = {}
		local Serverlist = game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")).data
		for _, Server in ipairs(Serverlist) do
			if type(Server) == "table" and Server.maxPlayers > Server.playing and Server.id ~= game.JobId then
				table.insert(Servers, Server.id)
			end
		end
		if #Servers > 0 then
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Servers[math.random(1, #Servers)])
			LocalPlayer:Kick("Joining a different server...")
		else
			game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "[ENTRI]";
			Text = "Could not find a server to hop to.";
			--Icon = "...";
			})
		end
	end
end)
Entri.AddCommandAlias("get", "rjdifferent", "rejoindifferent")
Entri.AddCommandAlias("get", "rejoindiff", "rejoindifferent")
Entri.AddCommandAlias("get", "serverhop", "rejoindifferent")
Entri.AddCommandAlias("get", "rjdiff", "rejoindifferent")
Entri.AddCommandAlias("get", "shop", "rejoindifferent")

Entri.AddCommand("get", "privateserver", "Teleports you to a private server, if they are free or you own one. If not, teleports you to the server with the least players.", {}, function(Player)
	if Player == LocalPlayer then
		local ServerFound = false;
		local httpRequest =
(syn and syn.request) or
(http and http.request) or
http_request or
(fluxus and fluxus.request) or
request

UserID = 1

local UserStatus = httpRequest({Url="https://presence.roblox.com/v1/presence/users", Body="{\"userIds\":["..UserID.."]}", Headers = {["Content-Type"]="application/json"}, Method = "POST"}).Body
print(UserStatus)
		local Serverlist = game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
		for _, Server in ipairs(Serverlist) do
			if type(Server) == "table" and Server.maxPlayers > Server.playing then
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Server.id)
				LocalPlayer:Kick("Joining a different server...")
				ServerFound = true;
				break;
			end
		end
		if ServerFound == false then
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "[ENTRI]";
				Text = "Could not find a server to hop to.";
				--Icon = "...";
			})
		end
	end
end)
Entri.AddCommandAlias("get", "privs", "privateserver")
Entri.AddCommandAlias("get", "ps", "privateserver")

Entri.AddCommand("get", "cancelteleport", "Cancels all current teleports.", {}, function(Player)
	if Player == LocalPlayer then
		game:GetService("TeleportService"):TeleportCancel()
	end
end)
Entri.AddCommandAlias("get", "canceltp", "cancelteleport")
Entri.AddCommandAlias("get", "ctp", "cancelteleport")

Entri.AddCommand("get", "rejoinposrespawn", "Rejoins the game and spawns in the current position", {}, function(Player)
	if Player == LocalPlayer then
		local Character = LocalPlayer.Character
		local Before = Character.PrimaryPart.CFrame or workspace.CurrentCamera.Focus
		queue_on_teleport([[
			repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer
			local Players = game:GetService("Players")
			local LocalPlayer = Players.LocalPlayer
			repeat task.wait() until LocalPlayer.Character
			local Character = LocalPlayer.Character
			repeat task.wait() until Character.PrimaryPart
			task.wait(.1)
			Character:SetPrimaryPartCFrame(CFrame.new(]]..tostring(Before)..[[))
			Character.PrimaryPart.Anchored = true
			Character.PrimaryPart.Velocity = Vector3.new()
			Character.PrimaryPart.AssemblyAngularVelocity = Vector3.new()
			Character.PrimaryPart.Anchored = false
		]])
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
		LocalPlayer:Kick("Rejoining...")
	end
end)
Entri.AddCommandAlias("get", "rjposrespawn", "rejoinposrespawn")
Entri.AddCommandAlias("get", "rejoinsreset", "rejoinposrespawn")
Entri.AddCommandAlias("get", "rejoinsr", "rejoinposrespawn")
Entri.AddCommandAlias("get", "rjsreset", "rejoinposrespawn")
Entri.AddCommandAlias("get", "rjsr", "rejoinposrespawn")
Entri.AddCommandAlias("get", "rjre", "rejoinposrespawn")

Entri.AddCommand("get", "respawn", "Respawns.", {}, function(Player)
	if Player == LocalPlayer then
		local PingData = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
		local Character = LocalPlayer.Character
		if not Character:GetAttribute("IgnoreChar") == true then
			Character:SetAttribute("IgnoreChar", true)
			LocalPlayer.Character = nil
			LocalPlayer.Character = Character
			task.wait(Players.RespawnTime-((PingData:GetValue()/1000)/4))
			Character:Destroy()
			local NewCharacter = LocalPlayer.CharacterAdded:wait()
			repeat task.wait(PingData:GetValue()/10000) until NewCharacter.PrimaryPart or LocalPlayer.Character ~= NewCharacter
			if NewCharacter == LocalPlayer.Character then
				if NewCharacter:FindFirstChildOfClass("ForceField") then
					task.wait((PingData:GetValue()/1000)/4)
					NewCharacter:FindFirstChildOfClass("ForceField"):Destroy()
				end
			end
		end
	end
end)
Entri.AddCommandAlias("get", "reset", "respawn")
Entri.AddCommandAlias("get", "r", "respawn")

Entri.AddCommand("get", "posrespawn", "Respawns in the current position.", {}, function(Player)
	if Player == LocalPlayer then
		local PingData = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
		local Character = LocalPlayer.Character
		if not Character:GetAttribute("IgnoreChar") == true then
			Character:SetAttribute("IgnoreChar", true)
			LocalPlayer.Character = nil
			LocalPlayer.Character = Character
			task.wait(Players.RespawnTime-((PingData:GetValue()/1000)/4))
			local Before = Character.PrimaryPart.CFrame or workspace.CurrentCamera.Focus
			Character:Destroy()
			local NewCharacter = LocalPlayer.CharacterAdded:wait()
			repeat task.wait(PingData:GetValue()/10000) until NewCharacter.PrimaryPart or LocalPlayer.Character ~= NewCharacter
			if NewCharacter == LocalPlayer.Character then
				NewCharacter:SetPrimaryPartCFrame(Before)
				if NewCharacter:FindFirstChildOfClass("ForceField") then
					task.wait((PingData:GetValue()/1000)/4)
					NewCharacter:FindFirstChildOfClass("ForceField"):Destroy()
				end
				NewCharacter.PrimaryPart.Anchored = true
				NewCharacter.PrimaryPart.Velocity = Vector3.new()
				NewCharacter.PrimaryPart.AssemblyAngularVelocity = Vector3.new()
				NewCharacter.PrimaryPart.Anchored = false
			end
		end
	end
end)
Entri.AddCommandAlias("get", "sreset", "posrespawn")
Entri.AddCommandAlias("get", "sr", "posrespawn")
Entri.AddCommandAlias("get", "re", "posrespawn")

--testing
Entri.AddCommand("get", "baseplate", "Creates a baseplate on client very far away and sets your spawn there.", {}, function(Player)
	if Player == LocalPlayer then
		local Character = LocalPlayer.Character
		local Baseplate = Entri["Settings"]["Mode"]["Testing"].Baseplate
		if Baseplate then
			warn("Baseplate already exists!")
			if Character and Character.PrimaryPart then
				Character:SetPrimaryPartCFrame(Baseplate.CFrame + Vector3.new(0, 5, 0))
				Character.PrimaryPart.Anchored = true
				Character.PrimaryPart.Velocity = Vector3.new()
				Character.PrimaryPart.AssemblyAngularVelocity = Vector3.new()
				Character.PrimaryPart.Anchored = false
			end
		else
			Baseplate = Instance.new("Part")
			Baseplate.Name = "Baseplate"
			Baseplate.Size = Vector3.new(2^10, 4, 2^10)
			Baseplate.Anchored = true
			Baseplate.Locked = true
			Baseplate.Parent = Entri.InstanceStorage
			Baseplate.CFrame = CFrame.new(2^16, 0, 2^16)
			Entri["Settings"]["Mode"]["Testing"].Baseplate = Baseplate
			if Character and Character.PrimaryPart then
				Character:SetPrimaryPartCFrame(Baseplate.CFrame + Vector3.new(0, 5, 0))
				Character.PrimaryPart.Anchored = true
				Character.PrimaryPart.Velocity = Vector3.new()
				Character.PrimaryPart.AssemblyAngularVelocity = Vector3.new()
				Character.PrimaryPart.Anchored = false
			end
			local Con1
			Con1 = Baseplate.Changed:Connect(function(Property)
				if Property == "Parent" and (Baseplate[Property] ~= Entri.InstanceStorage or not Baseplate:IsDescendantOf(workspace)) then
					Entri["Settings"]["Mode"]["Testing"].Baseplate = nil
					Con1:Disconnect()
				end
			end)
			local Con2
			Con2 = LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
				if Baseplate:IsDescendantOf(workspace) then
					repeat task.wait((PingData:GetValue()/1000)/4) until NewCharacter.PrimaryPart or LocalPlayer.Character ~= NewCharacter
					if not Character:GetAttribute("IgnoreChar") == true and NewCharacter == LocalPlayer.Character then
						NewCharacter:SetPrimaryPartCFrame(Baseplate.CFrame + Vector3.new(0, 5, 0))
						if NewCharacter:FindFirstChildOfClass("ForceField") then
							NewCharacter:FindFirstChildOfClass("ForceField"):Destroy()
						end
						NewCharacter.PrimaryPart.Anchored = true
						NewCharacter.PrimaryPart.Velocity = Vector3.new()
						NewCharacter.PrimaryPart.AssemblyAngularVelocity = Vector3.new()
						NewCharacter.PrimaryPart.Anchored = false
					end
				else
					Con2:Disconnect()
				end
			end)
		end
	end
end)
Entri.AddCommandAlias("get", "base", "baseplate")
Entri.AddCommandAlias("get", "b", "baseplate")

Entri.AddCommand("get", "removebaseplate", "If testing baseplate exists, removes it.", {}, function(Player)
	if Player == LocalPlayer then
		if Entri["Settings"]["Mode"]["Testing"].Baseplate then
			Entri["Settings"]["Mode"]["Testing"].Baseplate:Destroy()
			Entri["Settings"]["Mode"]["Testing"].Baseplate = nil
			local Character = LocalPlayer.Character
			if Character and Character.PrimaryPart then
				Character:SetPrimaryPartCFrame(Entri["Settings"].RespawnLocation)
				Character.PrimaryPart.Anchored = true
				Character.PrimaryPart.Velocity = Vector3.new()
				Character.PrimaryPart.AssemblyAngularVelocity = Vector3.new()
				Character.PrimaryPart.Anchored = false
			end
		else
			warn("Baseplate doesn't exist!")
		end
	end
end)
Entri.AddCommandAlias("get", "nobaseplate", "removebaseplate")
Entri.AddCommandAlias("get", "removebase", "removebaseplate")
Entri.AddCommandAlias("get", "nobase", "removebaseplate")
Entri.AddCommandAlias("get", "removeb", "removebaseplate")
Entri.AddCommandAlias("get", "nob", "removebaseplate")
Entri.AddCommandAlias("get", "rbase", "removebaseplate")
Entri.AddCommandAlias("get", "rb", "removebaseplate")

Entri.AddCommand("get", "walls", "If testing baseplate exists, adds walls to it.", {}, function(Player)
	if Player == LocalPlayer then
		if Entri["Settings"]["Mode"]["Testing"].Baseplate then
			local Baseplate = Entri["Settings"]["Mode"]["Testing"].Baseplate
			if Entri["Settings"]["Mode"]["Testing"].Walls then
				Entri["Settings"]["Mode"]["Testing"].Walls:Destroy()
				Entri["Settings"]["Mode"]["Testing"].Walls = nil
			end
			local Walls = Instance.new("Model")
			Walls.Name = "Walls"
			Walls.Parent = Entri.InstanceStorage
			Entri["Settings"]["Mode"]["Testing"].Walls = Walls
			local WallTable = {}
			for Count = 1, 4 do
				local Wall = Instance.new("Part")
				Wall.Name = "Entri Testing Wall "..tostring(Count)
				Wall.Size = Vector3.new(2^10, 2^8, 4)
				Wall.Anchored = true
				Wall.CFrame = CFrame.new(Baseplate.CFrame.X+((Baseplate.Size.X/2)*math.sin(math.rad(Count*90))), Baseplate.CFrame.Y+(Wall.Size.Y/2+Baseplate.Size.Y/2), Baseplate.CFrame.Z+((Baseplate.Size.Z/2)*math.cos(math.rad(Count*90)))) * CFrame.Angles(0, math.rad(90*Count), 0)
				Wall.Locked = true
				Wall.Parent = Walls
			end
			Con1 = Baseplate.Changed:Connect(function(Property)
				if Property == "Parent" and Baseplate[Property] ~= Entri.InstanceStorage then
					Entri["Settings"]["Mode"]["Testing"].Walls:Destroy()
					Entri["Settings"]["Mode"]["Testing"].Walls = nil
					Con1:Disconnect()
				end
			end)
		else
			warn("Baseplate doesn't exist!")
		end
	end
end)
Entri.AddCommandAlias("get", "wall", "walls")
Entri.AddCommandAlias("get", "w", "walls")

Entri.AddCommand("get", "removewalls", "If testing baseplate's walls exist, removes them.", {}, function(Player)
	if Player == LocalPlayer then
		if Entri["Settings"]["Mode"]["Testing"].Walls then
			Entri["Settings"]["Mode"]["Testing"].Walls:Destroy()
		else
			warn("Walls don't exist!")
		end
	end
end)
Entri.AddCommandAlias("get", "removewall", "removewalls")
Entri.AddCommandAlias("get", "removew", "removewalls")
Entri.AddCommandAlias("get", "removewall", "removewalls")
Entri.AddCommandAlias("get", "nowalls", "removewalls")
Entri.AddCommandAlias("get", "nowall", "removewalls")
Entri.AddCommandAlias("get", "rwall", "removewalls")
Entri.AddCommandAlias("get", "now", "removewalls")
Entri.AddCommandAlias("get", "rw", "removewalls")

--fix
Entri.AddCommand("get", "no.", "Runs all \"no...\" commands.", {}, function(Player)
	if Player == LocalPlayer then
		Entri["Prefixes"]["get"]["Commands"]["noguis"].Execute(Player, true)
		Entri["Prefixes"]["get"]["Commands"]["noaudios"].Execute(Player, true)
		Entri["Prefixes"]["get"]["Commands"]["noscripts"].Execute(Player, true)
		Entri["Prefixes"]["get"]["Commands"]["removebaseplate"].Execute(Player, true)
	end
end)

Entri.AddCommand("get", "noguis", "Removes all guis.", {}, function(Player)
	if Player == LocalPlayer then
		for _, Inst in pairs(LocalPlayer.PlayerGui:GetChildren()) do
			task.spawn(function()
				if Inst.Name ~= "Chat" and Inst.Name ~= "BubbleChat" then
					Inst:Destroy()
				end
			end)
		end
	end
end)
Entri.AddCommandAlias("get", "nogui", "noguis")
Entri.AddCommandAlias("get", "nog", "noguis")

Entri.AddCommand("get", "noaudios", "Calls Sound:Stop() on all sounds.", {}, function(Player)
	if Player == LocalPlayer then
		for _, Inst in pairs(game:GetDescendants()) do
			task.spawn(function()
				if Inst:IsA("Sound") and Inst.Playing == true then
					Inst:Stop()
				end
			end)
		end
	end
end)
Entri.AddCommandAlias("get", "nosounds", "noaudios")
Entri.AddCommandAlias("get", "noaudio", "noaudios")
Entri.AddCommandAlias("get", "nosound", "noaudios")
Entri.AddCommandAlias("get", "noa", "noaudios")

Entri.AddCommand("get", "synchronizesounds", "Synchronizes all sounds with the same id.", {}, function(Player)
	if Player == LocalPlayer then
		local Sounds = {}
		local TimePosition = {}
		for _, Inst in pairs(game:GetDescendants()) do
			if Inst:IsA("Sound") and Inst.SoundId ~= "" then
				if not Sounds[Inst.SoundId] then
					Sounds[Inst.SoundId] = {}
				end
				table.insert(Sounds[Inst.SoundId], Inst)
			end
		end
		for ID, SoundList in pairs(Sounds) do
			for _, Sound in pairs(SoundList) do
				if not TimePosition[ID] then
					TimePosition[ID] = 0
				end
				TimePosition[ID] += Sound.TimePosition
			end
			TimePosition[ID] = TimePosition[ID]/#SoundList
			for _, Sound in pairs(SoundList) do
				coroutine.wrap(function()
					Sound.TimePosition = TimePosition[Sound.SoundId]
				end)()
			end
		end
	end
end)
Entri.AddCommandAlias("get", "synchronizesound", "synchronizesounds")
Entri.AddCommandAlias("get", "syncsounds", "synchronizesounds")
Entri.AddCommandAlias("get", "syncaudios", "synchronizesounds")
Entri.AddCommandAlias("get", "syncsound", "synchronizesounds")
Entri.AddCommandAlias("get", "syncaudio", "synchronizesounds")
Entri.AddCommandAlias("get", "syncs", "synchronizesounds")
Entri.AddCommandAlias("get", "synca", "synchronizesounds")

Entri.AddCommand("get", "desynchronizesounds", "deynchronizes all sounds.", {}, function(Player)
	if Player == LocalPlayer then
		for _, Inst in pairs(game:GetDescendants()) do
			if Inst:IsA("Sound") and Inst.SoundId ~= "" then
				Inst.TimePosition = math.random(0, Inst.TimeLength*100)/100
			end
		end
	end
end)
Entri.AddCommandAlias("get", "desynchronizesound", "desynchronizesounds")
Entri.AddCommandAlias("get", "desyncsounds", "desynchronizesounds")
Entri.AddCommandAlias("get", "desyncaudios", "desynchronizesounds")
Entri.AddCommandAlias("get", "desyncsound", "desynchronizesounds")
Entri.AddCommandAlias("get", "desyncaudio", "desynchronizesounds")
Entri.AddCommandAlias("get", "desyncs", "desynchronizesounds")
Entri.AddCommandAlias("get", "desynca", "desynchronizesounds")

Entri.AddCommand("get", "noscripts", "Stops all scripts ran by the script builder.", {}, function(Player)
	if Player == LocalPlayer then
		for _, Script in pairs(Entri["Scripts"]["History"]) do
			task.spawn(function()
				if Script.Running then
					task.cancel(Script.Task)
					Script.Running = false
				end
			end)
		end
	end
end)
Entri.AddCommandAlias("get", "noscript", "noscripts")
Entri.AddCommandAlias("get", "nos", "noscripts")

Entri.AddCommand("get", "rigtype", "Changes your avatar rigtype to the specified rigtype.", {"RigType"}, function(Player, RigType)
	if Player == LocalPlayer then
		local RigExists = Entri["Functions"]["EnumCheck"].Execute({"HumanoidRigType", string.upper(RigType)}).Output[1]
		if RigExists then
			local AES = game:GetService("AvatarEditorService")
			local VIM = game:GetService("VirtualInputManager")
			AES:PromptSaveAvatar(Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId), Enum.HumanoidRigType[string.upper(RigType)])
			local Prompt = game:GetService("CoreGui").ThemeProvider.PromptFrame:WaitForChild("Prompt")
			local Button = Prompt:WaitForChild("AlertContents"):WaitForChild("Footer"):WaitForChild("Buttons"):WaitForChild("2")
			Prompt.ImageTransparency = 1
			task.wait(.1)
			Button.Parent = Prompt
			Button:ClearAllChildren()
			for _, Inst in pairs(Prompt:GetChildren()) do
				if Inst ~= Button then
					Inst:Destroy()
				end
			end
			Button.ImageTransparency = 1
			Button:GetPropertyChangedSignal("ImageTransparency"):Connect(function()
				Button.ImageTransparency = 1
			end)
			task.wait(.25)
			Prompt.Size = UDim2.new(0, 9e9, 0, 9e9)
			Button.Size = UDim2.new(0, 9e9, 0, 9e9)
			Button.AnchorPoint = Vector2.new(.5, .5)
			Button.Position = UDim2.new(.5, 0, .5, 0)
			Button.ZIndex = 9e9
			task.wait(.1)
			VIM:SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2, 0, true, game, 0)
			task.wait(.1)
			VIM:SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2, 0, false, game, 0)
		end
	end
end)
Entri.AddCommandAlias("get", "rig", "rigtype")

Entri.AddCommand("get", "dupetools", "Dupes your current tools (n) amount of times.", {"Times"}, function(Player, Times)
	if Player == LocalPlayer then
		if tonumber(Times) then
			Times = tonumber(Times) or 1
			local PingData = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
			for _=1, Times do
				local Character = LocalPlayer.Character
				local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
				if not Character:GetAttribute("IgnoreChar") == true then
					Character:SetAttribute("IgnoreChar", true)
					LocalPlayer.Character = nil
					LocalPlayer.Character = Character
					task.wait(Players.RespawnTime-((PingData:GetValue()/1000))*2)
					local Before = Character.PrimaryPart.CFrame or workspace.CurrentCamera.Focus
					Character:SetPrimaryPartCFrame(Before+Vector3.new(0, 2^30, 0))
					task.wait(PingData:GetValue()/2500)
					local Tools = {}
					for _, Inst in pairs(Character:GetChildren()) do
						if Inst:IsA("BackpackItem") and Inst:FindFirstChild("Handle") then
							table.insert(Tools, Inst)
						end
					end
					for _, Inst in pairs(Backpack:GetChildren()) do
							if Inst:IsA("BackpackItem") and Inst:FindFirstChild("Handle") then
							table.insert(Tools, Inst)
						end
					end
					for _, Tool in pairs(Tools) do
						task.spawn(function()
							Tool.Parent = Character
							if Tool.RequiresHandle and Tool:FindFirstChild("Handle") then
								Tool:FindFirstChild("Handle").Anchored = true
							end
							Tool.Parent = workspace
						end)
					end
					local CanDestroy
					repeat
						CanDestroy = true
						for _, Tool in pairs(Tools) do
							if Tool.Parent ~= workspace then
								CanDestroy = false
								break
							end
						end
						task.wait()
						if CanDestroy then
							Character:Destroy()
						end
					until CanDestroy == true or not Character
					local NewCharacter = LocalPlayer.CharacterAdded:wait()
					repeat task.wait(PingData:GetValue()/10000) until NewCharacter.PrimaryPart and NewCharacter:FindFirstChildOfClass("Humanoid") or LocalPlayer.Character ~= NewCharacter
					if NewCharacter == LocalPlayer.Character then
						NewHumanoid = NewCharacter:FindFirstChildOfClass("Humanoid")
						if NewHumanoid then
							repeat
								Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
								task.wait()
							until Backpack ~= nil
							for _, Tool in pairs(Tools) do
								task.spawn(function()
									if Tool.RequiresHandle and Tool:FindFirstChild("Handle") then
										Tool:FindFirstChild("Handle").Anchored = false
									end
									if Tool.Parent == workspace then
										NewHumanoid:EquipTool(Tool)
										repeat task.wait() until Tool.Parent == NewCharacter or Tool.Parent == Backpack
										Tool.Parent = Backpack
									end
								end)
							end
						end
						NewCharacter:SetPrimaryPartCFrame(Before)
						if NewCharacter:FindFirstChildOfClass("ForceField") then
							NewCharacter:FindFirstChildOfClass("ForceField"):Destroy()
						end
						NewCharacter.PrimaryPart.Anchored = true
						NewCharacter.PrimaryPart.Velocity = Vector3.new()
						NewCharacter.PrimaryPart.AssemblyAngularVelocity = Vector3.new()
						NewCharacter.PrimaryPart.Anchored = false
					end
					task.wait(.1)
				end
			end
		else
			error("Arg1 (Times) must be a number value.")
		end
	end
end)
Entri.AddCommandAlias("get", "dupetool", "dupetools")
Entri.AddCommandAlias("get", "tooldupe", "dupetools")
Entri.AddCommandAlias("get", "dt", "dupetools")
Entri.AddCommandAlias("get", "td", "dupetools")

Entri.AddCommand("get", "teleportto", "Teleports you to the specified Player's character.", {"Target"}, function(Player, Target)
	if Player == LocalPlayer then
		local Character = LocalPlayer.Character
		local Targets = Entri["Functions"]["GetPlayerBy"].Execute({Target}).Output[1]
		if Character and Character.PrimaryPart  and Targets[1].Character and Targets[1].Character.PrimaryPart then
			Character:SetPrimaryPartCFrame(Targets[1].Character.PrimaryPart.CFrame)
			Character.PrimaryPart.Anchored = true
			Character.PrimaryPart.Velocity = Vector3.new()
			Character.PrimaryPart.AssemblyAngularVelocity = Vector3.new()
			Character.PrimaryPart.Anchored = false
			print('hssd')
		end
	end
end)
Entri.AddCommandAlias("get", "tpto", "teleportto")
Entri.AddCommandAlias("get", "to", "teleportto")

Entri.AddCommand("get", "walkspeed", "Sets your Humanoid's WalkSpeed to a number value, if possible.", {"WalkSpeed"}, function(Player, WalkSpeed)
	if Player == LocalPlayer then
		local WalkSpeed = tonumber(WalkSpeed)
		if WalkSpeed then
			local Character = Player.Character
			if Character and Character:FindFirstChildOfClass("Humanoid") then
				Character:FindFirstChildOfClass("Humanoid").WalkSpeed = WalkSpeed
			else
				warn("WalkSpeed not set, as Player did not have valid character model with a Humanoid.")
			end
		else
			error("Arg1 (WalkSpeed) must be a number value.")
		end
	end
end)
Entri.AddCommandAlias("get", "speed", "walkspeed")
Entri.AddCommandAlias("get", "ws", "walkspeed")

Entri.AddCommand("get", "hipheight", "Sets your Humanoid's HipHeight to a number value, if possible.", {"HipHeight"}, function(Player, HipHeight)
	if Player == LocalPlayer then
		local HipHeight = tonumber(HipHeight)
		if HipHeight then
			local Character = Player.Character
			if Character and Character:FindFirstChildOfClass("Humanoid") then
				Character:FindFirstChildOfClass("Humanoid").HipHeight = HipHeight
			else
				warn("HipHeight not set, as Player did not have valid character model with a Humanoid.")
			end
		else
			error("Arg1 (HipHeight) must be a number value.")
		end
	end
end)
Entri.AddCommandAlias("get", "hheight", "hipheight")
Entri.AddCommandAlias("get", "hiph", "hipheight")
Entri.AddCommandAlias("get", "hh", "hipheight")

Entri.AddCommand("get", "jump", "Jumps.", {}, function(Player)
	if Player == LocalPlayer then
		local Character = Player.Character
		if Character and Character:FindFirstChildOfClass("Humanoid") then
			local Humanoid = Character:FindFirstChildOfClass("Humanoid")
			Character:FindFirstChildOfClass("Humanoid").Jump = true
		else
			warn("Could not jump, as Player did not have valid character model with a Humanoid.")
		end
	end
end)

Entri.AddCommand("get", "jumpheight", "Sets your Humanoid's JumpHeight to a number value, if possible.", {"JumpHeight"}, function(Player, JumpHeight)
	if Player == LocalPlayer then
		local JumpHeight = tonumber(JumpHeight)
		if JumpHeight then
			local Character = Player.Character
			if Character and Character:FindFirstChildOfClass("Humanoid") then
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				Humanoid.JumpHeight = JumpHeight
				Humanoid.UseJumpPower = false
			else
				warn("JumpHeight not set, as Player did not have valid character model with a Humanoid.")
			end
		else
			error("Arg1 (JumpHeight) must be a number value.")
		end
	end
end)
Entri.AddCommandAlias("get", "jheight", "jumpheight")
Entri.AddCommandAlias("get", "jumph", "jumpheight")
Entri.AddCommandAlias("get", "jh", "jumpheight")

Entri.AddCommand("get", "jumppower", "Sets your Humanoid's JumpPower to a number value, if possible.", {"JumpPower"}, function(Player, JumpPower)
	if Player == LocalPlayer then
		local JumpPower = tonumber(JumpPower)
		if JumpPower then
			local Character = Player.Character
			if Character and Character:FindFirstChildOfClass("Humanoid") then
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				Humanoid.JumpPower = JumpPower
				Humanoid.UseJumpPower = true
			else
				warn("JumpPower not set, as Player did not have valid character model with a Humanoid.")
			end
		else
			error("Arg1 (JumpPower) must be a number value.")
		end
	end
end)
Entri.AddCommandAlias("get", "jpower", "jumppower")
Entri.AddCommandAlias("get", "jumpp", "jumppower")
Entri.AddCommandAlias("get", "jp", "jumppower")

Entri.AddCommand("get", "platformstand", "Toggles your Humanoid's PlatformStand to a number value, if possible.", {}, function(Player)
	if Player == LocalPlayer then
		local Character = Player.Character
		if Character and Character:FindFirstChildOfClass("Humanoid") then
			local Humanoid = Character:FindFirstChildOfClass("Humanoid")
			Humanoid.PlatformStand = not Humanoid.PlatformStand
		else
			warn("PlatformStand not set, as Player did not have valid character model with a Humanoid.")
		end
	end
end)

Entri.AddCommand("get", "sit", "Sits.", {}, function(Player)
	if Player == LocalPlayer then
		local Character = Player.Character
		if Character and Character:FindFirstChildOfClass("Humanoid") then
			Character:FindFirstChildOfClass("Humanoid").Sit = true
		else
			warn("Could not sit, as Player did not have valid character model with a Humanoid.")
		end
	end
end)

Entri.AddCommand("get", "humanoidstate", "Sets your Humanoid's HumanoidStateType to a number value, if possible.", {"State"}, function(Player, State)
	if Player == LocalPlayer then
		local State = tonumber(State)
		if State then
			local Character = Player.Character
			if Character and Character:FindFirstChildOfClass("Humanoid") then
				Character:FindFirstChildOfClass("Humanoid").Sit = true
			else
				warn("Could not sit, as Player did not have valid character model with a Humanoid.")
			end
		else
			error("Arg1 (State) must be a number value.")
		end
	end
end)

Entri.AddCommand("get", "equiptools", "Equips all tools in your backpack, if possible.", {"State"}, function(Player, State)
	if Player == LocalPlayer then
		local State = tonumber(State)
		if State then
			local Character = Player.Character
			if Character and Character:FindFirstChildOfClass("Humanoid") then
				Character:FindFirstChildOfClass("Humanoid").Sit = true
			else
				warn("Could not sit, as Player did not have valid character model with a Humanoid.")
			end
		else
			error("Arg1 (State) must be a number value.")
		end
	end
end)

Entri.AddCommand("get", "top", "Teleports you to the topmost part that shares your CFrame X and Z.", {}, function(Player)
	if Player == LocalPlayer then
		local TopY = 0
		local CurrentWS = workspace:GetDescendants()
		for _, Inst in pairs(CurrentWS) do
			if Inst:IsA("BasePart") then
				local PartTop = Inst.Position.Y+(math.max(Inst.Size.X, Inst.Size.Y, Inst.Size.Z)/2)
				if PartTop > TopY then
					TopY = PartTop
				end
			end
		end
		local Character = LocalPlayer.Character
		local PrimaryPart = Character.PrimaryPart
		if Character and PrimaryPart then
			local BlacklistedParts = {}
			for _, Inst in pairs(game:GetDescendants()) do
				if Inst:IsA("BasePart") and ((not Inst:IsDescendantOf(workspace) or not Inst:CanCollideWith(PrimaryPart)) or Inst:IsDescendantOf(Character)) then
					table.insert(BlacklistedParts, Inst)
				end
			end
			local CurrentCF = Character.PrimaryPart.CFrame
			local RayCastParam = RaycastParams.new()
			RayCastParam.FilterDescendantsInstances = BlacklistedParts
			RayCastParam.FilterType = Enum.RaycastFilterType.Blacklist
			local RayCastResult = workspace:Raycast(CurrentCF.Position+Vector3.new(0, TopY, 0), Vector3.new(0, -TopY, 0), RaycastParam)
			if RayCastResult then
				CurrentCF = CFrame.new(RayCastResult.Position)
			end
			OverlapParam = OverlapParams.new()
			OverlapParam.FilterDescendantsInstances = BlacklistedParts
			OverlapParam.FilterType = Enum.RaycastFilterType.Blacklist
			while true do
				local OLap = workspace:GetPartBoundsInBox(CurrentCF, PrimaryPart.Size, OverlapParam)
				if #OLap == 0 then
					break
				else
					CurrentCF = CurrentCF + Vector3.new(0, math.max(PrimaryPart.Size.X, PrimaryPart.Size.Y, PrimaryPart.Size.Z), 0)
				end
			end
			Character:SetPrimaryPartCFrame(CurrentCF*(PrimaryPart.CFrame-PrimaryPart.CFrame.p))
			Character.PrimaryPart.Anchored = true
			Character.PrimaryPart.Velocity = Vector3.new()
			Character.PrimaryPart.AssemblyAngularVelocity = Vector3.new()
			Character.PrimaryPart.Anchored = false
		end
	end
end)

Entri.AddCommand("get", "bottom", "Teleports you to the bottommost part that shares your CFrame X and Z.", {}, function(Player)
	if Player == LocalPlayer then
		local TopY = 0
		local BottomY = 0
		local CurrentWS = workspace:GetDescendants()
		for _, Inst in pairs(CurrentWS) do
			if Inst:IsA("BasePart") then
				local PartTop = Inst.Position.Y+(math.max(Inst.Size.X, Inst.Size.Y, Inst.Size.Z)/2)
				if PartTop > TopY then
					TopY = PartTop
				end
			end
		end
		for _, Inst in pairs(CurrentWS) do
			if Inst:IsA("BasePart") then
				local PartBottom = Inst.Position.Y+(math.max(Inst.Size.X, Inst.Size.Y, Inst.Size.Z)/2)
				if PartBottom < BottomY then
					BottomY = PartBottom
				end
			end
		end
		local Character = LocalPlayer.Character
		local PrimaryPart = Character.PrimaryPart
		if Character and PrimaryPart then
			local BlacklistedParts = {}
			for _, Inst in pairs(game:GetDescendants()) do
				if Inst:IsA("BasePart") and ((not Inst:IsDescendantOf(workspace) or not Inst:CanCollideWith(PrimaryPart)) or Inst:IsDescendantOf(Character)) then
					table.insert(BlacklistedParts, Inst)
				end
			end
			local CurrentCF = Character.PrimaryPart.CFrame
			local RayCastParam = RaycastParams.new()
			RayCastParam.FilterDescendantsInstances = BlacklistedParts
			RayCastParam.FilterType = Enum.RaycastFilterType.Blacklist
			local RayCastResult = workspace:Raycast(Vector3.new(CurrentCF.Position.X, BottomY, CurrentCF.Position.Z), Vector3.new(0, -BottomY+TopY, 0), RaycastParam)
			if RayCastResult then
				CurrentCF = CFrame.new(RayCastResult.Position)
			end
			OverlapParam = OverlapParams.new()
			OverlapParam.FilterDescendantsInstances = BlacklistedParts
			OverlapParam.FilterType = Enum.RaycastFilterType.Blacklist
			while true do
				local OLap = workspace:GetPartBoundsInBox(CurrentCF, PrimaryPart.Size, OverlapParam)
				if #OLap == 0 then
					break
				else
					CurrentCF = CurrentCF + Vector3.new(0, math.max(PrimaryPart.Size.X, PrimaryPart.Size.Y, PrimaryPart.Size.Z), 0)
				end
			end
			Character:SetPrimaryPartCFrame(CurrentCF*(PrimaryPart.CFrame-PrimaryPart.CFrame.p))
			Character.PrimaryPart.Anchored = true
			Character.PrimaryPart.Velocity = Vector3.new()
			Character.PrimaryPart.AssemblyAngularVelocity = Vector3.new()
			Character.PrimaryPart.Anchored = false
		end
	end

end)
Entri.AddCommand("get", "stopinvoke", "", {"Path", "Message"}, function(Player, Path, Message)
    local Remote = Entri["Functions"]["GetInstanceFromPath"].Execute({Path})
    assert(Remote.ClassName == "RemoteFunction", "Error: stopinvoke needs a RemoteFunction!")
    Remote.OnClientInvoke = function()
        assert(false, Message or "")
    end
end)

Entri.AddCommandAlias("get", "stopremote", "stopinvoke")
Entri.AddCommandAlias("get", "si", "stopinvoke")
Entri.AddCommandAlias("get", "invokestop", "stopinvoke")

Entri["Settings"]["Output"].Send(print, "Entri loaded.")
