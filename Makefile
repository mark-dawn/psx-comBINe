#Output directories
SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin

#TARGET
TARGET := $(BIN_DIR)/psx-combine

#Source files
SRCS := $(wildcard $(SRC_DIR)/*.cpp)
#Objects derived from Sources
OBJS := $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRCS))

#Compiler
CC      := g++
win32CC := i686-w64-mingw32-g++
win64CC := x86_64-w64-mingw32-g++

#Flags
CPPFLAGS  := -Iinclude -MMD -MP
CFLAGS    := -Wall -std=c++17
LDLIBS    := -lm
winCFLAGS := -Wall -std=c++17 -static-libgcc -static-libstdc++
winLDLIBS := -lm -static


# Windows needs -static link and static cflags

.PHONY: all win32 win64 install clean

all: $(TARGET)

#Change the compiler and linker flags then run all
win32:
	$(MAKE) CC=$(win32CC) CFLAGS="$(winCFLAGS)" LDLIBS="$(winLDLIBS)" all
	
win64:
	$(MAKE) CC=$(win64CC) CFLAGS="$(winCFLAGS)" LDLIBS="$(winLDLIBS)" all

#Make binary
$(TARGET): $(OBJS) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

#Make objects
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@ 

#Create obj and bin directory if they don't exist
$(BIN_DIR) $(OBJ_DIR):
	mkdir -p $@

install: $(TARGET)
	mv ./$(TARGET) /usr/local/bin/
	
#Remove objects and binary
clean:
	@$(RM) -rv $(BIN_DIR) $(OBJ_DIR)

-include $(OBJ:.o=.d)
