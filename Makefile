INSTALL = install
ZIP = zip

prefix = /usr/local/djgpp

CPPFLAGS += -DHAVE_GCC_TIMER_H
CPPFLAGS += -O3 -Wall -Wextra
CXXFLAGS += -O3 -Wall -Wextra
CPPFLAGS += -I$(prefix)/include/libbinio -I$(prefix)/include -I$(prefix)/include/adplug -I$(prefix)/include/window
CXXFLAGS += -I$(prefix)/include/libbinio -I$(prefix)/include -I$(prefix)/include/adplug -I$(prefix)/include/window
LDFLAGS += -lstdc++ -lwindow -ladplug -lbinio -lgcctimer
LDFLAGS += -L$(prefix)/lib -L$(prefix)/lib/gcc/i586-pc-msdosdjgpp/$(gcc_version)

ifeq ($(DEBUG),1)
	CPPFLAGS += -DDEBUG
endif

DIST = readme.txt INSTALL.md Makefile build.txt \
	arcfile.h cfgparse.h filewnd.h helptxt.h adplay.cpp arcfile.cpp \
	cfgparse.cpp filewnd.cpp adplay.ini

BINARYDIST = adplay.exe $(srcdir)/adplay.ini $(srcdir)/readme.txt

VERSION = 1.7
NAME = adplay-$(VERSION)
BINARYNAME = adplay$(subst .,,$(VERSION))

bindir = $(prefix)/bin
srcdir = .

adplay.exe: adplay.o arcfile.o cfgparse.o filewnd.o
	$(CXX) -o $@ $^ $(LDFLAGS)

adplay.o: adplay.cpp cfgparse.h arcfile.h filewnd.h helptxt.h
arcfile.o: arcfile.cpp arcfile.h
cfgparse.o: cfgparse.cpp cfgparse.h
filewnd.o: filewnd.cpp filewnd.h arcfile.h

clean:
	rm -f *.o adplay.exe

dist:
	mkdir $(NAME)
	cd $(srcdir); cp $(DIST) $$OLDPWD/$(NAME)
	tar cfj $(NAME).tar.bz2 $(NAME)
	rm -r $(NAME)

binarydist: adplay.exe
	upx adplay.exe
	rm -rf $(BINARYNAME).zip $(BINARYNAME)
	mkdir $(BINARYNAME)
	cp $(BINARYDIST) $(BINARYNAME)
	cd $(BINARYNAME) && $(ZIP) ../$(BINARYNAME).zip *
	rm -rf $(BINARYNAME)

install: adplay.exe
	$(INSTALL) adplay.exe $(bindir)

test:
	mkdir -p capture
	set +eux
	dosbox-x --version || true
	SDL_VIDEODRIVER=offscreen
	SDL_AUDIODRIVER=dummy
	# dosbox-x --fastlaunch --nomenu --time-limit 10 --exit -c "mount c ." -c "c:" -c "cls" -c "dx-capture /v /a /o adplay"
	# No DRO, no output on stdin
	dosbox-x --debug --fastlaunch --nomenu --time-limit 10 --exit -c "mount c ." -c "c:" -c "cls" -c "dx-capture /v /a /o adplay /? >> thelp.txt"
	# No DRO, thelp should contain Adplay help
	cp -v ../adplug/test/testmus/* .
	# dosbox-x --fastlaunch --nomenu --time-limit 600 --exit -c "mount c ." -c "c:" -c "cls" -c "dx-capture /v /a /o adplay -q testmus\loudness.lds >> tbatch.txt"
	# dosbox-x --fastlaunch --nomenu --time-limit 600 --exit -c "mount c ." -c "c:" -c "cls" -c "dx-capture /v /a /o adplay -q adplay.ini >> tbatch.txt"
	for f in ./testmus/*; do dosbox-x --fastlaunch --nomenu --time-limit 10 --exit -c "mount c ." -c "c:" -c "cls" -c "dx-capture /v /a /o adplay -q $f >> $f.txt"; done
	ls -al ./capture
	# Assert Adplay is printed in output of txt.out
	# Assert audio is hearable
	# Assert dro file matches known good dro file