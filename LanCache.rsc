# Script Written By Md. Sabbir Rahman
# 
#
# 
# 
/system scheduler
add disabled=no interval=30s name=LanCache_Check on-event=DNS_CHECK policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon
/system script
add dont-require-permissions=yes name=DNS_CHECK policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    local HOST \"google.com\"\r\
    \n:local HOSTIP \"10.0.41.1\"\r\
    \n\r\
    \n:if ([/ping \$HOSTIP interval=1 count=1] = 1) do={\r\
    \n  :do {\r\
    \n    :resolve \$HOST server \$HOSTIP;\r\
    \n     /ip firewall nat set [find where comment=DNSRedirect && disabled=ye\
    s] disabled=no;\r\
    \n    } on-error={  \r\
    \n    :log error \"LAN Cache Service is DOWN!\"\r\
    \n   / ip firewall nat set [find where comment=DNSRedirect && disabled=no]\
    \_disabled=yes;\r\
    \n  }\r\
    \n} else={\r\
    \n  :log error \"SERVER DOWN! (ping)\"\r\
    \n   / ip firewall nat set [find where comment=DNSRedirect && disabled=no]\
    \_disabled=yes;\r\
    \n}"
/ip firewall nat add chain=dstnat src-address-list=LanCache-allow protocol=udp dst-port=53 to-addresses=10.0.41.1 to-ports=53 place-before=0\
	comment=DNSRedirect action=dst-nat
/ip firewall nat add chain=dstnat src-address-list=LanCache-allow protocol=tcp dst-port=53 to-addresses=10.0.41.1 to-ports=53 place-before=0\
	comment=DNSRedirect action=dst-nat;
