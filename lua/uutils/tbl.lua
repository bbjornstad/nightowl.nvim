local mod = {}

---
-- @section Table Manipulation Functions - `uutils.tbl`
function mod.print(tt, indent, done)
	done = done or {}
	indent = 4 --indent or 0
	if type(tt) == "table" then
		local sb = {}
		for key, value in pairs(tt) do
			table.insert(sb, string.rep(" ", indent)) -- indent it
			if type(value) == "table" and not done[value] then
				done[value] = true
				table.insert(sb, key .. " = {\n")
				table.insert(sb, mod.print(value, indent + 2, done))
				table.insert(sb, string.rep(" ", indent)) -- indent it
				table.insert(sb, "}\n")
			elseif "number" == type(key) then
				table.insert(sb, string.format('"%s"\n', tostring(value)))
			else
				table.insert(sb, string.format('%s = "%s"\n', tostring(key), tostring(value)))
			end
		end
		return table.concat(sb)
	else
		return tt .. "\n"
	end
end

function mod.to_string(tbl)
	if "nil" == type(tbl) then
		return tostring(nil)
	elseif "table" == type(tbl) then
		return mod.print(tbl)
	elseif "string" == type(tbl) then
		return tbl
	else
		return tostring(tbl)
	end
end

function mod.merge(tbl1, tbl2)
	-- Merges two tables
	--
	-- operates on tbl1 by insertion of all key,value pairs from tbl2
	-- does not do a deep copy.
	for _, v in ipairs(tbl2) do
		table.insert(tbl1, v)
	end
	return tbl1
end

function mod.clone(tbl)
	-- Clones a single table without a deep copy.
	return { unpack(tbl) }
end

function mod.tmap(fn, vec, fnopts, mapopts)
	fnopts = (fnopts or {})
	mapopts = (mapopts or {})
	local results = {}
	for k, v in pairs(vec) do
		-- TODO: maybe remake this...probably better to just write a wrapper to
		-- go from varargs fn to not-varargs.
		--
		-- if mapopts.unpack then
		-- 	results[k] = fn(unpack(v), fnopts)
		-- else
		
		-- store the results of 
		results[k] = fn(v, fnopts)
		-- end
	end
	return results
end

return mod
