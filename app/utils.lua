local function complete_table(major, minor)
  for k, v in pairs(major) do
      if minor[k] == nil then
          minor[k] = v
      end
  end
end


local function tuple_to_table(format, tuple)
  local map = {}
  for i, v in ipairs(format) do
      map[v.name] = tuple[i]
  end
  return map
end

return {complete_table = complete_table,
tuple_to_table=tuple_to_table
 }

