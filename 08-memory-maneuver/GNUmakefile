export GNUSTEP_MAKEFILES=/usr/share/GNUstep/Makefiles
include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = PartOne
PartOne_HEADERS =
PartOne_OBJC_FILES = main.m
PartOne_RESOURCE_FILES =

include $(GNUSTEP_MAKEFILES)/tool.make

test: all
	./obj/PartOne < ./test.txt
	./obj/PartOne < ./input.txt
