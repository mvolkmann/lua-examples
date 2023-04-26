#include <stdlib.h> // defines the exit function and EXIT_FAILURE
#include "lauxlib.h"
#include "lua.h"

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

