#
# makefile for 14-May-2016 distro
#

CPM = cpm68e
ROM = $(CPM)/rom
BIOS = bios-10.2



all:
	@echo Commands are:
	@echo "   make clean"
	@echo "   make roms"


roms:
	cd $(CPM); make RETAIL=1
	cd $(ROM); make
	cd $(BIOS); make clean
#	cd $(BIOS); make RETAIL=1 KISS=1
#	cd $(BIOS); make clean
	cd $(BIOS); make RETAIL=1 MINI=1
#	cd $(BIOS); make clean
	mv -v $(BIOS)/*.rom .
	cp -v $(BIOS)/*.map .
	ls -l *.map *.rom


clean:
	rm -f *.map
	rm -f *.rom
	cd $(BIOS); make clean
	cd $(CPM); make clean
	cd $(ROM); make clean
	echo All done.
