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
# sellect warn.sh alert sound to use ..
#
if [ -e warn.ogg ]; then
  sound="warn.ogg"
  found="ogg"
else
  sound="printf '\a'"
  found="sys"
fi


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
  echo "[Morpheus] Loging TCP/UDP Events .."
  echo "   * Interface : $interface"
  echo "   * Modem Ip  : $modem"
  echo "   * Hour/Date : $hour"
  echo "   * ---"
  echo ""
else
  echo "[Morpheus] Loging Events in: 67/UDP(dst) .."
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
    if [ "$found" = "ogg" ]; then
      cd .. && cd bin && paplay $sound
      cd .. && cd logs
    else
      $sound
      sleep 0.3
    fi

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
      if [ "$found" = "sys" ]; then
        if [ -e beep-warning.beep ]; then
          for i in `seq 1 7`; do
            printf '\a'
            sleep 0.1
          done
        fi
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


cd ..
# exit script execution
exit

