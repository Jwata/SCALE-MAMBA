
include ../CONFIG.mine

CC = g++

CFLAGS = -Wall -std=c++11 -pedantic -Wextra -g -pthread -I$(ROOT)/src -maes -mpclmul -msse4.1 -march=core2 $(FLAGS) $(OPT)
CPPFLAGS = $(CFLAGS)
LDLIBS = -L/$(OSSL)/lib -lm -lssl -lcrypto -lmpirxx -lmpir $(LDFLAGS)
RPATHFLAGS = -Wl,-R,./

all: Test.x Test-FHE.x Test-Adv-FHE.x

LIBNAME = MPC
LIB = lib$(LIBNAME).so

OBJ =  Test.o Test-FHE.o Test-Adv-FHE.o

SRC = Test.cpp Test-FHE.cpp Test-Adv-FHE.cpp

$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -c $*.cpp

Test.x: $(OBJ) ../$(LIB)
	$(CC) $(CFLAGS) -o Test.x Test.o -l$(LIBNAME) $(LDLIBS) $(RPATHFLAGS) -L../
	- cp Test.x ../

Test-FHE.x: $(OBJ) ../$(LIB)
	$(CC) $(CFLAGS) -o Test-FHE.x Test-FHE.o -l$(LIBNAME) $(LDLIBS) $(RPATHFLAGS) -L../
	- cp Test-FHE.x ../

Test-Adv-FHE.x: $(OBJ) ../$(LIB)
	$(CC) $(CFLAGS) -o Test-Adv-FHE.x Test-Adv-FHE.o -l$(LIBNAME) $(LDLIBS) $(RPATHFLAGS) -L../
	- cp Test-Adv-FHE.x ../


clean:
	- rm *.x *.o
