facebook 10246

标签
iptables -nL OUTPUT  --line-number
iptables -A OUTPUT -m owner --uid-owner 10246 -j CONNMARK --set-mark 10246
iptables -nL OUTPUT  --line-number
过滤
iptables -A INPUT -m connmark --mark 10246 -j NFLOG --nflog-group 10246
iptables -nL INPUT  --line-number
iptables -A OUTPUT -m connmark --mark 10246 -j NFLOG --nflog-group 10246
iptables -nL OUTPUT  --line-number
捕获
 tcpdump -i nflog:10022 -w /sdcard/uid-10246-2020-14-02.pcap

adb shell "su -c 'killall -SIGINT tcpdump'"