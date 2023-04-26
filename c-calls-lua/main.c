#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lauxlib.h"
#include "lua.h"
#include "lualib.h"

void error(lua_State *L, const char *fmt, ...) {
  va_list argp;
  va_start(argp, fmt);
  vfprintf(stderr, fmt, argp);
  va_end(argp);
  lua_close(L);
  exit(EXIT_FAILURE);
}

/* // This gets a boolean value from the top of the Lua stack.
bool getBool(lua_State *L, const char *name) {
  lua_getglobal(L, var);
  // Verify that the top of the stack holds a boolean value.
  result = (int) lua_toboolean(L, -1);
  if (!isNum) {
    error(L, "%s should be a number\n", var);
  }
  lua_pop(L, 1);
  return result;
} */

int getGlobalInt(lua_State *L, const char *var) {
  int isNum, result;
  lua_getglobal(L, var);
  result = (int) lua_tointegerx(L, -1, &isNum);
  if (!isNum) {
    error(L, "%s should be a number\n", var);
  }
  lua_pop(L, 1);
  return result;
}

int main(void) {
  char name[] = "Mark";
  printf("Hello %s!\n", name);

  lua_State *L = luaL_newstate();
  luaL_openlibs(L);

  luaL_dofile(L, "config.lua");

  // To check if the top of the stack contains nil ...
  // if (lua_isnil(L, -1))

  // TODO: Add error handling to validate types.
  lua_getglobal(L, "myBoolean");
  int myBoolean = lua_toboolean(L, -1);
  printf("myBoolean = %d\n", myBoolean);

  lua_getglobal(L, "myInteger");
  lua_Integer myInteger = lua_tointeger(L, -1);
  // lld is long long decimal
  printf("myInteger = %lld\n", myInteger);

  lua_getglobal(L, "myFloat");
  lua_Number myFloat = lua_tonumber(L, -1);
  printf("myFloat = %f\n", myFloat);

  lua_getglobal(L, "myString");
  const char *myString = lua_tostring(L, -1);
  printf("myString = %s\n", myString);

  lua_close(L);
  return 0;
}
