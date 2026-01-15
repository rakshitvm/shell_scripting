#!/bin/bash


while true 
do 
echo "Choose any one of the component name"
echo "1. INGESTOR 2.JOINER 3.WRANGLER 4.VALIDATOR"
read choice
case $choice in
1) comname="INGESTOR"
   break
;;
2) comname="JOINER"
break
;;
3) comname="WRANGLER"
break
;;
4) comname="VALIDATOR"
break
;;
*) echo "wrong choice"
;;
esac
done

while true 
do 
echo "Choose any one of the scale name"
echo "1.MID 2.HIGH 3.LOW "
read choice
case $choice in
1) scale="MID"
   break
;;
2) scale="HIGH"
break
;;
3) scale="LOW"
break
;;
*) echo"Enter the correct option";;
esac
done

while true 
do 
echo "Choose any one of the view name"
echo "1.Auction 2.Bid"
read choice
case $choice in
1) view="vdopiasample"
   break
;;
2) view="vdopiasample-bid"
break
;;
*) echo"Enter the correct option";;
esac
done

while true
do
echo "Enter the number between 0 to 9"
read num
if [[ $num =~ ^[0-9]$ ]]
then 
break
else
echo "enter the correct value"
fi
done

final="$view ; $scale ; $comname ; ETL ; vdopia-etl=$num"

sed -i "1s/.*/$final/" sig.conf
