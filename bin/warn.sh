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
# parsing data
cd .. && cd output
rhost=`cat parse`
cd .. && cd logs
if [ -e triggertwo ]; then
secund=`cat triggertwo`
fi
echo "" > $rhost.log
clear


#
# bash trap (ctrl+c) abort execution
#
trap ctrl_c INT
ctrl_c() {
  echo ""
  echo "[Morpheus] Abort module execution        .."
  sleep 2
exit
}



#
# first terminal message
#
echo "[Morpheus] Loging Events in: 67/UDP(dst) .."
echo "   * Interface : $interface"
echo "   * Modem Ip  : $modem"
if [ -e triggertwo ]; then
  echo "   *   status  : Filtering two targets at once [!]"
  echo "   * Device    : $rhost.lan"
  echo "   * Device    : $secund.lan"
else
  echo "   * Device    : $rhost.lan"
fi
echo "   * ---"
echo ""
echo ""



#
# Bash Loop funtion ..
# BEEP IF found 'beep-warning.beep'
#
while :
do

  cd .. && cd logs
  if [ -e beep-warning.beep ]; then
    # store date to dislay at event trigger
    hour=`date | awk {'print $4,$5,$6'}`
    echo "   ✔ Event trigger at: $hour .."
    #
    # emitt one warning sound (BEEP)
    #
    printf '\a'
    sleep 0.3
    # build logfile (logs folder)
    echo "[Morpheus] Loging Events in: 67/UDP(dst) .." >> $rhost.log
    echo "   * Interface : $interface" >> $rhost.log
    echo "   * Modem Ip  : $modem" >> $rhost.log
    echo "   * Hour/Date : $hour" >> $rhost.log
    echo "   * Action    : Request access to local LAN" >> $rhost.log
      if [ -e triggertwo ]; then
        echo "   *   status  : Filtering two targets at once [!]" >> $rhost.log
        echo "   * Device    : $rhost.lan [?]" >> $rhost.log
        echo "   * Device    : $secund.lan [?]" >> $rhost.log
      else
        echo "   * Device    : $rhost.lan" >> $rhost.log
      fi
    echo "   * ---" >> $rhost.log
    echo "" >> $rhost.log


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
    # delete .beep file to emitt another sound if the event its trigger again in the future..
    #
    rm -f beep-warning.beep > /dev/nul 2>&1
  fi

# end of loop funtion
done

cd ..
# exit script execution
exit
