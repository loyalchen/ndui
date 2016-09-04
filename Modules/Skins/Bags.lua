local B, C, L, DB = unpack(select(2, ...))
if not C.Skins.EnableBag then return end
local cargBags = select(2, ...).cargBags
-- main
local Bags = cargBags:NewImplementation("Bags")
Bags:RegisterBlizzard() 

local function highlightFunction(button, match)
	button:SetAlpha(match and 1 or 0.3)
end

local f = {}
function Bags:OnInit()
	local onlyBags = function(item) return item.bagID >= 0 and item.bagID <= 4 end
	local onlyBank = function(item) return item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11 end
	local onlyReagent = function(item) return item.bagID == -3 end
	local MyContainer = Bags:GetContainerClass()

	f.main = MyContainer:New("Main", {
			Columns = 12,
			Scale = C.Skins.BagScale,
			Bags = "bags",
			Movable = true,
	})
	f.main:SetFilter(onlyBags, true)
	f.main:SetPoint("RIGHT", -60, -100)

	f.bank = MyContainer:New("Bank", {
			Columns = 14,
			Scale = C.Skins.BagScale,
			Bags = "bank",
			Movable = true,
	})
	f.bank:SetFilter(onlyBank, true) 
	f.bank:SetPoint("BOTTOMRIGHT", f.main, "BOTTOMLEFT", -50, 0)
	f.bank:Hide()

	f.reagent = MyContainer:New("Reagent", {
			Columns = 14,
			Scale = C.Skins.BagScale,
			Bags = "bankreagent",
			Movable = true,
	})
	f.reagent:SetFilter(onlyReagent, true) 
	f.reagent:SetPoint("TOPLEFT", f.bank)
	f.reagent:Hide()
end

function Bags:OnBankOpened()
	BankFrame:Show()
	BankFrame.selectedTab = 1
	self:GetContainer("Bank"):Show()
end

function Bags:OnBankClosed()
	BankFrame:Hide()
	self:GetContainer("Bank"):Hide()
	self:GetContainer("Reagent"):Hide()
end

local MyButton = Bags:GetItemButtonClass()
MyButton:Scaffold("Default")

function MyButton:OnCreate()
	self:SetNormalTexture(nil)
	self:SetHighlightTexture(nil)
	self:SetSize(C.Skins.IconSize, C.Skins.IconSize)
	self:SetFrameLevel(3)

	self.Icon:SetAllPoints()
	self.Icon:SetTexCoord(unpack(DB.TexCoord))
	self.Count:SetPoint("BOTTOMRIGHT", 0, 2)
	self.Count:SetFont(unpack(DB.Font))
	self.HL = self:CreateTexture(nil, "HIGHLIGHT")
	self.HL:SetTexture(1, 1, 1, .35)
	self.HL:SetAllPoints(self.Icon)

	self.Border = CreateFrame("Frame", nil, self)
	self.Border:SetPoint("TOPLEFT", -1.2, 1.2)
	self.Border:SetPoint("BOTTOMRIGHT", 1.2, -1.2)
	self.Border:SetBackdrop({ bgFile = DB.bdTex	})
	self.Border:SetBackdropColor(0, 0, 0, 0)
	self.Border:SetFrameLevel(2)

	self.BG = CreateFrame("Frame", nil, self)
	self.BG:SetPoint("TOPLEFT", -1.2, 1.2)
	self.BG:SetPoint("BOTTOMRIGHT", 1.2, -1.2)
	self.BG:SetBackdrop({
		bgFile = DB.bdTex, edgeFile = DB.bdTex, edgeSize = 1.2,
	})
	self.BG:SetBackdropColor(0.2, 0.2, 0.2, 0.5)
	self.BG:SetBackdropBorderColor(0, 0, 0, 1)
	self.BG:SetFrameLevel(0)

	self.Junk = self:CreateTexture(nil, "ARTWORK")
	self.Junk:SetAtlas("bags-junkcoin")
	self.Junk:SetSize(20, 20)
	self.Junk:SetPoint("TOPRIGHT", 1, 0)

	self.New = self:CreateTexture(nil, "ARTWORK")
	self.New:SetAtlas("collections-icon-favorites")
	self.New:SetSize(35, 35)
	self.New:SetPoint("TOPLEFT", -10, 8)
