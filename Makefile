#
#  ARM CMSIS Arduino IDE Module makefile.
#
#  Copyright (c) 2015 Atmel Corp./Thibaut VIARD. All right reserved.
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2.1 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#  See the GNU Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

SHELL = /bin/sh

.SUFFIXES: .tar.bz2

ROOT_PATH := .

OS ?=$(shell uname -s)

PACKAGE_NAME := "CMSIS"

# -----------------------------------------------------------------------------
# packaging specific

ifeq (postpackaging,$(findstring $(MAKECMDGOALS),postpackaging))
  PACKAGE_FILENAME=$(PACKAGE_NAME)-$(PACKAGE_VERSION).tar.bz2
  PACKAGE_CHKSUM := $(firstword $(shell shasum -a 256 "$(PACKAGE_FILENAME)"))
  PACKAGE_SIZE := $(firstword $(shell wc -c "$(PACKAGE_FILENAME)"))
endif

# end of packaging specific
# -----------------------------------------------------------------------------

.PHONY: all clean cmsis cmsis5 print_info postpackaging

# Arduino module packaging:
#   - exclude version control system files, here git files and folders .git, .gitattributes and .gitignore
#   - exclude 'extras' folder
all: cmsis cmsis5

cmsis: PACKAGE_VERSION := 4.5.0
cmsis: PACKAGE_FOLDER := CMSIS
cmsis: clean print_info
	@echo ----------------------------------------------------------
	@echo "Packaging module."
	@tar --exclude=./.gitattributes \
		--exclude=./.travis.yml \
		--exclude=CMSIS/index.html \
		--exclude=CMSIS/Documentation \
		--exclude=CMSIS/Pack \
		--exclude=CMSIS/Utilities \
		--exclude=CMSIS/DSP_Lib/Examples \
		--exclude=Device/ARM/Documents \
		--exclude=.git \
		-cjf "$(PACKAGE_NAME)-$(PACKAGE_VERSION).tar.bz2" "$(PACKAGE_FOLDER)"
	$(MAKE) PACKAGE_VERSION=$(PACKAGE_VERSION) --no-builtin-rules postpackaging -C .
	@echo ----------------------------------------------------------

cmsis5: PACKAGE_FOLDER := CMSIS_5
cmsis5: PACKAGE_VERSION := $(shell git --git-dir=$(PACKAGE_FOLDER)/.git describe --tags)
cmsis5: PACKAGE_DATE := $(firstword $(shell git --git-dir=$(PACKAGE_FOLDER)/.git log -1 --pretty=format:%ci))
cmsis5: clean print_info
	@echo ----------------------------------------------------------
	@echo "Packaging module."
	@tar --mtime='$(PACKAGE_DATE)' \
		--exclude=docs \
		--exclude=CMSIS/CoreValidation \
		--exclude=CMSIS/Documentation \
		--exclude=CMSIS/DoxyGen \
		--exclude=CMSIS/DAP/Firmware/Examples/ \
		--exclude=CMSIS/DSP/DSP_Lib_TestSuite \
		--exclude=CMSIS/DSP/Examples \
		--exclude=CMSIS/DSP/Lib/ARM \
		--exclude=CMSIS/DSP/Lib/ARMCLANG \
		--exclude=CMSIS/DSP/Lib/IAR \
		--exclude=CMSIS/DSP/Projects \
		--exclude=CMSIS/NN/Examples \
		--exclude=CMSIS/NN/NN_Lib_Tests \
		--exclude=CMSIS/Pack \
		--exclude=CMSIS/RTOS/RTX/Library/ARM \
		--exclude=CMSIS/RTOS/RTX/Library/IAR \
		--exclude=CMSIS/RTOS2/RTX/Examples \
		--exclude=CMSIS/RTOS2/RTX/Library/ARM \
		--exclude=CMSIS/RTOS2/RTX/Library/IAR \
		--exclude=CMSIS/Utilities \
		--exclude=.git \
		--exclude=.gitignore \
		--exclude=.gitattributes \
		--exclude=manifest \
		--exclude=*.pdf \
		--transform "s|CMSIS_5|CMSIS|" \
		-cjf "$(PACKAGE_NAME)-$(PACKAGE_VERSION).tar.bz2" "$(PACKAGE_FOLDER)"
	$(MAKE) PACKAGE_VERSION=$(PACKAGE_VERSION) --no-builtin-rules postpackaging -C .
	@echo ----------------------------------------------------------

clean:
	@echo ----------------------------------------------------------
	@echo  Cleanup
	-$(RM) $(PACKAGE_NAME)-*.tar.bz2 package_$(PACKAGE_NAME)_*.json test_package_$(PACKAGE_NAME)_*.json
	@echo ----------------------------------------------------------

print_info:
	@echo ----------------------------------------------------------
	@echo Building $(PACKAGE_NAME) using
	@echo "CURDIR              = $(CURDIR)"
	@echo "OS                  = $(OS)"
	@echo "SHELL               = $(SHELL)"
	@echo "PACKAGE_NAME        = $(PACKAGE_NAME)"
	@echo "PACKAGE_FOLDER      = $(PACKAGE_FOLDER)"
	@echo "PACKAGE_VERSION     = $(PACKAGE_VERSION)"


postpackaging:
	@echo "PACKAGE_CHKSUM      = $(PACKAGE_CHKSUM)"
	@echo "PACKAGE_SIZE        = $(PACKAGE_SIZE)"
	@echo "PACKAGE_FILENAME    = $(PACKAGE_FILENAME)"
	@cat extras/package_index.json.template | sed s/%%VERSION%%/$(PACKAGE_VERSION)/ | sed s/%%FILENAME%%/$(PACKAGE_FILENAME)/ | sed s/%%CHECKSUM%%/$(PACKAGE_CHKSUM)/ | sed s/%%SIZE%%/$(PACKAGE_SIZE)/ > package_$(PACKAGE_NAME)_$(PACKAGE_VERSION)_index.json
	@echo "package_$(PACKAGE_NAME)_$(PACKAGE_VERSION)_index.json created"
