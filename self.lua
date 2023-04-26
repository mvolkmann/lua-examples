MyTable = {
  dotInner = function(p1, p2)
    print("dotInner p1 =", p1)
    print("dotInner p2 =", p2)
  end
}

-- This is an alternate way to write the dotInner function,
-- defining it outside the table literal.
-- The `self` variable is not defined in dot functions.
function MyTable.dotOuter(p1, p2)
  print("dotInner p1 =", p1)
  print("dotInner p2 =", p2)
end

-- Dot functions should always be called with a dot, not a colon.
MyTable.dotInner(1, 2) -- p1 = 1, p2 = 2
MyTable.dotOuter(1, 2) -- p1 = 1, p2 = 2

-- Using a colon causes the variable before the colon
-- to be passed as the first argument.
-- This makes 1 the second argument and 2 the third.
-- Dot function should never be called with a colon.
MyTable:dotOuter(1, 2) -- p1 = MyTable, p2 = 1, last argument 2 is ignored

-- Colon functions have an invisible first parameter named "self".
-- So p1 here is actually the second parameter and p2 is the third.
-- When a colon function is called using a colon,
-- the variable before the colon is passed as the first argument.
-- It seems colon functions cannot be defined inside a table literal.
function MyTable:colonOuter(p1, p2)
  print("colonOuter self =", self)
  print("colonOuterFn p1 =", p1)
  print("colorOuterFn p2 =", p2)
end

-- Here colonOuter is called without a colon,
-- so MyTable is not passed as the first argument.
-- Colon functions should never be called with a dot.
MyTable.colonOuter(1, 2, 3) -- self = 1, p1 = 2, p2 = 3

-- Here colonOuter is called with a colon,
-- so MyTable is passed as the first argument.
-- Colon functions should always be called with a colon.
MyTable:colonOuter(1, 2) -- self = MyTable, p1 = 1, p2 = 2

-- This is equivalent to the previous line.
-- While this works, it is overly verbose.
MyTable.colonOuter(MyTable, 1, 2) -- self = MyTable, p1 = 1, p2 = 2
