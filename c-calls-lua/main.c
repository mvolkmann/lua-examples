#include "lualib.h" // defines the luaL_openlibs function
#include "helpers.c" // defines L and several functions

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
  dumpStack();

  // Close the Lua virtual machine.
  lua_close(L);

  return 0; // success
}
