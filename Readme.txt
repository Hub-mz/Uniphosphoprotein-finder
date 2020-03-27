Step 1. Put all files under the same folder
Step 2. Run MZ_Readfiles_v3.m
	(a) The program reads data from the ‘Proteins’ sheet in the 6 excel files, 
	(b) calls "MZ_NoDupNames_from_facility_file.m" to extract protein ID from column B, spectra from column G, unique peptide from column H, modified peptides from column I, and parse the data.
	(c) and saves the parsed data matrix with a user-specified name 
Step 3. Run MZ_Readfiles_v3_filter.m 
	(a) The program reads the previous data matrix (select the file that you just saved), and 
	(b) finds the proteins absent in DMSO1 and DMSO2 and DMSO3 samples but present in Pim1 and Pim2 and Pim 3 samples.