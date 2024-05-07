#!/bin/make

SOURCES = $(wildcard ${SOURCE}/../reg/*.v \
                     ${SOURCE}/../ahb_ic/built/rsp_s2_dma/src/rsp_s2_dma_ahbic/*.v)
CFLAGS+= +incdir+${SOURCE}
CFLAGS+= +incdir+${rsp_common}/header/
CFLAGS+= -sverilog
include ${vobs}/templates/makefile.flst
