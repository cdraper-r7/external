#!/bin/bash

echo "Enter company name"
read -p 'Name: ' name

### SET VARIABLES ###
echo "Name = $name"
companypath=~/$name
echo "Files stored in $companypath"


#make folder if it does not exist
mkdir -p $companypath

echo "ENTER/VERIFY IN SCOPE IP ADDRESSES ONE ON EACH LINE IN CIDR NOTATION!!! Opening file in gedit please wait....."
sleep 1
gedit $companypath/inscope.txt

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
mkdir -p $companypath/nmap
sudo nmap -vv -Pn -sV -O -iL $companypath/inscope.txt -oA $companypath/nmap/nmap

##Convert nmap scan to CSV for spreadsheet
python3 /opt/Nmap-Scan-to-CSV/nmap_xml_parser.py -f $companypath/nmap/nmap.xml -csv $companypath/nmap/nmap.csv

# eyewitness
cd $companypath/
#sudo eyewitness -x $companypath/nmap/nmap.xml --no-prompt --delay 10 -d $companypath/eyewitness
/opt/EyeWitness/Python/EyeWitness.py -x $companypath/nmap/nmap.xml --no-prompt --delay 10 -d $companypath/eyewitness

echo "SCRIPT COMPLETED!!! (chris is awesome)"
