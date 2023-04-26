#include "lualib.h" // defines the luaL_openlibs function
#include "helpers.c" // defines L and several functions
#include <string.h> // for strlen function

// All C functions that are intended to be called from Lua must
// 1) have an `int` return type and return the number of result values
// 2) take a `lua_State *` argument
//
// Beginning the function name with "l_" indicates that
// this function is written to be called from Lua.
//
// This expects a string argument.
// It returns the length of the string.
// Making this static restricts its access to this file.
// Each invocation of this function receives its own stack.
// There is no need to pop anything off of this stack.
static int l_strlen(lua_State *L) {
  const char *s = lua_tostring(L, 1);
  lua_pushnumber(L, strlen(s));
  return 1; // one value is returned
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

  // Call a function defined in config.lua.
  pushFunction("demo");
  callFunction(0, 0);

  pushFunction("add");
  pushInt(3);
  pushInt(4);

  dumpStack();

  callFunction(2, 1);

  int sum = lua_tonumber(L, -1);
  printf("sum = %d\n", sum); // 3 + 4 = 7
  pop(1);
  dumpStack();

  registerCFunction("l_strlen", l_strlen);

  // Call the C function.
  pushFunction("l_strlen");
  lua_pushstring(L, "cheeseburger");
  lua_pcall(L, 1, 1, 0);
  int length = lua_tonumber(L, -1);
  printf("length = %d\n", length);
  pop(1);
  dumpStack();

  // Close the Lua virtual machine.
  lua_close(L);

  return 0; // success
}
