
all: videoram.memb fontrom.memb videoram.init fontrom.init

%.memb: %.bin
	./bin2memb $< > $@
	
%.init: %.bin
	./bin2init $< ram > $@

clean:
	rm -f *.memb *.init
	
	