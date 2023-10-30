local Editor = {}

local Terrain = game.Workspace.Terrain

function Editor.getInstancesCountWithName(name)
	local count = 0
	for _, obj in ipairs(game:GetDescendants()) do
		if obj.Name == name then
			count += 1
		end
	end
	print(name .. " instances: ".. count)
	return count
end

--[[

deletes models that have 0 children.
function Editor.cleanup()
	local deleted = 0
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and #v:GetChildren() == 0 then
			v:Destroy()
			deleted+=1
		end
	end
	
	print("removed empty "..deleted.." models")
	
end
--]]

-- 
function Editor.deleteRegion(p1, p2)
	--assume the x,y,z of p2-p1 are multiple of 4s 
	local region = Region3.new(p1, p2) 
	local materials, occupancies = Terrain:ReadVoxels(region, 4)
	local toDelete = {"Grass", "Sand", "Ground", "Leafy Grass", "Rock"}
	local size = materials.Size -- Same as occupancies.Size
	for x = 1, size.X, 1 do
		for z = 1, size.Z, 1 do
			for y = 1, size.Y - 1, 1 do
				if occupancies[x][y][z] == 1  and occupancies[x][y+1][z] == 1  and table.find(toDelete, materials[x][y][z].Name) and table.find(toDelete, materials[x][y+1][z].Name)  then
					local regionToDelete = Region3.new(p1 + Vector3.new((x-1) * 4, (y-1) * 4, (z-1) * 4), p1 + Vector3.new(x * 4, y * 4, z * 4))
					Terrain:FillRegion(regionToDelete, 4, Enum.Material.Air)
				end
			end
		end
	end
end

function Editor.deleteInstances(name, instanceCount)
	local instancesDeleted = 0
	for _, obj in pairs(workspace:GetDescendants()) do
		
		if instancesDeleted >= instanceCount then
			break
		end
		
		if instancesDeleted < instanceCount and obj.Name == name then
			obj:Destroy()
			instancesDeleted += 1
		end
		
	end
	print("deleted ".. instancesDeleted .. " instances named " ..name)
end

return Editor
