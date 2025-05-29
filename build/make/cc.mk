ifeq ($(COMPILER),gcc) 
	CC=$(PREFIX)gcc
	CXX=$(PREFIX)g++
	AR=$(PREFIX)ar
	AS=$(PREFIX)as
else
ifeq ($(COMPILER),clang) 
	CC=clang
	CXX=clang++
	AR=llvm-ar
	AS=llvm-as
endif
endif

# Get the compiler version
CC_VERSION       := $(shell $(CC) -dumpversion)
# Replaqce dot with space
CC_VERSION_SPACE := $(subst ., ,$(CC_VERSION))
# Split on space, get first, second, third word
CC_VERSION_MAJOR := $(word 1,$(CC_VERSION_SPACE))
CC_VERSION_MINOR := $(word 2,$(CC_VERSION_SPACE))
CC_VERSION_PATCH := $(word 3,$(CC_VERSION_SPACE))

$(info Compiler: $(COMPILER) version $(CC_VERSION_MAJOR))


ifeq ($(COMPILER),gcc) 
	# Select the greatest C version for the gcc version
	ifeq ($(shell test $(CC_VERSION_MAJOR) -ge 14; echo $$?),0)
		CFLAGS   += --std=gnu23
	else
	ifeq ($(shell test $(CC_VERSION_MAJOR) -ge 8; echo $$?),0)
		CFLAGS += --std=gnu17
	else
	ifeq ($(shell test $(CC_VERSION_MAJOR) -ge 5; echo $$?),0)
		CFLAGS += --std=gnu11
	else
		CFLAGS += --std=gnu99
	endif
	endif
	endif

	# Select the greatest C++ version for the gcc version
	ifeq ($(shell test $(CC_VERSION_MAJOR) -ge 14; echo $$?),0)
		CXXFLAGS += --std=gnu++26
	else
	ifeq ($(shell test $(CC_VERSION_MAJOR) -ge 11; echo $$?),0)
		CXXFLAGS += --std=gnu++23
	ifeq ($(shell test $(CC_VERSION_MAJOR) -ge 10; echo $$?),0)
		CXXFLAGS += --std=gnu++20
	else
	ifeq ($(shell test $(CC_VERSION_MAJOR) -ge 5; echo $$?),0)
		CXXFLAGS += --std=gnu++17
	else
		CXXFLAGS += --std=gnu++11
	endif
	endif
	endif
	endif
else
ifeq ($(COMPILER),clang) 
	# Select the greatest C version for the clang version
	ifeq ($(shell test $(CC_VERSION_MAJOR) -gt 18; echo $$?),0)
		CFLAGS += --std=gnu23
	else 
	ifeq ($(shell test $(CC_VERSION_MAJOR) -gt 6; echo $$?),0)
		CFLAGS += --std=gnu17
	else 
	ifeq ($(shell test $(CC_VERSION_MAJOR) -gt 4; echo $$?),0)
		CFLAGS += --std=gnu11
	else
		CFLAGS += --std=gnu99
	endif
	endif
	endif

	# Select the greatest C++ version for the clang version
	ifeq ($(shell test $(CC_VERSION_MAJOR) -ge 17; echo $$?),0)
		CXXFLAGS += --std=gnu++26
	else
	ifeq ($(shell test $(CC_VERSION_MAJOR) -ge 12; echo $$?),0)
		CXXFLAGS += --std=gnu++2b
	else
	ifeq ($(shell test $(CC_VERSION_MAJOR) -ge 10; echo $$?),0)
		CXXFLAGS += --std=gnu++20
	else
	ifeq ($(shell test $(CC_VERSION_MAJOR) -ge 5; echo $$?),0)
		CXXFLAGS += --std=gnu++17
	else
		CXXFLAGS += --std=gnu++11
	endif
	endif
	endif
	endif
endif
endif

CXXFLAGS += -Wall
CFLAGS += -Wall

ifeq ($(CXX_SRC),)
	LINK := $(CC)
else
	LINK := $(CXX)
endif


ASFLAGS  += $(foreach d, $(AS_INCLUDES),  -I$d)
CFLAGS   += $(foreach d, $(C_INCLUDES),   -I$d)
CXXFLAGS += $(foreach d, $(CXX_INCLUDES), -I$d)

################################################################################
## Add verbose option													       #
################################################################################
V ?= 0
ACTUAL_CC   := $(CC)
ACTUAL_CXX  := $(CXX)
ACTUAL_AS   := $(AS)
ACTUAL_AR   := $(AR)
ACTUAL_LINK := $(LINK)


CC_0 =  @echo "Compiling     $<..."; $(ACTUAL_CC)
CC_1 =  $(ACTUAL_CC)
CC =    $(CC_$(V))

CXX_0 = @echo "Compiling     $<..."; $(ACTUAL_CXX)
CXX_1 = $(ACTUAL_CXX)
CXX =   $(CXX_$(V))

AS_0 =  @echo "Assembling    $<..."; $(ACTUAL_AS)
AS_1 =  $(ACTUAL_AS)
AS =    $(AS_$(V))

AR_0 =  @echo "Archiving     $@..."; $(ACTUAL_AR)
AR_1 =  $(ACTUAL_AR)
AR =    $(AR_$(V))

LINK_0 =@echo "Linking       $@..."; $(ACTUAL_LINK)
LINK_1 =$(ACTUAL_LINK)
LINK =  $(LINK_$(V))

MKDIR_P0 = @mkdir -p
MKDIR_P1 = mkdir -p
MKDIR_P = $(MKDIR_P$(V))

