#include <stdlib.h> // defines the exit function and EXIT_FAILURE
#include "lauxlib.h"
#include "lua.h"

lua_State *L;

void callFunction(int inputs, int outputs);

void doFile(const char* filePath);

void dumpStack();

void error(const char *fmt, ...);

int getGlobalBoolean(const char *var);

double getGlobalDouble(const char *var);

int getGlobalInt(const char *var);

const char* getGlobalString(const char *var);

void createLuaVM();

void pop(int n);

void pushBoolean(int b);
void pushFunction(const char *name);
void pushDouble(double n);
void pushInt(int n);
void pushString(const char *s);

void registerCFunction(const char* name, lua_CFunction fn);

// This assumes that a Lua table is at the top of the stack.
// This must be defined after the `pushString` function.
int getIntTableValueForIndex(int index);

// This assumes that a Lua table is at the top of the stack.
// This must be defined after the `pushString` function.
const char* getStringTableValueForStringKey(const char *key);

