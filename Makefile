#
#
#

SKETCH := CameraWebServer.ino
BOARD := esp32:esp32:esp32cam

BOARD_FILENAME_SLUG := $(subst :,.,$(BOARD))

all: $(SKETCH).$(BOARD_FILENAME_SLUG).bin


PACKAGE_URL := https://dl.espressif.com/dl/package_esp32_index.json
# Note that the package URL is sometimes documented as
# https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
# At the time of writing these two urls resulted in byte-for-byte identical
# files, so I used the shorter URL
# I dont want to use curl|sh, but this is the documented install method ...


ARDUINO_URL := https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh
bin/arduino-cli: /usr/bin/curl
	mkdir -p bin
	curl -fsSL $(ARDUINO_URL) | BINDIR=bin sh

.PHONY: $(BOARD_FILENAME_SLUG)
$(BOARD_FILENAME_SLUG): bin/arduino-cli
	bin/arduino-cli config init --additional-urls $(PACKAGE_URL)
	bin/arduino-cli core update-index
	bin/arduino-cli core install esp32:esp32

build-deps:
	sudo apt-get -y install curl
	$(MAKE) $(BOARD_FILENAME_SLUG)

%.ino.$(BOARD_FILENAME_SLUG).bin: %.ino
	bin/arduino-cli compile -b $(BOARD) $<
