data aps;
set "/home/u60949421/SAS files/RESEARCH ASS/aps.sas7bdat";
run;

data age_aps;
set aps;
age = round(age);
run;

proc univariate data = age_aps;
var age;
run;

data new_aps;
set aps;
age = round(age);
if age = 11 then age = 12;
if age = 18 then age = 17;
if age = 17 then age = 16;
if neuro = 3 then neuro = 2;
if 0 <= behav <= 2 then behav = 2 ;
if 0 <= los < 7 then losgrp = 0;
else if 7 <= los < 14 then losgrp = 1;
else if los >= 14 then losgrp = 2;
run;

/*DETERMINING THE TREND OF EACH VARIABLE USING PROC FREQ*/
/*VARIABLE AGE*/
*As age increases, the likelihood for a teen to be a residential patient also increases, this a positive slope;
/*VARIABLE RACE*/
*The likelihood of being a residential patient increases as the teen is a non-white person;
/*VARIABLE GENDER*/
*The odd of females to become residential patients decreases as the levels of placement increase;
/*Neuropsychiatric Disturbance*/
*The odds to become a residential patient increase as the levels of this disturbance increase;
/*Emotional Disturbance*/
*If a teen is emotinaly disturbed, their odds of being a residential also increase;
/*DANGER*/
*If the teen is highly likely to be danger to others, their odds of being a residential patient increases;
/*ELOPE*/
*Positive trend;
/*Length of Hospitalization*/
*Positive trend;
/*BEHAV*/
*On average, there is a nice positive trend;
/*CUSTD*/
*Positive relationship;
/*VIOL*/
*Positive relationship;

 
proc freq data = new_aps;
tables place3*(age race gender neuro emot danger elope losgrp behav custd viol) / chisq;
run;
/*THE VARIABLES THAT DO NOT PLAY A SIGNIFICANT ROLE IN THE RESPOENSE*/
*RACE, gender, neuro;

/*ESTIMATING 0 VS 1*/

proc logistic data = new_aps;
where place3^=2;
class race gender neuro emot elope custd viol;
model place3 (REF = '0') = age race gender neuro emot /*danger*/ elope losgrp behav custd viol / aggregate scale = none;
output out = predicted predprobs = I;
run;


*ALLISON PG 147;
/*BINARY LOGIT MODEL ESTIMATION*/
/*ESTIMATING 0 VS 2*/

proc logistic data = new_aps;
where place3^=1;
class race gender neuro emot elope custd viol;
model place3 (REF = '0') = age race gender neuro emot danger elope losgrp behav custd viol / aggregate scale = none;
output out = predicted predprobs = I;
run;


/*ESTIMATING 1 VS 2*/
proc logistic data = new_aps;
where place3^=0;
class race gender neuro emot elope custd viol;
model place3 (REF = '1') = age race gender neuro emot danger elope losgrp behav custd viol / aggregate scale = none;
output out = predicted predprobs = I;
estimate "AGE" age 1/ exp;
estimate "DANGER" danger 1 / exp;
estimate "0 vs 1" neuro 1 -1 / exp;
estimate "0 vs 2" neuro 2  1 / exp;
estimate "1 vs 2" neuro 1  2 / exp;
run;

***************************************************************************;
*Center age and behav around 0 and fit a slope;
*THE MULTINOMIAL LOGIT MODEL;
*THIS CODE IS FOR 0 VS 1, AND 0 VS 2;

proc logistic data = new_aps;
class race gender neuro emot elope custd viol;
model place3 (REF = '0') = age race gender neuro emot danger elope losgrp behav custd viol / LINK = GLOGIT aggregate scale = none;
output out = predicted predprobs = I;
run;

*THIS CODE IS FOR 0 VS 1, AND 1 VS 2;

proc logistic data = new_aps;
class race gender neuro emot elope custd viol;
model place3 (REF = '1') = age race gender neuro emot danger elope losgrp behav custd viol / LINK = GLOGIT aggregate scale = none;
output out = predicted predprobs = I;
run;


*************************************************************************;
*THE ORDERED LOGIT MODEL;
*DANGER IS EXCLUDED. BUT WHY? LOOK AT PROC FREQ;
proc logistic data = new_aps;
class race gender neuro emot elope custd viol;
model place3 = age race gender neuro emot elope losgrp behav custd viol / aggregate scale = none;
output out = predicted predprobs = I;
run;

proc freq data=new_aps;
table race*place3 / out=os;
run;

proc transpose data=os out=tran;
by race; var count;
run;
     
data a; set tran;
const=0;
c1=log((sum(of col1-col1)+const)/(sum(of col2-col3)+const));
c2=log((sum(of col1-col2)+const)/(sum(of col3-col3)+const));
/*c3=log((sum(of col1-col3)+const)/(sum(of col4-col3)+const));*/
run;
     
proc sgplot;
series y=c1 x=race; 
series y=c2 x=race;
/*series y=c3 x=race;*/
yaxis label="Empirical Logits";
xaxis integer;
run;

*FOR ANOTHER VARIABLE;

proc freq data=new_aps;
table neuro*place3 / out=os;
run;

proc transpose data=os out=tran;
by neuro; var count;
run;
     
data a; set tran;
const=0;
c1=log((sum(of col1-col1)+const)/(sum(of col2-col3)+const));
c2=log((sum(of col1-col2)+const)/(sum(of col3-col3)+const));
c3=log((sum(of col1-col3)+const)/(sum(of col4-col3)+const));
run;
     
proc sgplot;
series y=c1 x=neuro; 
series y=c2 x=neuro;
series y=c3 x=neuro;
yaxis label="Empirical Logits";
xaxis integer;
run;

proc logistic data = new_aps;
class race gender neuro emot elope custd viol;
model place3 = age race gender neuro emot elope losgrp behav custd viol / aggregate scale = none unequalslopes;
output out = predicted predprobs = I;
run;

*TRY TO ESTIMATE THE BINARY FROM THE ORDERED;

data a;
set new_aps;
if place3 = 0 then place3 = 1;

proc logistic data = a;
model place3 = age race gender neuro emot danger elope losgrp behav custd viol / aggregate scale = none;
output out = predicted predprobs = I;
run;

data b;
set new_aps;
if place3 = 2 then place3 = 1;

proc logistic data = b;
model place3 = age race gender neuro emot danger elope losgrp behav custd viol / aggregate scale = none;
output out = predicted predprobs = I;
run;

**********************************************************************************;
































































