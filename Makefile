TEMPFILE := $(shell mktemp)

size: arc/build-csibe
	$(MAKE) -C reports

arc/build-csibe: benchmark/csibe
	rm -rf $@ $(notdir $@)
	mkdir $(notdir $@)
	benchmark/csibe/csibe.py gcc-arc-hs gcc-arc-em CSiBE-v2.1.1 \
		--build-dir $(notdir $@) -j8
	cp $(notdir $@)/gcc-arc-em/all_results.csv reports/size/gcc-arc-em.csv
	cp $(notdir $@)/gcc-arc-hs/all_results.csv reports/size/gcc-arc-hs.csv

arm/build-csibe: arc/build-csibe
	benchmark/csibe/csibe.py gcc-cortex-m0 gcc-cortex-m4 CSiBE-v2.1.1 \
		--build-dir $(notdir $@) -j8
	cp $(notdir $@)/gcc-cortex-m0/all_results.csv \
	reports/size/gcc-cortex-m0.csv
	cp $(notdir $@)/gcc-cortex-m4/all_results.csv \
	reports/size/gcc-cortex-m4.csv

arc/hs4xd/ncam:
	$(MAKE) -C benchmark/tests clean
	$(MAKE) -C benchmark/tests run
	$(MAKE) -C benchmark/tests reports
	cat benchmark/tests/*.rep > reports/performance/arc_hs4xd_ncam.txt
	$(MAKE) -C reports arc/hs4xd/ncam.perf

arc/archs/xcam:
	$(MAKE) -C benchmark/tests clean
	$(MAKE) -C benchmark/tests run SIM=xcam CPU=archs
	$(MAKE) -C benchmark/tests reports
	cat  benchmark/tests/*.rep > reports/performance/arc_archs_xcam.txt
	$(MAKE) -C reports arc/archs/xcam.perf

arc/arcem/xcam:
	$(MAKE) -C benchmark/tests clean
	$(MAKE) -C benchmark/tests run SIM=xcam CPU=arcem ARCH=av2em
	$(MAKE) -C benchmark/tests reports
	head -n 40  $< > $(TEMPFILE)
	echo "" >> $(TEMPFILE)
	echo "## XCAM runs for ARC EM" >> $(TEMPFILE)
	echo "Benchmark | Score" >> $(TEMPFILE)
	echo "-----|----:" >> $(TEMPFILE)
	cat benchmark/tests/*.rep >> $(TEMPFILE)
	cp $(TEMPFILE) $<
