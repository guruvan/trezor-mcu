TREZOR Firmware
===============

http://bitcointrezor.com/

How to build Trezor firmware?
-----------------------------

1. Install Docker (from docker.com or from your distribution repositories)
2. ``git clone https://github.com/trezor/trezor-mcu.git``
3. ``cd trezor-mcu``
4. ``./firmware-docker-build.sh TAG`` (where TAG is v1.3.2 for example, if left blank the script builds latest commit)

This will build a docker image ``mazaclub/trezor-mcu-build:$FIRMWARETAG`` 
Mazaclub versions reflect the upstream versions, with additional mazaclub enhancements (coins)

This creates trezor.bin in current directory and prints its fingerprint from inside and out of the container at the last lines of the build log.

How to install your new firmware?
--------------------------------
1. Build as above
2. Put device into bootloader mode
   - restart device pressing both buttons
3. ``python bootloader/firmware_sign.py -f ./trezor.bin``
4. ``trezorctl firmware_update -f ./trezor.bin``
5. Ensure shasums match
6. ``trezorctl list_coins`` to see the new coins available


How to get fingerprint of firmware signed and distributed by SatoshiLabs?
-------------------------------------------------------------------------

1. Pick version of firmware binary listed on https://mytrezor.com/data/firmware/releases.json
2. Download it: ``wget -O trezor.signed.bin.hex https://mytrezor.com/data/firmware/trezor-1.1.0.bin.hex``
3. ``xxd -r -p trezor.signed.bin.hex trezor.signed.bin``
4. ``./firmware-fingerprint.sh trezor.signed.bin``

Step 4 should produce the same sha256 fingerprint like your local build (for the same version tag).

The reasoning for ``firmware-fingerprint.sh`` script is that signed firmware has special header holding signatures themselves, which must be avoided while calculating the fingerprint.
