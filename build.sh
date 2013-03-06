#!/bin/bash -e

#  build.sh
#  xcodeavr
#
#  Created by Furkan Mustafa on 3/6/13.
#  copyleft (c) 2013 fume.jp All rights left. Have fun. No warranties btw.

#!/bin/bash

# CROSSPACK-AVR
if [ -d /usr/local/CrossPack-AVR ]; then

CC="/usr/local/CrossPack-AVR/bin/avr-gcc"
OBJCOPY="/usr/local/CrossPack-AVR/bin/avr-objcopy"
AVRDUDE="/usr/local/CrossPack-AVR/bin/avrdude"
OBJDUMP="/usr/local/CrossPack-AVR/bin/avr-objdump"
SIZE="/usr/local/CrossPack-AVR/bin/avr-size"
NM="/usr/local/CrossPack-AVR/bin/avr-nm"

# HOMEBREW / https://github.com/larsimmisch/homebrew-avr
else
CC="/usr/local/bin/avr-gcc"
OBJCOPY="/usr/local/bin/avr-objcopy"
AVRDUDE="/usr/local/bin/avrdude"
OBJDUMP="/usr/local/bin/avr-objdump"
SIZE="/usr/local/bin/avr-size"
NM="/usr/local/bin/avr-nm"

fi

ALL_CFLAGS="-mmcu=${MCU} -I. ${CFLAGS} ${GENDEPFLAGS}"
ALL_ASFLAGS="-mmcu=${MCU} -I. -x assembler-with-cpp ${ASFLAGS}"

PATH="${PATH}:/usr/local/bin"

mkdir -p ${BUILD_DIR}
mkdir -p ${BUILT_PRODUCTS_DIR}
mkdir -p ${OBJECT_FILE_DIR}

rm -f ${OBJECT_FILE_DIR}/*.o
rm -f ${BUILD_DIR}/*.elf
rm -f ${BUILD_DIR}/*.eep
rm -f ${BUILD_DIR}/*.lss
rm -f ${BUILD_DIR}/*.sym
rm -f ${SRCROOT}/*.map
rm -f ${BUILT_PRODUCTS_DIR}/*.hex
if [ -e ${BUILD_DIR}/loader ]; then
	rm -f ${BUILD_DIR}/loader
fi
if [ -e ${SRCROOT}/${PRODUCT_NAME}.hex ]; then
	rm ${SRCROOT}/${PRODUCT_NAME}.hex
fi

find ${SRCROOT} -name "*.c" | while read cfile; do
	echo "Compiling `basename ${cfile}`"
	${CC} -c ${ALL_CFLAGS} ${cfile} -o ${OBJECT_FILE_DIR}/`basename ${cfile} .c`.o
done

echo "Linking"
${CC} ${ALL_CFLAGS} ${OBJECT_FILE_DIR}/*.o --output ${BUILD_DIR}/${PRODUCT_NAME}.elf ${LDFLAGS}

echo "Linking (hex file)"
${OBJCOPY} -O ${FORMAT} -R .eeprom ${BUILD_DIR}/${PRODUCT_NAME}.elf ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.hex
${OBJCOPY} -j .eeprom --set-section-flags=.eeprom="alloc,load" --change-section-lma .eeprom=0 -O ${FORMAT} ${BUILD_DIR}/${PRODUCT_NAME}.elf ${BUILD_DIR}/${PRODUCT_NAME}.eep
${OBJDUMP} -h -S ${BUILD_DIR}/${PRODUCT_NAME}.elf > ${BUILD_DIR}/${PRODUCT_NAME}.lss
${NM} -n ${BUILD_DIR}/${PRODUCT_NAME}.elf > ${BUILD_DIR}/${PRODUCT_NAME}.sym

HEXSIZE="${SIZE} --target=${FORMAT} ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.hex"
ELFSIZE="${SIZE} -A ${BUILD_DIR}/${PRODUCT_NAME}.elf"
echo "SIZE:"
${ELFSIZE}

cp ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.hex ${SRCROOT}/

echo "#!/bin/bash -e" > ${BUILD_DIR}/loader
echo "${AVRDUDE} -c ${AVRDUDE_PROGRAMMER} -p ${MCU} -U flash:w:${SRCROOT}/${PRODUCT_NAME}.hex" >> ${BUILD_DIR}/loader
chmod +x ${BUILD_DIR}/loader

