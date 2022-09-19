# vcfSNPgeno_to_genind pipeline
This set of scripts extracts genotypes at loci where SNPs were identified in a VCF file to a matrix of genotypes. This output file of genotypes is then edited for format using sed/awk/grep, and transposed using a python script. All arguments from the bash command are passed to Python.

## Dependencies
	python3

	bcftools


## Usage:

This bash script calls the python script, and both can be executed using bash. Call the vcf2SNPgeno_pyT.sh script in the following manner:
	bash vcf2SNPgeno_pyT.sh -d \<OUTPUT_DIRECTORY> -i \<INPUTFILE> -o \<OUTPUTFILE>
The arguments in the bash command are passed to Python.

The output file from Python (the transposed data table) can then be imported into R. Because there may be some additional formatting to troubleshoot in R, the R script is not chained in the original bash command.