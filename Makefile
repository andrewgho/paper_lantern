# Makefile - create STL files from OpenSCAD source
# Andrew Ho (andrew@zeuscat.com)

ifeq ($(shell uname), Darwin)
  OPENSCAD = /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
else
  OPENSCAD = openscad
endif

TARGETS = paper_lantern.stl

all: $(TARGETS)

paper_lantern.stl: paper_lantern.scad
	$(OPENSCAD) -o paper_lantern.stl paper_lantern.scad

clean:
	@rm -f $(TARGETS)
