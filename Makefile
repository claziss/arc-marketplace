
size: arc/build-csibe

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
