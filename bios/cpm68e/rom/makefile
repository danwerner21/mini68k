
BIOS = 48		# space reserved for BIOS
CPMDIR = ../../cpm68e
TOOLS = ../../../tools

all:	rom80.bin rom400.bin krom80.bin krom464.bin


dir.bin:
	$(TOOLS)/hex2bin -R 2k -p 0xE5 -o dir.bin

data398.bin:
	$(TOOLS)/hex2bin -R 398k -p 0xFF -o data398.bin

data78.bin:
	$(TOOLS)/hex2bin -R 78k -p 0xff -o data78.bin

data64.bin:
	$(TOOLS)/hex2bin -R 64k -p 0xFF -o data64.bin

rom80.bin:	dir.bin data78.bin cpm.sys
	cat dir.bin data78.bin >rom80.bin
	cpmcp -f m68k80 rom80.bin cpm.sys 0:
	cpmcp -f m68k80 rom80.bin ./ROM01/*.* 0:

rom400.bin:	dir.bin data398.bin cpm.sys data64.bin
	cat dir.bin data398.bin >rom400.bin
	cpmcp -f m68k400 rom400.bin cpm.sys 0:
	cpmcp -f m68k400 rom400.bin ./ROM01/*.* 0:
	cpmcp -f m68k400 rom400.bin ./ROM02/*.* 0:
	cat data64.bin >>rom400.bin

krom80.bin:	dir.bin data78.bin kcpm.sys
	cat dir.bin data78.bin >krom80.bin
	cpmcp -f m68k80 krom80.bin kcpm.sys 0:cpm.sys
	cpmcp -f m68k80 krom80.bin ./ROM01/*.* 0:

krom464.bin:	dir.bin data398.bin kcpm.sys data64.bin
	cat dir.bin data398.bin data64.bin >krom464.bin
	cpmcp -f m68k464 krom464.bin kcpm.sys 0:cpm.sys
	cpmcp -f m68k464 krom464.bin ./ROM01/*.* 0:
	cpmcp -f m68k464 krom464.bin ./ROM02/*.* 0:
	cpmcp -f m68k464 krom464.bin ./ROM03/*.* 0:

cpm.sys:	$(CPMDIR)/cpm.sys
	cp -pv $(CPMDIR)/cpm.sys .

kcpm.sys:	$(CPMDIR)/kcpm.sys
	cp -pv $(CPMDIR)/kcpm.sys kcpm.sys

list:	all
	@echo "\n"
	cpmls -d -f m68k80 rom80.bin 0:*.*
	cpmls -D -f m68k80 rom80.bin 0:*.*
	@echo "\n\n"
	cpmls -d -f m68k400 rom400.bin 0:*.*
	cpmls -D -f m68k400 rom400.bin 0:*.*
	@echo "\n\n"
	cpmls -d -f m68k80 krom80.bin 0:*.*
	cpmls -D -f m68k80 krom80.bin 0:*.*
	@echo "\n\n"
	cpmls -d -f m68k464 krom464.bin 0:*.*
	cpmls -D -f m68k464 krom464.bin 0:*.*


clean:
	rm -f *.bin
	rm -f *.sys
