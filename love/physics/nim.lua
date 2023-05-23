local bit = require "bit"
local computerWon = false
local gameOver = false

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

local function removeTabs(counts, row, count, byHuman)
  gameStarted = true
  counts[row] = counts[row] - count
  if gameOver then computerWon = byHuman end
end

local function makeMove(columns)
  if gameOver then return end

  local foundMove = false

  -- Find the first move that results in a score of zero.
  for index, count in ipairs(columns) do
    if count == 0 then goto continue end

    for c = 1, count do
      local board = { unpack(columns) } -- makes a copy
      board[index] = board[index] - c
      if isWinning(board) then
        removeTabs(columns, index, count)
        foundMove = true
        break
      end
    end

    if foundMove then break end

    ::continue::
  end

  while not foundMove do
    -- Remove one from any non-empty row.
    local index = math.random(0, columns.count - 1)
    if columns[index] > 0 then
      removeTabs(columns, index, 1)
      foundMove = true
    end
  end
end

return {
  isWinning = isWinning,
  makeMove = makeMove
}
