HOST_OS=$(shell uname | tr A-Z a-z)
HOST_MACHINE=$(shell uname -m)

HOST_TUPLE=$(shell $(CC) -dumpmachine)

ifeq ($(MSYSTEM),MINGW32)
	TARGET_MACHINE=i686
	TARGET_TUPLE=$(TARGET_MACHINE)-msys64-windows-$(shell echo $(MSYSTEM) | tr A-Z a-z)
	COMPILER?=gcc
	CFLAGS += -D$(MSYSTEM)
	CXXFLAGS += -D$(MSYSTEM)
	ASMFLAGS += -D$(MSYSTEM)
endif

ifeq ($(MSYSTEM),MINGW64)
	TARGET_MACHINE=x86_64
	TARGET_TUPLE=$(TARGET_MACHINE)-msys64-windows-$(shell echo $(MSYSTEM) | tr A-Z a-z)
	COMPILER?=gcc
	CFLAGS += -D$(MSYSTEM)
	CXXFLAGS += -D$(MSYSTEM)
	ASMFLAGS += -D$(MSYSTEM)
endif

ifeq ($(MSYSTEM),CLANG64)
	TARGET_MACHINE=x86_64
	TARGET_TUPLE=$(TARGET_MACHINE)-msys64-windows-$(shell echo $(MSYSTEM) | tr A-Z a-z)
	COMPILER?=clang
	CFLAGS += -D$(MSYSTEM)
	CXXFLAGS += -D$(MSYSTEM)
	ASMFLAGS += -D$(MSYSTEM)
endif

ifeq ($(MSYSTEM),UCRT64)
	TARGET_MACHINE=x86_64
	TARGET_TUPLE=$(TARGET_MACHINE)-msys64-windows-$(shell echo $(MSYSTEM) | tr A-Z a-z)
	COMPILER?=gcc
	CFLAGS += -D$(MSYSTEM)
	CXXFLAGS += -D$(MSYSTEM)
	ASMFLAGS += -D$(MSYSTEM)
endif

TARGET_OS?=$(HOST_OS)
TARGET_MACHINE?=$(HOST_MACHINE)

TARGET_TUPLE?=$(HOST_TUPLE)

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


# When building for mingw (Windows) use these pre/suffixes
# Otherwise, assume a POSIX/elf style OS.
# As Windows is the exception, and we shouldn't list all
# Operating Systems here. Might add excptions in the future,
# not list the standard multiple times.
# Potentially for Darwin (macOS) support? If the PureDarwin
# project comes back to life?

ifeq ($(TARGET_OS),mingw)
	EXEPRE  :=
	EXESUF  :=.exe
	SOPRE   :=
	SOSUF   :=.dll
	APRE    :=
	ASUF    :=.a
else
ifdef MSYSTEM
EXEPRE  :=
	EXESUF  :=.exe
	SOPRE   :=
	SOSUF   :=.dll
	APRE    :=
	ASUF    :=.a
else
	EXEPRE  :=
	EXESUF  :=
	SOPRE   :=lib
	SOSUF   :=.so
	APRE    :=lib
	ASUF    :=.a
endif
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

$(info HOST_OS:        $(HOST_OS))
$(info HOST_MACHINE:   $(HOST_MACHINE))
$(info HOST_TUPLE:     $(HOST_TUPLE))
$(info TARGET_OS:      $(TARGET_OS))
$(info TARGET_MACHINE: $(TARGET_MACHINE))
$(info TARGET_TUPLE:   $(TARGET_TUPLE))
