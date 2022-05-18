# GettingAndCleaningDataCourseProject
Coursera/ Johns Hopkins University "Getting and Cleaning Data" Course Project

The purpose of the project is to demonstrate ability to collect, work with, and clean a data set.

The project consists on preparing a tidy data set for the "Human Activity Recognition Using Smartphones Data Set", generating a second tidy data set with variables means and providing a code book.

Files in this repository:  
run_analysis.R - R script that performs the data preparation.

CodeBook.pdf -  - Code Book containing information on the raw data used, the steps performed by the run_analysis.R script to prepare the final tidy data set and a list of variables in the tidy data set.

CodeBook.html - Same as above, in html format. If GitHub doesn't show the rendered formatted html, it can be viewed here: https://raw.githack.com/#:~:text=https%3A//rawcdn.githack.com/Lilith21971/GettingAndCleaningDataCourseProject/45d54daab26f8cad656354fae3f25b21d72857c9/CodeBook.html

CodeBook.Rmd - R Markdown script used to generate the CodeBook.html file.

FinalData.txt - final tidy data set as a text file; to read it in R, after downloading it and properly addressing its path, run: read.table("path/FinalData.txt", header=TRUE).  
Dimensions (wide form): 180 rows, 88 columns.  
All variables in the final data set, except Subject and Activity, refer to group means, i.e. they are feature measurement averages within the pair of Subject and Activity.

** Please see the Code Book (CodeBook.html) for more information.
