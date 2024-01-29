******************************************************************
******************************************************************
* Data Processing
* Survey Research Analysis
* IPSA-USP Summer School 2019
******************************************************************
******************************************************************


* Clear our workspace
clear all

* Set our working directory
cd ""


********************************************************
** Drawing Discrete Distributions
********************************************************

** Let's clear our workspace and load in some data
** all this is is one variable with many possible outcomes 
** from a roll of a die
use dice_population , clear

** Let's check it out
sum dice
tab dice
** tab is a good command if you have a discrete variable

** We can preserve the data so that we can guarantee that 
** the data will be resored after we finish our session
preserve


** If we do not know what a distribution looks like,
** we can sample from the set of possible outcomes (the sample space)
** and then look at the distribution of the sample

** Again, think about rolling a die
** in this case, our variable dice provides us with the sample space

** Sample from the population
** i.e. Roll the "die" repeatedly
sample 10000 , count
** 1000000 is the sample size
** the rest of the data will be deleted (this is why we preserved it)
** the larger it is the more accurate will be your distribution
**    Prove it to yourself!
** count says that we are specifying the size of the sample as a count

** Plot the distribution of our variable (roll of a die)
hist dice , discrete

** restores the data to the point when we preserved it
restore


********************************************************
** Drawing Continuous Distributions
********************************************************

** Let's clear our work space
clear

** Like with discrete distributions, we can sample from the population
** to see what our distribution looks like

** Stata has a bunch of canned functions which make this easy

** Say we want to look at the distribution of salaries
** and we assume that salaries are normally distributed 
** with mean 40000 and standard deviation 10000

** It may be hard to conceptualize this distribution,
** So we can sample from it using the drawnorm command
** First, we set our sample size or the number of observations we want
set obs 1000000
drawnorm salary , mean (40000) sd (10000)

** Plot the distribution
kdensity salary


********************************************************
** Summary Statistics
********************************************************

** Let's load the apipop data from last week
use "apipop.dta", clear

************************
* Visualize the distribution of variables

* We can look at the distribution of continuous variables by plotting its density as we did above
kdensity enroll

* And we can look at the distribution of discrete variables by plotting a histogram
hist awards, discrete

************************
* Cross-Tabs

* We can also look at how two discrete variables interact 
* by creating a table of the cross-tabulations
tabulate awards stype

* And we can look at the proportions by specifying whether we want row or col proporitions
tabulate awards stype, row col


************************
* Mean, SD, N, Min, Max

* Let's get all of the summary statistics for the variable enroll 
* What is the mean? standard deviation? max? min? median? quantiles?
sum enroll, detail
	local meanenroll = r(mean)
	local sdenroll = r(sd)
	local maxenroll = r(max)
	local minenroll = r(min)
	local medianenroll = r(p50)
	local enroll25 = r(p25)
	local enroll75 = r(p75)
	local enrollN = r(N)
	
* Number of observations
count
count if enroll != .

* We can also calculate the standard error for the sample mean:
di `sdenroll'/sqrt(`enrollN')


********************************************************
** Summary Statistics : Surveys
********************************************************

* Over the next week, we will discuss why we have to calculate our statistics from survey data
* in a different way than from other data
* But for now, let's familiarize ourselves with the survey package and how we can use it 
* to get summary statistics

* Lets use the apisrs data, which is just a random sample from the population
use "apisrs.dta", clear

* First, we must tell Stata that this is survey data using the svyset function
svyset _n, fpc(fpc)
  * _n specifies that we sampled observations directly (i.e. there are no clusters)
  * fpc(fpc) says that the variable fpc contains the population size 
  *     this is specifying the finite population correction - it is not necessary if we are taking only a small sample of the population
  * from this, the function can work out the sampling weights


* Now we can estimate summary statistics
svy: mean enroll
svy: total enroll

* We can also use this to get updated cross tabs!
svy: tab awards stype



********************************************************
** Coding
********************************************************

clear

* Let's just create some empty data
set obs 100
generate u1 = runiform()

************************
* Factor Variables 

** Create Factor Variable from Dichotomous Data
gen gender = 1 if _n <51
replace gender = 2 if _n >50
lab define sex 1 "Male" 2 "Female"
lab values gender sex

** Recode Data
recode gender (2=1)(1=0)
lab define sex2 0 "Male" 1 "Female"
lab values gender sex2


** Using recode function to create factors from continuous data
gen age = ceil(87 * uniform())
recode age (1/21 = 1) (22/65 = 2) (65/87 = 3), generate(agecat)
tab agecat


** We can also use the recode function to create indicator variables
recode age (0/50 = 0) (51/87 = 1), generate(agedummy)
tab agedummy

** Let's look at the mean of our categorical age
sum agecat



********************************************************
** Simple Indices
********************************************************

* Load Arrests data 
use "USArrests", clear
sum

* One possible index we can create by combining this data is to take the simple arithmetic mean
* But first, we should standardize the variables
* For this, we can use the scale function
foreach var of varlist _all {
	sum `var'
		local me = r(mean)
		local sd = r(sd)
	gen `var'_stand = (`var' - `me')/`sd'
}
sum

* Now we can create an index that is the mean across all measures
* For this, we will use the egen function, which applies a function to all rows or columns in a data set
egen index1 = rowmean(*_stand)
sum index1


* Another index could be the total across all variables (although this doesn't make a huge amount of sense in this case)
egen index2 = rowtotal(*_stand)



********************************************************
** Principal Components Analysis
********************************************************

* Run PCA on all standardized variables using the prcomp function
pca *_stand
* We can specify how many components we want using components() or 
*		the min eigen value using mineigen()

* How many components should we keep?
* We can look at a screeplot
screeplot

* Let's extract our first two principal components
predict pc1 pc2, score
* Each of these variables is a principal component
* We will usually use 1 or 2 of these as variables in our analysis instead of the multiple measures

* What are we capturing?
cor Murder Assault UrbanPop Rape pc1 pc2
* The first PC is highly correlated with the variables Murder, Assault, and Rape
* The second PC is highly correlated with UrbanPop



