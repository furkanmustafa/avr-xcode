avr-xcode
=========

Xcode® External Build System Project for Atmel® AVR using avr-gcc

*This is a two-hour work, it needs to be improved. Please fork the project and contribute.*

## Usage

Open the project with xCode, put your C Code in, use `⌘ + B` to build, (after build) `⌘ + R` to upload with avrdude.

Also see Build Settings in xCode, you can change MCU, Programmer Type, CFLAGS, etc..

## Prerequisites

You should install basic tools required AVR development like, `avr-gcc` `avr-libc` `avrdude` ..

To do that, use either `homebrew` or `crosspack-avr`;

**Crosspack-AVR**

  http://www.obdev.at/products/crosspack/index.html

**homebrew** ( see https://github.com/larsimmisch/homebrew-avr noted 2013.03.06 )

  brew install avrdude
	brew tap larsimmisch/avr
	brew install avr-gcc avr-libc avr-binutils

## Known Annoying Details

* xCode cannot find symbols, header files, even the files in project itself. Would be nice if fixed.

*Probably there's more, please let me know*
