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

# -----------------------------------------------------------------------------
# packaging specific

ifeq (postpackaging,$(findstring $(MAKECMDGOALS),postpackaging))
  PACKAGE_FILENAME=$(PACKAGE_NAME)-$(PACKAGE_VERSION).tar.bz2
  PACKAGE_CHKSUM := $(firstword $(shell shasum -a 256 "$(PACKAGE_FILENAME)"))
  PACKAGE_SIZE := $(firstword $(shell wc -c "$(PACKAGE_FILENAME)"))
endif

# end of packaging specific
# -----------------------------------------------------------------------------

.PHONY: all clean cmsis5 cmsis6 cmsis_dsp cmsis_nn print_info postpackaging

# Arduino module packaging:
#   - exclude version control system files, here git files and folders .git, .gitattributes and .gitignore
#   - exclude 'extras' folder
all: cmsis6 cmsis_dsp cmsis_nn

cmsis6: PACKAGE_NAME := "CMSIS"
cmsis6: PACKAGE_FOLDER := CMSIS_6
cmsis6: PACKAGE_VERSION := $(shell git --git-dir=$(PACKAGE_FOLDER)/.git describe --tags |  sed 's/^v//')
cmsis6: PACKAGE_DATE := $(firstword $(shell git --git-dir=$(PACKAGE_FOLDER)/.git log -1 --pretty=format:%ci))
cmsis6: clean print_info
	@echo ----------------------------------------------------------
	@echo "Packaging module."
	@tar --mtime='$(PACKAGE_DATE)' \
		--exclude=.github \
		--exclude=CMSIS/CoreValidation \
		--exclude=CMSIS/Documentation \
		--exclude=CMSIS/Driver \
		--exclude=.git \
		--exclude=.gitignore \
		--exclude=gen_pack.sh \
		--exclude=.devcontainer \
		--transform "s|CMSIS_6|CMSIS|" \
		-cjf "$(PACKAGE_NAME)-$(PACKAGE_VERSION).tar.bz2" "$(PACKAGE_FOLDER)"
	$(MAKE) PACKAGE_NAME=$(PACKAGE_NAME) PACKAGE_VERSION=$(PACKAGE_VERSION) CMSIS_VERSION=$(PACKAGE_VERSION) --no-builtin-rules postpackaging -C .
	@echo ----------------------------------------------------------

cmsis_dsp: PACKAGE_NAME := "CMSIS_DSP"
cmsis_dsp: PACKAGE_FOLDER := CMSIS-DSP
cmsis_dsp: PACKAGE_VERSION := $(shell git --git-dir=$(PACKAGE_FOLDER)/.git describe --tags |  sed 's/^v//')
cmsis_dsp: PACKAGE_DATE := $(firstword $(shell git --git-dir=$(PACKAGE_FOLDER)/.git log -1 --pretty=format:%ci))
cmsis_dsp: CMSIS_VERSION := $(shell git --git-dir=CMSIS_6/.git describe --tags |  sed 's/^v//')
cmsis_dsp: clean print_info
	@echo ----------------------------------------------------------
	@echo "Packaging module."
	@tar --mtime='$(PACKAGE_DATE)' \
		--exclude=.github \
		--exclude=cmsisdsp \
		--exclude=Documentation \
		--exclude=dsppp \
		--exclude=Examples \
		--exclude=PythonWrapper \
		--exclude=Scripts \
		--exclude=Testing \
		--exclude=.git \
		--exclude=.gitignore \
		--exclude=CMakeLists.txt \
		--exclude=gen_pack.sh \
		--exclude=MANIFEST.in \
		--exclude=pyproject.toml \
		--exclude=PythonWrapper_README.md \
		--exclude=setup.py \
		--exclude=vcpkg-configuration.json \
		--transform "s|CMSIS-DSP|CMSIS_DSP|" \
		-cjf "$(PACKAGE_NAME)-$(PACKAGE_VERSION).tar.bz2" "$(PACKAGE_FOLDER)"
	$(MAKE) PACKAGE_NAME=$(PACKAGE_NAME) PACKAGE_VERSION=$(PACKAGE_VERSION) CMSIS_VERSION=$(CMSIS_VERSION) --no-builtin-rules postpackaging -C .
	@echo ----------------------------------------------------------

