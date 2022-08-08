# HicTrioBinning
A simply pipeline to identify the HiC reads to paternal and maternal.

example CMD line:
Please set -I with 1 to bwa index the reference when first launch the shell.

/usr/bin/bash HTB.sh -M MF2_MAT_hifi_slr_bionano.fasta -P MF2_PAT_hifi_slr_bionano.fasta -1 ./MF2_R1.fq.gz -2 ./MF2_R2.fq.gz -N 10 -B /share/app/bwa-0.7.12/bwa -S /share/app/seqtk/1.3/seqtk  -I 1

You have the PAT and MAT assemly reference index, you can set -I with 0 to skipped the indexing step.

/usr/bin/bash HicTrioBinning.sh -M MF2_MAT_hifi_slr_bionano.fasta -P MF2_PAT_hifi_slr_bionano.fasta -1 ./MF2_R1.fq.gz -2 ./MF2_R2.fq.gz -N 10 -B /share/app/bwa-0.7.12/bwa -S /share/app/seqtk/1.3/seqtk  -I 0
