local Set = require "set"

local s1 = Set.new { 10, 20, 30, 50 }
local s2 = Set.new { 30, 10, 60 }
local s3 = Set.new { 50 }

print("intersection =", Set.intersection(s1, s2)) -- {30, 10}
print("intersection =", s1:intersection(s2))      -- {30, 10}
print("union =", s1 + s2)                         -- {50, 30, 10, 60, 20}
print("complex =", (s2 + s3) * s1)                -- {30, 10, 50}
