#include "lauxlib.h" // for most luaL_* functions
#include "lualib.h" // for luaL_openlibs

void error(const char *fmt, ...) {
  va_list argp;
  va_start(argp, fmt);
  vfprintf(stderr, fmt, argp);
  va_end(argp);
}

int main(void) {
  lua_State *L = luaL_newstate();
  luaL_openlibs(L); // loads ALL standard libraries

  luaL_dofile(L, "config.lua");

  // Get and print the value of a Lua global variable.
  lua_getglobal(L, "message"); // pushes onto stack
  const char *message = lua_tostring(L, -1);
  lua_pop(L, 1); // pops from stack
  printf("message = %s\n", message);

  lua_getglobal(L, "color"); // pushes onto stack
  const char *color = lua_tostring(L, -1);
  lua_pop(L, 1); // pops from stack
  printf("color = %s\n", color);

  // Call a Lua function that takes no arguments and returns no values.
  lua_getglobal(L, "demo");
  if (lua_pcall(L, 0, 0, 0) != LUA_OK) {
    error("error at %s", lua_tostring(L, -1));
  }

  lua_close(L);
  return 0; // success
}
