local mod = {}

function mod._longest_common_substring(str_a, str_b)
	if #str_a == 0 or #str_b == 0 then
		return ""
	elseif string.sub(str_a, -1, -1) == string.sub(str_b, -1, -1) then
		return mod.longest_common_substring(string.sub(str_a, 1, -2), string.sub(str_b, 1, -2)) .. string.sub(str_a, -1, -1)
	else
		local a_sub = mod.longest_common_substring(str_a, string.sub(str_b, 1, -2))
		local b_sub = mod.longest_common_substring(string.sub(str_a, 1, -2), str_b)

		if #a_sub > #b_sub then
			return a_sub
		else
			return b_sub
		end
	end
end

function mod.maximal_common_substring(str_list)
	-- construct a generalized suffix tree for the list of strings given.
	-- The longest common susbtring is therefore in the suffix tree satisfying
	-- the following constraints:
	
	local res_i, res = next(str_list)
	return res
end

function mod.suffix_tree(str_a)
	-- temporarily, we pick a random item. Need to implement the suffix tree
	-- somehow.
	return next(str_a)
end

return mod
