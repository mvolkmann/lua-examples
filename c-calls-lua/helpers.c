#include <stdlib.h> // defines the exit function and EXIT_FAILURE
#include "lauxlib.h"
#include "lua.h"

lua_State *L;

void callFunction(int inputs, int outputs) {
  // 2nd argument is the number of arguments being passed to the Lua function.
  // 3rd argument is the number of values being returned by Lua function.
  // 4th argument is a pointer to an error handling function,
  // or 0 to not use one.
  lua_pcall(L, inputs, outputs, 0);
  // After the call the function and all its arguments are popped from the stack
  // and the outputs are pushed onto the stack.
}

void doFile(const char* filePath) {
  luaL_dofile(L, filePath);
}

// static void dumpStack(lua_State *L) {
static void dumpStack() {
  int top = lua_gettop(L);
  if (top == 0) {
    printf("Lua stack is empty.\n");
    return;
  }

  printf("Lua stack contains:\n");
  int i;
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

void createLuaVM() {
  L = luaL_newstate();

  // Make the standard library functions available in Lua code.
  luaL_openlibs(L);
}

void pop(int n) {
  lua_pop(L, n);
}

void pushBoolean(int b) {
  lua_pushboolean(L, b);
}

void pushFunction(const char *name) {
  lua_getglobal(L, name);
}

void pushDouble(double n) {
  lua_pushnumber(L, n);
}

void pushInt(int n) {
  lua_pushnumber(L, n);
}

void pushString(const char *s) {
  lua_pushstring(L, s);
}

void registerCFunction(const char* name, lua_CFunction fn) {
  lua_pushcfunction(L, fn);
  lua_setglobal(L, name);
}
