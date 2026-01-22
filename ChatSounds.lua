ChatSounds_Version = "2.1"
ChatSounds_Player  = "player"
ChatSounds_Config  = ChatSounds_Config or {}

local ChatSounds_label = "|cffFFCC00ChatSounds|r";
local chatFrameHooked = false

local function ChatSounds_TryHookChatFrame()
	if (not chatFrameHooked) then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", ChatSounds_ChatMessageFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", ChatSounds_ChatMessageFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", ChatSounds_ChatMessageFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", ChatSounds_ChatMessageFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", ChatSounds_ChatMessageFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", ChatSounds_ChatMessageFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", ChatSounds_ChatMessageFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", ChatSounds_ChatMessageFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChatSounds_ChatMessageFilter)
		chatFrameHooked = true
		return true
	end
	return false
end

local function ChatSounds_Slasher(cmd)
	ChatSounds_InitConfig()
	if not cmd or cmd == "" then
		ChatSoundsOptionsFrame_Show()
		DEFAULT_CHAT_FRAME:AddMessage(ChatSounds_label..": '/chatsounds ?' or '/chatsounds !help' for other commands.");
	elseif string.lower(cmd) == "!help" or cmd == "?" then
		DEFAULT_CHAT_FRAME:AddMessage(ChatSounds_label.." ".. ChatSounds_Version);
		DEFAULT_CHAT_FRAME:AddMessage("'/chatsounds customchannel' blacklists/un-blacklists a custom channel from playing sounds");
		DEFAULT_CHAT_FRAME:AddMessage("    Useful if you have some addon joining a custom channel and spamming messages.");
		DEFAULT_CHAT_FRAME:AddMessage("'/chatsounds !list' lists the custom channels you have blacklisted if any.");
	elseif string.lower(cmd) == "!list" then
		if next(ChatSounds_Config[ChatSounds_Player].Blacklist) then
			DEFAULT_CHAT_FRAME:AddMessage("ChatSounds Blacklist:")
			for k,v in pairs(ChatSounds_Config[ChatSounds_Player].Blacklist) do
				DEFAULT_CHAT_FRAME:AddMessage(k)
			end
		else
			DEFAULT_CHAT_FRAME:AddMessage(ChatSounds_label..": no blacklisted channels")
		end
	else
		cmd = string.lower(cmd)
		if ChatSounds_Config[ChatSounds_Player].Blacklist[cmd] then
			ChatSounds_Config[ChatSounds_Player].Blacklist[cmd] = nil
			DEFAULT_CHAT_FRAME:AddMessage(ChatSounds_label..": ".. cmd .. " removed from Blacklist.");
		else
			ChatSounds_Config[ChatSounds_Player].Blacklist[cmd] = true
			DEFAULT_CHAT_FRAME:AddMessage(ChatSounds_label..": ".. cmd .. " added to Blacklist.");
		end
	end
end

function ChatSounds_OnLoad(self)

	-- Register Variable Loading and Chat Events.
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_LOGIN")
	
	-- Register Slash Command.
	SLASH_CHATSOUNDS1 = "/chatsounds"
	SlashCmdList["CHATSOUNDS"] = ChatSounds_Slasher

end

