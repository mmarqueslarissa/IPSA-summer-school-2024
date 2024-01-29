**********************************************************
**********************************************************
* Introduction to Sampling
* IPSA-USP Summer School 2023
* Survey Research Methods

**********************************************************
**********************************************************

* Clear our workspace
clear all

* Set our working directory or adapt to your own working directory/folder
cd "C:\Users\fcssalas\Downloads"

* We are going to use user-written functions in Stata
* Install if you haven't already
*ssc install gsample
*ssc install moremata

**********************************************************
** The Population
**********************************************************

* Load the API Population data
* The API population is the California Academic Performance Index data which derives from standardized
*   tests administered to students in California schools
* There are several different datasets in the API data that we will explore
use "apipop.dta", clear
* We will use the following variables:
*   stype - Elementary/Middle/High School
*   dname - District Name
*   sname - School Name
*   enroll - Number of students enrolled
*   api00 - API in 2000

* Let's treat the dataset "apipop" as our population
* We can look at it
summarize
* We have 6194 elements in our population

* Let's treat enroll as our variable of interest
* First we need to remove the rows that have a missing value for enroll
* What is the population mean and standard deviation?
summarize api00
* Let's store these values for later. The local and global commands create a so called macro. In order to use that variable stored as macro in the future we'll need to use the symbols ` and '. E.g.: `pop_N'. We could also show that variable using the command macro list. Global macros we'll be recognized in every dataset that you are reunning simultaneously.
global pop_mean = r(mean)
local pop_sd = r(sd)

* Let's also store our population size
local pop_N = r(N)


**********************************************************
** Simple Random Samples
**********************************************************

* What if we wanted to take a simple random sample of 1000 from our population?

* First let's set the seed so that we can reproduce our results
set seed 1234

* Now let's get our sample
* We will use the gsample function for this
gsample 1000, wor
* We are telling it we want a sample of size 1000 
* And to take this sample without replacement (wor)

* Let's tell Stata that this our srs is survey data
* First we have to add the population size as a column in our dataset
generate pop_N = `pop_N'

* Then we must specify the design specifics using the svyset command
svyset _n, fpc(pop_N)
  * _n specifies that we sampled observations directly (i.e. there are no clusters)
  * fpc(pop_N) says that the variable pop_N contains the population size 
  *     this is specifying the finite population correction - it is not necessary if we are taking only a small sample of the population
  * from this, the function can work out the sampling weights


* From this, let's estimate the population mean for the variable enroll. The object that contains the variance of the estimator is stored as a matrix
svy: mean api00
matrix srs_mean = e(b)
matrix list srs_mean
* This gives us the mean of 662.72 and standard error of 3.73

* How were these numbers calculated?
* Remember that mu_hat = 1/n sum x
summarize api00
local sumx = r(sum)
local n = _N
local mu_hat = (1/`n') * `sumx'
display `n'
display `mu_hat'

