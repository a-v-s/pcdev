LDFLAGS  +=   $(foreach lib, $(LIBS), $(shell $(PREFIX)pkg-config --libs   $(lib) ) )
LIB_CFLAGS =  $(foreach lib, $(LIBS), $(shell $(PREFIX)pkg-config --cflags $(lib) ) )
CFLAGS   += $(LIB_CFLAGS)
CXXFLAGS += $(LIB_CFLAGS)

