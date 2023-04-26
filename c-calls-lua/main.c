#include <stdlib.h> // defines the exit function and EXIT_FAILURE
#include "lauxlib.h"
#include "lua.h"
#include "lualib.h" // defines the luaL_openlibs function

lua_State *L;

// static void dumpStack(lua_State *L) {
static void dumpStack() {
  printf("Lua stack contains:\n");
  int i;
  int top = lua_gettop(L);
  for (i = 1; i <= top; i++) {
    int t = lua_type(L, i);
    switch (t) {
      case LUA_TSTRING: {
        printf("  %d) %s", i, lua_tostring(L, i));
        break;
      }
      case LUA_TBOOLEAN: {
        printf("  %d) %s", i, lua_toboolean(L, i) ? "true" : "false");
        break;
      }
      case LUA_TNUMBER: {
        printf("  %d) %g", i, lua_tonumber(L, i));
        break;
      }
      default: {
        printf("  %d) %s", i, lua_typename(L, t));
        break;
      }
    }
    printf("\n");
  }
}

void error(const char *fmt, ...) {
  va_list argp;
  va_start(argp, fmt);
  vfprintf(stderr, fmt, argp);
  va_end(argp);
  lua_close(L);
  exit(EXIT_FAILURE);
}

int getGlobalBoolean(const char *var) {
  lua_getglobal(L, var); // pushes onto stack
  if (!lua_isboolean(L, -1)) {
    error("expected %s to be a boolean\n", var);
  }
  int result = lua_toboolean(L, -1);
  lua_pop(L, 1); // pops from stack
  return result;
}

double getGlobalDouble(const char *var) {
  lua_getglobal(L, var); // pushes onto stack
  // From the docs, "the term number in the API refers to doubles."
  if (!lua_isnumber(L, -1)) {
    error("expected %s to be a number\n", var);
  }
  double result = lua_tonumber(L, -1);
  lua_pop(L, 1); // pops from stack
  return result;
}

int getGlobalInt(const char *var) {
  lua_getglobal(L, var); // pushes onto stack
  if (!lua_isinteger(L, -1)) {
    error("expected %s to be an integer\n", var);
  }
  int result = lua_tointeger(L, -1);
  lua_pop(L, 1); // pops from stack
  return result;
}

const char* getGlobalString(const char *var) {
  lua_getglobal(L, var); // pushes onto stack
  if (!lua_isstring(L, -1)) {
    error("expected %s to be a string\n", var);
  }
  const char *result = lua_tostring(L, -1);
  lua_pop(L, 1); // pops from stack
  return result;
}

int main(void) {
  char name[] = "Mark";
  printf("Hello %s!\n", name);

  // Create a Lua virtual machine.
  // lua_State *L = luaL_newstate();
  L = luaL_newstate();

  // Make the standard library functions available in Lua code.
  luaL_openlibs(L);

  // Execute a Lua source file.
  luaL_dofile(L, "config.lua");

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
  lua_getglobal(L, "demo");

  // 2nd argument is the number of arguments being passed to the Lua function.
  // 3rd argument is the number of values being returned by Lua function.
  // 4th argument is a pointer to an error handling function,
  // or 0 to not use one.
  lua_pcall(L, 0, 0, 0);

  lua_getglobal(L, "add");
  lua_pushnumber(L, 3);
  lua_pushnumber(L, 4);
  dumpStack();
  lua_pcall(L, 2, 1, 0);
  int sum = lua_tonumber(L, -1);
  printf("sum = %d\n", sum); // 3 + 4 = 7
  dumpStack();

  // Close the Lua virtual machine.
  lua_close(L);

  return 0; // success
}