* And V(mu_hat) = (N-n)/n V(x)
summarize api00
local varx = r(sd)^2
local N = pop_N
local n = _N
local v_mu_hat = ((`N' - `n')/`N') * (`varx'/`n')
local se_mu_hat = sqrt(`v_mu_hat')
display `se_mu_hat'
* It's the same!


* How does this compare to just using the mean function?
summarize api00
* Note that the estimate of the sample mean is the same but the standard error is different!
* Why is this?

* How does this compare to the population mean?
macro list pop_mean


**********************************************************
** Stratified Random Samples
**********************************************************

* Now, let's take a stratified random sample of 1000 from our population
* We will use stype as the  strata variable - School Type (Elementary, Middle, High)
* Why might we want to stratify on this when trying to get a precise estimate of API scores?

* Let's re-open our population data
use "apipop.dta", clear

* Let's set the seed so that we can reproduce our results
set seed 1234

* 1. Let's figure out the sizes of the population for each strata 
bysort stype: generate pop_strata_N = _N

* 2. Let's calculate how many elements to sample from each strata so that the total sample is 1000
*	 and each strata is sampled in proportion to its population size
gen strata_N = round(1000*(pop_strata_N/_N))

* 3. Let's sample 1000 observations stratifying on stype using our assigned strata sample sizes
* Set the seed
set seed 1234
* We can get our sample again using the ssample function
gsample strata_N, wor strata(stype)  
* Here we are telling it to sample the sample size stored in strata_N for each strata
* And to stratify on stype


* 4. Let's tell Stata that this is survey data
svyset _n, fpc(pop_strata_N) strata(stype)
  * _n again specifies that we sampled observations directly (i.e. there are no clusters)
  * fpc(pop_strata_N) says that the variable pop_strata_N contains the population sizes for each strata
  * strata(stype) specifies that we stratified the sample on the variable stype
  * from this, the function can work out the sampling weights

* From this, let's estimate the population mean for the variable enroll
svy: mean api00
matrix strat_mean = e(b)
matrix list strat_mean
* This gives us the mean of 664.145 and standard error of 3.70

* We can check the design effects (DEFF and DEFT)
* DEFF =  survey design-based variance / SRS hypothetical variance
* DEFF =  survey design-based standard-error / SRS hypothetical standard-error
* DEFF is referred as d2 in the lecture slides
svy: mean api00
estat effects
* We should use the estat effects command right after running svy:mean

* How does this compare to just using the mean function?
summarize api00
* Note that the estimate of the sample mean is the same but the standard error is different!
* Why is this?

* How does this compare to the population mean?
macro list pop_mean


**********************************************************
** Subpopulation Estimates

* We could also have calculated the strata-specific statistics (subpopulation estimate) using svy: mean
svy: mean api00, over(stype)

* But what if want to calculate statistics for a subpopulation that was not a strata?
* This is difficult because the sampling weights have to correctly account for the pairwise probability of selection
* But the survey package does this for you!
* Let's look at the average enrollment for schools with awards
svy: mean api00, over(awards)


**********************************************************
** Other Quantities of Interest

* We can use the survey package to calculate other quantities of interest
* You can see all of the other things you can calculate by typing:
help svy estimation


**********************************************************
** Clustered Random Samples
**********************************************************

**********************************************************
* Single Stage Cluster Sample (Only Sample Clusters, Not Indivdiuals)

* Now, let's take a clustered random sample 
* We can cluster on county name - cname
* Let's say we want to sample from 10 clusters

* Let's re-open our population data and set the seed
use "apipop.dta", clear
set seed 1234

* We are going to do this in stata by:
* 1. Collapsing our data just to the clusters using the contract command
* 2. Sampling 10 clusters from all of the clusters
* 3. Merging this back with the apipop data
* 4. Keeping only the matched observation
* This will give us a sample of 10 clusters with all units from that cluster

* First let's collapse our data to just the clusters
* We will use the contract command which just gets the frequency of each
*	element in the cluster
contract cname
* _freq stores the number of units in the population in each cluster
* This is useful, so let's change the name of this variable
rename _freq pop_cluster_N
* Let's also store the total number of clusters in the population
gen pop_cluster_M = _N

* Second, let's sample 10 clusters from all 57 clusters using gsample as we did before
set seed 1234
gsample 10, wor

* Third, let's merge this back with the unit-leve data in api pop
merge 1:m cname using "apipop.dta"

* Fourth, let's keep only the matched units
drop if _merge != 3

* Ta-da! Now we have our sample.

* We could now do a second stage of sampling to sample individuals within clusters, but we will just
* sample everyone in the cluster for now


* Let's tell Stata that this is survey data
svyset cname, fpc(pop_cluster_M)
  * we now include cname in the beginning to say that our primary sampling unit (or cluster) was cname
  * For the finite population correct, we need to specify the total number of clusters in the population
  * We stored this in fpc(pop_cluster_M)
  * from this, the function can work out the sampling weights

* From this, let's estimate the population mean for the variable enroll
svy: mean api00
matrix clus1_mean = e(b)
matrix list clus1_mean
* This gives us the mean of 679.72 and standard error of 24.73

*We can check the design effects (DEFF and DEFT)
svy: mean api00
estat effects

* How does this compare to just using the mean function?
summarize api00

* How does this compare to the population mean?
macro list pop_mean



**********************************************************
* Two Stage Cluster Sample (Sample Clusters AND Indivdiuals)

* Now, let's take a clustered random sample, 
* but we will first sample clusters
* and then sample schools within clusters
* We can cluster on county name - cname
* Let's say we want to sample from 10 clusters, and then 1 school in each cluster

* Let's re-open our population data and set the seed
use "apipop.dta", clear
set seed 1234


* First, we sample clusters just as we did above in the one-stage clustering
contract cname
rename _freq pop_cluster_N
gen pop_cluster_M = _N
set seed 1234
gsample 10, wor
merge 1:m cname using "apipop.dta"
drop if _merge != 3

* Second, we sample individuals just as we did in the srs sampling above but essentially where we are stratifying on cluster
set seed 1234
gsample 1, wor strata(cname)
* We now have 10 observations - 1 each per cluster


* Let's tell Stata that this is survey data
svyset cname, fpc(pop_cluster_M) || _n, fpc(pop_cluster_N)
  * We use || to separate our two stages of clustering
  * First, we include cname in the beginning to say that our primary sampling unit (or cluster) was cname
  * 	For the finite population correct, we need to specify the total number of clusters in the population
  * 	We stored this in fpc(pop_cluster_M)
  * Second, we specify we sampled indivdiuals using _n
  *		and the FPC is a function of the total population size in each cluster
  * 	which we stored in pop_cluster_N
  * from this, the function can work out the sampling weights

* From this, let's estimate the population mean for the variable enroll
svy: mean api00
matrix clus2_mean = e(b)
matrix list clus2_mean
* This gives us the mean of 664.7 and standard error is missing because the sample size is too small

*We can check the design effects (DEFF and DEFT)
svy: mean api00
estat effects

* How does this compare to just using the mean function?
summarize api00

* How does this compare to the population mean?
macro list pop_mean



