local s = "This is a TEST of FINDING upperCase words."
-- local pattern = "%u+" -- gives T, TEST, FINDING, and C
local pattern = "%f[%a]%u+" -- gives T, TEST, and FINDING
string.gsub(s, pattern, print)
-- How can you eliminate matching T?
