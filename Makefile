TEMPFILE := $(shell mktemp)

all: arc/build-csibe
	#$(MAKE) -C reports

arc/build-csibe: benchmark/csibe
	rm -rf $@ $(notdir $@)
	mkdir $(notdir $@)
	benchmark/csibe/csibe.py gcc-arc-hs44 gcc-arc-em4 CSiBE-v2.1.1 \
		--build-dir $(notdir $@) -j8
	cp $(notdir $@)/gcc-arc-em4/all_results.csv reports/size/gcc-arc-em4.csv
	cp $(notdir $@)/gcc-arc-hs44/all_results.csv reports/size/gcc-arc-hs44.csv

arm/build-csibe:
	benchmark/csibe/csibe.py gcc-cortex-m0 gcc-cortex-m4 gcc-cortex-a7 \
	gcc-cortex-r5 CSiBE-v2.1.1 --build-dir $(notdir $@) -j8
	cp $(notdir $@)/gcc-cortex-m0/all_results.csv \
	reports/size/gcc-cortex-m0.csv
	cp $(notdir $@)/gcc-cortex-m4/all_results.csv \
	reports/size/gcc-cortex-m4.csv
	cp $(notdir $@)/gcc-cortex-a7/all_results.csv \
	reports/size/gcc-cortex-a7.csv
	cp $(notdir $@)/gcc-cortex-r5/all_results.csv \
	reports/size/gcc-cortex-r5.csv

arc/hs4xd/ncam:
	$(MAKE) -C benchmark/tests clean
	$(MAKE) -C benchmark/tests reports
	cat benchmark/tests/*.rep > reports/performance/arc_hs4xd_ncam.txt
	$(MAKE) -C reports arc/hs4xd/ncam.perf

arc/hs44/xcam:
	$(MAKE) -C benchmark/tests clean
	source $$MODULESHOME/init/bash; module add xmodels/HS44; \
	$(MAKE) -C benchmark/tests reports SIM=xcam CPU=hs4x
	cat benchmark/tests/*.rep > reports/performance/arc_hs4x_xcam.txt

arc/hs38/xcam:
	$(MAKE) -C benchmark/tests clean
	source $$MODULESHOME/init/bash; module add xmodels/XcamHS34; \
	$(MAKE) -C benchmark/tests reports SIM=xcam CPU=hs38
	cat  benchmark/tests/*.rep > reports/performance/arc_archs_xcam.txt
	#$(MAKE) -C reports arc/archs/xcam.perf

arc/em4/xcam:
	$(MAKE) -C benchmark/tests clean
	source $$MODULESHOME/init/bash; module add xmodels/EM4; \
	$(MAKE) -C benchmark/tests reports SIM=xcam CPU=em4
	cat  benchmark/tests/*.rep > reports/performance/arc_arcem_xcam.txt
	#$(MAKE) -C reports arc/arcem/xcam.perf

arc/arc700/xcam:
	$(MAKE) -C benchmark/tests clean
	source $$MODULESHOME/init/bash; module add xmodels/arc700; \
	$(MAKE) -C benchmark/tests reports SIM=xcam CPU=arc700
	cat  benchmark/tests/*.rep > reports/performance/arc_arc700_xcam.txt

arc/arc625/xcam:
	$(MAKE) -C benchmark/tests clean
	source $$MODULESHOME/init/bash; module add xmodels/arc625; \
	$(MAKE) -C benchmark/tests reports SIM=xcam CPU=arc625
	cat  benchmark/tests/*.rep > reports/performance/arc_arc625_xcam.txt

arc: arc/hs44/xcam arc/hs38/xcam arc/em4/xcam arc/arc700/xcam arc/arc625/xcam

clean:
	$(MAKE) -C benchmark/tests clean
