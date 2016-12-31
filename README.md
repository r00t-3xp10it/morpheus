[![Version](https://img.shields.io/badge/MORPHEUS-2.0-brightgreen.svg?maxAge=259200)]()
[![Stage](https://img.shields.io/badge/Release-STABLE-brightgreen.svg)]()
[![Build](https://img.shields.io/badge/Supported_OS-linux-orange.svg)]()
[![AUR](https://img.shields.io/aur/license/yaourt.svg)]()

# Morpheus - automated ettercap TCP/IP Hijacking tool
![morpheus v2.0-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-banner.png)

    Version release: v2.0-STABLE
    Author: pedro ubuntu  [ r00t-3xp10it ]
    Codename: oneiroi phobetor (The mithologic dream greek god)
    Distros Supported: Linux Ubuntu, Kali, Debian, BackBox, Parrot OS
    Suspicious-Shell-Activity© (SSA) RedTeam develop @2017

<br />

# LEGAL DISCLAMER
    The author does not hold any responsibility for the bad use of this tool,
    remember that attacking targets without prior consent it's illegal and punished by law.

# Framework description
    Morpheus it's a Man-In-The-Middle (mitm) suite that allows users to manipulate
    tcp/udp data using ettercap, urlsnarf, msgsnarf and tcpkill as backend applications.
    but this tool main objective its not to provide an easy way to exploit/sniff targets,
    but ratter a call of attemption to tcp/udp manipulations technics (etter filters)

    Morpheus ships with some pre-configurated filters but it will allow users to improve them
    when launch the attack (morpheus scripting console). In the end of the attack morpheus will
    revert the filter back to is default stage, this will allow users to improve filters at
    running time without the fear of messing with filter command syntax and spoil the filter.
    "Perfect for scripting fans to safely test new concepts"...

    HINT: morpheus allow you to improve filters in 2 diferent ways
    1º - Edit filter before runing morpheus and the 'changes' will be permanent
    2º - Edit filter using 'morpheus scripting console' and the changes are active only once

<br />

# What can we acomplish by using filters?
    morpheus comes with a collection of filters writen be me to acomplish various tasks:
    replacing images in webpages, replace text in webpages, inject payloads in webpages,
    denial-of-service attacks (drop,kill packets from source), redirect browser traffic
    to another domain and gives you the ability to build compile your filter from scratch
    and run it through morpheus framework (option W).

    "filters can be extended using browser languages like: javascript,css,flash,etc"...


> In this example we are using "<head> HTML tag" to inject an rediretion url into target request
![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-refresh.png)
> In this example we are using 'CSS3' to trigger webpage 180º rotation
![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-css.png)

<br />

# Framework limitations
    1º - morpheus will fail if target system its protected againt arp poison atacks
    2º - target system sometimes needs to clear the net cache for arp poison to be effective
    3º - many attacks described in morpheus may be dropped by the target HSTS detection sys.


> 4º - morpheus needs ettercap to be executed with higth privileges (uid 0 | gid 0). <br />
> correct ettercap configuration display (running as Admin without ssl disectors active)
![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-sslBug3.png)

    By default morpheus (at startup) will replace the original etter.conf/etter.dns files
    provided by ettercap. On exit morpheus will revert those files to is original state.. 

<br />

# Dependencies
    required: ettercap, nmap, zenity, apache2
    sub-dependencies: driftnet, dsniff (urlsnarf,tcpkill,msgsnarf)

# Credits
    ettercap (alor&naga) | nmap (fyodor) | apache2 (Rob McCool) | dsniff (Dug Song)
    filters: irongeek (replace img) | seannicholls (rotate 180º) | TheBlaCkCoDeR09 (ToR-Browser-0day)

<br />

# Framework option 1 [firewall] screenshots

    firewall [option 1] pre-configurated filter will capture credentials from the follow services:
    http,ftp,ssh,telnet (facebook uses https/ssl :( ) report suspicious connections, report common
    websocial browsing (facebook,twitter,youtube), report the existence of botnet connections like:
    Mocbot IRC Bot, Darkcomet, redirect browser traffic and allow users to block connections (drop,kill) 
    "Remmenber: morpheus gives is users the ability to 'add more rules' to filters befor execution"

    [morpheus] host:192.168.1.67   [ -> ]  port:23 telnet  ☆
               Source ip addr      flow    destination     rank good

    [morpheus] host:192.168.1.67   [ <- ]  port:23 telnet  ☠
               Destination ip      flow    source port     rank suspicious


![morpheus v2.0-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-uau4.png)

![morpheus v2.0-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-option9.png)

![morpheus v2.0-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-creds5.png)

![morpheus v2.0-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-creds2.png)

![morpheus v2.0-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-creds1.png)

![morpheus v2.0-Alpha](https://dl.dropboxusercontent.com/u/21426454/sidejacking.png)

![morpheus v2.0-Alpha](https://dl.dropboxusercontent.com/u/21426454/gtf.png)

![morpheus v2.0-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-ircbot.png)

> Basically firewall filter will act like one offensive and defensive tool analyzing the
<br />
> tcp/udp data flow to report logins,suspicious traffic,brute-force,block target ip,etc.

<br />
---


_EOF

