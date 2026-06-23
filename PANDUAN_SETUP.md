# 📚 PANDUAN LENGKAP - SETUP ADMIN GUI MENU DI ROBLOX STUDIO

## 📍 Lokasi Penempatan Script

### 1. **AdminGUI_MainScript.lua** (Script Utama)
**TEMPAT:** `StarterGui` → Klik Kanan → Insert Object → **LocalScript**

**Langkah-langkah:**
1. Buka Roblox Studio
2. Cari panel **Explorer** (sebelah kanan)
3. Expand `StarterGui` (folder di dalam)
4. Klik Kanan pada `StarterGui`
5. Pilih **Insert Object** → **LocalScript**
6. Rename script menjadi `AdminMenuScript`
7. Copy-paste seluruh kode dari `AdminGUI_MainScript.lua` ke dalamnya

```
StarterGui
├── AdminMenuScript (LocalScript) ← TARUH DI SINI
└── ScreenGui (sudah ada)
```

---

### 2. **AdminServer.lua** (Script Backend/Server)
**TEMPAT:** `ServerScriptService` → Klik Kanan → Insert Object → **Script**

**Langkah-langkah:**
1. Buka Roblox Studio
2. Cari panel **Explorer** (sebelah kanan)
3. Expand `ServerScriptService` (folder di dalam)
4. Klik Kanan pada `ServerScriptService`
5. Pilih **Insert Object** → **Script**
6. Rename script menjadi `AdminHandlerScript`
7. Copy-paste kode dari `AdminServer.lua`

```
ServerScriptService
├── AdminHandlerScript (Script) ← TARUH DI SINI
└── (script lain)
```

---

## 📋 Checklist Instalasi

- [ ] **AdminMenuScript** di `StarterGui` ✓
- [ ] **AdminHandlerScript** di `ServerScriptService` ✓
- [ ] **ReplicatedStorage** tersedia untuk RemoteEvents ✓
- [ ] **Admin IDs** sudah diubah sesuai user ID Anda
- [ ] Test play di Studio
- [ ] Tekan tombol **M** untuk membuka menu

---

## 🔧 Konfigurasi Admin

### Mengubah Admin User IDs

**File:** `AdminGUI_MainScript.lua` (baris 13-14)

```lua
-- SEBELUM (Default)
local ADMIN_IDS = {12345, 67890}

-- SESUDAH (Ganti dengan ID Anda)
local ADMIN_IDS = {1234567890, 9876543210}
```

**Cara mendapatkan User ID Anda:**
1. Buka: https://www.roblox.com/
2. Login dengan akun Anda
3. Masuk ke profile Anda
4. URL akan terlihat: `https://www.roblox.com/users/{YOUR_USER_ID}/profile`
5. Copy angka tersebut ke `ADMIN_IDS`

**Contoh:**
```lua
local ADMIN_IDS = {1234567890} -- User ID Anda
```

---

### Mengubah Tombol Keyboard

**File:** `AdminGUI_MainScript.lua` (baris 11)

```lua
-- Tekan M untuk membuka menu
local ADMIN_KEY = Enum.KeyCode.M

-- Ganti dengan tombol lain jika ingin:
-- local ADMIN_KEY = Enum.KeyCode.L    (Tekan L)
-- local ADMIN_KEY = Enum.KeyCode.P    (Tekan P)
-- local ADMIN_KEY = Enum.KeyCode.F10  (Tekan F10)
```

---

## 🎮 Cara Menggunakan Admin Menu

### Membuka Menu
- **Tekan M** di dalam game (saat playtesting)
- Menu akan muncul di tengah layar

### Fitur-Fitur:

#### 1️⃣ **Change Player Tag**
- Untuk memberikan tag/gelar kepada pemain
- Input: `username tagbaru`
- Contoh: `john VIP Premium`
- Output: Player "john" mendapat tag "VIP Premium"

#### 2️⃣ **Change Permission**
- Untuk mengubah level permission pemain (1-5)
- Input: `username level`
- Contoh: `john 3`
- Level: 1=User, 2=Moderator, 3=Admin, 4=Owner, 5=Developer

#### 3️⃣ **Ban Player**
- Untuk melarang pemain masuk kembali
- Input: `username`
- Data ban disimpan dalam DataStore

#### 4️⃣ **Kick Player**
- Untuk mengeluarkan pemain dari game
- Input: `username`
- Pemain bisa masuk lagi (bukan permanent)

#### 5️⃣ **List Players Online**
- Menampilkan semua pemain yang sedang online
- Hanya untuk referensi

---

## 🔴 Troubleshooting

### ❌ Menu tidak muncul saat tekan M
**Solusi:**
1. Pastikan Anda adalah admin (User ID ada di `ADMIN_IDS`)
2. Script berada di `StarterGui` sebagai `LocalScript`
3. Cek Output Console untuk error

### ❌ "Player tidak ditemukan"
**Solusi:**
1. Pastikan username tepat (case-sensitive)
2. Pastikan player sudah masuk ke server
3. Cek daftar dengan fitur "List Players Online"

### ❌ Perintah tidak bekerja
**Solusi:**
1. Pastikan `AdminHandlerScript` ada di `ServerScriptService`
2. Periksa Server Output Console untuk error
3. Gunakan format: `username perintah` (dengan spasi)

---

## 📝 Struktur File Akhir

```
Game
├── StarterGui
│   ├── AdminMenuScript (LocalScript) ← AdminGUI_MainScript.lua
│   └── ScreenGui (sudah ada)
│
├── ServerScriptService
│   └── AdminHandlerScript (Script) ← AdminServer.lua
│
├── ReplicatedStorage
│   └── (RemoteEvents dibuat otomatis)
│
└── ServerStorage
    └── (Opsional: DataStore untuk ban data)
```

---

## 🚀 Testing

1. **Klik Play** button untuk test
2. **Tekan M** untuk membuka menu
3. **Test fitur:**
   - Buka menu admin
   - Coba ubah tag player
   - Coba ubah permission
   - Coba kick/ban player
4. **Cek Console:**
   - Output untuk info sukses
   - Server Output untuk error

---

## ⚙️ Custom Setup (Opsional)

### Menambah Fitur Baru ke Menu

Tambahkan ini sebelum `print()` di akhir `AdminGUI_MainScript.lua`:

```lua
-- Contoh: Tombol Give Money
createButton(scrollFrame, "💰 Give Money", function()
	createInputDialog("Username dan Jumlah", function(input)
		local parts = input:split(" ")
		if #parts >= 2 then
			local username = parts[1]
			local amount = tonumber(parts[2])
			
			local targetPlayer = Players:FindFirstChild(username)
			if targetPlayer then
				local event = Instance.new("RemoteEvent")
				event.Name = "GiveMoneyEvent"
				event.Parent = game.ReplicatedStorage
				event:FireServer(targetPlayer, amount)
			end
		end
	end)
end)
```

---

## 📞 Tips & Tricks

✅ **Backup script sebelum edit**
✅ **Test di Studio dulu sebelum publish**
✅ **Gunakan multiple admin IDs untuk tim**
✅ **Simpan log admin actions di DataStore**
✅ **Jangan share Admin IDs secara public**

---

**Selesai! Admin Menu GUI Anda siap digunakan! 🎉**
