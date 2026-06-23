-- AdminGUI Main Script
-- Letakkan script ini di StarterGui untuk membuat admin menu interface

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Konfigurasi Admin Menu
local ADMIN_KEY = Enum.KeyCode.M -- Tekan M untuk membuka menu
local ADMIN_IDS = {12345, 67890} -- Ganti dengan User IDs admin yang bisa membuka menu

-- Fungsi untuk mengecek apakah pemain adalah admin
local function isAdmin(player)
	for _, adminId in ipairs(ADMIN_IDS) do
		if player.UserId == adminId then
			return true
		end
	end
	return false
end

-- Buat main GUI container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Enabled = false
screenGui.Parent = game:GetService("StarterGui")

-- Buat background frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Tambah corner untuk efek rounded
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Header dengan title
local headerFrame = Instance.new("Frame")
headerFrame.Name = "Header"
headerFrame.Size = UDim2.new(1, 0, 0, 50)
headerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = headerFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚙️ ADMIN MENU"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = headerFrame

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "✕"
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = headerFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- ScrollingFrame untuk content
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "Content"
scrollFrame.Size = UDim2.new(1, 0, 1, -50)
scrollFrame.Position = UDim2.new(0, 0, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = mainFrame

-- UIListLayout untuk auto-arrange buttons
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.PaddingTop = UDim.new(0, 10)
padding.Parent = scrollFrame

-- Fungsi untuk membuat tombol
local function createButton(parent, text, callback)
	local button = Instance.new("TextButton")
	button.Name = text
	button.Size = UDim2.new(1, -20, 0, 40)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Text = text
	button.TextSize = 16
	button.Font = Enum.Font.Gotham
	button.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = button
	
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	end)
	
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end)
	
	button.MouseButton1Click:Connect(callback)
	
	return button
end

-- Fungsi untuk membuat input dialog
local function createInputDialog(title, callback)
	local dialog = Instance.new("Frame")
	dialog.Name = "InputDialog"
	dialog.Size = UDim2.new(0, 300, 0, 200)
	dialog.Position = UDim2.new(0.5, -150, 0.5, -100)
	dialog.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	dialog.BorderSizePixel = 0
	dialog.Parent = screenGui
	
	local dialogCorner = Instance.new("UICorner")
	dialogCorner.CornerRadius = UDim.new(0, 10)
	dialogCorner.Parent = dialog
	
	-- Title
	local dialogTitle = Instance.new("TextLabel")
	dialogTitle.Size = UDim2.new(1, 0, 0, 40)
	dialogTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	dialogTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	dialogTitle.Text = title
	dialogTitle.TextSize = 16
	dialogTitle.Font = Enum.Font.GothamBold
	dialogTitle.Parent = dialog
	
	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 10)
	titleCorner.Parent = dialogTitle
	
	-- Text input
	local textBox = Instance.new("TextBox")
	textBox.Name = "Input"
	textBox.Size = UDim2.new(1, -20, 0, 40)
	textBox.Position = UDim2.new(0, 10, 0, 50)
	textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	textBox.PlaceholderText = "Masukkan teks..."
	textBox.TextSize = 14
	textBox.Font = Enum.Font.Gotham
	textBox.Parent = dialog
	
	local textBoxCorner = Instance.new("UICorner")
	textBoxCorner.CornerRadius = UDim.new(0, 8)
	textBoxCorner.Parent = textBox
	
	-- OK button
	local okButton = Instance.new("TextButton")
	okButton.Name = "OK"
	okButton.Size = UDim2.new(0, 130, 0, 35)
	okButton.Position = UDim2.new(0, 10, 1, -45)
	okButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
	okButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	okButton.Text = "OK"
	okButton.TextSize = 14
	okButton.Font = Enum.Font.GothamBold
	okButton.Parent = dialog
	
	local okCorner = Instance.new("UICorner")
	okCorner.CornerRadius = UDim.new(0, 8)
	okCorner.Parent = okButton
	
	-- Cancel button
	local cancelButton = Instance.new("TextButton")
	cancelButton.Name = "Cancel"
	cancelButton.Size = UDim2.new(0, 130, 0, 35)
	cancelButton.Position = UDim2.new(1, -140, 1, -45)
	cancelButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
	cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	cancelButton.Text = "Cancel"
	cancelButton.TextSize = 14
	cancelButton.Font = Enum.Font.GothamBold
	cancelButton.Parent = dialog
	
	local cancelCorner = Instance.new("UICorner")
	cancelCorner.CornerRadius = UDim.new(0, 8)
	cancelCorner.Parent = cancelButton
	
	okButton.MouseButton1Click:Connect(function()
		callback(textBox.Text)
		dialog:Destroy()
	end)
	
	cancelButton.MouseButton1Click:Connect(function()
		dialog:Destroy()
	end)
	
	textBox:CaptureFocus()
