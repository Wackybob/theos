.PHONY: before-$(FW_INSTANCE)-all after-$(FW_INSTANCE)-all internal-$(FW_TYPE)-all \
	before-$(FW_INSTANCE)-package after-$(FW_INSTANCE)-package internal-$(FW_TYPE)-package
OBJCC_OBJS := $(patsubst %.mm,%.mm.o,$($(FW_INSTANCE)_OBJCC_FILES))
ifeq ($(OBJCC_OBJS),)
OBJCC_OBJS := $(patsubst %.xm,%.xm.o,$($(FW_INSTANCE)_LOGOS_FILES))
else
OBJCC_OBJS += $(patsubst %.xm,%.xm.o,$($(FW_INSTANCE)_LOGOS_FILES))
endif
OBJC_OBJS := $(patsubst %.m,%.m.o,$($(FW_INSTANCE)_OBJC_FILES))
CC_OBJS := $(patsubst %.cc,%.cc.o,$($(FW_INSTANCE)_CC_FILES))
C_OBJS := $(patsubst %.c,%.c.o,$($(FW_INSTANCE)_C_FILES))

ifneq ($($(FW_INSTANCE)_SUBPROJECTS),)
#SUBPROJECT_OBJ_FILES = $(foreach d, $($(FW_INSTANCE)_SUBPROJECTS), \ $(addprefix $(FW_BUILD_DIR)/$(d)/, $(FW_OBJ_DIR_NAME)/$(FW_SUBPROJECT_PRODUCT)))
SUBPROJECT_OBJ_FILES = $(addsuffix /$(FW_OBJ_DIR_NAME)/$(FW_SUBPROJECT_PRODUCT), $(addprefix $(FW_BUILD_DIR)/,$($(FW_INSTANCE)_SUBPROJECTS)))
endif

OBJ_FILES = $(strip $(OBJCC_OBJS) $(OBJC_OBJS) $(CC_OBJS) $(C_OBJS))
OBJ_FILES_TO_LINK = $(addprefix $(FW_OBJ_DIR)/,$(OBJ_FILES)) $($(FW_INSTANCE)_OBJ_FILES) $(SUBPROJECT_OBJ_FILES)

ADDITIONAL_CPPFLAGS += $($(FW_INSTANCE)_CPPFLAGS)
ADDITIONAL_CFLAGS += $($(FW_INSTANCE)_CFLAGS)
ADDITIONAL_OBJCFLAGS += $($(FW_INSTANCE)_OBJCFLAGS)
ADDITIONAL_CCFLAGS += $($(FW_INSTANCE)_CCFLAGS)
ADDITIONAL_OBJCCFLAGS += $($(FW_INSTANCE)_OBJCCFLAGS)
ADDITIONAL_LDFLAGS += $($(FW_INSTANCE)_LDFLAGS)

# If we have any Objective-C objects, link Foundation and libobjc.
ifneq ($(words $(OBJC_OBJS)$(OBJCC_OBJS)),0)
	AUXILIARY_LDFLAGS += -lobjc -framework Foundation -framework CoreFoundation

	# Add all frameworks from the type and instance.
	AUXILIARY_LDFLAGS += $(foreach framework,$($(FW_TYPE)_FRAMEWORKS),-framework $(framework))
	AUXILIARY_LDFLAGS += $(foreach framework,$($(FW_INSTANCE)_FRAMEWORKS),-framework $(framework))

	# Add all private frameworks from the type and instance, as well as -F for the private framework dir.
	ifneq ($(words $($(FW_TYPE)_PRIVATE_FRAMEWORKS)$($(FW_INSTANCE)_PRIVATE_FRAMEWORKS)),0)
		AUXILIARY_OBJCFLAGS += -F/System/Library/PrivateFrameworks
		AUXILIARY_LDFLAGS += -F/System/Library/PrivateFrameworks
	endif

	AUXILIARY_LDFLAGS += $(foreach framework,$($(FW_TYPE)_PRIVATE_FRAMEWORKS),-framework $(framework))
	AUXILIARY_LDFLAGS += $(foreach framework,$($(FW_INSTANCE)_PRIVATE_FRAMEWORKS),-framework $(framework))
endif

# In addition, if we have any Objective-C++, add the ObjC++ linker flags.
ifneq ($(words $(OBJCC_OBJS)),0)
	AUXILIARY_LDFLAGS += -ObjC++ -fobjc-exceptions -fobjc-call-cxx-cdtors
endif

before-$(FW_INSTANCE)-all::

after-$(FW_INSTANCE)-all::

internal-$(FW_TYPE)-all:: before-$(FW_INSTANCE)-all internal-$(FW_TYPE)-all_ after-$(FW_INSTANCE)-all

before-$(FW_INSTANCE)-package::

after-$(FW_INSTANCE)-package::

internal-$(FW_TYPE)-package:: before-$(FW_INSTANCE)-package internal-$(FW_TYPE)-package_ after-$(FW_INSTANCE)-package

