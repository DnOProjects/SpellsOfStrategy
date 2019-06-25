local Utility = {}

function Utility.round(x,decimalPlaces)
  local mult = 10^(decimalPlaces or 0) --decimalPlaces default to 0
  return math.floor(x * mult + 0.5) / mult
end

function Utility.findByTag(list,tagName,tagContent) --leave tag content blank to filter for any occurance of the tag
	for i=1,#list do
		local i = list[i]
		if i[tagName] then
			if (tagContent==nil) or (i[tagName]==tagContent) then
				return i
			end
		end
	end
end

return Utility