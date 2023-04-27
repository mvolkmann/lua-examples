#include "lua.h" // for lua_State

lua_State *L;

void callFunction(int inputs, int outputs);

void doFile(const char* filePath);

int getGlobalBoolean(const char *var);

double getGlobalDouble(const char *var);

int getGlobalInt(const char *var);

const char* getGlobalString(const char *var);

void getGlobalTable(const char *var);

// This assumes that a Lua table is at the top of the stack.
// This must be defined after the `pushString` function.
int getIntTableValueForIndex(int index);

// This assumes that a Lua table is at the top of the stack.
// This must be defined after the `pushString` function.
const char* getStringTableValueForStringKey(const char *key);

void createLuaVM();

void pop(int n);

void printStack();
void printTable();

void pushBoolean(int b);
void pushFunction(const char *name);
void pushDouble(double n);
void pushInt(int n);
void pushString(const char *s);

void registerCFunction(const char* name, lua_CFunction fn);

void setTableKeyValue(const char* key, const char* value);

