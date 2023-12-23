LDFLAGS += 	$(shell $(PREFIX)pkg-config --libs   sdl2)
INCLUDES += $(shell $(PREFIX)pkg-config --cflags sdl2)

LDFLAGS += 	$(shell $(PREFIX)pkg-config --libs   jsoncpp)
INCLUDES += $(shell $(PREFIX)pkg-config --cflags jsoncpp)

# No pkg-config support for imgui
# Disabled until we have the MSYS2 version ready
# LDFLAGS += -limgui


# Catch2 and cxxopts are header-onlym no libraries to link, so we don't
# need a os-specific prefix when cross-compiling
# however... /usr/include would not be included when cross-compiling. 
INCLUDES += $(shell pkg-config --cflags catch2)
INCLUDES += $(shell pkg-config --cflags cxxopts)

ifeq ($(TARGET_OS),mingw)
	LDFLAGS += -lws2_32
endif

