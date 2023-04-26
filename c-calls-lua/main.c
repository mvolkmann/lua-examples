#include <stdlib.h> // defines the exit function and EXIT_FAILURE
#include "lauxlib.h"
#include "lua.h"
#include "lualib.h" // defines the luaL_openlibs function

void error(lua_State *L, const char *fmt, ...) {
  va_list argp;
  va_start(argp, fmt);
  vfprintf(stderr, fmt, argp);
  va_end(argp);
  lua_close(L);
  exit(EXIT_FAILURE);
}

int getGlobalBoolean(lua_State *L, const char *var) {
  lua_getglobal(L, var); // pushes onto stack
  if (!lua_isboolean(L, -1)) {
    error(L, "expected %s to be a boolean\n", var);
  }
  int result = lua_toboolean(L, -1);
  lua_pop(L, 1); // pops from stack
  return result;
}

double getGlobalDouble(lua_State *L, const char *var) {
  lua_getglobal(L, var); // pushes onto stack
  if (!lua_isnumber(L, -1)) {
    error(L, "expected %s to be a number\n", var);
  }
  double result = lua_tonumber(L, -1);
  lua_pop(L, 1); // pops from stack
  return result;
}

int getGlobalInt(lua_State *L, const char *var) {
  lua_getglobal(L, var); // pushes onto stack
  if (!lua_isinteger(L, -1)) {
    error(L, "expected %s to be an integer\n", var);
  }
  int result = lua_tointeger(L, -1);
  lua_pop(L, 1); // pops from stack
  return result;
}

const char* getGlobalString(lua_State *L, const char *var) {
  lua_getglobal(L, var); // pushes onto stack
  if (!lua_isstring(L, -1)) {
    error(L, "expected %s to be a string\n", var);
  }
  const char *result = lua_tostring(L, -1);
  lua_pop(L, 1); // pops from stack
  return result;
}

int main(void) {
  char name[] = "Mark";
  printf("Hello %s!\n", name);

  // Create a Lua virtual machine.
  lua_State *L = luaL_newstate();

  // Make the standard library functions available in Lua code.
  luaL_openlibs(L);

  // Execute a Lua source file.
  luaL_dofile(L, "config.lua");

  // To check if the top of the stack contains nil ...
  // if (lua_isnil(L, -1))

  int myBoolean = getGlobalBoolean(L, "myBoolean");
  printf("myBoolean = %d\n", myBoolean);

  int myInteger = getGlobalInt(L, "myInteger");
  printf("myInteger = %d\n", myInteger);

  double myDouble = getGlobalDouble(L, "myDouble");
  printf("myDouble = %f\n", myDouble);

  const char *myString = getGlobalString(L, "myString");
  printf("myString = %s\n", myString);

  // Close the Lua virtual machine.
  lua_close(L);

  return 0; // success
}
