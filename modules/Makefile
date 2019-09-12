.PHONY:	all clean allclean distclean help

DIRS=$(sort $(wildcard */))

all:
	@for dir in $(DIRS); do \
	  (cd $$dir; make); \
	done

install:
	@for dir in $(DIRS); do \
	  (cd $$dir; make install); \
	done

##################################################################
# Clean rules
##################################################################
clean:
	@for dir in $(DIRS); do \
	  (cd $$dir; make clean); \
	done

allclean: clean

distclean: clean

##################################################################
# Help rule
##################################################################
help:
	@echo "Makefile usage:"
	@echo
	@echo "make <all>         Build all the modules"
	@echo "make install       Install the modules files in vm/mnt"
	@echo "make clean         Clean modules sources"
	@echo "make help          Display this help"
