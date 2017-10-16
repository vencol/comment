#! /bin/sh
#use crontab command 
#crontab -l list the Crontab task
#crontab -e edit the Crontab task
#min hour date month week commandTask
#*/1 *    *    *     *    /home/vencol/pingip/ping.sh          per min
#*   *    */1  *     *    /home/vencol/pingip/ping.sh		  per date
#crontab -r remove Crontab task

INET_IP="108.177.97.192"
INET_IPPORT="7276"
LAN_IP="118.193.145.14"
IPTABLES="/sbin/iptables"
#echo "1" > /proc/sys/net/ipv4/ip_forward 
#$IPTABLES -t nat -A PREROUTING -d $LAN_IP -p tcp -m tcp --dport $INET_IPPORT -j DNAT --to-destination $INET_IP
#$IPTABLES -t nat -A POSTROUTING -d $INET_IP -p tcp --dport $INET_IPPORT -j MASQUERADE

LOG_PATH=$(pwd)/iplog
OLD_IP=`tail -n 1 $LOG_PATH`
echo $OLD_IP
#IP_TEMP=`ping -w 3  baidu.com | grep 'icmp_seq=1' | awk '{print $4}'`
IP_TEMP=`ping -w 3  supl.google.com | grep 'icmp_seq=1' | awk '{print $4}'`
if [[ "$OLD_IP"x == "$IP_TEMP"x ]];then
	echo "old ip: " >> $LOG_PATH 
else 
	echo "$OLD_IP change to new ip: " >> $LOG_PATH
	echo "1" > /proc/sys/net/ipv4/ip_forward 
	$IPTABLES -t nat -A PREROUTING -d $LAN_IP -p tcp -m tcp --dport $INET_IPPORT -j DNAT --to-destination $IP_TEMP
	$IPTABLES -t nat -A POSTROUTING -d $IP_TEMP -p tcp --dport $INET_IPPORT -j MASQUERADE
fi
echo $IP_TEMP >> $LOG_PATH
exit 0

