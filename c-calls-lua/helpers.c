#include <stdlib.h> // for exit function and EXIT_FAILURE
#include <string.h> // for strcpy
#include "lauxlib.h" // for luaL_* functions
#include "lualib.h" // for luaL_openlibs
#include "helpers.h"

lua_State *L;

void callFunction(int inputs, int outputs) {
  // 2nd argument is the number of arguments being passed to the Lua function.
  // 3rd argument is the number of values being returned by Lua function.
  // 4th argument is a pointer to an error handling function,
  // or 0 to not use one.
  // TODO: Learn how to use an error handling function.
  lua_pcall(L, inputs, outputs, 0);
  // After the call the function and all its arguments are popped from the stack
  // and the outputs are pushed onto the stack.
}

void doFile(const char* filePath) {
  luaL_dofile(L, filePath);
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

void getGlobalTable(const char *var) {
  lua_getglobal(L, var);
  if (!lua_istable(L, -1)) {
    error("expected %s to be a table\n", var);
  }
  // This leaves the table on the stack.
}

void createLuaVM() {
  L = luaL_newstate();

  // Make the standard library functions available in Lua code.
  luaL_openlibs(L);
}

void pop(int n) {
  lua_pop(L, n);
}

const char* getStackString(int i) {
  int t = lua_type(L, i);
  switch (t) {
    case LUA_TSTRING:
      return lua_tostring(L, i);
    case LUA_TBOOLEAN:
      return lua_toboolean(L, i) ? "true" : "false";
    case LUA_TNUMBER: {
      static char text[20];
      sprintf(text, "%g", lua_tonumber(L, i));
      return text;
    }
    default: {
      static char text[20];
      sprintf(text, "some %s", lua_typename(L, t));
      return text;
    }
  }
}

void printStack() {
  int top = lua_gettop(L);
  if (top == 0) {
    printf("Lua stack is empty.\n");
    return;
  }

  printf("Lua stack contains:\n");
  int i;
  for (i = 1; i <= top; i++) {
    printf("  %d = %s\n", i, getStackString(i));
  }
}

// This assumes that the table is on the top of the stack.
void printTable() {
  printf("table contains:\n");
  lua_pushnil(L); // initial key
  //
  // lua_next removes the key on the top of the stack and
  // pushes the next key and value onto the stack.
  while (lua_next(L, -2) != 0) {
    // The next key is at index -2 and its value is at index -1.
    char key[100];
    strcpy(key, getStackString(-2));
    const char *value = getStackString(-1);
    printf("  %s = %s\n", key, value);

    // This removes the value and keeps the key for the next iteration.
    lua_pop(L, 1);
  }
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

// This assumes that a Lua table is at the top of the stack.
// This must be defined after the `pushString` function.
int getIntTableValueForIndex(int index) {
  pushInt(index);
  // The table should now be at -2 on the stack.
  lua_gettable(L, -2);
  int value = lua_tointeger(L, -1);
  pop(1); // pops the key from the stack
  return value;
}

// This assumes that a Lua table is at the top of the stack.
// This must be defined after the `pushString` function.
const char* getStringTableValueForStringKey(const char *key) {
  lua_getfield(L, -1, key);
  const char *value = lua_tostring(L, -1);
  pop(1); // pops the key from the stack
  return value;
}

// This assumes that the table is already at the top of the stack.
// Other versions are needed for non-string keys and values.
void setTableKeyValue(const char* key, const char* value) {
  pushString(key);
  pushString(value);
  lua_settable(L, -3); // -3 refers to the Lua table
}
