HOST_OS=$(shell uname | tr A-Z a-z)
HOST_MACHINE=$(shell uname -m)

ifeq ($(MSYSTEM),MINGW32)
    TARGET_OS=mingw
	TARGET_MACHINE=i686
	COMPILER?=gcc
endif

ifeq ($(MSYSTEM),MINGW64)
    TARGET_OS=mingw
	TARGET_MACHINE=x86_64
	COMPILER?=gcc
endif

ifeq ($(MSYSTEM),CLANG32)
    TARGET_OS=mingw
	TARGET_MACHINE=i686
	COMPILER?=clang
endif

ifeq ($(MSYSTEM),CLANG64)
    TARGET_OS=mingw
	TARGET_MACHINE=x86_64
	COMPILER?=clang
endif


# Under MSYS, uname returns a string like MINGW64_NT-10.0-19043
# We are not interested in the version, so we replace the string here
ifneq (,$(findstring mingw64,$(HOST_OS)))
		HOST_OS=mingw
endif

ifneq (,$(findstring mingw32,$(HOST_OS)))
        HOST_OS=mingw
endif



TARGET_OS?=$(HOST_OS)
TARGET_MACHINE?=$(HOST_MACHINE)
$(info HOST:   $(HOST_OS))
$(info TARGET: $(TARGET_OS))

ifneq ($(TARGET_OS),mingw)
  ifneq ($(HOST_MACHINE),$(TARGET_MACHINE))
  $(info Cross compilation, Host $(HOST_MACHINE) Target $(TARGET_MACHINE) )
  ifeq ($(HOST_MACHINE),x86_64)
    ifeq ($(TARGET_MACHINE),i686)
      CFLAGS += -m32
      CXXFLAGS += -m32
      LDFLAGS += -m32
      PKG_CONFIG_PATH=/usr/lib32/pkgconfig/
    else
      $(error this cross compilation option is not yet supported)
    endif
  else
    $(error this cross compilation option is not yet supported)
  endif
endif
endif


ifeq ($(TARGET_OS),mingw)
	EXESUF=.exe
endif

ifeq ($(COMPILER),gcc) 
  ifneq ($(HOST_OS),$(TARGET_OS))
    ifeq ($(TARGET_OS),mingw)
      ifeq ($(TARGET_MACHINE),x86_64)
        PREFIX=x86_64-w64-mingw32-
      endif
      ifeq ($(TARGET_MACHINE),i686)
        PREFIX=i686-w64-mingw32-
      endif
    endif
  endif	
endif

ifeq ($(COMPILER),clang) 
  ifeq ($(TARGET_OS),mingw)
    ifeq ($(TARGET_MACHINE),x86_64)
      CFLAGS   += -target x86_64-w64-mingw32
      CXXFLAGS += -target x86_64-w64-mingw32
	  LDFLAGS += -target x86_64-w64-mingw32
    endif
    ifeq ($(TARGET_MACHINE),i686)
      CFLAGS   += -target i686-w64-mingw32
      CXXFLAGS += -target i686-w64-mingw32
	  LDFLAGS += -target i686-w64-mingw32
    endif
  endif
endif

