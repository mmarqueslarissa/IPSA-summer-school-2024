##################################################################
##################################################################
# Data Processing
# Survey Research Analysis
# IPSA-USP Summer School 2019
##################################################################
##################################################################


##################################################################
## Probability Distributions in R
##################################################################

## PMF

## Example: roll of a die
## Let's start by creating an empty plot
plot(0,0,type="n",xlab="X",ylab="f(x)",
     xlim=c(1,6), ylim=c(0,1),
     main="PMF of Dice Roll")

## A PMF represents the probability of each event occurring individually
## i.e. the probability that you will get any outcome

## To start, we specify the probability of our first outcome
## and draw a line from 0 to that probability
## to do so, we will use the segments command 
##    which takes as its input two points:
##    the starting point (x0,y0) and the end point(x1,y1)
## for PMFs, the starting point will always be (x,0)
## and the end point will be (x,P(X=x))
segments(x0=1,x1=1,y0=0,y1=1/6)

## Next we add in the point that is the probability for our first outcome
## to do so, we will use the points command
##    which takes as its input just the point (x1,y1)
## this is the same (x1,y1) from our segment 
## i.e. (x,P(X=x))
points(x=1,y=1/6,pch=19)

## Now we just repeat this for all of our values of x
segments(x0=2,x1=2,y0=0,y1=1/6)
points(x=2,y=1/6,pch=19)
segments(x0=3,x1=3,y0=0,y1=1/6)
points(x=3,y=1/6,pch=19)
segments(x0=4,x1=4,y0=0,y1=1/6)
points(x=4,y=1/6,pch=19)
segments(x0=5,x1=5,y0=0,y1=1/6)
points(x=5,y=1/6,pch=19)
segments(x0=6,x1=6,y0=0,y1=1/6)
points(x=6,y=1/6,pch=19)

## Voila! We have a beautiful PMF



## CDF

## Create an empty plot
plot(0,0,type="n",xlab="X",ylab="f(x)",
     xlim=c(1,6), ylim=c(0,1),
     main="PMF of Dice Roll")

## A CDF represents the probability of getting an outcome less than 
##    or equal to x

## To start, we specify the probability of our first outcome
## and draw a line from 0 to that probability
## again using the segments command 
## for CDFs, the starting point will always be (x-1,P(X<x-1))
## and the end point will be (x,P(X<x-1))
## First, add the horizontal line for each value of x
segments(x0=0,x1=1,y0=0,y1=0)

## Next we add in the point that is the probability for x-1 (our preceding outcome)
## to do so, we will again use the points command
##    which takes as its input (x,P(X<x-1))
## this is an open point since it is not the actual value of F(x)
points(x=1,y=0,pch=21,bg="white")

## Next we add in the point that is the probability for x (the outcome)
## to do so, we will again use the points command
##    which takes as its input (x,P(X<x))
## this is a closed point since it is the actual value of F(x)
points(x=1,y=1/6,pch=19)

## Now we just repeat this for all of our values of x
segments(x0=1,x1=2,y0=1/6,y1=1/6)
points(x=2,y=1/6,pch=21,bg="white")
points(x=2,y=2/6,pch=19)
segments(x0=2,x1=3,y0=2/6,y1=2/6)
points(x=3,y=2/6,pch=21,bg="white")
points(x=3,y=3/6,pch=19)
segments(x0=3,x1=4,y0=3/6,y1=3/6)
points(x=4,y=3/6,pch=21,bg="white")
points(x=4,y=4/6,pch=19)
segments(x0=4,x1=5,y0=4/6,y1=4/6)
points(x=5,y=4/6,pch=21,bg="white")
points(x=5,y=5/6,pch=19)
segments(x0=5,x1=6,y0=5/6,y1=5/6)
points(x=6,y=5/6,pch=21,bg="white")
points(x=6,y=1,pch=19)

## And Voila! A CDF




########################################################
## Drawing Discrete Distributions
########################################################

## If we do not know what a distribution looks like,
## we can sample from the set of possible outcomes (the sample space)
## and then look at the distribution of the sample

## Again, think about rolling a die
## Define the sample space
S <- 1:6

## Set the sample size 
## the larger it is the more accurate will be your distribution
##    Prove it to yourself!
n <- 1000000

## Sample from the population
## i.e. Roll the "die" repeatedly
dice.rolls <- sample(S, size=n, replace=T)

## Plot the distribution 
hist(dice.rolls, freq=F)



########################################################
## Drawing Continuous Distributions
########################################################

## Like with discrete distributions, we can sample from the population
## to see what our distribution looks like

## R has a bunch of canned functions which make this easy

## Say we want to look at the distribution of salaries
## and we assume that salaries are normally distributed 
## with mean 40000 and standard deviation 10000

## It may be hard to conceptualize this distribution,
## So we can sample from it using the rnorm() command
##    n is the sample size
salaries <- rnorm(n=1000000 , mean=40000 , sd=10000)

## Plot the distribution
plot(density(salaries))

## Now, what if we wanted to know the density of the distribution
## i.e. the height of the distribution
## when x = 20000
## dnorm provides the PDF of the normal distribution
dnorm(20000, mean=40000, sd=10000)

## Or maybe we want to know the probability that a salary is 
## is less than 20000
## pnorm provides the CDF of the normal distribution
pnorm(20000, mean=40000, sd=10000)

## Or maybe we want to know what salary marks the 95% percentile
## qnorm provides the inverse CDF of the normal distribution
qnorm(0.95, mean=40000, sd=10000)
## this tells us that under our assumed model, 
## 95% of people earn a salary of less than roughly $56000


