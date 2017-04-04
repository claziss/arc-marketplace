
bsize: stamps/build-csibe

stamps/build-csibe: benchmark/csibe
	rm -rf $@ $(notdir $@)
	mkdir $(notdir $@)
	benchmark/csibe/csibe.py gcc-arc-hs gcc-arc-em CSiBE-v2.1.1 \
		--build-dir $(notdir $@) -j8

