local bit = require "bit"

local function all(t, predicate)
  for _, v in ipairs(t) do
    if not predicate(v) then return false end
  end
  return true
end

local function reduce(fn, t, initial)
  local acc = initial
  for _, v in ipairs(t) do
    acc = fn(acc, v)
  end
  return acc
end

local function sum(n1, n2) return n1 + n2 end

local function xor(n1, n2) return bit.bxor(n1, n2) end

local function isWinning(counts)
  -- We are in the end game if all columns are empty or contain one.
  local isEndGame = all(counts, function(count) return count <= 1 end)
  if isEndGame then
    local total = reduce(sum, counts, 0)
    return total % 2 ~= 0 -- odd is winning
  end
  -- Exclusive-or all the row counts.
  local score = reduce(xor, counts, 0)
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
