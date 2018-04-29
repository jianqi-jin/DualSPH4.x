#ToVtk4 v0.2 (21-07-2015)
CC=g++

CCFLAGS=-c -O3
CCLINKFLAGS=
ARCH=64

#CCFLAGS=-c -O3 -m32
#CCLINKFLAGS=-static -m32
#ARCH=32

JLIBS=-L./ -ljxml_$(ARCH) -ljcreatevtk_$(ARCH)

OBJECTS=main.o Functions.o JBinaryData.o JCfgRun.o JException.o JObject.o JPartDataBi4.o JRangeFilter.o JSpaceCtes.o JSpaceEParms.o JSpaceParts.o JSpaceProperties.o

all:tovtk 
	rm -rf *.o

tovtk:  $(OBJECTS)
	$(CC) $(CCLINKFLAGS) $(OBJECTS) -o $@  $(JLIBS)

.cpp.o: 
	$(CC) $(CCFLAGS) $< 

clean:
	rm -rf *.o tovtk


