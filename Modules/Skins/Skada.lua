local B, C, L, DB = unpack(select(2, ...))

local Skadaskin = CreateFrame("Frame")
Skadaskin:RegisterEvent("PLAYER_LOGIN")
Skadaskin:SetScript("OnEvent", function()
	if not NDuiDB["Skins"]["Skada"] then return end
	if IsAddOnLoaded("Skada") then
		local Skada = Skada
		local barSpacing = 0
		local barmod = Skada.displays["bar"]
		local function StripOptions(options)
			options.baroptions.args.barspacing = nil
			options.titleoptions.args.texture = nil
			options.titleoptions.args.bordertexture = nil
			options.titleoptions.args.thickness = nil
			options.titleoptions.args.margin = nil
			options.titleoptions.args.color = nil
			options.windowoptions = nil
			options.baroptions.args.barfont = nil
			options.titleoptions.args.font = nil
		end

		barmod.AddDisplayOptions_ = barmod.AddDisplayOptions
		barmod.AddDisplayOptions = function(self, win, options)
			self:AddDisplayOptions_(win, options)
			StripOptions(options)
		end

		for k, options in pairs(Skada.options.args.windows.args) do
			if options.type == "group" then
				StripOptions(options.args)
			end
		end

		barmod.ApplySettings_ = barmod.ApplySettings
		barmod.ApplySettings = function(self, win)
			barmod.ApplySettings_(self, win)
			local skada = win.bargroup
			if win.db.enabletitle then
				skada.button:SetBackdrop(nil)
			end
			skada:SetTexture(DB.normTex)
			skada:SetSpacing(barSpacing)
			skada:SetFrameLevel(5)
			skada:SetBackdrop(nil)

			local color = win.db.title.color
			win.bargroup.button:SetBackdropColor(1,1,1,0)

			if not skada.shadow then
				skada.shadow = CreateFrame("Frame", nil, skada)
				skada.shadow:SetAllPoints()
				skada.shadow:SetFrameLevel(1)
				B.CreateBD(skada.shadow, 0.5, 3)
				B.CreateTex(skada.shadow)

				local Cskada = CreateFrame("Button", nil, skada)
				Cskada:SetPoint("RIGHT", skada, "LEFT", 0, 0)
				Cskada:SetSize(20, 100)
				B.CreateBD(Cskada, 0.5, 3)
				B.CreateFS(Cskada, 18, ">")
				B.CreateBC(Cskada, 0.5)
				B.CreateTex(Cskada)
				local Oskada = CreateFrame("Button", nil, UIParent)
				Oskada:Hide()
				Oskada:SetPoint("RIGHT", skada, "RIGHT", 5, 0)
				Oskada:SetSize(20, 100)
				B.CreateBD(Oskada, 0.5, 3)
				B.CreateFS(Oskada, 18, "<")
				B.CreateBC(Oskada, 0.5)
				B.CreateTex(Oskada)
				Cskada:SetScript("OnClick", function()
					Oskada:Show()
					skada:Hide()
				end)
				Oskada:SetScript("OnClick", function()
					Oskada:Hide()
					skada:Show()
				end)
			end
			skada.shadow:ClearAllPoints()
			if win.db.enabletitle then
				skada.shadow:SetPoint("TOPLEFT", win.bargroup.button, "TOPLEFT", -3, 3)
			else
				skada.shadow:SetPoint("TOPLEFT", win.bargroup, "TOPLEFT", -3, 3)
			end
			skada.shadow:SetPoint("BOTTOMRIGHT", win.bargroup, "BOTTOMRIGHT", 3, -3)
			win.bargroup.button:SetFrameStrata("MEDIUM")
			win.bargroup.button:SetFrameLevel(5)	
			win.bargroup:SetFrameStrata("MEDIUM")
		end

		local function EmbedWindow(window, width, barheight, height, point, relativeFrame, relativePoint, ofsx, ofsy)
			window.db.barwidth = width
			window.db.barheight = barheight
			if window.db.enabletitle then 
				height = height - barheight
			end
			window.db.background.height = height
			window.db.spark = false
			window.db.barslocked = true
			window.bargroup:ClearAllPoints()
			window.bargroup:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
			barmod.ApplySettings(barmod, window)
		end

		local windows = {}
		function EmbedSkada()
			if #windows == 1 then
				EmbedWindow(windows[1], 300, 18, 198, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 24)
			elseif #windows == 2 then
				EmbedWindow(windows[1], 180, 18, 198,  "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 24)
				EmbedWindow(windows[2], 180, 18, 198,  "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -210, 24)
			end
		end

		for _, window in ipairs(Skada:GetWindows()) do
			window:UpdateDisplay()
		end

		Skada.CreateWindow_ = Skada.CreateWindow
		function Skada:CreateWindow(name, db)
			Skada:CreateWindow_(name, db)
			windows = {}
			for _, window in ipairs(Skada:GetWindows()) do
				tinsert(windows, window)
			end
			EmbedSkada()
		end

		Skada.DeleteWindow_ = Skada.DeleteWindow
		function Skada:DeleteWindow(name)
			Skada:DeleteWindow_(name)
			windows = {}
			for _, window in ipairs(Skada:GetWindows()) do
				tinsert(windows, window)
			end
			EmbedSkada()
		end

		local Skada_Skin = CreateFrame("Frame")
		Skada_Skin:RegisterEvent("PLAYER_ENTERING_WORLD")
		Skada_Skin:SetScript("OnEvent", function(self)
			self:UnregisterAllEvents()
			self = nil
			EmbedSkada()
			SkadaDB["profiles"]["Default"]["icon"]["hide"] = true
		end)
	end
end)