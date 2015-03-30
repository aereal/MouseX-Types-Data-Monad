CPANM = cpanm
CARTON = carton
CARTON_EXEC = $(CARTON) exec --
PROVE = $(CARTON_EXEC) prove
TEST_TARGET = t/

test:
	$(PROVE) $(TEST_TARGET)

prepare:
	$(CPANM) --notest Carton

deps:
	$(CARTON) install
