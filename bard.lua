function main()
  -- Read numbers from stdin.
  local numbers = {}
  for line in io.lines() do
    local number = tonumber(line)
    if number then
      table.insert(numbers, number)
    end
  end

  -- Calculate the average.
  local sum = 0
  for _, number in ipairs(numbers) do
    sum = sum + number
  end
  local average = sum / #numbers

  -- Print the average.
  print(average)
end

main()
