HOST_OS=$(shell uname | tr A-Z a-z)
#HOST_MACHINE=$(shell uname -m)


ifeq ($(COMPILER),gcc) 
	HOST_TUPLE=$(shell gcc -dumpmachine)
endif

ifeq ($(COMPILER),clang) 
	HOST_TUPLE=$(shell clang -dumpmachine)
endif

# TODO Switching to TARGET_TUPLE rather then TARGET_OS requires some
# tuple parsing to make some stuff like file prefix/suffix code work

ifneq ($(TARGET_TUPLE),)

	# TODO detect gcc 32 bit (i686) compilation on 64-bit (x86_64) host
	# if this is the case, drop the prefix, add the -m32 flag
	# This is a specific GNU/Linux case, can this be made generic?
	ifeq ($(TARGET_TUPLE),i686-pc-linux-gnu)
		ifeq ($(HOST_TUPLE),x86_64-pc-linux-gnu)
			PREFIX=
			CFLAGS += -m32
			CXXFLAGS += -m32
			ASMFLAGS += -m32
			LDFLAGS += -m32
		else
			PREFIX=$(TARGET_TUPLE)-
		endif
	else
		PREFIX=$(TARGET_TUPLE)-
	endif
else
	TARGET_TUPLE=$(HOST_TUPLE)
endif

ifneq (,$(findstring mingw,$(TARGET_TUPLE)))
	TARGET_OS=mingw
endif


ifeq ($(MSYSTEM),MINGW32)
	TARGET_TUPLE=i686-msys2-$(shell echo $(MSYSTEM) | tr A-Z a-z)
	TARGET_OS=mingw
	COMPILER?=gcc
	CFLAGS += -D$(MSYSTEM)
	CXXFLAGS += -D$(MSYSTEM)
	ASMFLAGS += -D$(MSYSTEM)
endif

ifeq ($(MSYSTEM),MINGW64)
	TARGET_TUPLE=x86_64-msys2-$(shell echo $(MSYSTEM) | tr A-Z a-z)
	COMPILER?=gcc
	TARGET_OS=mingw
	CFLAGS += -D$(MSYSTEM)
	CXXFLAGS += -D$(MSYSTEM)
	ASMFLAGS += -D$(MSYSTEM)
endif

ifeq ($(MSYSTEM),CLANG64)
	TARGET_TUPLE=x86_64-msys2-$(shell echo $(MSYSTEM) | tr A-Z a-z)
	COMPILER?=clang
	TARGET_OS=mingw
	CFLAGS += -D$(MSYSTEM)
	CXXFLAGS += -D$(MSYSTEM)
	ASMFLAGS += -D$(MSYSTEM)
endif

ifeq ($(MSYSTEM),UCRT64)
	TARGET_TUPLE=x86_64-msys2-$(shell echo $(MSYSTEM) | tr A-Z a-z)
	COMPILER?=gcc
	TARGET_OS=mingw
	CFLAGS += -D$(MSYSTEM)
	CXXFLAGS += -D$(MSYSTEM)
	ASMFLAGS += -D$(MSYSTEM)
endif

TARGET_OS?=$(HOST_OS)
TARGET_TUPLE?=$(HOST_TUPLE)




# When building for mingw (Windows) use these pre/suffixes
# Otherwise, assume a POSIX/elf style OS.
# As Windows is the exception, and we shouldn't list all
# Operating Systems here. Might add excptions in the future,
# not list the standard multiple times.
# Potentially for Darwin (macOS) support? If the PureDarwin
# project comes back to life?
# It seems the darling project is taking off. Prelimary Darwin support 
# throug Darling at the moment

ifeq ($(TARGET_OS),mingw)
	EXEPRE  :=
	EXESUF  :=.exe
	SOPRE   :=
	SOSUF   :=.dll
	APRE    :=
	ASUF    :=.a
else
ifeq ($(TARGET_OS),darwin)
	EXEPRE  :=
	EXESUF  :=
	SOPRE   :=lib
	SOSUF   :=.dylib
	APRE    :=lib
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


ifeq ($(COMPILER),clang) 
	CFLAGS   += -target $(TARGET_TUPLE)
	CXXFLAGS += -target $(TARGET_TUPLE)
	LDFLAGS  += -target $(TARGET_TUPLE)
endif


$(info HOST_OS:        $(HOST_OS))
$(info HOST_TUPLE:     $(HOST_TUPLE))
$(info TARGET_OS:      $(TARGET_OS))
$(info TARGET_TUPLE:   $(TARGET_TUPLE))
