//==============================================
//    Do file to compute enumerators scores
//    Filippo C - IPA SL
//==============================================




*cd "C:\Users\FCuccaro\Box Sync\Hiring test 2020"
cd "C:\Users\DELL\Box Sync\Hiring test 2020"


// change to try
gen issue=1 if spel_score1!=.


// change 2 to new branch
drop issue if issue==1


//this are the data from enum test done on February 2020
use "hiring_test_2019.dta"
foreach var in *_*s{
destring `var',replace 
}

gen feb2020=1

//here I append data from previuos test (March 2019)
append using "hiring_test_2019_old.dta"

foreach var in *_*s belmont_score*{
destring `var',replace 
}

replace belmont_score = 1 if belmont == "2 3 4"

gen spel_score1=0
gen spel_score2=0
gen spel_score3=0
gen spel_score4=0
gen spel_score5=0
gen spel_score6=0
gen spel_score7=0
gen spel_score8=0

replace spel_score1=0.5 if innovation==4
replace spel_score2=0.5 if ambiguous==3
replace spel_score3=0.5 if necessary==2
replace spel_score4=0.5 if certificate==2
replace spel_score5=0.5 if successful==1
replace spel_score6=0.5 if embarrassed==3
replace spel_score7=0.5 if accommodation==4
replace spel_score8=0.5 if february==2

egen spel_score = rowtotal(spel_score1 spel_score2 spel_score3 spel_score4 spel_score5 spel_score6 spel_score7 spel_score8)

egen tot_score = rowtotal( *_*s belmont_score belmont_score2 belmont_score3 spel_score)
egen tot_lang = rowtotal (languages_1 languages_2 languages_3 languages_4 languages_5 languages_6 languages_7 languages_8 languages_9 languages_10 languages_11 languages_12 languages_13 )

// create variables to look at languages spoken
gen 	lang_spoke1=	"Mende"	 if 	languages_1	==	1
gen 	lang_spoke2=	"Temne"	 if 	languages_2	==	1
gen 	lang_spoke3=	"Kono"	 if 	languages_3	==	1
gen 	lang_spoke4=	"Kissy"	 if 	languages_4	==	1
gen 	lang_spoke5=	"Koronko" if 	languages_5	==	1
gen 	lang_spoke6=	"Susu"	 if 	languages_6	==	1
gen 	lang_spoke7=	"Limba"	 if 	languages_7	==	1
gen 	lang_spoke8=	"Mandingo" if 	languages_8	==	1
gen 	lang_spoke9=	"Loko"	 if 	languages_9	==	1
gen 	lang_spoke10=	"Fulla"	 if 	languages_10	==	1
gen 	lang_spoke11=	"Other"	 if 	languages_11	==	1
gen 	lang_spoke12=	"Yalunka" if 	languages_12	==	1
gen 	lang_spoke13=	"Krio"	 if 	languages_13	==	1

egen lang_all= concat (lang_spoke1 lang_spoke2 lang_spoke3 lang_spoke4 lang_spoke5 lang_spoke6 lang_spoke7 lang_spoke8 lang_spoke9 lang_spoke10 lang_spoke11 lang_spoke12 lang_spoke13),punct(" ")

gsort tot_score

save "hiring_test_full_clean.dta",replace 

sum tot_score if feb2020==.,d
/*
		tot_score
				
	Percentiles	Smallest
1%	5	0
5%	6	2
10%	7	2	Obs	604
25%	9	4	Sum of Wgt.	604

50%	11		        Mean	10.70861
		Largest	Std. Dev.	2.674961
75%	13	17
90%	14	17	Variance	7.155415
95%	15	17	Skewness	-.3263274
99%	16	18	Kurtosis	3.109849
*/

sum tot_score if feb2020==1,d
/*
		tot_score
				
	Percentiles	Smallest
1%	7	1
5%	9	7
10%	10	7.5	Obs	169
25%	12	7.5	Sum of Wgt.	169

50%	13.5		    Mean	13.39349
		Largest	Std. Dev.	2.791444
75%	15	19
90%	17	19	Variance	7.79216
95%	17.5	19.5	Skewness	-.4825183
99%	19.5	20.5	Kurtosis	4.49173

*/

tempfile tot_score

save "`tot_score'"

use "`tot_score'",clear

//====================================
//here below the new (2020) candidate
//====================================

keep if feb2020==1 & enum_exp_ipa == 1 & tot_score >= 13.6

save "prev_ipa_exp_above_cutoff_2020.dta",replace

use "`tot_score'",clear

keep if feb2020==1 & enum_exp_ipa == 1 & tot_score < 13.6

save "prev_ipa_exp_below_cutoff_2020.dta",replace

use "`tot_score'",clear

keep if  feb2020==1 & enum_exp_ipa == 0 & tot_score >= 13.6

save "new_recruits_above_cutoff_2020.dta",replace 

use "`tot_score'",clear

keep if feb2020==1 & tot_score >= 13.6

save "new_to_database_2020.dta",replace

//====================================
//here below the old (2019) candidate
//====================================
use "`tot_score'",clear

keep if feb2020==. & enum_exp_ipa == 1 & tot_score >= 11.1

save "prev_ipa_exp_above_cutoff_2019.dta",replace

use "`tot_score'",clear

keep if feb2020==. & enum_exp_ipa == 1 & tot_score < 11.1

save "prev_ipa_exp_below_cutoff_2019.dta",replace

use "`tot_score'",clear

keep if  feb2020==. & enum_exp_ipa == 0 & tot_score >= 11.1

save "new_recruits_above_cutoff_2019.dta",replace 

use "`tot_score'",clear

keep if feb2020==. & tot_score >= 11.1

save "new_to_database_2019.dta",replace