cmsis_nn: PACKAGE_NAME := "CMSIS_NN"
cmsis_nn: PACKAGE_FOLDER := CMSIS-NN
cmsis_nn: PACKAGE_VERSION := $(shell git --git-dir=$(PACKAGE_FOLDER)/.git describe --tags |  sed 's/^v//')
cmsis_nn: PACKAGE_DATE := $(firstword $(shell git --git-dir=$(PACKAGE_FOLDER)/.git log -1 --pretty=format:%ci))
cmsis_nn: CMSIS_VERSION := $(shell git --git-dir=CMSIS_6/.git describe --tags |  sed 's/^v//')
cmsis_nn: clean print_info
	@echo ----------------------------------------------------------
	@echo "Packaging module."
	@tar --mtime='$(PACKAGE_DATE)' \
		--exclude=.github \
		--exclude=Documentation \
		--exclude=Examples \
		--exclude=Tests \
		--exclude=.git \
		--exclude=.clang-format \
		--exclude=.gitignore \
		--exclude=check_pdsc.sh \
		--exclude=check_version_and_date.sh \
		--exclude=CMakeLists.txt \
		--exclude=gen_pack.sh \
		--transform "s|CMSIS-NN|CMSIS_NN|" \
		-cjf "$(PACKAGE_NAME)-$(PACKAGE_VERSION).tar.bz2" "$(PACKAGE_FOLDER)"
	$(MAKE) PACKAGE_NAME=$(PACKAGE_NAME) PACKAGE_VERSION=$(PACKAGE_VERSION) CMSIS_VERSION=$(CMSIS_VERSION) --no-builtin-rules postpackaging -C .
	@echo ----------------------------------------------------------

cmsis5: PACKAGE_NAME := "CMSIS"
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
		--exclude=CMSIS/DSP/cmsisdsp \
		--exclude=CMSIS/DSP/Examples \
		--exclude=CMSIS/DSP/Platforms \
		--exclude=CMSIS/DSP/PythonWrapper \
		--exclude=CMSIS/DSP/Scripts \
		--exclude=CMSIS/DSP/SDFTools \
		--exclude=CMSIS/DSP/Testing \
		--exclude=CMSIS/DSP/Toolchain \
		--exclude=CMSIS/NN/Examples \
		--exclude=CMSIS/NN/Scripts \
		--exclude=CMSIS/NN/Tests \
		--exclude=CMSIS/Pack \
		--exclude=CMSIS/RTOS/RTX/LIB \
		--exclude=CMSIS/RTOS/RTX/SRC/ARM \
		--exclude=CMSIS/RTOS/RTX/SRC/IAR \
		--exclude=CMSIS/RTOS2/RTX/Examples* \
		--exclude=CMSIS/RTOS2/RTX/Library/ARM \
		--exclude=CMSIS/RTOS2/RTX/Library/IAR \
		--exclude=CMSIS/RTOS2/RTX/Source/ARM \
		--exclude=CMSIS/RTOS2/RTX/Source/IAR \
		--exclude=CMSIS/Utilities \
		--exclude=Device/_Template_Vendor/Vendor/Device/Source/ARM \
		--exclude=Device/_Template_Vendor/Vendor/Device/Source/IAR \
		--exclude=Device/_Template_Vendor/Vendor/Device_A \
		--exclude=Device/ARM/*/Source/AC5 \
		--exclude=Device/ARM/*/Source/AC6 \
		--exclude=Device/ARM/*/Source/ARM \
		--exclude=Device/ARM/*/Source/IAR \
		--exclude=Device/Utilities \
		--exclude=docker \
		--exclude=*.cmake \
		--exclude=CMakeLists.txt \
		--exclude=.git \
		--exclude=.gitignore \
		--exclude=.gitattributes \
		--exclude=.github \
		--exclude=manifest \
		--exclude=*.pdf \
		--exclude=*.py \
		--exclude=*.scvd \
		--transform "s|CMSIS_5|CMSIS|" \
		-cjf "$(PACKAGE_NAME)-$(PACKAGE_VERSION).tar.bz2" "$(PACKAGE_FOLDER)"
	$(MAKE) PACKAGE_NAME=$(PACKAGE_NAME) PACKAGE_VERSION=$(PACKAGE_VERSION) --no-builtin-rules postpackaging -C .
	@echo ----------------------------------------------------------

clean:
	@echo ----------------------------------------------------------
	@echo  Cleanup
	-$(RM) CMSIS*-*.tar.bz2 package_CMSIS*_*.json test_package_CMSIS*_*.json
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
	@cat extras/package_index.json.template | sed s/%%PACKAGENAME%%/$(PACKAGE_NAME)/ | sed s/%%VERSION%%/$(PACKAGE_VERSION)/ | sed s/%%CMSISVERSION%%/$(CMSIS_VERSION)/ | sed s/%%FILENAME%%/$(PACKAGE_FILENAME)/ | sed s/%%CHECKSUM%%/$(PACKAGE_CHKSUM)/ | sed s/%%SIZE%%/$(PACKAGE_SIZE)/ > package_$(PACKAGE_NAME)_$(PACKAGE_VERSION)_index.json
	@echo "package_$(PACKAGE_NAME)_$(PACKAGE_VERSION)_index.json created"
