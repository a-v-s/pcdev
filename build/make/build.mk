
BUILD_TYPE?=debug

ifeq ($(BUILD_TYPE),debug)
	CXXFLAGS += -g  # Generate debug information (inside the binary)
	CXXFLAGS += -O0 # Disable optimisation
	CFLAGS += -g  # Generate debug information (inside the binary)
	CFLAGS += -O0 # Disable optimisation
else 
	CXXFLAGS += -O2 # Optimise code
	CXXFLAGS += -D_FORTIFY_SOURCE=2
	CFLAGS += -O2 # Optimise code
	CFLAGS += -D_FORTIFY_SOURCE=2
endif




BUILD_DIR = $(OUT_DIR)/$(COMPILER)/$(TARGET_OS)/$(TARGET_MACHINE)/$(BUILD_TYPE)/build
EXE_DIR   = $(OUT_DIR)/$(COMPILER)/$(TARGET_OS)/$(TARGET_MACHINE)/$(BUILD_TYPE)/bin
SO_DIR    = $(OUT_DIR)/$(COMPILER)/$(TARGET_OS)/$(TARGET_MACHINE)/$(BUILD_TYPE)/lib
A_DIR     = $(OUT_DIR)/$(COMPILER)/$(TARGET_OS)/$(TARGET_MACHINE)/$(BUILD_TYPE)/slib

OUT_EXE   = $(EXE_DIR)/$(EXEPRE)$(TARGET)$(EXESUF) 
OUT_SO    = $(SO_DIR)/$(SOPRE)$(TARGET)$(SOSUF) 
OUT_A     = $(A_DIR)/$(APRE)$(TARGET)$(ASUF) 


#CXX_OBJ = $(CXX_SRC:%=$(BUILD_DIR)/%.o)
#C_OBJ = $(C_SRC:%=$(BUILD_DIR)/%.o)

# Fix for building with makefiles in a different path relative to source

PROJ_DIR?=.
ABS_CXX_SRC = $(realpath $(CXX_SRC))
ABS_C_SRC = $(realpath $(C_SRC))
REL_CXX_SRC = $(ABS_CXX_SRC:$(realpath $(PROJ_DIR))/%=%)
REL_C_SRC = $(ABS_C_SRC:$(realpath $(PROJ_DIR))/%=%)


CXX_OBJ = $(REL_CXX_SRC:%=$(BUILD_DIR)/%.o)
C_OBJ = $(REL_C_SRC:%=$(BUILD_DIR)/%.o)


# Generate dependency information
CFLAGS   +=  -MMD -MP -MF"$(@:%.o=%.d)"
CXXFLAGS +=  -MMD -MP -MF"$(@:%.o=%.d)"
ASFLAGS   += -MMD -MP -MF"$(@:%.o=%.d)"



CFLAGS   += -D__FILENAME__=\"$(notdir $<)\" 
CXXFLAGS += -D__FILENAME__=\"$(notdir $<)\" 
ASFLAGS  += -D__FILENAME__=\"$(notdir $<)\" 

ifeq ($(BUILD_LIBRARY),D)
default: $(OUT_SO)
CFLAGS   += -fPIC -DDYNAMIC_LIBRARY
CXXFLAGS += -fPIC -DDYNAMIC_LIBRARY
LDFLAGS  += -shared -fPIC
else 
ifeq ($(BUILD_LIBRARY),S)
default: $(OUT_A)
CFLAGS   += -DSTATIC_LIBRARY
CXXFLAGS += -DSTATIC_LIBRARY 
else 
default: $(OUT_EXE)
endif
endif

$(OUT_SO): $(CXX_OBJ) $(C_OBJ) 
	$(MKDIR_P) $(SO_DIR)
	$(LINK) $(CXX_OBJ) $(C_OBJ) $(LDFLAGS) -o$@

$(OUT_A): $(CXX_OBJ) $(C_OBJ)
	$(MKDIR_P) $(A_DIR)
	$(AR) rcs $@ $(CXX_OBJ) $(C_OBJ)

$(OUT_EXE): $(CXX_OBJ) $(C_OBJ)
	$(MKDIR_P) $(EXE_DIR)
	$(LINK) $(CXX_OBJ) $(C_OBJ) $(LDFLAGS) -o$@

# asm source
$(BUILD_DIR)/%.s.o: $(PROJ_DIR)/%.s
	$(MKDIR_P)  $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

# c source
$(BUILD_DIR)/%.c.o: $(PROJ_DIR)/%.c
	$(MKDIR_P)  $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.cpp.o: $(PROJ_DIR)/%.cpp
	$(MKDIR_P)  $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


clean:
	rm -rf $(BUILD_DIR) $(OUT_EXE)

################################################################################
# Dependencies
################################################################################
include $(shell find $(BUILD_DIR) -iname "*.d")
