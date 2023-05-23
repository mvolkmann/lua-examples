local bit = require "bit"
local fun = require "fun"

local function isWinning(counts)
  -- We are in the end game if all columns are empty or contain one.
  local isEndGame = fun.every(counts, function(count) return count <= 1 end)
  if isEndGame then
    local total = fun.tableSum(counts)
    return total % 2 ~= 0 -- odd is winning
  end
  -- Exclusive-or all the row counts.
  local score = fun.reduce(counts, fun.xor, 0)
  return score == 0
end

local function getMove(counts)
  -- Find the first move that results in a score of zero.
  for column, count in ipairs(counts) do
    if count == 0 then goto continue end

    for c = 1, count do
      local board = { unpack(counts) } -- makes a copy
      board[column] = board[column] - c
      if isWinning(board) then
        return column, c
      end
    end

    ::continue::
  end

  -- No move with a score of zero was found,
  -- remove one from any non-empty row.
  while true do
    local column = math.random(1, #counts)
    if counts[column] > 0 then return column, 1 end
  end
end

return {
  getMove = getMove,
  isWinning = isWinning
}
