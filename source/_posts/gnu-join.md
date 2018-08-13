---
title: Gnu join - join two files by specified field
date: 2018-08-10 12:36:45
tags:
---

# How to join multiple files using GNU join

## Basic usage

Create two files with *TAB* delimiter

file1:
	
	a    1
	b   1
	d       1
	e       1
	g       1
	
	
file2:

	a   2
	b   2
	c   2
	e   2
	f   2

Join them use join:
   
    join -1 1 -2 1 file1 file2

Output:

	a 1 2
	d 1 2
	e 1 2
	

## The very useful options for GNU join

### -a1 - print unmatched lines in file1;

	join -1 1 -1 1 file1 file2 -a1
	
Output:

	a 1 2
	b 1
	d 1 2
	e 1 2
	g 1

### -a2 - print unmatched lines in file2
	
	join -1 1 -1 1 file1 file2 -a2
	
Output:

	a 1 2
	c 2
	d 1 2
	e 1 2
	f 2

### -a1 -a2 - print unmatched lines in both file1 and file2

	join  -1 1 -1 1 file1 file2 -a1 -a2

Output:

	a 1 2
	b 1
	c 2
	d 1 2
	e 1 2
	f 2
	g 1


*Be careful that tab is not aligned well.*

### -o - To align the output in table format, use the option to custome the output

	join  -1 1 -1 1 file1 file2 -a1 -a2 -o 0,1.2,2.2

*0*  means the joined column.
*1.2* means print the column 2 in file1;
*2.2* means print the column 2 in file2;

Output:

	a 1 2
	b 1 
	c  2
	d 1 2
	e 1 2
	f  2
	g 1 

If file1 and files have more than 2 columns, modify the -o string

### -t - To use the *TAB* as output delimiter

	join  -1 1 -1 1 file1 file2 -a1 -a2 -o 0,1.2,2.2 -t$'\t'
	
Output:

	a       1       2
	b       1
	c               2
	d       1       2
	e       1       2
	f               2
	g       1
	

### --check-order -  join requires the input file sorted, if join with 1st column, please sort the input files using 1st columns before use join. And to make sure there is no problem, use this option to check.

	join  -1 1 -1 1 file1 file2 -a1 -a2 -o 0,1.2,2.2 -t$'\t' --check-order

Output:

	a       1       2
	b       1
	c               2
	d       1       2
	e       1       2
	f               2
	g       1
	
Create non-sorted file3:

	a       3
	d       3
	c       3
	e       3
	f       3
	
join file1 and file3:

	join  -1 1 -1 1 file1 file3 -a1 -a2 -o 0,1.2,2.2 -t$'\t' --check-order


Output with error message:

	a       1       3
	b       1
	join: file3:3: is not sorted: c 3



### -e -  To make the output format more strict and use this option to fill missing columns. This helps greatly if you need to process the file in the downstreaming analysis.

	join  -1 1 -1 1 file1 file2 -a1 -a2 -o 0,1.2,2.2 -t$'\t' --check-order -eNULL
	
Output:

	a       1       2
	b       1       NULL
	c       NULL    2
	d       1       2
	e       1       2
	f       NULL    2
	g       1       NULL

Output is a very tidy table.

