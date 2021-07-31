# facebook (userId = 10246)

## 标签
```
$ adb shell
$ su
# iptables -nL OUTPUT  --line-number
# iptables -A OUTPUT -m owner --uid-owner 10246 -j CONNMARK --set-mark 10246
# iptables -nL OUTPUT  --line-number
```
## 过滤
```
$ adb shell
$ su
# iptables -A INPUT -m connmark --mark 10246 -j NFLOG --nflog-group 10246
# iptables -nL INPUT  --line-number
# iptables -A OUTPUT -m connmark --mark 10246 -j NFLOG --nflog-group 10246
# iptables -nL OUTPUT  --line-number
```
## 手动执行捕获
```
$ adb shell
$ su
# tcpdump -i nflog:10022 -w /sdcard/uid-10246-2020-14-02.pcap
......执行一些操作产生流量......
# adb shell "su -c 'killall -SIGINT tcpdump'"
```
## 自动脚本捕获
```
$ sh capture.sh
```
