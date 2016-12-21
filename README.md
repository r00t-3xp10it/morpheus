[![Version](https://img.shields.io/badge/MORPHEUS-1.9-brightgreen.svg?maxAge=259200)]()
[![Stage](https://img.shields.io/badge/Release-developing-red.svg)]()
[![Build](https://img.shields.io/badge/Supported_OS-linux-orange.svg)]()
[![Github All Releases](https://img.shields.io/github/downloads/atom/atom/total.svg)]()
[![AUR](https://img.shields.io/aur/license/yaourt.svg)]()

# Morpheus - automated ettercap TCP/IP Hijacking tool
![morpheus v1.9-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-banner.png)

    Version release : v1.9-Alpha
    Author : pedro ubuntu  [ r00t-3xp10it ]
    Distros Supported : Linux Ubuntu, Kali, Mint, Parrot OS
    Suspicious-Shell-Activity (SSA) RedTeam develop @2016

# LEGAL DISCLAMER
    The author does not hold any responsibility for the bad use
    of this tool, remember that attacking targets without prior
    consent its illegal and punished by law.

# Framework description
    morpheus framework automates tcp/udp packet manipulation tasks by using etter filters
    to manipulate target requests/responses under MitM attacks replacing the tcp/udp packet
    contents by our contents befor forward the packet back to the target host...

    workflow:
    1º - attacker -> arp poison local lan (mitm)
    2º - target   -> requests webpage from network (wan)
    3º - attacker -> modifies webpage response (contents)
    4º - attacker -> modified packet its forward back to target host

    morpheus ships with some pre-configurated filters but it will allow users to improve them
    when lunching the attack (morpheus scripting console). In the end of the attack morpheus
    will revert the filter back to is default stage, this will allow users to improve filters
    at running time without the fear of messing with filter command syntax and spoil the filter.

    "Perfect for scripting fans to safely test new concepts"...


# What can we acomplish by using filters?
    morpheus ships with a collection of etter filters writen be me to acomplish various tasks:
    replacing images in webpages, replace text in webpages, inject payloads using html <form> tag,
    denial-of-service attacks (drop,kill packets from source), https/ssh downgrade attacks,
    redirect target browser traffic to another domain and gives you the ability to build
    compile your filter from scratch and lunch it through morpheus framework (option W).

    "filters can be extended using browser languages like: javascript,css,flash,etc"...


> In this example we are using "<head> HTML tag" to inject an rediretion url in target request
![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-refresh.png)
> In this example we are using 'CSS3' to trigger webpage 180º rotation
![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-css.png)


# Framework limitations
    1º - morpheus will fail if target system its protected againt arp poison atacks
    2º - downgrade attacks will fail if browser target as installed only-https addon's
    3º - target system sometimes needs to clear netcache for arp poison to be effective
    4º - many attacks described in morpheus may be droped by target HSTS detection sys.

> 5º - incorrect number of token (///) in TARGET !!
![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-error1.png)

    morpheus by default will run ettercap using IPv6 (USE_IPV6=ACTIVE) like its previous
    configurated into the 'settings' file, if you are reciving this error edit settings
    file befor runing morpheus and set (USE_IPV6=DISABLED) to force ettercap to use IPV4

> 6º - morpheus needs ettercap to be executed with higth privileges (uid 0 | gid 0).
![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-sslBug.png)

> correct ettercap configuration display (running as Admin without ssl disectors active)
![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-sslBug3.png)

    By default morpheus (at startup) will replace the original etter.conf/etter.dns files
    provided by ettercap, at framework exit morpheus will revert files to is original state.. 

<br />

# Dependencies
    required: ettercap, nmap, apache2, zenity
    sub-dependencies: dnsniff (urlsnarf,tcpkill)

# Credits
    alor&naga (ettercap framework)  | fyodor (nmap framework)
    filters: irongeek (replace img) | seannicholls (rotate 180º) | TheBlaCkCoDeR09 (ToR-Browser-0day)
    Most of the filters in morpheus framework have been writen be me except the ones described
    above, but this project will contemplate new external addictions (authors) also new examples
    can be found editing ettercap's etter.filter.examples file that will help us write new ones.


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


![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-uau4.png)

![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-option9.png)

![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-creds5.png)

![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-creds2.png)

![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-creds1.png)

![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/sidejacking.png)

![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/gtf.png)

![morpheus v1.6-Alpha](https://dl.dropboxusercontent.com/u/21426454/morpheus-ircbot.png)

> Basically firewall filter will act like one offensive and defensive tool analyzing the
<br />
> tcp/udp data flow to report logins,suspicious traffic,brute-force,block target ip,etc.

<br />
---


_EOF