end

function MyButton:OnUpdate(item)
	self.Junk:SetAlpha(0)
	if item.questID or item.isQuestItem then
		self.Border:SetBackdropColor(1, 1, 0, 1)
	elseif item.rarity then
		local color = BAG_ITEM_QUALITY_COLORS[item.rarity]
		if item.rarity > 1 and color then
			self.Border:SetBackdropColor(color.r, color.g, color.b, 1)
		else
			self.Border:SetBackdropColor(0, 0, 0, 0)
		end
		if item.rarity == LE_ITEM_QUALITY_POOR and item.sellPrice > 0 and MerchantFrame:IsShown() then
			self.Junk:SetAlpha(1)
		end
	else
		self.Border:SetBackdropColor(0, 0, 0, 0)
	end

	if C_NewItems.IsNewItem(item.bagID, item.slotID) then
		self.New:SetAlpha(1)
	else
		self.New:SetAlpha(0)
	end
end

local BagButton = Bags:GetClass("BagButton", true, "BagButton")
function BagButton:OnCreate()
	self:SetNormalTexture(nil)
	self:SetHighlightTexture(nil)
	self:SetCheckedTexture(DB.textures.pushed)
	self:GetCheckedTexture():SetVertexColor(0.3, 0.9, 0.9, 0.5)
	self.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
	self.Icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 2)
	self.Icon:SetTexCoord(unpack(DB.TexCoord))
	self.HL = self:CreateTexture(nil, "HIGHLIGHT")
	self.HL:SetTexture(1,1,1,0.35)
	self.HL:SetAllPoints(self.Icon)
end

local UpdateDimensions = function(self)
	local width, height = self:LayoutButtons("grid", self.Settings.Columns, 6, 10, -10)
	local margin = 40
	if self.BagBar and self.BagBar:IsShown() then
		margin = margin + 45
	end
	self:SetHeight(height + margin)
end

local MyContainer = Bags:GetContainerClass()
function MyContainer:OnContentsChanged()
	self:SortButtons("bagSlot")
	local width, height = self:LayoutButtons("grid", self.Settings.Columns, 6, 10, -10)
	self:SetSize(width + 20, height + 10)
	if self.UpdateDimensions then self:UpdateDimensions() end
end

