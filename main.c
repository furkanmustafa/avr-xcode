
#define F_CPU	10000000

#include <avr/io.h>
#include <util/delay.h>

#define outp(val, reg)  (reg = val)
#define inp(reg)        (reg)

#define sbi(reg,bit)	(reg |= (1<<bit))
#define cbi(reg,bit)	(reg &= ~(1<<bit))

#define nop() asm volatile("nop\n\t"::);

int main(void) {
	sbi(DDRA, 0);	// portA.0 output
	sbi(PORTA, 0);	// portA.0 on
	
	while (1==1) {	// forever
		cbi(PORTA, 0);	// portA.0 off
		_delay_ms(1000);
		sbi(PORTA, 0);	// portA.0 on
		_delay_ms(1000);
	}
	return 0;		// end
}
