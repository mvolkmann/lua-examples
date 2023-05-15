-- Find the start end end index of the first occurrence.
local text = "abcdefgh"
local startIndex, endIndex = string.find(text, "def")
print(startIndex, endIndex) -- 4, 6

startIndex, endIndex = string.find(text, "not")
print(startIndex, endIndex) -- nil, nil

-- Get a substring.
local chunk = string.sub(text, 4, 6)
print(chunk) -- "def"

-- Replace all occurrences.
local sentence = "The dog jumped over the log."
local changed, count = string.gsub(sentence, "og", "ake")
print(changed) -- The dake jumped over the lake.
print(count)   -- 2

-- Replace the first n occurrences (1 in this case).
sentence = "The dog jumped over the log."
changed = string.gsub(sentence, "og", "eer", 1)
print(changed) -- The deer jumped over the log.

local datePattern = "%u%l%l%s%d%d?,%s%d%d%d%d"
sentence = "The date today is Apr 14, 2023."
startIndex, endIndex = string.find(sentence, datePattern)
print(startIndex, endIndex) -- 19, 30
local date = string.sub(sentence, startIndex, endIndex)
print(date)                 -- Apr 14, 2023

sentence = "The date today is April 14, 2023."
startIndex, endIndex = string.find(sentence, datePattern)
print(startIndex, endIndex) -- nil, nil

-- Hexadecimal
sentence = "Decimal 255 is hex ff."
-- `[%da-fA-F]` is the equivalent of `%x` for describe a hexadecimal digit.

