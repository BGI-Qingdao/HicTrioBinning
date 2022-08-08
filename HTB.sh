#!/bin/bash

helpdoc(){
		cat<<EOF
Usage:
		Input file list
Option:
		-I < assembly hap reference index: 1|0>
		-M < maternal assembly hap fasta >
		-P < paternal assembly hap fasta >
		-1 < HiC Read R1 >
		-2 < HiC Read R2 >
		-N < thread number : 20 >
		-B < /path/to/bwa >
		-S < /path/to/seqtk >
		-h <help>
EOF
}

while getopts ":I:M:P:1:2:N:B:S:h" opt
do

	echo $opt $OPTARG;

	case $opt in
		I)Index=$OPTARG;;
		M)MF2_MAT_ASM_fasta=$OPTARG;;
		P)MF2_PAT_ASM_fasta=$OPTARG;;

		1)MF2_R1_fq_gz=$OPTARG;;
		2)MF2_R2_fq_gz=$OPTARG;;

		N)n_thread=$OPTARG;;
		B)bwa=$OPTARG;;
		S)seqtk=$OPTARG;;

		h|help) helpdoc exit 1 ;;
		?) echo "$OPTARG Unknown parameter"
		exit 1;;
        esac
done

if [ $# = 0 ]
then
	helpdoc
	exit 1
fi

echo "HiC Trio Binning End: `date`"

#### 00 get map quality
if [ $Index = 1 ]
then
	$bwa index $MF2_MAT_ASM_fasta &
	$bwa index $MF2_PAT_ASM_fasta &
	wait
fi

$bwa mem -t $n_thread $MF2_MAT_ASM_fasta $MF2_R1_fq_gz 1> HiC_MAT_MAP.R1.sam 2> HiC_MAT_MAP.R1.log &
$bwa mem -t $n_thread $MF2_MAT_ASM_fasta $MF2_R2_fq_gz 1> HiC_MAT_MAP.R2.sam 2> HiC_MAT_MAP.R2.log &

$bwa mem -t $n_thread $MF2_PAT_ASM_fasta $MF2_R1_fq_gz 1> HiC_PAT_MAP.R1.sam 2> HiC_PAT_MAP.R1.log &
$bwa mem -t $n_thread $MF2_PAT_ASM_fasta $MF2_R2_fq_gz 1> HiC_PAT_MAP.R2.sam 2> HiC_PAT_MAP.R2.log &
wait

#### 01 get_info
cut -f 1,2,3,6,12 HiC_MAT_MAP.R1.sam | perl -ane  \
'if(/NM:i:(\d+)/){ $n=$1;$m=$g=$o=0;$m+=$1 while/(\d+)M/g;$g+=$1,++$o while/(\d+)[ID]/g; chomp ;@a=split;print($a[0],"\t",$a[1],"\t",$a[2], "\t", 1-($n-$g+$o)/($m+$o) ,"\t",($m+$o)-($n-$g+$o),  "\t",($m+$o),"\n")}' \
> HiC_MAT_MAP.R1.Info &

cut -f 1,2,3,6,12 HiC_MAT_MAP.R2.sam | perl -ane  \
'if(/NM:i:(\d+)/){ $n=$1;$m=$g=$o=0;$m+=$1 while/(\d+)M/g;$g+=$1,++$o while/(\d+)[ID]/g; chomp ;@a=split;print($a[0],"\t",$a[1],"\t",$a[2], "\t", 1-($n-$g+$o)/($m+$o) ,"\t",($m+$o)-($n-$g+$o),  "\t",($m+$o),"\n")}' \
> HiC_MAT_MAP.R2.Info &

cut -f 1,2,3,6,12 HiC_PAT_MAP.R1.sam | perl -ane  \
'if(/NM:i:(\d+)/){ $n=$1;$m=$g=$o=0;$m+=$1 while/(\d+)M/g;$g+=$1,++$o while/(\d+)[ID]/g; chomp ;@a=split;print($a[0],"\t",$a[1],"\t",$a[2], "\t", 1-($n-$g+$o)/($m+$o) ,"\t",($m+$o)-($n-$g+$o),  "\t",($m+$o),"\n")}' \
> HiC_PAT_MAP.R1.Info &

cut -f 1,2,3,6,12 HiC_PAT_MAP.R2.sam | perl -ane  \
'if(/NM:i:(\d+)/){ $n=$1;$m=$g=$o=0;$m+=$1 while/(\d+)M/g;$g+=$1,++$o while/(\d+)[ID]/g; chomp ;@a=split;print($a[0],"\t",$a[1],"\t",$a[2], "\t", 1-($n-$g+$o)/($m+$o) ,"\t",($m+$o)-($n-$g+$o),  "\t",($m+$o),"\n")}' \
> HiC_PAT_MAP.R2.Info &

wait

#### 02 get_read_score.sh
awk 'BEGIN{name="";chr="";score=0;}{ if(NR>=1){ n=$1; chr=$3;if(n!=name && name!=""){printf("%s\t%s\t%f\n",name,ref,score);score=0;} name=n;if($2<256){ref=$3;score=(3*(log($4)/log(10))+(log($6)/log(10)) );} } }' \
HiC_MAT_MAP.R1.Info > HiC_MAT_MAP.R1.Info.score &
 
awk 'BEGIN{name="";chr="";score=0;}{ if(NR>=1){ n=$1; chr=$3;if(n!=name && name!=""){printf("%s\t%s\t%f\n",name,ref,score);score=0;} name=n;if($2<256){ref=$3;score=(3*(log($4)/log(10))+(log($6)/log(10)) );} } }' \
HiC_MAT_MAP.R2.Info > HiC_MAT_MAP.R2.Info.score &

awk 'BEGIN{name="";chr="";score=0;}{ if(NR>=1){ n=$1; chr=$3;if(n!=name && name!=""){printf("%s\t%s\t%f\n",name,ref,score);score=0;} name=n;if($2<256){ref=$3;score=(3*(log($4)/log(10))+(log($6)/log(10)) );} } }' \
HiC_PAT_MAP.R1.Info > HiC_PAT_MAP.R1.Info.score &

awk 'BEGIN{name="";chr="";score=0;}{ if(NR>=1){ n=$1; chr=$3;if(n!=name && name!=""){printf("%s\t%s\t%f\n",name,ref,score);score=0;} name=n;if($2<256){ref=$3;score=(3*(log($4)/log(10))+(log($6)/log(10)) );} } }' \
HiC_PAT_MAP.R2.Info > HiC_PAT_MAP.R2.Info.score &
wait

#### 03 merge_pe_read_info.sh 
join -o 1.1 2.1 1.2 2.2 1.3 2.3 -e 0 -a1 -a2  HiC_MAT_MAP.R1.Info.score HiC_MAT_MAP.R2.Info.score |awk '{if($3==$4) printf("%s\t%s\n",$1,$5+$6);}'  > HiC_MAT_MAP.R1R2.merge.score &

join -o 1.1 2.1 1.2 2.2 1.3 2.3 -e 0 -a1 -a2  HiC_PAT_MAP.R1.Info.score HiC_PAT_MAP.R2.Info.score |awk '{if($3==$4) printf("%s\t%s\n",$1,$5+$6);}'  > HiC_PAT_MAP.R1R2.merge.score &

wait

#### 04 select_reads.sh

join -o 1.1 2.1 1.2  2.2  -e 0 -a1 -a2 HiC_PAT_MAP.R1R2.merge.score HiC_MAT_MAP.R1R2.merge.score > read.scores 2>join.err 

awk '{if($1==0) name =$2; else name = $1 ; if($3>$4)print name>"paternal.reads"; else if ( $4>$3) print name>"maternal.reads" ; else print name>"homo.reads"}' read.scores
wait

#### 05 extract_reads.sh
seqtk=/share/app/seqtk/1.3/seqtk
awk '{print $1"/1"}' paternal.reads > paternal.reads_1 &
awk '{print $1"/2"}' paternal.reads > paternal.reads_2 &

awk '{print $1"/1"}' maternal.reads > maternal.reads_1 &
awk '{print $1"/2"}' maternal.reads > maternal.reads_2 &
wait

$seqtk subseq $MF2_R1_fq_gz paternal.reads_1 |gzip > paternal.reads_1.fq.gz &
$seqtk subseq $MF2_R2_fq_gz paternal.reads_2 |gzip > paternal.reads_2.fq.gz &

$seqtk subseq $MF2_R1_fq_gz maternal.reads_1 |gzip > maternal.reads_1.fq.gz &
$seqtk subseq $MF2_R2_fq_gz maternal.reads_2 |gzip > maternal.reads_2.fq.gz &

wait
echo "HiC Trio Binning End: `date`"
