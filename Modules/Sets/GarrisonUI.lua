local B, C, L, DB = unpack(select(2, ...))

local Event = CreateFrame("Frame")
Event:RegisterEvent("ADDON_LOADED")
Event:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_GarrisonUI" then
		self:UnregisterEvent("ADDON_LOADED")

		--[[ rGarrisonFollowerItems, zork
		local function AfterGarrisonFollowerPage_ShowFollower(self,followerID)
			local followerInfo = C_Garrison.GetFollowerInfo(followerID)
			if not followerInfo then return end
			if not followerInfo.isCollected then return end
			local weaponItemID, weaponItemLevel, armorItemID, armorItemLevel = C_Garrison.GetFollowerItems(followerInfo.followerID)
			GarrisonFollowerPage_SetItem(self.ItemWeapon, weaponItemID, weaponItemLevel)
			GarrisonFollowerPage_SetItem(self.ItemArmor, armorItemID, armorItemLevel)
			if self.isLandingPage and not self.pointAdjusted then
				self.ItemWeapon:SetScale(0.9)
				self.ItemArmor:SetScale(0.9)
				self.ItemArmor:ClearAllPoints()
				self.ItemArmor:SetPoint("LEFT",self.ItemWeapon,"RIGHT",10,0)
				if IsAddOnLoaded("Aurora") then
					local F = unpack(Aurora)
					for _, item in pairs({self.ItemWeapon, self.ItemArmor}) do
						local icon = item.Icon
						item.Border:Hide()
						icon:SetTexCoord(unpack(DB.TexCoord))
						F.CreateBG(icon)
						local bg = F.CreateBDFrame(item, .25)
						bg:SetPoint("TOPLEFT", 41, -1)
						bg:SetPoint("BOTTOMRIGHT", 0, 1)
					end
				end
				self.pointAdjusted = true
			end
		end
		hooksecurefunc("GarrisonFollowerPage_ShowFollower", AfterGarrisonFollowerPage_ShowFollower)]]

		-- FollowerClick, Tekkub
		local MissionPage = GarrisonMissionFrame.MissionTab.MissionPage
		local function RemoveFollower(followerID)
			for i, frame in pairs(MissionPage.Followers) do
				if frame.info and frame.info.followerID == followerID then
					return GarrisonMissionPage_ClearFollower(frame, true)
				end
			end
		end
		local orig = GarrisonFollowerListButton_OnClick
		function GarrisonFollowerListButton_OnClick(self, button)
			if MissionPage:IsVisible() and MissionPage.missionInfo and button == "RightButton" then
				if not self.info.status then
					return GarrisonMissionPage_AddFollower(self.id)
				elseif self.info.status == GARRISON_FOLLOWER_IN_PARTY then
					return RemoveFollower(self.id)
				end
			end
			return orig(self, button)
		end
	end
end)