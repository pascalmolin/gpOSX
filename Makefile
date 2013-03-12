VERSION=2.5.3
APP:=/Applications/PariGP.app
PariGPdir:=$(APP)/Contents
MacOSdir:=$(PariGPdir)/MacOS
Resourcesdir:=$(PariGPdir)/Resources
Resourceslibdir:=$(Resourcesdir)/lib
GPexe:=$(Resourcesdir)/bin/gp
GPrun:=$(MacOSdir)/PariGP

$(MacOSdir):
	mkdir -p $@

$(Resourcesdir):
	mkdir -p $@

$(Resourceslibdir):
	mkdir -p $@
  
INFO=$(PariGPdir)/Info.plist

$(INFO): files/Info.plist ${Resourcesdir}
	sed 's/VERSION/$(VERSION)/' $< > $@

BUILD=sources
READLINE=--with-readline=/usr/local/Cellar/readline/6.2.4
CC=/usr/local/bin/gcc-4.7
PREFIX=--prefix=$(Resourcesdir)


sources/build-%:
	cd sources && git co pari-$*
	export CC=$(CC)
	cd sources && ./Configure ${READLINE} ${PREFIX} --builddir=build-$*
	cd $@ && make clean
	cd $@ && make -j6 gp
	cd $@ && make all
	cd $@ && make dobench

${GPinstall}: sources/build-${VERSION}
	export CC=$(CC)
	cd sources && make install

ReadLineLib=libreadline.6.2.dylib
RLorig=/usr/local/opt/readline/lib/$(ReadLineLib)
RLdest=$(Resourcesdir)/lib/$(ReadLineLib)
GccLib=libgcc_s.1.dylib
Gccorig=/usr/local/Cellar/gcc/4.7.1/gcc/lib/$(GccLib)
Gccdest=$(Resourcesdir)/lib/$(GccLib)

$(RLdest): $(RLorig) ${Resourceslibdir}
	cp -f $< $@

$(Gccdest): $(Gccorig) ${Resourceslibdir}
	cp -f $< $@
  
$(GPexe): $(RLdest) $(Gccdest) PariGP-$(VERSION) ${Resourcesdir}
	cd $(Resourcesdir) && install_name_tool -change $(RLorig) $(RLdest) bin/gp
	cd $(Resourcesdir) && install_name_tool -change $(Gccorig) $(Gccdest) bin/gp

$(GPrun): files/GPrun.sh ${GPexe} ${MacOSdir}
	  cp -f $< $@
  
ICONS:=$(Resourcesdir)/PariGP.icns

$(ICONS): images/PariGP.icns ${Resourcesdir}
	cp -f $< $@

# The app directory
$(APP): $(ICONS) $(INFO) $(GPrun)
  
APPSIZE=20m
VOLUME=/Volumes/PariGP
tmp-$(VERSION).dmg: ${APP}
	hdiutil create -srcfolder "$<" -volname "PariGP" -fs HFS+ \
	-fsargs "-c c=64,a=16,e=16" -format UDRW -size ${APPSIZE} $@
	sleep 5
	# mount
	device=$$(hdiutil attach -readwrite -noverify -noautoopen "$<" | \
	         egrep '^/dev/' | sed 1q | awk '{print $$1}')
	sleep 5
	mkdir -p ${VOLUME}/.background
	cp images/install.png ${VOLUME}/.background/install.png
	osascript files/installer.applescript
	-chmod -Rf go-w ${VOLUME}
	sync
	sync
	hdiutil detach $${device}
  

PariGP-%.dmg: tmp-%.dmg
	hdiutil convert "$<" -format UDZO -imagekey zlib-level=9 -o PariGP-%


all: PariGP-${VERSION}.dmg

clean:
	rm -rf /Applications/PariGP.app
  
