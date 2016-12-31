############################################################################
#                                                                          #
#  ettercap -- etter.dns -- host file for dns_spoof plugin                 #
#                                                                          #
#  Copyright (C) ALoR & NaGA                                               #
#                                                                          #
#  This program is free software; you can redistribute it and/or modify    #
#  it under the terms of the GNU General Public License as published by    #
#  the Free Software Foundation; either version 2 of the License, or       #
#  (at your option) any later version.                                     #
#                                                                          #
############################################################################





###########################################
#    morpheus domain name redirections    #
###########################################

.com           A   TaRgEt
*.com          A   TaRgEt
.com           PTR TaRgEt     # Wildcards in PTR are not allowed

.PrE           A   TaRgEt
*.PrE          A   TaRgEt
.PrE           PTR TaRgEt      # Wildcards in PTR are not allowed



##########################################
# no one out there can have our domains...
#

www.alor.org  A 127.0.0.1
www.naga.org  A 127.0.0.1

###############################################
# one day we will have our ettercap.org domain
#

www.ettercap.org           A  127.0.0.1
ettercap.sourceforge.net   A  216.136.171.201

###############################################
# some MX examples
#

alor.org   MX  127.0.0.1
naga.org   MX  127.0.0.1

###############################################
# This messes up NetBIOS clients using DNS
# resolutions. I.e. Windows/Samba file sharing.
#

LAB-PC*  WINS  127.0.0.1

# vim:ts=8:noexpandtab
