local mod = {}

---
--@section Table Manipulation Functions - `uutils.tbl`
function mod.merge(tbl1, tbl2)
    -- Merges two tables
    --
    -- operates on tbl1 by insertion of all key,value pairs from tbl2
    -- does not do a deep copy.
    for _,v in ipairs(tbl2) do
	table.insert(tbl1, v)
    end
    return tbl1
end

function mod.clone(tbl)
    -- Clones a single table without a deep copy.
    return {unpack(tbl)}
end

return mod
