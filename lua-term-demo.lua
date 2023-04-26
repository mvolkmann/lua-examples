local term = require 'term'
local colors = term.colors

print(colors.bright .. colors.red 'red')
print(colors.bright .. colors.yellow 'yellow')
print(colors.bright .. colors.blue .. 'blue')
print(colors.reset 'white')
