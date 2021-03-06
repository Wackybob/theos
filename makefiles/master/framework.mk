FRAMEWORK_NAME := $(strip $(FRAMEWORK_NAME))

ifeq ($(FW_RULES_LOADED),)
include $(FW_MAKEDIR)/rules.mk
endif

internal-all:: $(FRAMEWORK_NAME:=.all.framework.variables);

internal-package:: $(FRAMEWORK_NAME:=.package.framework.variables);

FRAMEWORKS_WITH_SUBPROJECTS = $(strip $(foreach framework,$(FRAMEWORK_NAME),$(patsubst %,$(framework),$($(framework)_SUBPROJECTS))))
ifneq ($(FRAMEWORKS_WITH_SUBPROJECTS),)
internal-clean:: $(FRAMEWORKS_WITH_SUBPROJECTS:=.clean.framework.subprojects)
endif

$(FRAMEWORK_NAME):
	@$(MAKE) -f $(MAKEFILE_NAME) --no-print-directory --no-keep-going $@.all.framework.variables
