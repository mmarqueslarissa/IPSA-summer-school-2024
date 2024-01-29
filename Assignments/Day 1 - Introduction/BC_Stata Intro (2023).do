********************************************************
********************************************************
* Introductory R Code
* IPSA-USP summer school 2023
* Survey Research Methods

********************************************************
********************************************************

** This file walks you through the most basic Stata commands

********************************************************
** PREAMBLE: Script and Console
********************************************************

** Stata works by 
** 1. typing code in the console 
** 2. OR by typing in a do file (like this one) and sending the lines of
**    code to the console.

** Unless you are working on very simple calculations,
** you should always save your code in a do file using a ".do" file extension.

** Let's set up a do file
** Open a new file using the New Do File Editor Button
** Save it as Section1.do
** Put commands in the script and execute them one by one

** Every line that begins with '*' is ignored by the console.
** So you can add comments to your code without generating syntax errors.
** It's good practice to comment everything in your code.
** Somebody who knows Stata should be able to take your code and understand
** exactly what it's doing, without you there to explain it to them.

** Note: to send a line of code to your console, use the Execute(Do) button
** Or, select the code and:
** (PC users:) "control + D"
** (Mac users:) "command + shift + D"


********************************************************
** Introduction to Stata
********************************************************

** Stata can function as a basic calculator
** Use the display command to use stata for calculations
display 2+2

display 6*12

display 2^8
* ^ means to the power of 

display 86/4

display log(12)
* the log function in Stata is based e, or the "natural log"

display exp(2)
** equivalent to 2.71828^2 or e squared

display 2 * (6 + 2)^2 
* Stata preserves order of operations
display 2 * (8)^2  
* equivalent to the expression above
display 2 * 64


********************************************************
** Getting Help in Stata
********************************************************

** Let's say you wanted to calculate the mean of a variable...
** How could we do that?

** We could calculate the mean by brute force...
** But that would take awhile

** Use the command search to look up any help files 
search mean

** If we already know the name of the command
** we can look it up using the help command
help mean
** Note that this help file tells you the syntax needed to use the command

********************************************************
** Working Directories
********************************************************

** In Stata, we will always be working with data
** Data comes in the format of .dta

** To load in data, we first want to set our working directory,
** which is the folder in which the files are stored. 

** If you want to change the working directory to another folder
** You have to use the cd command


** To make sure that you have no data loaded, you must clear the workspace
clear 


********************************************************
** Loading Data
********************************************************

* Now, let's load some data.
insheet using "houses.txt", tab

** Data can also be loaded by selecting File, Open

** Notice after the data is loaded that all of our variables appear on the right  

* Explore what we've loaded in
br
** This can also be done by opening the data editor either with the button
** or with Data, Data Editor, Data Editor (Browse)

** If you need to change any data, open the Data Editor (Edit) and change
**  it as you would any spreadsheet


********************************************************
** Working with Data
********************************************************

** What if we want to know the summary statistics (mean, sd, etc) about a variable?
* Learn about a variable:
summarize price
sum price

** We can even summarize multiple variables at a time
** Just separate the variables with a space
sum price sqft feats


** Say we want to summarize only the data which fit certain criteria
** To do this, we must subset the data
** Let's get the average square footage for corner houses
sum sqft if cor==1
sum sqft if cor==0

** NOTE: When conditioning (subsetting) we use two =
** But when creating a new variable we only use one

** We can also permanently subet our data
** i.e. remove all of the data that do not meet some criteria
** Let's keep only the data from the northeast
keep if ne==1
drop if ne==0



********************************************************
********************************************************
** Work Break
********************************************************
********************************************************

** Summarize the square footage variable
** Find the average price for northeast (ne) and non-northeast houses

summarize sqft
mean price if ne==1


********************************************************
** Managing and Manipulating Data
********************************************************

** Stata is an excellent and easy program for data management

** Say we want to create a new variable
** And we want that variable to be the same price * 1000
** And we want to name the new variable actualprice
** Use the function gen or generate
generate actualprice = price * 1000
sum actualprice

** What if the variable we are trying to create already exists?
gen actualprice = price * 100
** We get an error
** We first have to drop the existing variable to create another with the same name
drop actualprice
gen actualprice = price * 100


** Another example:
** Say we want to create a variable that is the product of two existing variableS?
gen price_sqft = price*sqft
sum price_sqft


********************************************************
********************************************************
** Work Break
********************************************************
********************************************************

** Create a variable that is actual price(*1000) per square footage
** Call it pricepersqft
** Find the mean of this variable
** Summarize this variable, price, and square footage



gen pricepersqft = (price*1000)/sqft
mean pricepersqft
sum pricepersqft price sqft


********************************************************
** Graphing Data
********************************************************

** What if we wanted to see histogram of the variable price?
** We can search for the command 
help hist
hist price

* Don't forget to google when you need to know how to do something!!

** Make a histogram of our new price per squarefoot variable
hist pricepersqft

** What if we want to see the correlation between squarefoot and price
** We can use a scatterplot to do this
scatter sqft price
** Notice that the first variable we list is placed on the y-axis
** and the second variable we list is placed on the x-axis


********************************************************
********************************************************
** Work Break
********************************************************
********************************************************

** Create a box plot of the price per square foot variable





help boxplot
graph box pricepersqft

















