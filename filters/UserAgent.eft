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
#  If target its vulnerable to d0s (firefox =< 49.0.1 versions) 
##




#
# Report port 443 (tcp) traffic just to make displays
# that shows to users that filter its working fine ..
#
if (ip.proto == TCP && tcp.src == 443 || tcp.dst == 443) {
  msg("[morpheus] host:TaRONE   [ <> ]  port:443  [tcp] https ☆");
}



#
# Report port 80 (tcp) traffic
# And warn attacker that User-Agent has captured...
#
if (ip.proto == TCP && tcp.dst == 80 || tcp.src == 80) {
  msg("[morpheus] host:TaRgEt   [ ⊶ ]  port:80   [tcp] http ☆");
    if (search(DATA.data, "User-Agent")) {
      msg("\n[morpheus] host:TaRgEt   [ ⊶ ]   found ..");
      msg("[morpheus] | status: User-Agent detected");
      msg("[morpheus] |  info : tcp header found, log stored ✔");
      msg("[morpheus] |  log  : morpheus/logs/UserAgent.log");
      msg("[morpheus] |_ exec : CHECK IN LOGFILE FOR DATA CAPTURE, AND THEN EXIT CONSOLE\n");
      log(DECODED.data, "./UserAgent.log");
  }
}



