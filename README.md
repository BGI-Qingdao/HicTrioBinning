# HicTrioBinning
A pipeline to bin Hi-C reads for trios.

* Instruction:
---------------------------------------------------------------------------
Usage: 

		/usr/bin/bash HTB.sh -M MF2_MAT_conitg.fasta -P MF2_PAT_contig.fasta \
		-1 ./MF2_Hi-C_R1.fq.gz -2 ./MF2_Hi-C_R2.fq.gz -N 10 -B /paht/to/bwa \
		-S /path/to/seqtk -O /path/to/output/ -I 1 
Option: 

		-I < bwa index for haplotype assemblies: 1|0 > 
		-M < input draft maternal-specific haplotype assembly > 
		-P < input draft paternal-specific haplotype assembly > 
		-1 < hybrid Hi-C Reads R1 > 
		-2 < hybrid Hi-C Reads R2 > 
		-N < thread number : 20 (default) > 
		-B < path to installed bwa > 
		-S < path to installed seqtk > 
		-h <help> 
---------------------------------------------------------------------------
[bwa github](https://github.com/lh3/bwa) 

[seqtk github](https://github.com/lh3/seqtk)


example CMD line: 

* Please set -I to 1 if you donot have bwa indices for the two haplotype assemblies. 
```
/usr/bin/bash HTB.sh -M MF2_MAT_conitg.fasta -P MF2_PAT_contig.fasta -1 ./MF2_Hi-C_R1.fq.gz -2 ./MF2_Hi-C_R2.fq.gz -N 10 -B /share/app/bwa-0.7.12/bwa -S /share/app/seqtk/1.3/seqtk -O /path/to/output/ -I 1 
```

* Please set -I to 0 if you already have bwa indices for the two haplotype assemblies. 
```
/usr/bin/bash HTB.sh -M MF2_MAT_conitg.fasta -P MF2_PAT_contig.fasta -1 ./MF2_Hi-C_R1.fq.gz -2 ./MF2_Hi-C_R2.fq.gz -N 10 -B /share/app/bwa-0.7.12/bwa -S /share/app/seqtk/1.3/seqtk -O /path/to/output/ -I 0 
```
