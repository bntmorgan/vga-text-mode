# vga-text-mode
VGA compatible text video controller for Digilent Nexys 3 FPGA

## Build font bitmap
$ cd fonts/xbm_tools
$ make gen

## Synthesize circuit
$ make targets

## Load circuit
$ sudo djtgcfg prog -f binary/vga_demo/system.bit -d Nexys3 -i 0
