#!/bin/sh
#$-S /bin/bash
#$-cwd
#$ -V

#########################################################################
# -- Author: Amos Folarin                                               #
# -- Organisation: KCL/SLaM                                             #
# -- Email: amosfolarin@gmail.com                                       #
#########################################################################


######################################################################
# Post Z-Call Filtering Steps (see protocol sheet step 9-11)
# USAGE: sge_post-z-qc.sh <tpedBasename> 
# ARGS: 
#      arg1) tped file basename generated from the zcall step
######################################################################

# parameters
tpedBasename=${1}


# Step 9) SNP QC step
# perform basic sample removal callrate <= 90%  (seems redundant??)
plink --noweb --tfile ${tpedBasenmae} --missing


## 2 run very basic qc
echo "- running basic qc 01 -"
for my_qc in missing freq hardy;do
plink --noweb --bfile ${bedfile}_01 --${my_qc} --out ${bedfile}_01;
done
## Plot missing
R --vanilla --slave --args bfile=${bedfile}_01 < plot.missingness.r;


## 3 Id samples/SNPs with call rates <= 90%
cat ${bedfile}_01.imiss | awk '$6>=0.10'> ${bedfile}_01_poor_sample_callrate;
cat ${bedfile}_01.imiss | awk '$6>=0.10'| sed '1,1d' | awk '{print $1,$2}' > ${bedfile}_01_poor_sample_callrate_exclude;
#
cat ${bedfile}_01.lmiss | awk '$5>=0.10'> ${bedfile}_01_poor_snp_callrate;
cat ${bedfile}_01.lmiss | awk '$5>=0.10'| sed '1,1d' | awk '{print $1,$2}' > ${bedfile}_01_poor_snp_callrate_exclude;


# 4 do the exclusions in plink using --exclude and --remove
# TODO!!!!!