## There are many other distributions which you can sample from in a similar way!


##################################################################
## Summary Statistics
##################################################################

## Let's load the api data from the survey package
library(survey)
data(api)
names(apipop)
head(apipop)

########################
# Visualize the distribution of variables

# We can look at the distribution of continuous variables by plotting its density as we did above
plot(density(apipop$enroll, na.rm=T))
#na.rm=T just tells R to ignore missing values

# And we can look at the distribution of discrete variables by plotting a histogram
hist(as.numeric(apipop$awards))
# Note: we have to use as.numeric because the awards variable is a factor (you will see why in a second!)

########################
# Cross-Tabs

# We can also look at how two discrete variables interact 
# by creating a table of the cross-tabulations
tb1 <- table(apipop$awards, apipop$stype)
tb1

# And we can look at the proportions using the prop.table function
prop.table(tb1)

# Or add the margin totals using the addmargines function
addmargins(tb1)


########################
# Mean, SD, N, Min, Max

# Let's get all of the summary statistics for the variable enroll 
# What is the mean?
mean(apipop$enroll, na.rm=T) 
#na.rm=T just tells it to ignore the missing values, we will just ignore those for now

# What about the standard deviation?
sd(apipop$enroll, na.rm=T)

# Max?
max(apipop$enroll, na.rm=T)

# Min?
min(apipop$enroll, na.rm=T)

# Median?
median(apipop$enroll, na.rm=T)

# Quantiles?
quantile(apipop$enroll, probs = seq(0, 1, .25), na.rm=T)

# Number of observations
dim(apipop)[1]
# Or...
length(apipop$enroll)

# We can also calculate the standard error for the sample mean:
sd(apipop$enroll, na.rm=T)/sqrt(length(apipop$enroll))


##################################################################
## Summary Statistics : Surveys
##################################################################

# Over the next week, we will discuss why we have to calculate our statistics from survey data
# in a different way than from other data
# But for now, let's familiarize ourselves with the survey package and how we can use it 
# to get summary statistics

# We already loaded the survey package above
# Lets use the apisrs data, which is just a random sample from the population

# First, we must tell R that this is survey data using the svydesign function
srs_design <- svydesign(id = ~1, fpc = ~fpc, data=apisrs)
srs_design
# data specifies where data is stored
# id=~1 says that there are no clusters and individual schools were sampled (~ says this is a variable)
# fpc=~fpc says that the variable fpc contains the population size 
#     this is specifying the finite population correction - it is not necessary if we are taking only a small sample of the population
# from this, the function can work out the sampling weights

# Now we can estimate summary statistics
svymean(~enroll, srs_design)
svyvar(~enroll, srs_design)
svytotal(~enroll, srs_design)
svyquantile(~enroll, srs_design, quantiles = seq(0, 1, .25))

# We can also use this to get updated cross tabs!
svytable(~awards + stype, srs_design)
# Note, the slight difference in how we tell it which variables we want to include



##################################################################
## Coding
##################################################################


#################################
# Factor Variables 

## Create Factor Variable from Dichotomous Data
gender <- c(rep(1,50),rep(2,50))
sex <- factor(gender, levels=1:2, labels=c("Male", "Female"))

## Recode Data
library(car)
female <- factor(recode(gender, "2=1 ; 1=0"), levels=0:1, labels=c("Male", "Female"))

## Using Cut function to create factors from continuous data
age <- sample(1:87,1000,replace=T) 
agecat <- cut(age, c(0,21,65,Inf))
class(agecat)
table(agecat)

## We can also use the cut function to create indicator variables
agedummy <- cut(age, c(0,50,Inf))
table(agedummy)

## We can't take the mean of factor variables
mean(agecat)

## So make it a numeric variable
mean(as.numeric(agecat))



##################################################################
## Simple Indices
##################################################################

# Load Arrests data already stored in R
data("USArrests")
names(USArrests)
summary(USArrests)

# One possible index we can create by combining this data is to take the simple arithmetic mean
# But first, we should standardize the variables
# For this, we can use the scale function
USArrests_standardized <- scale(USArrests, center=T, scale=T)
summary(USArrests_standardized)

# Now we can create an index that is the mean across all measures
# For this, we will use the apply function, which applies a function to all rows or columns in a data set
# If we specify MARGIN = 1, we tell it to apply to function to all rows
index1 <- apply(USArrests_standardized, MARGIN = 1, FUN = mean)
head(index1)
class(index1)
length(index1)
# Another way to do the exact same thing is:
index1 <- rowMeans(USArrests_standardized)


# Another index could be the total across all variables (although this doesn't make a huge amount of sense in this case)
index2 <- apply(USArrests_standardized, MARGIN = 1, FUN = sum)

# We could do any function we feel like!
index3 <- apply(USArrests_standardized, MARGIN = 1, FUN = function(x) min(x)/max(x))


##################################################################
## Principal Components Analysis
##################################################################

# Run PCA on all variables using the prcomp function
pca1 <- prcomp(USArrests, center = T, scale. = T)
print(pca1)
# center says to deman
# scale. says to create unit variance
# center+scale. standardizes the variables!

# look at loadings
head(pca1$rotation)

# Look at PCs 
# Each of these columns is a principal component
# We will usually use 1 or 2 of these as variables in our analysis instead of the multiple measures
head(pca1$x)

# Visualize PCA
plot(pca1, type = "l")

# What are we capturing?
cor(USArrests, pca1$x)
# The first PC is highly correlated with the variables Murder, Assault, and Rape
# The second PC is highly correlated with UrbanPop



