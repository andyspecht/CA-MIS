----------------------------------------------------------------
PowerShell Utility for California Management Information Systems
----------------------------------------------------------------

Q) For whom is this useful?
A) Honestly, not that many people. It is for the staff members at
California's 100+ Community Colleges responsible for assembling
the school's MIS submission.

Q) How do use this utility?
A) Copy master.ps1 and config.csv to your folder that contains the files
for your MIS submission. The files you are submitting to MIS must be have
.ext or .dat file extensions. Fill out the information in config.csv and
then run master.ps1.

Q) What does the utility do?
A) It creates copies of the relevant .ext files, renames them as .dat files
and gives them an appropriate name for MIS submission. Most importantly, this 
utility will automatically create a perfectly formated TX (transmittal) file 
that has information on all the .dat files in your folder and the contact
information you provide in the config.csv. This saves you the work of having
to tediously piece together the TX file.

Q) What information goes into config.csv
A) Column A: your school's three digit district code
   Column B: the current three digit MIS term
   Column C: The first names of your three contact people 
   Column D: The last names of your three contact people 
   Column E: The phone numbers of your three contact people 
				The three contact people are:
					DP Manager, Tech Contact, and Data Contact in that order
					You can repeat contacts if someone is responsible for multiple
					things
	Column F: The valid types of files that can be submitted via MIS. These are
			  current as of Summer 2017.

Q) What is MIS?
A) See this site: http://extranet.cccco.edu/Divisions/TechResearchInfoSys/MIS.aspx

Q) What version of PowerShell do you need?
A) It has been tested on 2.0 and 3.0. 

