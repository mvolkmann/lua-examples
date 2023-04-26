local s = "The 2nd time was easier than the 1st, and the 4th was a piece of cake."
local pattern = "%d%l%l"

local replTable = {
  ["1st"] = "first",
  ["2nd"] = "second",
  ["3rd"] = "third"
}
-- If no match is found in `replTable`, it keeps the match.
local s2 = string.gsub(s, pattern, replTable)
print(s2)
-- The second time was easier than the first, and the 4th was a piece of cake.

-- This function produces the same result as using `replTable`.
local function replFn(match)
  if match == "1st" then return "first" end
  if match == "2nd" then return "second" end
  if match == "3rd" then return "third" end
  return match
end

local s3 = string.gsub(s, pattern, replFn)
print(s3)
-- The second time was easier than the first, and the 4th was a piece of cake.