end

-- Tombol Change Tag
createButton(scrollFrame, "📝 Change Player Tag", function()
	createInputDialog("Masukkan Username dan Tag", function(input)
		local parts = input:split(" ")
		if #parts >= 2 then
			local username = parts[1]
			local newTag = table.concat(parts, " ", 2)
			
			local targetPlayer = Players:FindFirstChild(username)
			if targetPlayer then
				-- Kirim event untuk mengubah tag
				local event = Instance.new("RemoteEvent")
				event.Name = "ChangeTagEvent"
				event.Parent = game.ReplicatedStorage
				event:FireServer(targetPlayer, newTag)
				print("Tag player " .. username .. " diubah menjadi: " .. newTag)
			else
				warn("Player " .. username .. " tidak ditemukan!")
			end
		end
	end)
end)

-- Tombol Change Permission
createButton(scrollFrame, "🔐 Change Permission", function()
	createInputDialog("Username dan Level (1-5)", function(input)
		local parts = input:split(" ")
		if #parts >= 2 then
			local username = parts[1]
			local level = tonumber(parts[2])
			
			if level and level >= 1 and level <= 5 then
				local targetPlayer = Players:FindFirstChild(username)
				if targetPlayer then
					local event = Instance.new("RemoteEvent")
					event.Name = "ChangePermissionEvent"
					event.Parent = game.ReplicatedStorage
					event:FireServer(targetPlayer, level)
					print("Permission " .. username .. " diubah menjadi level: " .. level)
				else
					warn("Player " .. username .. " tidak ditemukan!")
				end
			else
				warn("Level harus antara 1-5!")
			end
		end
	end)
end)

-- Tombol Ban Player
createButton(scrollFrame, "🚫 Ban Player", function()
	createInputDialog("Masukkan Username untuk di-ban", function(username)
		if username ~= "" then
			local targetPlayer = Players:FindFirstChild(username)
			if targetPlayer then
				local event = Instance.new("RemoteEvent")
				event.Name = "BanPlayerEvent"
				event.Parent = game.ReplicatedStorage
				event:FireServer(targetPlayer)
				print("Player " .. username .. " di-ban!")
			else
				warn("Player " .. username .. " tidak ditemukan!")
			end
		end
	end)
end)

-- Tombol Kick Player
createButton(scrollFrame, "👢 Kick Player", function()
	createInputDialog("Masukkan Username untuk di-kick", function(username)
		if username ~= "" then
			local targetPlayer = Players:FindFirstChild(username)
			if targetPlayer then
				local event = Instance.new("RemoteEvent")
				event.Name = "KickPlayerEvent"
				event.Parent = game.ReplicatedStorage
				event:FireServer(targetPlayer)
				print("Player " .. username .. " di-kick!")
			else
				warn("Player " .. username .. " tidak ditemukan!")
			end
		end
	end)
end)

-- Tombol List Players Online
createButton(scrollFrame, "👥 List Players Online", function()
	local playerList = ""
	for _, player in ipairs(Players:GetPlayers()) do
		playerList = playerList .. player.Name .. "\n"
	end
	
	local listFrame = Instance.new("Frame")
	listFrame.Name = "PlayerList"
	listFrame.Size = UDim2.new(0, 300, 0, 400)
	listFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
	listFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	listFrame.BorderSizePixel = 0
	listFrame.Parent = screenGui
	
	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = UDim.new(0, 10)
	listCorner.Parent = listFrame
	
	local listLabel = Instance.new("TextLabel")
	listLabel.Size = UDim2.new(1, 0, 1, 0)
	listLabel.BackgroundTransparency = 1
	listLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	listLabel.Text = playerList
	listLabel.TextSize = 14
	listLabel.Font = Enum.Font.Gotham
	listLabel.TextYAlignment = Enum.TextYAlignment.Top
	listLabel.Parent = listFrame
	
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.PaddingTop = UDim.new(0, 10)
	padding.Parent = listLabel
	
	wait(3)
	listFrame:Destroy()
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
	screenGui.Enabled = false
end)

-- Keyboard shortcut untuk buka/tutup menu
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == ADMIN_KEY then
		local player = Players.LocalPlayer
		if isAdmin(player) then
			screenGui.Enabled = not screenGui.Enabled
		else
			warn("Anda bukan admin!")
		end
	end
end)

print("✅ Admin Menu loaded! Tekan M untuk membuka menu (admin only)")
