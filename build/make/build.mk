-DEPENDENCIES = $(shell find $(BUILD_DIR) -iname "*.d")

BUILD_TYPE?=debug

ifeq ($(BUILD_TYPE),debug)
	CXXFLAGS += -g  # Generate debug information (inside the binary)
	CXXFLAGS += -O0 # Disable optimisation
	CXXFLAGS += -D_DEBUG
	CFLAGS += -g  # Generate debug information (inside the binary)
	CFLAGS += -O0 # Disable optimisation
	CFLAGS += -D_DEBUG
else 
	CXXFLAGS += -O2 # Optimise code
	CXXFLAGS += -D_FORTIFY_SOURCE=2
	CXXFLAGS += -D_RELEASE
	CFLAGS += -O2 # Optimise code
	CFLAGS += -D_FORTIFY_SOURCE=2
	CFLAGS += -D_RELEASE
endif




BUILD_DIR = bld/$(COMPILER)/$(TARGET_OS)/$(TARGET_MACHINE)/$(BUILD_TYPE)
OUT_DIR = out/$(COMPILER)/$(TARGET_OS)/$(TARGET_MACHINE)/$(BUILD_TYPE)
OUT_EXE = $(OUT_DIR)/$(EXEPRE)$(TARGET)$(EXESUF) 
OUT_SO = $(OUT_DIR)/$(SOPRE)$(TARGET)$(SOSUF) 
OUT_A = $(OUT_DIR)/$(APRE)$(TARGET)$(ASUF) 

CXX_OBJ = $(CXX_SRC:%=$(BUILD_DIR)/%.o)
C_OBJ = $(C_SRC:%=$(BUILD_DIR)/%.o)


# Generate dependency information
CFLAGS   +=  -MMD -MP -MF"$(@:%.o=%.d)"
CXXFLAGS +=  -MMD -MP -MF"$(@:%.o=%.d)"
ASFLAGS   += -MMD -MP -MF"$(@:%.o=%.d)"


ifeq ($(BUILD_LIBRARY),D)
default: $(OUT_SO)
CFLAGS += -fPIC
CXXFLAGS += -fPIC
LDFLAGS += -shared
else 
ifeq ($(BUILD_LIBRARY),S)
default: $(OUT_A)
else 
default: $(OUT_EXE)
endif
endif

$(OUT_SO): $(CXX_OBJ) $(C_OBJ) 
	$(MKDIR_P) $(OUT_DIR)
	$(LINK) $(CXX_OBJ) $(C_OBJ) $(LDFLAGS) -o$@

$(OUT_A): $(CXX_OBJ) $(C_OBJ)
	$(MKDIR_P) $(OUT_DIR)
	$(AR) rcs $@ $(CXX_OBJ) $(C_OBJ)

$(OUT_EXE): $(CXX_OBJ) $(C_OBJ)
	$(MKDIR_P) $(OUT_DIR)
	$(LINK) $(CXX_OBJ) $(C_OBJ) $(LDFLAGS) -o$@

# asm source
$(BUILD_DIR)/%.s.o: %.s
	$(MKDIR_P)  $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

# c source
$(BUILD_DIR)/%.c.o: %.c
	$(MKDIR_P)  $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P)  $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


clean:
	rm -rf $(BUILD_DIR) $(OUT_EXE)

################################################################################
# Dependencies
################################################################################
#-include $(wildcard $(BUILD_DIR)/*.d)
-include $(DEPENDENCIES)
