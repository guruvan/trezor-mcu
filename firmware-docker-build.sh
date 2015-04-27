#!/bin/bash
IMAGETAG=mazaclub/trezor-mcu-build
FIRMWARETAG=${1:-master}

docker build -t $IMAGETAG:$FIRMWARETAG .
docker run -t -v $(pwd):/output $IMAGETAG:$FIRMWARETAG /bin/sh -c "\
	git clone https://github.com/mazaclub/trezor-mcu && \
	cd trezor-mcu && \
	git checkout $FIRMWARETAG && \
	git submodule update --init && \
	make && \
	cd firmware && \
	make && \
	cp trezor.bin /output && \
        shasum -a 256 -p trezor.bin \
	"

echo "---------------------"
echo "Firmware fingerprint:"
shasum -a 256 -p trezor.bin 
echo "To Install, first sign, then update the device:"
echo "python firmware/firmware_sign.py -f ./trezor.bin"
echo "python trezorctl firmware_update -f ./trezor.bin"

