
ifeq ($(COMPILER),gcc) 
	CC=$(PREFIX)gcc
	CXX=$(PREFIX)g++
#	LINKCXX=$(CXX)
#	LINKC=$(CC)
	AR=$(PREFIX)ar
	AS=$(PREFIX)as
else
ifeq ($(COMPILER),clang) 
	CC=clang
	CXX=clang++
#	LINKCXX=$(CXX)
#	LINKC=$(CC)
	AR=llvm-ar
	AS=llvm-as
endif
endif



#CXXFLAGS += -Werror
CXXFLAGS += -Wall

# For GCC, gnu++23 and gnu++2b are equivalent, but clang only accepts 2b
CXXFLAGS += --std=gnu++23
#CXXFLAGS += --std=gnu++2b
#CXXFLAGS += --std=gnu++26 # starting gcc 14

#CFLAGS += -Werror
CFLAGS += -Wall
#CFLAGS += --std=gnu2x
CFLAGS += --std=gnu23

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
ACTUAL_CC := $(CC)
ACTUAL_CXX := $(CXX)
ACTUAL_AS := $(AS)
ACTUAL_AR := $(AR)
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

