COMPILER?=gcc

PCDEV_MAKE=$(PCDEV_ROOT)/build/make

include $(PCDEV_MAKE)/tag.mk
include $(PCDEV_MAKE)/os.mk
include $(PCDEV_MAKE)/cc.mk
include $(PCDEV_MAKE)/lib.mk
include $(PCDEV_MAKE)/build.mk
include $(PCDEV_MAKE)/format.mk
