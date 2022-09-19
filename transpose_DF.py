#!/usr/bin/env python3

import argparse
import sys
import pandas as pd
import csv
from pathlib import Path


def Get_Arguments():

	parser = argparse.ArgumentParser(description='Transposing file so that samples are rows and loci are columns.')
	parser.add_argument("-d", "--directory", type=str, required=True, help="Run subfolder")
	parser.add_argument("-i", "--inputfile", type=str, required=True, help="Input text file")
	parser.add_argument("-o", "--outputfile", type=str, required=True, help="Output text file")

	args = parser.parse_args()

	return args

# transpose the dataframe
def Transpose_DF(infile, outfile):
		with open(infile, 'r') as f:
			outfile = (pd.read_csv(f, sep='\t', index_col=0, header=0)).T
			outfile.to_csv('{}/{}'.format(arguments.directory, arguments.outputfile), sep='\t')


def Print_Dimensions(infile):

	with open(infile, 'r') as f:
		for count, line in enumerate(f):
			pass
		print(' Number of rows: ', count)

	with open(infile, 'r') as f:
		first_line = f.readline()
		column_list = list(first_line.split('\t'))
		column_list.remove(column_list[0])
		print(' Number of columns: ', len(column_list))
		

def Write_ID_List(infile, ID_type):

	ID_list = []
	with open(infile, 'r') as f:
		for line in f:
			ID = line.split("	")[0]
			ID_list.append(ID)

		ID_list.remove(ID_list[0])
		df = pd.DataFrame({('{}').format(ID_type):ID_list})
		df.to_csv('{}/{}_ID_list.txt'.format(arguments.directory, ID_type), sep='\t')
		


arguments = Get_Arguments()

dir = arguments.directory
if Path(dir).exists() == True:
	pass
else:
	Path(arguments.directory).mkdir()

print('\nINPUT FILE DIMENSIONS (rows = loci, columns = samples)')
Print_Dimensions(dir+'/'+arguments.inputfile)

Write_ID_List(dir+'/'+arguments.inputfile, 'locus')

print('\nTRANSPOSING DATAFRAME')
Transpose_DF(dir+'/'+arguments.inputfile, arguments.outputfile)

print('\nOUTPUT FILE DIMENSIONS (rows = samples, columns = loci)')
Print_Dimensions(dir+'/'+arguments.outputfile)

print('\nWriting list of samples to txt file.')
Write_ID_List(dir+'/'+arguments.outputfile, 'sample')