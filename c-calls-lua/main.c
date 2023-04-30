#include <stdio.h> // for printf function
#include <string.h> // for strlen function
#include "helpers.h"

// All C functions that are intended to be called from Lua must
// 1) have an `int` return type
// 2) take a `lua_State *` argument
// 3) return the number of result values
//
// Beginning the function name with "l_" indicates that
// this function is written to be called from Lua.
//
// This expects a string argument.
// It returns the length of the string.
//
// Making this static restricts its access to this file.
//
// Each invocation of this function receives its own stack.
// There is no need to pop anything off of this stack.
static int l_strlen(lua_State *L) {
  const char *s = lua_tostring(L, 1);
  lua_pushnumber(L, strlen(s));
  return 1; // one value is returned
}

// This assumes that the table is on the top of the stack.
void dumpTable() {
  printf("Lua table contains:\n");

  // Get the value of the "apple" key.
  const char *fruit = "apple";
  const char *color = getStringTableValueForStringKey(fruit);
  printf("  %s = %s\n", fruit, color);

  // Get the value of the "banana" key.
  fruit = "banana";
  color = getStringTableValueForStringKey(fruit);
  printf("  %s = %s\n", fruit, color);

  // Get the value of the 1 key.
  int index = 1;
  int value = getIntTableValueForIndex(index);
  printf("  value at index %d = %d\n", index, value);
}

int main(void) {
  createLuaVM();

  // Execute a Lua source file.
  doFile("config.lua");

  // To check if the top of the stack contains nil ...
  // if (lua_isnil(L, -1))

  int myBoolean = getGlobalBoolean("myBoolean");
  printf("myBoolean = %d\n", myBoolean);

  int myInteger = getGlobalInt("myInteger");
  printf("myInteger = %d\n", myInteger);

  double myDouble = getGlobalDouble("myDouble");
  printf("myDouble = %g\n", myDouble);

  const char *myString = getGlobalString("myString");
  printf("myString = %s\n", myString);

  // TODO: Learn how to retrieve a table.

  // Call a function defined in config.lua that
  // takes no arguments and doesn't return anything.
  pushFunction("demo");
  callFunction(0, 0);

  // Call a function defined in config.lua that
  // adds two numbers.
  pushFunction("add");
  // pushInt(3);
  // pushInt(4);
  pushDouble(3.5);
  -- pushDouble(0); -- for testing lua_pcall error handling
  pushDouble(4.7);
  // printStack();
  callFunction(2, 1);

  // Get, print, and pop the result.
  float sum = lua_tonumber(L, -1);
  printf("sum = %f\n", sum); // 3.5 + 4.7 = 8.2
  pop(1); // stack should be empty now

  registerCFunction("l_strlen", l_strlen);

  // Call the C function.
  pushFunction("l_strlen");
  pushString("cheeseburger");
  callFunction(1, 1);

  // Get, print, and pop the result.
  int length = lua_tonumber(L, -1);
  printf("length = %d\n", length);
  pop(1); // stack should be empty now

  // Currently the Lua table is the only thing on the stack.
  getGlobalTable("myTable");
  printTable();

  // Currently the Lua table is the only thing on the stack.
  setTableKeyValue("apple", "green");

  // dumpTable();
  printTable();
  pop(1); // removes the table from the stack

  printStack(); // stack should be empty now

  // Close the Lua virtual machine.
  lua_close(L);

  return 0; // success
}
