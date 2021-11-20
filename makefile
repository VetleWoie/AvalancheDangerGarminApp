CC=monkeyc
SIM=connectiq
RUN=monkeydo

BUILDFOLDER=Builds
OUTFILE=app.prg
PACKAGEFOLDER=Package
PACKAGEFILE=avalanche.iq
JUNGLE=AvalancheDanger/monkey.jungle

DEVICE=fenix5plus
# DEVICE=fenix6pro
#DEV_KEY=../DevKey/developer_key
DEV_KEY=~/developer_key.der
COMFLAGS=-d $(DEVICE) -f $(JUNGLE) -y $(DEV_KEY) -o $(BUILDFOLDER)\$(OUTFILE)
RUNFLAGS=$(BUILDFOLDER)\$(OUTFILE) $(DEVICE)
PCKFLAGS=-d $(DEVICE) -f $(JUNGLE) -y $(DEV_KEY) -o $(PACKAGEFOLDER)\$(PACKAGEFILE)

DEPENDECIES=AvalancheDanger/manifest.xml

make: $(DEPENDECIES)
	$(CC) $(COMFLAGS)
	$(RUN) $(RUNFLAGS)
all: $(DEPENDECIES)
	$(CC) $(COMFLAGS)
run:
	$(RUN) $(RUNFLAGS)
startsim:
	$(SIM)
package: .FORCE
	$(CC) $(PCKFLAGS) -r -e

.FORCE: