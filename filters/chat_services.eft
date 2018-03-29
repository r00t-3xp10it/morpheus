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
#  This filter display port 80 (tcp) port 443 (https) 194 (irc)
#  port 995 (pop3) port 993 (imap) port 1863 (mnsp) traffic.
##




#
# Report ports comunicating only to make terminal displays.
#
if (ip.proto == TCP && tcp.src == 80 || tcp.dst == 80) {
 msg("[morpheus] host:TaRgEt   [ ⊶  ]  port:80   [tcp] http ☆");
}
if (ip.proto == TCP && tcp.src == 194 || tcp.dst == 194) {
 msg("[morpheus] host:TaRgEt   [ ⊶  ]  port:194  [tcp] irc ☆");
}
if (ip.proto == TCP && tcp.src == 443 || tcp.dst == 443) {
 msg("[morpheus] host:TaRgEt   [ ⊶  ]  port:443  [tcp] https ☆");
}
if (ip.proto == TCP && tcp.src == 995 || tcp.dst == 995) {
 msg("[morpheus] host:TaRgEt   [ ⊶  ]  port:995  [tcp] pop3-ssl ☆");
 msg("[morpheus] | status: server referer found ☠");
}
if (ip.proto == TCP && tcp.src == 993 || tcp.dst == 993) {
 msg("[morpheus] host:TaRgEt   [ ⊶  ]  port:993  [tcp] imap ☆");
}
if (ip.proto == TCP && tcp.src == 1863 || tcp.dst == 1863) {
 msg("[morpheus] host:TaRgEt   [ ⊶  ]  port:1863 [tcp] msnp ☆");
}


