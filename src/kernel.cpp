#include <stdint.h>
static volatile uint16_t* const VGA = reinterpret_cast<volatile uint16_t*>(0xB8000);
static void line(const char* s, unsigned row, uint8_t color) {
 for (unsigned i=0; s[i] && i<80; ++i) VGA[row*80+i] = uint16_t(s[i]) | (uint16_t(color)<<8);
}
extern "C" void kernel_main(uint32_t, uint32_t) {
 for (unsigned i=0;i<2000;++i) VGA[i]=0x1F20;
 line("BudgieOS Family - BNU Kernel",2,0x1F);
 line("Experimental BIOS boot image",4,0x0F);
 line("Kernel started successfully.",6,0x0A);
 line("Starter build only - not a complete operating system.",8,0x0E);
 for (;;) __asm__ volatile("hlt");
}