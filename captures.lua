local s = "The score was 19 to 7."
local pattern = "(%d+).+(%d+)"
local score1, score2 = string.match(s, pattern)
print(score1, score2) -- 19      7
