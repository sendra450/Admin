-- AdminServer.lua (Server-side handler)
-- Letakkan script ini di ServerScriptService untuk menangani admin actions

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game.ReplicatedStorage

-- DataStore untuk ban data
local banDataStore = DataStoreService:GetDataStore("BannedPlayers")

-- Fungsi untuk membuat remote event
local function createRemoteEvent(name)
	local event = ReplicatedStorage:FindFirstChild(name)
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = name
		event.Parent = ReplicatedStorage
	end
	return event
end

-- Buat semua remote events
local changeTagEvent = createRemoteEvent("ChangeTagEvent")
local changePermissionEvent = createRemoteEvent("ChangePermissionEvent")
local banPlayerEvent = createRemoteEvent("BanPlayerEvent")
local kickPlayerEvent = createRemoteEvent("KickPlayerEvent")

-- ============================================
-- CHANGE TAG HANDLER
-- ============================================
changeTagEvent.OnServerEvent:Connect(function(admin, targetPlayer, newTag)
	if targetPlayer and targetPlayer:IsDescendantOf(Players) then
		-- Simpan tag di player attributes
		targetPlayer:SetAttribute("PlayerTag", newTag)
		
		-- Update di UI jika ada
		if targetPlayer:FindFirstChild("TagGui") then
			targetPlayer.TagGui.TextLabel.Text = newTag
		end
		
		-- Log action
		print("[ADMIN ACTION] " .. admin.Name .. " mengubah tag " .. targetPlayer.Name .. " menjadi: " .. newTag)
	end
end)

-- ============================================
-- CHANGE PERMISSION HANDLER
-- ============================================
changePermissionEvent.OnServerEvent:Connect(function(admin, targetPlayer, permLevel)
	if targetPlayer and targetPlayer:IsDescendantOf(Players) then
		-- Validasi level
		if permLevel < 1 or permLevel > 5 then
			warn("Permission level harus antara 1-5")
			return
		end
		
		local levelNames = {
			[1] = "User",
			[2] = "Moderator",
			[3] = "Admin",
			[4] = "Owner",
			[5] = "Developer"
		}
		
		-- Simpan permission
		targetPlayer:SetAttribute("PermissionLevel", permLevel)
		
		-- Log action
		print("[ADMIN ACTION] " .. admin.Name .. " mengubah permission " .. targetPlayer.Name .. " menjadi: " .. levelNames[permLevel] .. " (Level " .. permLevel .. ")")
		
		-- Notify pemain (opsional)
		local notif = Instance.new("Message")
		notif.Text = "Permission Anda diubah menjadi: " .. levelNames[permLevel]
		notif.Parent = workspace
		game:GetService("Debris"):AddItem(notif, 3)
	end
end)

-- ============================================
-- BAN PLAYER HANDLER
-- ============================================
banPlayerEvent.OnServerEvent:Connect(function(admin, targetPlayer)
	if targetPlayer and targetPlayer:IsDescendantOf(Players) then
		local userId = targetPlayer.UserId
		local username = targetPlayer.Name
		
		-- Simpan ke DataStore
		local success, err = pcall(function()
			banDataStore:SetAsync("Ban_" .. userId, {
				userId = userId,
				username = username,
				bannedAt = os.time(),
				bannedBy = admin.Name,
				reason = "Banned by admin"
			})
		end)
		
		if success then
			print("[ADMIN ACTION] " .. admin.Name .. " membanned " .. username .. " (ID: " .. userId .. ")")
			
			-- Kick dari server
			targetPlayer:Kick("Anda telah di-ban dari server ini!")
		else
			warn("Error saat menyimpan ban data: " .. err)
		end
	end
end)

-- ============================================
-- KICK PLAYER HANDLER
-- ============================================
kickPlayerEvent.OnServerEvent:Connect(function(admin, targetPlayer)
	if targetPlayer and targetPlayer:IsDescendantOf(Players) then
		local username = targetPlayer.Name
		
		print("[ADMIN ACTION] " .. admin.Name .. " mengkick " .. username)
		
		-- Kick dari server
		targetPlayer:Kick("Anda telah di-kick oleh admin!")
	end
end)

-- ============================================
-- ANTI BAN - Cegah banned players masuk
-- ============================================
Players.PlayerAdded:Connect(function(player)
	local userId = player.UserId
	
	-- Check jika player sudah banned
	local success, banData = pcall(function()
		return banDataStore:GetAsync("Ban_" .. userId)
	end)
	
	if success and banData then
		print("[BAN CHECK] " .. player.Name .. " sudah banned, kick dari server")
		wait(0.1) -- Tunggu sebentar agar player fully load
		player:Kick("Anda telah di-ban dari server ini!")
	end
end)

-- ============================================
-- ADMIN LOG SYSTEM (Opsional)
-- ============================================
local adminLogDataStore = DataStoreService:GetDataStore("AdminLogs")

local function logAdminAction(admin, action, target, details)
	local timestamp = os.date("%Y-%m-%d %H:%M:%S")
	local logEntry = {
		timestamp = timestamp,
		admin = admin,
		action = action,
		target = target,
		details = details or ""
	}
	
	-- Log ke server output
	print("[LOG] " .. timestamp .. " | " .. admin .. " | " .. action .. " | Target: " .. target .. " | " .. (details or ""))
	
	-- Opsional: Simpan ke DataStore
	local key = "AdminLog_" .. os.time()
	local success, err = pcall(function()
		adminLogDataStore:SetAsync(key, logEntry)
	end)
end

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

-- Fungsi untuk mendapatkan permission level
local function getPlayerPermission(player)
	return player:GetAttribute("PermissionLevel") or 1
end

-- Fungsi untuk mendapatkan player tag
local function getPlayerTag(player)
	return player:GetAttribute("PlayerTag") or ""
end

-- Expose functions ke module (opsional)
local AdminModule = {}

function AdminModule:BanPlayer(userId, username, bannedBy)
	local success, err = pcall(function()
		banDataStore:SetAsync("Ban_" .. userId, {
			userId = userId,
			username = username,
			bannedAt = os.time(),
			bannedBy = bannedBy,
			reason = "Banned by admin"
		})
	end)
	return success
end

function AdminModule:UnbanPlayer(userId)
	local success, err = pcall(function()
		banDataStore:RemoveAsync("Ban_" .. userId)
	end)
	return success
end

function AdminModule:IsBanned(userId)
	local success, banData = pcall(function()
		return banDataStore:GetAsync("Ban_" .. userId)
	end)
	return success and banData ~= nil
end

print("✅ Admin Server Handler loaded!")
print("📡 Remote Events ready for admin menu")
