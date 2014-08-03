Getting and Cleaning Data Course Project
========================================

This file provides a quick description of the run_analysis script

* Create required directories and downloads file if required
* File unzipped to enable downstream processing
* Basic data manipulation is performed to get to one table
 - Renames columns as appropriate
* Select columns that are required for analysis
 - We only need columns relating to the mean and standard deviation
* Apply activity labels as appropriate
 - This is required so we know what we activity we are analysing
* Rename Columns to make them more readable
 - This involves things like removing capitals and removing dashes
* Summarise table to compute mean for each combination of subject and activity
* Export table to working directory
