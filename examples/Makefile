TARGETS=\
	device_info.out

CXX=g++
CXXFLAGS=-Wall
LIBS=-lbb_api

all : $(TARGETS)

%.out : %.cpp
	$(CXX) $< $(CXXFLAGS) $(LIBS) -o $@

clean :
	rm -f *.out