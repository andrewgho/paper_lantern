# Makefile - create STL files from OpenSCAD source
# Andrew Ho (andrew@zeuscat.com)

ifeq ($(shell uname), Darwin)
  OPENSCAD = /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
else
  OPENSCAD = openscad
endif

TARGETS = lantern.stl aframe.stl

all: $(TARGETS)

lantern.stl: lantern.scad
	$(OPENSCAD) -o lantern.stl lantern.scad

aframe.stl: aframe.scad
	$(OPENSCAD) -o aframe.stl aframe.scad

clean:
	@rm -f $(TARGETS)
