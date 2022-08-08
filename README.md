# HicTrioBinning
A multithread pipeline to bin Hi-C reads for trios.
![T2T (2)](https://user-images.githubusercontent.com/38022049/183343419-0d6a0f2e-abd8-439a-96ed-883446ea19ea.png)

RED: Input, YELLOW: this pipeline, GREEN: Output


* Instruction:
---------------------------------------------------------------------------
Input:

		1. two haplotype-resolved assembled contigs
		2. Hi-C reads for child
		
Output:	

		two haplotype-resolved Hi-C reads for Hi-C assembly
		
Dependencies:	

		1. BWA
		2. Seqkit
		
Usage: 

		/usr/bin/bash HTB.sh -M Input_MAT_conitg.fasta -P Input_PAT_contig.fasta \
		-1 Input_Hi-C_R1.fq.gz -2 Input_Hi-C_R2.fq.gz -N 10 -B /path/to/bwa \
		-S /path/to/seqtk -O /path/to/output/ -I 1
		
Option: 

		-I < bwa index for haplotype assemblies: 1|0 > 
		-M < input draft maternal-specific haplotype assembly for the child > 
		-P < input draft paternal-specific haplotype assembly for the child > 
		-1 < hybrid Hi-C Reads R1 for the child > 
		-2 < hybrid Hi-C Reads R2 for the child > 
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
/usr/bin/bash HTB.sh -M Input_MAT_conitg.fasta -P Input_PAT_contig.fasta -1 Input_Hi-C_R1.fq.gz -2 Input_Hi-C_R2.fq.gz -N 10 -B /share/app/bwa-0.7.12/bwa -S /share/app/seqtk/1.3/seqtk -O /path/to/output/ -I 1 
```

* Please set -I to 0 if you already have bwa indices for the two haplotype assemblies. 
```
/usr/bin/bash HTB.sh -M Input_MAT_conitg.fasta -P Input_PAT_contig.fasta -1 Input_Hi-C_R1.fq.gz -2 Input_Hi-C_R2.fq.gz -N 10 -B /share/app/bwa-0.7.12/bwa -S /share/app/seqtk/1.3/seqtk -O /path/to/output/ -I 0 
```
