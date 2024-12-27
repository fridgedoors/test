local Remote = game.ReplicatedStorage.Remotes.Levels:WaitForChild('LevelStart')
local rs = game:GetService("ReplicatedStorage")
local Loaded = 0
local function Freeze(character)
	character.Humanoid.WalkSpeed = 0
	character.Humanoid.JumpHeight = 0
end

local function Unfreeze(character)
	character.Humanoid.WalkSpeed = 16
	character.Humanoid.JumpHeight = 7.2
end

local function BackToTheLobby(CurrentLevel, Player)
		Player:MoveTo(CurrentLevel.Spawns.PlayerSpawn.Position)

		for i,noob in pairs(CurrentLevel.NPCS:FindFirstChild(Player.Name .. "_NPCS" ):GetChildren()) do
			noob:MoveTo(CurrentLevel.Spawns.NPCSpawn.Position)
		end
	
	
end




local function LoadNPCSRewrite(CurrentLevel, player, NoobsToLoad)

	local NPCS = game.ReplicatedStorage.NPCS
	local PlayerFolder = Instance.new("Folder", CurrentLevel.NPCS)

	PlayerFolder.Name = player.Name .. "_NPCS"
	print(PlayerFolder.Name .. " has been created.")
	local Skin = player.OwnedSkins.Equipped.Value
	local	function Randomized(noob)
		local AF = rs.Accessories.AccessoriesFaces:GetChildren()
		local AH = rs.Accessories.AccessoriesHats:GetChildren()
		local AP = rs.Accessories.AccessoriesPants:GetChildren()
		local AS = rs.Accessories.AccessoriesShirts:GetChildren()


		local randomcolor = BrickColor.random()
		noob["Body Colors"].HeadColor = randomcolor
		noob["Body Colors"].LeftArmColor = randomcolor
		noob["Body Colors"].LeftLegColor = randomcolor
		noob["Body Colors"].RightArmColor = randomcolor
		noob["Body Colors"].RightLegColor = randomcolor
		noob["Body Colors"].TorsoColor = randomcolor


		local randomface = AF[math.random(1, #AF)]:Clone()
		noob.Head.face.Texture = randomface.Texture

		local randompants = AP[math.random(1, #AP)]:Clone()
		noob.Pants.PantsTemplate = randompants.PantsTemplate

		local randomshirt = AS[math.random(1, #AS)] :Clone()
		noob.Shirt.ShirtTemplate = randomshirt.ShirtTemplate

		local randomhat = AH[math.random(1, #AH)]:Clone()
		randomhat.Parent = noob







		local RunService = game:GetService("RunService")
		local Players = game:GetService("Players")


		local rootPart = noob.HumanoidRootPart
		local humanoid = noob.Humanoid


		local animate = rs.Animate:Clone()
		animate.Parent = noob

		local follow = rs.Follow:Clone()
		follow.PlayerID.Value = player.UserId
		follow.Parent = noob
		noob.Parent = PlayerFolder
		noob:MoveTo(CurrentLevel.Spawns.NPCSpawn.Position)
	end


	for i = 1, NoobsToLoad  do
		if Skin == "Default" then
			local noob = NPCS.Default:Clone()	

			Randomized(noob)
		end

		if Skin == "Classic" then
			local classicfolder = game.ReplicatedStorage.NPCS.Classic

			local children = classicfolder:GetChildren()
			local randomIndex = math.random(1, #children)
			local noob = children[randomIndex]:Clone()

			local animate = rs.Animate:Clone()
			animate.Parent = noob

			local follow = rs.Follow:Clone()
			follow.PlayerID.Value = player.UserId
			follow.Parent = noob
			noob.Parent = PlayerFolder
			noob:MoveTo(CurrentLevel.Spawns.NPCSpawn.Position)
			-- Replace with your NPC's name


		end

		if Skin == "Yourself" then
			local noob = rs.NPCS.Yourself:Clone()
			noob.Parent = rs.NPCS
			noob.Humanoid:ApplyDescription(player.Character.Humanoid.HumanoidDescription)
			local animate = rs.Animate:Clone()
			animate.Parent = noob

			local follow = rs.Follow:Clone()
			follow.PlayerID.Value = player.UserId
			follow.Parent = noob
			noob.Parent = PlayerFolder
			noob:MoveTo(CurrentLevel.Spawns.NPCSpawn.Position)
		end

		if Skin == "Friends" then
			local players = game:GetService("Players")

			local friendsId = player.UserId
			local PlayersFriends = {}

			local success, page = pcall(function() return players:GetFriendsAsync(friendsId) end)
			if success then
				repeat

					local info = page:GetCurrentPage()
					for i, friendInfo in pairs(info) do
						table.insert(PlayersFriends, friendInfo)
					end
					if not page.IsFinished then 
						page:AdvanceToNextPageAsync()
					end
				until page.IsFinished
			end

			if #PlayersFriends == 0 then
				local noob = rs.NPCS.Default:Clone()

				Randomized(noob)
			else


				local randomIndex = math.random(1, #PlayersFriends)

				local NoobInfo = PlayersFriends[randomIndex]
				print(NoobInfo)
				local noob = rs.NPCS.Friends:Clone()
				noob.Parent = rs.NPCS
				local friendDescription = game.Players:GetHumanoidDescriptionFromUserId(NoobInfo.Id)
				noob.Humanoid:ApplyDescription(friendDescription)
				local animate = rs.Animate:Clone()
				animate.Parent = noob

				local follow = rs.Follow:Clone()
				follow.PlayerID.Value = player.UserId
				follow.Parent = noob
				noob.Parent = PlayerFolder
				noob:MoveTo(CurrentLevel.Spawns.NPCSpawn.Position)
			end
		end

		if Skin == "Toilet" then
			local noob = rs.NPCS.Toilet:Clone()
			noob.Parent = rs.NPCS
			local animate = rs.Animate:Clone()
			animate.Parent = noob

			local follow = rs.Follow:Clone()
			follow.PlayerID.Value = player.UserId
			follow.Parent = noob
			noob.Parent = PlayerFolder
			noob:MoveTo(CurrentLevel.Spawns.NPCSpawn.Position)
		end

		if Skin == "Rthro" then
			local noob = rs.NPCS.Rthro:Clone()
			noob.Parent = rs.NPCS
			local animate = rs.Animate:Clone()
			animate.Parent = noob

			local follow = rs.Follow:Clone()
			follow.PlayerID.Value = player.UserId
			follow.Parent = noob
			noob.Parent = PlayerFolder
			noob:MoveTo(CurrentLevel.Spawns.NPCSpawn.Position)
		end
	end
end
local function LoadObstacles(CurrentLevel)
	local ObstaclesFolder = CurrentLevel.Obstacles

	for i,obstacle in pairs(ObstaclesFolder:GetChildren()) do

		if obstacle.Name == "KillBricks" then

			for i,brick in pairs(obstacle:GetChildren()) do
				if brick:IsA("Part") then
					brick.Touched:Connect(function(hit)
						if game.Players:FindFirstChild(hit.Parent.Name) then
							local player = game.Players:FindFirstChild(hit.Parent.Name)
							player.Character:MoveTo(CurrentLevel.Spawns.PlayerSpawn.Position)

							BackToTheLobby(CurrentLevel, player.Character)
						end
					end)
				end
			end
		end

		if obstacle.Name == "OpenDoors" then
			for _, barrier in pairs(obstacle:GetChildren()) do
				if barrier:IsA("Part") then
					local PhysicsService = game:GetService("PhysicsService")



					barrier.CollisionGroup = "NPCs"
					barrier.ClickPart.CollisionGroup = "NPCs"
					PhysicsService:CollisionGroupSetCollidable("NPCs", "Players", false)

					local button = barrier.ClickPart -- Assuming ClickPart is a part within each barrier

					button.ClickDetector.MouseClick:Connect(function()
						barrier.Transparency = 0.5 -- Make barrier semi-transparent to indicate NPCs can pass
						barrier.CollisionGroup = "Default"
						barrier.CanCollide = false
						wait(5) -- Keep the barrier open for 5 seconds (adjust as needed)

						barrier.Transparency = 0 -- Restore barrier visibility
						barrier.CollisionGroup = "NPCs"
						barrier.CanCollide = true
					end)


				end
			end
		end

		if obstacle.Name == "Ladder" then
			for i,partType in pairs(obstacle:GetChildren()) do
				if partType:IsA("Part") then
					if partType.Name == "SpinningPart" then



						local function MovePart()

							local speed = partType.SpeedNumber.Value  -- Rotation speed

							while wait() do
								partType.CFrame = partType.CFrame * CFrame.Angles(0, math.rad(speed), 0)
								wait(0.01) -- Adjust the wait time to control rotation speed
							end

						end

						partType.Touched:Connect(function(hit)
							if hit.Parent:FindFirstChild("Humanoid") then
								BackToTheLobby(CurrentLevel, hit.Parent)
							end
						end)



						-- Create a coroutine for the movement function
						local moveCoroutine = coroutine.create(MovePart)

						-- Start the coroutine
						coroutine.resume(moveCoroutine)



					end

					if partType.Name == "AlternatingPart" then
						local AlternatingSpeed = partType.AlternatingSpeed.Value

						local function Alternating()
							while wait() do
								partType.CanCollide = false
								partType.Transparency = 1

								wait(AlternatingSpeed)
								partType.CanCollide = true
								partType.Transparency = 0
								wait(AlternatingSpeed)
							end
						end

						partType.Touched:Connect(function(hit)
							if hit.Parent:FindFirstChild("Humanoid") then
								if partType.CanCollide == true then
									BackToTheLobby(CurrentLevel, hit.Parent)

								end
							end
						end)


						-- Create a coroutine for the movement function
						local moveCoroutine = coroutine.create(Alternating)

						-- Start the coroutine
						coroutine.resume(moveCoroutine)
					end

				end
			end
		end

		if obstacle.Name == "BlockingOff" then
			local db = false
			local counter = 0
			for i, theblockoff in pairs(obstacle:GetChildren()) do


				local pad = theblockoff.Pad
				pad.Top.Touched:Connect(function(hit)
					if hit.Parent.Parent.Parent.Name == 'NPCS' and not hit.Parent:FindFirstChild("PadAlreadyTouched") then

						counter += 1
						local bool = Instance.new("BoolValue", hit.Parent)
						bool.Name ="PadAlreadyTouched"






						local playernpcfolder = CurrentLevel.NPCS:FindFirstChild(hit.Parent.Parent.Name)


						if counter == #playernpcfolder:GetChildren() then
							theblockoff.BlockOff.Transparency = 1
							theblockoff.BlockOff.CollisionGroup = "NPCs"
							wait(5)
							theblockoff.BlockOff.CollisionGroup = "Default"


							theblockoff.BlockOff.Transparency = 0.5
							counter = 0
							for i, padalreadytouched in pairs(CurrentLevel.NPCS:GetDescendants()) do
								if padalreadytouched:IsA("BoolValue") and padalreadytouched.Name == "PadAlreadyTouched" then
									padalreadytouched:Destroy()
								end
							end
						end
					end
				end)
			end
		end


		if obstacle.Name == "HiddenKeys" then
			for i, hiddenkey in pairs(obstacle:GetChildren()) do
				local keytake = hiddenkey:FindFirstChild("KeyTake")
				local lockedwall = hiddenkey:FindFirstChild("LockedPart")
				keytake.Take.Triggered:Connect(function(player)
					if player then
						if player.Backpack:FindFirstChild("Key") or player.Character:FindFirstChild("Key") then
							print(player.Name .. " already has a key.")
							return
						end
						local key = game.ReplicatedStorage.Items.Key:Clone()
						key.Parent = player.Backpack

					end

				end)
				local dbforwall = false
				lockedwall.Touched:Connect(function(hit)
					if hit.Parent:FindFirstChild("Humanoid") and game.Players:GetPlayerFromCharacter(hit.Parent) then
						if dbforwall == false then
							dbforwall = true
							local key = game.Players:GetPlayerFromCharacter(hit.Parent).Backpack:FindFirstChild("Key") or hit.Parent:FindFirstChild("Key")
							if  key then
								lockedwall.CanCollide = false
								lockedwall.Transparency = 1
								key:Destroy()
								wait(3)
								lockedwall.CanCollide = true
								lockedwall.Transparency = 0
								dbforwall = false
							else
								dbforwall = false

							end
						end
					end

				end)

			end
		end

		if obstacle.Name == "SlipperyBananas" then
			for i, slipperybananafolder in pairs(obstacle:GetChildren()) do
				for i,v in pairs(slipperybananafolder:GetDescendants()) do
					if v.Name == "Banana" then
						v["Banana Peel"].Touched:Connect(function(hit)
							if hit.Parent:FindFirstChild("Humanoid") then
								hit.Parent.Humanoid.Sit = true

								wait(1)
								hit.Parent.Humanoid.Sit = false
							end
						end)
					end

					if v.Name == "RottenBanana" then
						v.Take.Triggered:Connect(function(plr)
							if plr.Backpack:FindFirstChild("RottenBanana") or plr.Character:FindFirstChild("RottenBanana") then
								print('no.')
								return
							end
							local banana = game.ReplicatedStorage.Items.RottenBanana:Clone()
							banana.Parent = plr.Backpack
							print('hi')
						end)
					end
					if v.Name == "PartBlocking" then

						local originalPosition = v.Position
						local originalOrientation = v.Orientation
						local reanchorTime = 3 -- Time in seconds to reanchor the part

						local function applyBackwardForce()
							local force = Instance.new("BodyVelocity")
							force.Velocity = Vector3.new(0, -25, -50) -- Adjust the force direction and magnitude as needed
							force.Parent = v
							game.Debris:AddItem(force, 1) -- Remove the force after 1 second
						end

						local function onTouch(otherPart)
							if otherPart.Parent.Name == "RottenBanana" then
								v.Anchored = false -- Deanchor the part
								applyBackwardForce() -- Apply the force to collapse backwards
								wait(reanchorTime)
								v.Anchored = true -- Reanchor the part
								v.Position = originalPosition -- Return the part to its original position
								v.Orientation = originalOrientation -- Return the part to its original orientation
							end
						end

						v.Touched:Connect(onTouch)


					end
				end

			end
		end
	end
	print("Obstacles are now loaded.")
end
local function LoadPads(CurrentLevel, StatsForEndPad)
	if CurrentLevel:FindFirstChild("Pads") then
		for i, pad in pairs(CurrentLevel.Pads:GetChildren()) do
			if pad.Name == "TeleportPad" then
				local db = false
				pad.Top.Touched:Connect(function(hit)
					if hit.Parent:FindFirstChild("Humanoid") and game.Players:GetPlayerFromCharacter(hit.Parent) then
						if db == false then
							db = true
							
								for i,v in pairs(CurrentLevel.NPCS:FindFirstChild(game.Players:GetPlayerFromCharacter(hit.Parent).Name .. "_NPCS"):GetChildren()) do
									v:MoveTo(pad.Top.Position)
									wait(1)
								
							end
							

							db = false
						end


					end
				end)
			end





			if pad.Name == "EndPad" then
				local db = false
				local counter = 0
				pad.Top.Touched:Connect(function(hit)
					if hit.Parent.Parent.Parent.Name == 'NPCS' and not hit.Parent:FindFirstChild("EndPadAlreadyTouched") then

						counter += 1
						local bool = Instance.new("BoolValue", hit.Parent)
						bool.Name ="EndPadAlreadyTouched"






						local playernpcfolder = CurrentLevel.NPCS:FindFirstChild(hit.Parent.Parent.Name)


						if counter == #playernpcfolder:GetChildren() then
							counter = 0
							print('all touched.')

							print(playernpcfolder.Name .. " has been deleted as player has finished level.")


							local suffix = "_NPCS"

							local playerName = string.gsub(playernpcfolder.Name, suffix, "")

							local WinningPlayer = game.Players:FindFirstChild(playerName)

							playernpcfolder:Destroy()

							Freeze(WinningPlayer.Character)
							wait(3)

							local gui = WinningPlayer.PlayerGui.CompletedLevel
							local function GiveRewards()
								gui.Enabled = true
								gui.Main.LevelBeaten.Text = "You beat level " .. StatsForEndPad.Level.Value .. ": " .. StatsForEndPad.LevelName.Value .. "!"

								local TotalCoins = 0
								local TotalGems = 0
								local CrystalCoins = 0
								local CrystalGems = 0
								local NormalCoins = 0
								local NormalGems = 0

								local crystalfolder = CurrentLevel:FindFirstChild('Crystals')

								if crystalfolder then
									local plrCrystalFolder = crystalfolder:FindFirstChild(WinningPlayer.Name .. "_Crystals")
									local plrCollectedCrystals = plrCrystalFolder:FindFirstChild(WinningPlayer.Name .. "_CollectedCrystals")
									if #plrCollectedCrystals:GetChildren() > 0 then
										print(#plrCollectedCrystals:GetChildren())
										CrystalCoins = plrCrystalFolder.AddedCoins.Value
										CrystalGems = plrCrystalFolder.AddedGems.Value

									end
								end

								local DoubleMoney = WinningPlayer.Gamepasses.DoubleMoney
								local DoubleGems = WinningPlayer.Gamepasses.DoubleGems

								if DoubleMoney.Value == true then
									print(WinningPlayer.Name .. ' has 2XMoney')
									NormalCoins = StatsForEndPad.Coins.Value * 2
									gui.Main.DoubleMoney.Visible = true

								else
									NormalCoins = StatsForEndPad.Coins.Value
								end

								if DoubleGems.Value == true then
									print(WinningPlayer.Name .. ' has 2XGems')

									NormalGems = StatsForEndPad.Diamonds.Value * 2
									gui.Main.DoubleGems.Visible = true
								else
									NormalGems = StatsForEndPad.Diamonds.Value

								end

								TotalCoins = NormalCoins + CrystalCoins
								TotalGems = NormalGems + CrystalGems
								if CrystalCoins > 0 or CrystalGems > 0  then

									gui.Main.Rewards.Gems.GemsObtained.Text = "+" .. NormalGems .. " (+" .. CrystalGems .. ")"
									gui.Main.Rewards.Money.MoneyObtained.Text = "+" .. NormalCoins .. " (+" .. CrystalCoins .. ")"
								else
									gui.Main.Rewards.Gems.GemsObtained.Text = "+" .. TotalGems
									gui.Main.Rewards.Money.MoneyObtained.Text = "+" .. TotalCoins
								end

								WinningPlayer.leaderstats.Coins.Value += TotalCoins 
								WinningPlayer.leaderstats.Gems.Value += TotalGems

								game.ReplicatedStorage.Remotes.Quests.CollectedCurrency:FireClient(WinningPlayer, "Coins", TotalCoins)
								game.ReplicatedStorage.Remotes.Quests.CollectedCurrency:FireClient(WinningPlayer, "Gems", TotalGems)

							end

							GiveRewards()

							local SideScreengui = WinningPlayer.PlayerGui.LevelSideScreen
							SideScreengui.Enabled = false
							local DisconnectProperty
							DisconnectProperty =	gui.Main.Exit.MouseButton1Click:Connect(function()
								CurrentLevel.Other.CurrentlyLoadedPlayers.Value -= 1
								if CurrentLevel.Other.CurrentlyLoadedPlayers.Value == 0 then
									CurrentLevel:Destroy()
								end

								gui.Enabled = false

								Unfreeze(WinningPlayer.Character)
								WinningPlayer.Character:MoveTo(workspace.SpawnLocation.Position)
								db = false

								for i,v in pairs(WinningPlayer.Character:GetChildren()) do
									if v:IsA("Tool") then
										v:Destroy()
									end
								end

								for i,v in pairs(WinningPlayer.Backpack:GetChildren()) do
									if v:IsA("Tool") then
										v:Destroy()
									end
								end
								game.ReplicatedStorage.Remotes.Quests.BeatedLevel:FireClient(WinningPlayer, StatsForEndPad.Level)
								DisconnectProperty:Disconnect()
							end)
						end
					end
				end)
			end
		end
	end
	print("Pads are now loaded.")
end

local function ForceEnd(CurrentLevel, plr)
	local gui = plr.PlayerGui.LevelSideScreen
	gui.Enabled = true
	local forceendgui = gui.ForceEnd
	local DisconnectProperty 
	DisconnectProperty = forceendgui.MouseButton1Click:Connect(function()
		if CurrentLevel == nil then return  DisconnectProperty:Disconnect() end
		if	CurrentLevel.NPCS:FindFirstChild(plr.Name .. "_NPCS") then
			CurrentLevel.NPCS:FindFirstChild(plr.Name .. "_NPCS"):Destroy()
		end
		if CurrentLevel:FindFirstChild("Crystals") then
			local playerFolder = CurrentLevel.Crystals:FindFirstChild(plr.Name .. "_Crystals")
			if playerFolder then
				playerFolder:Destroy()
				print('destroyed')
			end
		end
		gui.Enabled = false
		plr.Character:MoveTo(workspace.SpawnLocation.Position)
		CurrentLevel.Other.CurrentlyLoadedPlayers.Value -= 1
		if CurrentLevel.Other.CurrentlyLoadedPlayers.Value == 0 then
			CurrentLevel:Destroy()
		end

		for i,v in pairs(plr.Character:GetChildren()) do
			if v:IsA("Tool") then
				v:Destroy()
			end
		end

		for i,v in pairs(plr.Backpack:GetChildren()) do
			if v:IsA("Tool") then
				v:Destroy()
			end
		end
		DisconnectProperty:Disconnect()
	end)



end

local function LoadCrystalsRewrite(CurrentLevel, player)
	if CurrentLevel:FindFirstChild("Crystals") then
		local crystalfolder = CurrentLevel:FindFirstChild("Crystals")
		local playerFolderName = player.Name .. "_Crystals"

		-- Check if the player's folder already exists
		local CrystalPlayerFolder = crystalfolder:FindFirstChild(playerFolderName)
		if not CrystalPlayerFolder then
			CrystalPlayerFolder = Instance.new("Folder", crystalfolder)
			CrystalPlayerFolder.Name = playerFolderName
			print(CrystalPlayerFolder.Name .. " has been created.")
			local AddedCoins = Instance.new('IntValue', CrystalPlayerFolder)
			AddedCoins.Name = "AddedCoins"

			local AddedGems = Instance.new('IntValue', CrystalPlayerFolder)
			AddedGems.Name = "AddedGems"

			local InsertCrystals = Instance.new("Folder", CrystalPlayerFolder)
			InsertCrystals.Name = player.Name .. "_CollectedCrystals"
		end

		-- Load the crystals only once
		for i, crystal in pairs(crystalfolder:GetChildren()) do
			if crystal:IsA("Model") then
				local CrystalConnection
				CrystalConnection = 	crystal.UnionCollect.Take.Triggered:Connect(function(plrwhopressed)
					local playerFolder = crystalfolder:FindFirstChild(plrwhopressed.Name .. "_Crystals")
					local InsertCrystals = playerFolder:FindFirstChild(plrwhopressed.Name .. "_CollectedCrystals")

					if InsertCrystals:FindFirstChild(crystal.Name) then
						print('already collected')
						return
					end

					local NewCrystal = Instance.new("StringValue", InsertCrystals)
					NewCrystal.Name = crystal.Name

					local coinsAdder = crystal:FindFirstChild("CoinsAdder")
					local gemsAdder = crystal:FindFirstChild("GemsAdder")

					if coinsAdder then
						playerFolder.AddedCoins.Value += coinsAdder.Value
					end

					if gemsAdder then
						playerFolder.AddedGems.Value += gemsAdder.Value
					end
					game.ReplicatedStorage.Remotes.Other.DeleteCrystals:FireClient(plrwhopressed, crystal)

					game.ReplicatedStorage.Remotes.Quests.CollectedCurrency:FireClient(plrwhopressed, "Crystals", 1)

					CrystalConnection:Disconnect()
				end)
			end
		end
		print("Crystals are now loaded.")

	end
end


Remote.OnServerEvent:Connect(function(plr, statsFolder)
	print('fired')
	local levelclone = workspace:FindFirstChild(statsFolder.LevelName.Value) 
	if levelclone == nil then
		levelclone =  game.ReplicatedStorage.Levels:FindFirstChild(statsFolder.LevelName.Value):Clone()
	end

	levelclone.Other.CurrentlyLoadedPlayers.Value += 1
	if levelclone.NPCS:FindFirstChild(plr.Name .. "_NPCS") then levelclone.NPCS:FindFirstChild(plr.Name .. "_NPCS"):Destroy() end

	if levelclone.Parent == workspace then
		print('This level is already loaded.')
		LoadCrystalsRewrite(levelclone, plr)

	else
		LoadCrystalsRewrite(levelclone, plr)
		LoadObstacles(levelclone)
		LoadPads(levelclone, statsFolder, plr)
	end

	levelclone.Parent = workspace
	wait(1)
	plr.Character:MoveTo(levelclone.Spawns.PlayerSpawn.Position)




	Freeze(plr.Character)
	LoadNPCSRewrite(levelclone, plr, statsFolder.NoobsToLoad.Value)
	wait(3)
	print("Loaded Noobs: " .. #levelclone.NPCS:FindFirstChild(plr.Name .. "_NPCS"):GetChildren())
	print('GO')
	Unfreeze(plr.Character)
	levelclone.Other.BlockOff.CanCollide = false
--	ForceEnd(levelclone, plr)


	local physics = game:GetService("PhysicsService")

	-- Function to reset NPC collisions
	local function resetNPCCollisions(npc)
		for _, part in pairs(npc:GetChildren()) do
			if part:IsA("BasePart") or part:IsA("MeshPart") then
				part.CollisionGroup = "Default"
			end
		end
	end

	-- Apply to specific NPCs
	local npcFolder = levelclone.NPCS:FindFirstChild(plr.Name .. "_NPCS")
	for _, npc in pairs(npcFolder:GetChildren()) do
		resetNPCCollisions(npc)
	end

	game.Players.PlayerRemoving:Connect(function(theplayer)
		if #game.Players:GetPlayers() == 0 then
			return
		end
		if theplayer == plr then
			levelclone.Other.CurrentlyLoadedPlayers.Value -= 1
			levelclone.NPCS:FindFirstChild(plr.Name .. "_NPCS"):Destroy()
			if levelclone:FindFirstChild("Crystals") then
				levelclone.Crystals:FindFirstChild(plr.Name .. "_Crystals"):Destroy()
			end
			if levelclone.Other.CurrentlyLoadedPlayers.Value == 0 then
				levelclone:Destroy()
			end
		end
	end)


end)
