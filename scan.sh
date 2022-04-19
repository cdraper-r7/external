#!/bin/bash

echo "Enter company domain (ex. tesla.com)"
read -p 'Domain: ' domain

### SET VARIABLES ###
echo "Domain = $domain"
companyname=`echo $domain | cut -d "." -f1`
echo "Company Name = $companyname"
companypath=~/$companyname
echo "Files stored in $companypath"


#make folder if it does not exist
sudo mkdir -p $companypath

echo "ENTER/VERIFY IN SCOPE IP ADDRESSES ONE ON EACH LINE IN CIDR NOTATION!!! Opening file in gedit please wait....."
sleep 3
sudo gedit $companypath/inscope.txt

# if inscope does not exist then exit
if [ ! -f $companypath/inscope.txt ]
then
    echo "inscope.txt not found. Exiting!"
    exit 1
else
    echo "In scope file found."
fi

###Block Comment for troubleshooting ####
: <<'END'
END
#########################################

### nmap scan ##
sudo mkdir -p $companypath/nmap
sudo nmap -vv -sV -O -iL $companypath/inscope.txt -oA $companypath/nmap/$companyname

##Convert nmap scan to CSV for spreadsheet
#python3 /opt/scripts/xml2csv.py -f $companypath/nmap/$companyname.xml -csv $companypath/nmap/$companyname.csv

# eyewitness
cd $companypath/
sudo eyewitness -x $companypath/nmap/$companyname.xml --no-prompt --delay 10 -d $companypath/eyewitness

echo "SCRIPT COMPLETED!!! (chris is awesome)"
