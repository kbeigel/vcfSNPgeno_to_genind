# Load libraries
library("stringr")
library("tidyverse")
library("data.table")
library("adegenet")
library("hierfstat")
library("poppr")
library("pegas")
library("ape")
library("ade4")
library("dartR")
library("vegan")


# Enter working directory here
setwd("")


## Read in data (tab separated txt file, loci as rows and samples as columns)
geno.raw <- read.table("file_name.txt", 
                           header = FALSE,
                           stringsAsFactors = FALSE)


## Transposing the data
geno.tp <- as.data.frame(transpose(geno.raw))


## Format check
dim(geno.tp)
geno.tp[,1:10]


#### MAKING THE MAIN DATAFRAME ####
## Adjusting data frame
geno.df = as.data.frame(geno.tp[2:nrow(geno.tp), 1:ncol(geno.tp)],)


# Use the first row from the transposed data as the column names
colnames(geno.df) = geno.tp[1,1:ncol(geno.tp)]


# Renumbering the rows
rownames(geno.df) = c(1:20)


## Optional: adjust/remote any undesired prefixes/suffixes/etc in colnames
colnames(geno.df) = gsub("_", "", colnames(geno.df))
colnames(geno.df) = gsub("-", "", colnames(geno.df))
colnames(geno.df) = gsub("\\.", "", colnames(geno.df))


## Optional: adjust/remote any undesired prefixes/suffixes/etc in rownames
geno.df[,1] = gsub("-", "", geno.df[,1])
geno.df[,1] = gsub("_sorted", "", geno.df[,1])


#### MAKING THE GENIND OBJECT ####
### OPTIONS:
## 1. SUBSET OF LOCI: This is a lot of data so a subset can be used to test
ant.loci = geno.df[,3:100000]

## 2. ALL LOCI: Use this when ready to run all loci
# ant.all.loci = ant.geno.df[,3:ncol(ant.geno.df)]


### TROUBLESHOOTING df2genind:
## Once you try running df2genind below, check back here!
## IF df2genind says LOCUS NAMES ARE NOT UNIQUE: Assign numbers to the colnames


## Check if loci names are unique
## define the function
check_dup_colnames <- function(input.df) {
  dupes <- duplicated(colnames(input.df))
}




## Make list of numbers from 1 to <total number of loci>
loci.numbers = c(1:(ncol(ant.geno.tp)-2))

## Reassign column names as list of numbers to data frame of loci
colnames(ant.loci) = loci.numbers[1:99998] # for subset of loci
# colnames(all.loci) = loci.numbers[1:ncol(all.loci)] # for all loci

## Code here is to make a reference guide for numbers to loci names
# loci.names = c(ant.geno.tp[1,3:ncol(ant.geno.tp)])
# loci.ref = data.frame(loci.numbers, loci.names)

## For df2genind, we need some additional parameters to define the individuals
## as well as the populations (groups, etc.)
ind = as.character(ant.geno.df$antid) # labels of the INDIVIDUALS
sp = as.character(ant.geno.df$species) # labels of the POPULATIONS


### RUN THE FXN df2genind:
## Notes on using df2genind to make the genind object:
## THIS IS IMPORTANT. Check your data to see how "missing" alleles/genotypes
## are coded. By default this is "NA", but if you have another coding for
## missing genotypes, this must be specified using the NA.char parameter
## (accepts a character string). Make sure to use the correct arg for the df,
## either loci or all.loci!
ant.geno.gi = df2genind(ant.loci, ploidy = 2, ind.names = ind, pop = sp, 
                        sep = "", NA.char = "NN")






###################

#### INDIVIDUAL GENETIC DISTANCES ####
### https://popgen.nescent.org/2015-05-18-Dist-SNP.html

## EUCLIDEAN DISTANCE
## Need to used the genind object as input
ant.distgenEUCL = dist(ant.geno.gi, method = "euclidean", diag = FALSE, upper = FALSE, p=2)
ant.distgenEUCL.df <- as.data.frame(as.matrix(ant.distgenEUCL))