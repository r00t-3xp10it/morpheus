#!/bin/sh
##
# This scipt will sound a BEEP if the 'event' its found ..
# The objective of this script its to assist morpheus tool to
# sound warnings (beep sound) everytime the event its trigged.
# HOW? ettercap -blabla -bla & ./warn.sh
#
# DESCRIPTION:
# In this case the 'event' will be the creation of ettercap output:
# 'beep-warning.beep' logfile, that this script its looking for to emitt
# one sound warning to users (BEEP). It also deletes the logfile to allow
# the loop funtion to trigger another warning if the event its trigger again ..
##




# store info into local vars for later use
IPATH=`pwd`
interface=`netstat -r | grep "default" | awk {'print $8'}`
modem=`route -n | grep "UG" | awk {'print $2'} | tr -d '\n'`
#
# parsing data
#
cd .. && cd logs
if [ -e parse ]; then
rhost=`cat parse`
echo "" > $rhost.log
rm -f parse > /dev/nul 2>&1
else
external="YES"
echo "" > warn.log
fi
if [ -e triggertwo ]; then
secund=`cat triggertwo`
echo "" > $secund.log
rm -f triggertwo > /dev/nul 2>&1
fi
hour=`date | awk {'print $4,$5,$6'}`
clear


#
# bash trap (ctrl+c) abort execution
#
trap ctrl_c INT
ctrl_c() {
  echo ""
  echo "[Morpheus] Abort module execution .."
  sleep 2
exit
}



#
# first terminal message
#
if [ "$external" = "YES" ]; then
  echo "[Morpheus] Beeping/Loging TCP/UDP Events .."
  echo "   * Interface : $interface"
  echo "   * Modem Ip  : $modem"
  echo "   * Hour/Date : $hour"
  echo "   * ---"
  echo ""
else
  echo "[Morpheus] Beeping/Loging Events in: 67/UDP(dst) .."
  echo "   * Interface : $interface"
  echo "   * Modem Ip  : $modem"
  echo "   * Hour/Date : $hour"
    if [ -e $secund.log ]; then
      echo "   *   status  : Filtering two targets at once [!]"
      echo "   * Device    : $rhost.lan"
      echo "   * Device    : $secund.lan"
    else
      echo "   * Device    : $rhost.lan"
    fi
  echo "   * ---"
  echo ""
fi



#
# Bash Loop funtion ..
# BEEP IF found 'beep-warning.beep'
#
while :
do
#
# sleep time in loop funtion ..
# increase time in old pc's to consume less resources ..
# HINT: this value sets loop and sound warning delay time ..
#
sleep 1.5

  # check for .beep file existence
  if [ -e beep-warning.beep ]; then
    # store date to dislay at event trigger
    hour=`date | awk {'print $4,$5,$6'}`
    echo "   ✔ Event trigger at: $hour .."
    #
    # emitt one warning sound (BEEP)
    #
    printf '\a'
    sleep 0.3


    #
    # build logfile (in logs folder)
    #
    if [ -e parse.bin ]; then
      echo "[Morpheus] Loging Events in: 67/UDP(dst) .." >> $rhost.log
      echo "   * Interface : $interface" >> $rhost.log
      echo "   * Modem Ip  : $modem" >> $rhost.log
      echo "   * Hour/Date : $hour" >> $rhost.log
      echo "   * Device    : $rhost.lan" >> $rhost.log
      echo "   * Action    : Request access to local LAN" >> $rhost.log
      echo "   * ---" >> $rhost.log
      echo "" >> $rhost.log
    fi

    if [ -e triggertwo.bin ]; then
      echo "[Morpheus] Loging Events in: 67/UDP(dst) .." >> $secund.log
      echo "   * Interface : $interface" >> $secund.log
      echo "   * Modem Ip  : $modem" >> $secund.log
      echo "   * Hour/Date : $hour" >> $secund.log
      echo "   * Device    : $secund.lan" >> $secund.log
      echo "   * Action    : Request access to local LAN" >> $secund.log
      echo "   * ---" >> $secund.log
      echo "" >> $secund.log
    fi

    if [ "$external" = "YES" ]; then
      echo "[Morpheus] Loging Events .." >> warn.log
      echo "   * Interface : $interface" >> warn.log
      echo "   * Modem Ip  : $modem" >> warn.log
      echo "   * Hour/Date : $hour" >> warn.log
      echo "   * ---" >> warn.log
      echo "" >> warn.log
    fi


      #
      # emmit more than one beep just to users to hear it proper ..
      #
      if [ -e beep-warning.beep ]; then
        for i in `seq 1 7`; do
          printf '\a'
          sleep 0.1
        done
      fi

    #
    # delete all files to emitt another sound if the event its trigger again in the future..
    #
    if [ -e beep-warning.beep ]; then
      rm -f beep-warning.beep > /dev/nul 2>&1
      rm -f triggertwo.bin > /dev/nul 2>&1
      rm -f parse.bin > /dev/nul 2>&1
    fi
  fi


# end of loop funtion
done


#
# delete ANCII chars from logfiles
#
cd .. && cd logs
if [ -e $rhost.log ]; then
tr -cd '\11\12\15\40-\176' < $rhost.log > clean.log
mv clean.log $rhost.log > dev/null 2>&1
rm clean.log > dev/null 2>&1
fi

if [ -e $secund.log ]; then
tr -cd '\11\12\15\40-\176' < $secund.log > clean2.log
mv clean2.log $secund.log > dev/null 2>&1
rm clean2.log > dev/null 2>&1
fi

if [ -e warn.log ]; then
tr -cd '\11\12\15\40-\176' < warn.log > clean3.log
mv clean3.log warn.log > dev/null 2>&1
rm clean3.log > dev/null 2>&1
fi


cd ..
# exit script execution
exit