function ChatSounds_InitConfig()

	ChatSounds_Player = UnitName("player") .. " of " .. GetRealmName()

	if (not ChatSounds_Config) then
		ChatSounds_Config = {}
	end
	if (not ChatSounds_Config[ChatSounds_Player]) then
		ChatSounds_Config[ChatSounds_Player] = {}
		ChatSounds_Config[ChatSounds_Player].ForceWhispers          = true
	end
	if (not ChatSounds_Config[ChatSounds_Player].Blacklist) then
		ChatSounds_Config[ChatSounds_Player].Blacklist = {}
	end
	if (not ChatSounds_Config[ChatSounds_Player].Incoming) then
		ChatSounds_Config[ChatSounds_Player].Incoming               					= {}
		ChatSounds_Config[ChatSounds_Player].Incoming["GUILD"]      					= "Kachink"
		ChatSounds_Config[ChatSounds_Player].Incoming["OFFICER"]    					= "Link"
		ChatSounds_Config[ChatSounds_Player].Incoming["PARTY"]      					= "Text1"
		ChatSounds_Config[ChatSounds_Player].Incoming["PARTY_LEADER"]    			= "Choo"
		ChatSounds_Config[ChatSounds_Player].Incoming["RAID"]       					= "Text2"
		ChatSounds_Config[ChatSounds_Player].Incoming["RAID_LEADER"]    			= "Choo"
		ChatSounds_Config[ChatSounds_Player].Incoming["INSTANCE_CHAT"]    		= "switchy"
		ChatSounds_Config[ChatSounds_Player].Incoming["INSTANCE_CHAT_LEADER"]	= "doublehit"
		ChatSounds_Config[ChatSounds_Player].Incoming["WHISPER"]    					= "Heart"
		ChatSounds_Config[ChatSounds_Player].Incoming["BNWHISPER"]    				= "Heart"
		ChatSounds_Config[ChatSounds_Player].Incoming["GMWHISPER"] 						= "gasp"
		ChatSounds_Config[ChatSounds_Player].Incoming["CHANNEL"]							= "himetal"
	end
	if (not ChatSounds_Config[ChatSounds_Player].Outgoing) then
		ChatSounds_Config[ChatSounds_Player].Outgoing               					= {}
		ChatSounds_Config[ChatSounds_Player].Outgoing["GUILD"]      					= "pop1"
		ChatSounds_Config[ChatSounds_Player].Outgoing["OFFICER"]    					= "pop2"
		ChatSounds_Config[ChatSounds_Player].Outgoing["PARTY"]      					= "pop1"
		ChatSounds_Config[ChatSounds_Player].Outgoing["PARTY_LEADER"]    			= "pop2"
		ChatSounds_Config[ChatSounds_Player].Outgoing["RAID"]       					= "pop1"
		ChatSounds_Config[ChatSounds_Player].Outgoing["RAID_LEADER"]    			= "pop2"
		ChatSounds_Config[ChatSounds_Player].Outgoing["INSTANCE_CHAT"]    		= "pop1"
		ChatSounds_Config[ChatSounds_Player].Outgoing["INSTANCE_CHAT_LEADER"]	= "pop2"
		ChatSounds_Config[ChatSounds_Player].Outgoing["WHISPER"]    					= "TellMessage"
		ChatSounds_Config[ChatSounds_Player].Outgoing["BNWHISPER"]    				= "TellMessage"
		ChatSounds_Config[ChatSounds_Player].Outgoing["CHANNEL"]							= "himetal"
	end
end

function ChatSounds_OnEvent(self, event, ...)
	
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...;
	
	if (event == "ADDON_LOADED" and arg1 == "ChatSounds" ) then

		ChatSounds_InitConfig();
		if not ChatSounds_TryHookChatFrame() then
			self:RegisterEvent("PLAYER_LOGIN")
		end
		-- ChatSounds are now loaded!
		DEFAULT_CHAT_FRAME:AddMessage(ChatSounds_label.." ".. ChatSounds_Version .. " are loaded.");
		self:UnregisterEvent("ADDON_LOADED");

	elseif (event == "PLAYER_LOGIN") then
		if ChatSounds_TryHookChatFrame() then
			self:UnregisterEvent("PLAYER_LOGIN")
		end

	end
end

-- Chat message filter for WoW 12.0+ API
function ChatSounds_ChatMessageFilter(frame, event, message, sender, languageName, channelName, ...)
	local msgtype = string.sub(event, 10)
	
	-- Skip if config not ready yet
	if not ChatSounds_Config or not ChatSounds_Config[ChatSounds_Player] then
		return false
	end
	
	if msgtype == "CHANNEL" then
		-- Get additional args specific to CHAT_MSG_CHANNEL
		local channelIndex = select(7, ...)  -- channelIndex
		-- Filter AFK/DND/COM or global channels (1-10)
		if channelName == "AFK" or channelName == "DND" or channelName == "COM" or (channelIndex and channelIndex > 0) then 
			return false  
		end
		-- Check blacklist
		if channelName and ChatSounds_Config[ChatSounds_Player].Blacklist[string.lower(channelName)] then 
			return false 
		end
	end
	
	-- Check if message is from player
	local isOutgoing = (sender == UnitName("player"))
	
	if isOutgoing then
		ChatSounds_PlaySound(ChatSounds_Config[ChatSounds_Player].Outgoing[msgtype])
	else
		ChatSounds_PlaySound(ChatSounds_Config[ChatSounds_Player].Incoming[msgtype])
	end
	
	return false  -- Don't filter the message
end

function ChatSounds_PlaySound(sound)
	if (not sound or not ChatSounds_Sound[sound]) then return end
	local snd = tostring(ChatSounds_Sound[sound].value)
	if snd:find("%\\") then
		PlaySoundFile(snd, "Master")
	else
		PlaySound(snd, "Master")
	end
end

function ChatSoundsOptionsFrame_Show()
	if ChatSoundsOptionsFrame and InterfaceOptionsFrame_OpenToCategory then
		InterfaceOptionsFrame_OpenToCategory(ChatSoundsOptionsFrame)
		InterfaceOptionsFrame_OpenToCategory(ChatSoundsOptionsFrame)
	elseif ChatSoundsOptionsFrame then
		ChatSoundsOptionsFrame:Show()
	end
end
