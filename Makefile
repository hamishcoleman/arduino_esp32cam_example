#
#
#

SKETCH := CameraWebServer.ino

BOARD := esp32:esp32:esp32cam
PACKAGE_URL := https://dl.espressif.com/dl/package_esp32_index.json

BOARD_FILENAME_SLUG := $(subst :,.,$(BOARD))

all: $(SKETCH).$(BOARD_FILENAME_SLUG).bin

# I dont want to use curl|sh, but this is the documented install method ...
ARDUINO_URL := https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh
bin/arduino-cli: /usr/bin/curl
	curl -fsSL $(ARDUINO_URL) | sh

.PHONY: $(BOARD_FILENAME_SLUG)
$(BOARD_FILENAME_SLUG): bin/arduino-cli
	~/bin/arduino-cli config init --additional-urls $(PACKAGE_URL)
	~/bin/arduino-cli core update-index
	arduino-cli core install esp32:esp32

build-deps:
	sudo apt-get -y install curl
	$(MAKE) $(BOARD_FILENAME_SLUG)

%.ino.$(BOARD_FILENAME_SLUG).bin: %.ino
	arduino-cli compile -b $(BOARD) $<
