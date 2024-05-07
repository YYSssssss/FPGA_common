vcs:
	vcs \
	+define+ASIC \
	+define+UNIT_DELAY \
	-f filelist.f \
	-full64 -R +vc +v2k -sverilog -debug_all \
	-timescale=1ns/1ps \
	+incdir+${rsp_s1_fft}/src \
	-fsdb \
	| tee vcs.log
verdi:
	verdi \
	+define+ASIC \
	-f filelist.f \
	-ssf tb_top_fft.fsdb \
	+incdir+${rsp_s1_fft}/src \
	-sv &
clean:
	rm -rf *.log simv *.daidir csrc *.key DVEfiles *.vpd *.conf  *.fsdb verdiLog

