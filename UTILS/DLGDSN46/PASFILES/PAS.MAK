# Pascal make file for Dialog Design's external translators
# Usage:
#     make -fpas

# Root directory, change as appropriate
ROOT = C:\BP

# Compiler name, use either tpc or bpc
TPC = tpc

# Unit path, where the System and Pascal units are
UNITPATH = $(ROOT)\units;

# Temporary config file name in default directory
CFG = $(TPC).cfg

# Compiler name, add ROOT\bin directory
TPC = $(ROOT)\bin\$(TPC)


#		*Explicit Rules*
all: passrc1.exe passrc2.exe pasrsrc.exe delete

passrc1.exe: $(CFG)
  $(TPC) /m  passrc1

passrc2.exe: $(CFG)
  $(TPC) /m passrc2

pasrsrc.exe: $(CFG)
  $(TPC) /m pasrsrc

delete:
  del readscpt.tpu
  del inplong.tpu
  del colortxt.tpu
  del $(CFG)

#		*Compiler Configuration File*
$(CFG): pas.mak
  copy &&|
/$A-,B-,D-,E+,F-,G-,I+,L-,N-,O-,P-,Q-,R-,S-,T-,V-,X+
/U$(UNITPATH)
| $(CFG)