function MyContainer:OnCreate(name, settings)
    self.Settings = settings
	self.UpdateDimensions = UpdateDimensions
	B.CreateBD(self, 0.6)
	B.CreateTex(self)

	self:SetParent(settings.Parent or Bags)
	self:SetFrameStrata("HIGH")
	self:SetClampedToScreen(true)
	settings.Columns = settings.Columns
	self:SetScale(settings.Scale)

	if settings.Movable then
		self:SetMovable(true)
		self:RegisterForClicks("LeftButton")
	    self:SetScript("OnMouseDown", function()
			self:ClearAllPoints() 
			self:StartMoving()
	    end)
		self:SetScript("OnMouseUp", self.StopMovingOrSizing)
	end

	local infoFrame = CreateFrame("Button", nil, self)
	infoFrame:SetPoint("BOTTOMRIGHT", -50, 0)
	infoFrame:SetWidth(220)
	infoFrame:SetHeight(32)

	local search = self:SpawnPlugin("SearchBar", infoFrame)
	search.highlightFunction = highlightFunction
	search.isGlobal = true
	search:SetPoint("LEFT", infoFrame, "LEFT", 0, 5)
	search.Left:SetTexture(nil)
	search.Right:SetTexture(nil)
	search.Center:SetTexture(nil)
	local sbg = CreateFrame("Frame", nil, search)
	sbg:SetPoint("CENTER", search, "CENTER")
	sbg:SetSize(230, 20)
	sbg:SetFrameLevel(0)
	B.CreateBD(sbg)

	local tagDisplay = self:SpawnPlugin("TagDisplay", "[money]", infoFrame)
	tagDisplay:SetFont(unpack(DB.Font))
	tagDisplay:SetPoint("RIGHT", infoFrame, "RIGHT",0,0)
	B.CreateFS(infoFrame, 12, SEARCH, "LEFT", 0, 1)

	local SortButton = CreateFrame("Button", nil, self)
	SortButton:SetPoint("BOTTOMLEFT", 5, 7)
	SortButton:SetSize(60, 20)
	SortButton:SetScript("OnClick", function()
		if name == "Bank" then
			SortBankBags()
		elseif name == "Reagent" then
			SortReagentBankBags()
		else
			SortBags()
		end
	end)
	B.CreateBD(SortButton, 0.3)
	B.CreateBC(SortButton)
	B.CreateFS(SortButton, 12, SORT)

	local closebutton = CreateFrame("Button", nil, self)
	closebutton:SetPoint("BOTTOMRIGHT", -5, 7)
	closebutton:SetSize(20, 20)
	closebutton:SetScript("OnClick", function()
		CloseAllBags()
	end)
	B.CreateBD(closebutton, 0.3)
	B.CreateBC(closebutton)
	B.CreateFS(closebutton, 14, "X")

	if name == "Main" or name == "Bank" then
		local bagBar = self:SpawnPlugin("BagBar", settings.Bags)
		bagBar:SetSize(bagBar:LayoutButtons("grid", 7))
		bagBar:SetScale(0.8)
		bagBar.highlightFunction = highlightFunction
		bagBar.isGlobal = true
		bagBar:Hide()
		self.BagBar = bagBar
		bagBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 10, 46)
		self:UpdateDimensions()

		local bagToggle = CreateFrame("Button", nil, self)
		bagToggle:SetPoint("LEFT", SortButton, "RIGHT", 6, 0)
		bagToggle:SetSize(60, 20)
		bagToggle:SetScript("OnClick", function()
			if(self.BagBar:IsShown()) then
				self.BagBar:Hide()
			else
				self.BagBar:Show()
			end
			self:UpdateDimensions()
		end)
		B.CreateBD(bagToggle, 0.3)
		B.CreateBC(bagToggle)
		B.CreateFS(bagToggle, 12, BAGSLOT)

		if name == "Bank" then
			local switch = CreateFrame("Button", nil, self)
			switch:SetPoint("LEFT", bagToggle, "RIGHT", 6, 0)
			switch:SetSize(70, 20)
			switch:RegisterForClicks("AnyUp")
			switch:SetScript("OnClick", function(self, button)
				if not IsReagentBankUnlocked() then
					StaticPopup_Show("CONFIRM_BUY_REAGENTBANK_TAB")
				else
					ReagentBankFrame:Show()
					BankFrame.selectedTab = 2
					f.bank:Hide()
					f.reagent:Show()
					if button == "RightButton" then
						DepositReagentBank()
					end
				end
			end)
			B.CreateBD(switch, 0.3)
			B.CreateBC(switch)
			B.CreateFS(switch, 12, REAGENT_BANK)
		end
	elseif name == "Reagent" then
		local deposit = CreateFrame("Button", nil, self)
		deposit:SetPoint("LEFT", SortButton, "RIGHT", 6, 0)
		deposit:SetSize(100, 20)
		deposit:SetScript("OnClick", function()
			DepositReagentBank()
		end)
		B.CreateBD(deposit, 0.3)
		B.CreateBC(deposit)
		B.CreateFS(deposit, 12, REAGENTBANK_DEPOSIT)

		local switch = CreateFrame("Button", nil, self)
		switch:SetPoint("LEFT", deposit, "RIGHT", 6, 0)
		switch:SetSize(70, 20)
		switch:SetScript("OnClick", function()
			ReagentBankFrame:Hide()
			BankFrame.selectedTab = 1
			f.reagent:Hide()
			f.bank:Show()
		end)
		B.CreateBD(switch, 0.3)
		B.CreateBC(switch)
		B.CreateFS(switch, 12, BANK)
	end
end