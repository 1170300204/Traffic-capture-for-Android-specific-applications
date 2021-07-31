# Traffic-capture-for-Android-specific-applications
一种捕获Android手机（root）特定应用tcp网络数据流量的方法。有些时候我们在进行Android应用分析的时候需要获取相应app的纯净（或较为纯净）的数据流量，因此就需要一种方法，能够从Android设备的庞杂流量中提取或者过滤出该app的流量。因此，找到了一种基于Android应用userId的app流量的过滤方法，该方法基于iptables（一个Linux系统下的包过滤防火墙）。
## userId
  Android平台的过滤基于Android系统文件/data/system/packages.xml。/data/system/packages.xml文件是由Android系统源代码生成的，其中动态保存着当前Android设备中所安装的所有应用的一些属性，如应用包名、文件路径、版本信息等。当系统中出现应用安装、删除或升级等行为时，就会更新packages.xml文件的内容。packages.xml文件一共分为permission块、package块、shared-user块和keyset-setting块四部分内容。Android平台下的包过滤需要用到package块中的userId信息。
  
  对于Android系统，每当用户下载并安装完成一个应用的时候，系统就会在packages.xml文件中记录下应用的一些信息，并且为该应用分配一个设备内独立的userId，作为该应用在本设备中的标识符。该userId的有效范围是安装了该应用的当前Android设备，其生命周期是从应用被成功安装到设备上开始到应用被用户从设备上卸载而结束。有了特定应用的userId就可以从Android应用中准确识别出该应用。
## iptables
  Netfileter/iptables（以下简称iptables）是nuix/linux 系统自带的一套十分优秀的基于包过滤的防火墙工具，其功能十分的强大并且使用起来非常灵活，能够对流入、流出和流经服务器的数据包进行较为精细的控制。
  
  而自从Linux 2.6.14版本开始，IP tables工具的拓展就已经支持通过出站流量数据包的生成者ID，即生成数据包的应用的userId来过滤数据包，并可以给过滤到的数据包打上相应的内核过滤标签。在打上标签之后，使用iptables就可以将带有指定流标签的INPUT和OUTPUT数据包过滤保存在NFLOG消息池中，并且为该NFLOG消息池指定一个对应的标好。这样即完成了将指定（userId）应用的纯净流量的过滤工作。后续只需要从相应的NFLOG消息池中抓取数据包并保存即可。
## 操作流程
  首先，我们需要拿到当前Android设备的packages.xml文件。
  ```
  $ adb shell
  $ su
  # cp /data/system/packages.xml /sdcard/packages.xml //将packages.xml文件复制一份到SD卡中，这样就可以通过PC查看该文件并进行一些操作
  ```
  在拿到packages.xml文件之后，我们就可以查看其中的内容，寻找指定应用的userId信息，以下为从文件中截取的部分内容。
  ```
    <package name="com.facebook.katana" codePath="/data/app/com.facebook.katana-Lb2TQVwaYNBhSJxgP8Vlvg==" nativeLibraryPath="/data/app/com.facebook.katana-Lb2TQVwaYNBhSJxgP8Vlvg==/lib" primaryCpuAbi="armeabi-v7a" publicFlags="811105860" privateFlags="0" ft="17688f709e0" it="17688f70db0" ut="17688f70db0" version="195354799" userId="10246" installer="com.miui.packageinstaller">
        <sigs count="1" schemeVersion="2">
            <cert index="21" key="30820268308201d102044a9c4610300d06092a864886f70d0101040500307a310b3009060355040613025553310b3009060355040813024341311230100603550407130950616c6f20416c746f31183016060355040a130f46616365626f6f6b204d6f62696c653111300f060355040b130846616365626f6f6b311d301b0603550403131446616365626f6f6b20436f72706f726174696f6e3020170d3039303833313231353231365a180f32303530303932353231353231365a307a310b3009060355040613025553310b3009060355040813024341311230100603550407130950616c6f20416c746f31183016060355040a130f46616365626f6f6b204d6f62696c653111300f060355040b130846616365626f6f6b311d301b0603550403131446616365626f6f6b20436f72706f726174696f6e30819f300d06092a864886f70d010101050003818d0030818902818100c207d51df8eb8c97d93ba0c8c1002c928fab00dc1b42fca5e66e99cc3023ed2d214d822bc59e8e35ddcf5f44c7ae8ade50d7e0c434f500e6c131f4a2834f987fc46406115de2018ebbb0d5a3c261bd97581ccfef76afc7135a6d59e8855ecd7eacc8f8737e794c60a761c536b72b11fac8e603f5da1a2d54aa103b8a13c0dbc10203010001300d06092a864886f70d0101040500038181005ee9be8bcbb250648d3b741290a82a1c9dc2e76a0af2f2228f1d9f9c4007529c446a70175c5a900d5141812866db46be6559e2141616483998211f4a673149fb2232a10d247663b26a9031e15f84bc1c74d141ff98a02d76f85b2c8ab2571b6469b232d8e768a7f7ca04f7abe4a775615916c07940656b58717457b42bd928a2" />
        </sigs>
        <perms>
            <item name="android.permission.DOWNLOAD_WITHOUT_NOTIFICATION" granted="true" flags="0" />
            <item name="com.facebook.receiver.permission.ACCESS" granted="true" flags="0" />
            <item name="android.permission.MODIFY_AUDIO_SETTINGS" granted="true" flags="0" />
            <item name="android.permission.MANAGE_ACCOUNTS" granted="true" flags="0" />
            <item name="android.permission.NFC" granted="true" flags="0" />
            <item name="android.permission.CHANGE_NETWORK_STATE" granted="true" flags="0" />
            <item name="android.permission.FOREGROUND_SERVICE" granted="true" flags="0" />
            <item name="android.permission.WRITE_SYNC_SETTINGS" granted="true" flags="0" />
            <item name="android.permission.RECEIVE_BOOT_COMPLETED" granted="true" flags="0" />
            <item name="com.facebook.katana.permission.CROSS_PROCESS_BROADCAST_MANAGER" granted="true" flags="0" />
            <item name="android.permission.READ_PROFILE" granted="true" flags="0" />
            <item name="android.permission.BLUETOOTH" granted="true" flags="0" />
            <item name="com.facebook.katana.permission.RECEIVE_ADM_MESSAGE" granted="true" flags="0" />
            <item name="android.permission.GET_TASKS" granted="true" flags="0" />
            <item name="android.permission.AUTHENTICATE_ACCOUNTS" granted="true" flags="0" />
            <item name="android.permission.INTERNET" granted="true" flags="0" />
            <item name="android.permission.BLUETOOTH_ADMIN" granted="true" flags="0" />
            <item name="android.permission.BROADCAST_STICKY" granted="true" flags="0" />
            <item name="com.facebook.permission.prod.FB_APP_COMMUNICATION" granted="true" flags="0" />
            <item name="android.permission.CHANGE_WIFI_STATE" granted="true" flags="0" />
            <item name="com.facebook.orca.provider.ACCESS" granted="true" flags="0" />
            <item name="android.permission.ACCESS_NETWORK_STATE" granted="true" flags="0" />
            <item name="com.facebook.katana.provider.ACCESS" granted="true" flags="0" />
            <item name="android.permission.USE_FINGERPRINT" granted="true" flags="0" />
            <item name="android.permission.READ_SYNC_SETTINGS" granted="true" flags="0" />
            <item name="android.permission.VIBRATE" granted="true" flags="0" />
            <item name="android.permission.ACCESS_WIFI_STATE" granted="true" flags="0" />
            <item name="android.permission.USE_BIOMETRIC" granted="true" flags="0" />
            <item name="com.android.launcher.permission.INSTALL_SHORTCUT" granted="true" flags="0" />
            <item name="android.permission.WAKE_LOCK" granted="true" flags="0" />
        </perms>
        <proper-signing-keyset identifier="54" />
    </package>
  ```
  从中可以看到facebook（com.facebook.katana）的userId为10246，则由此可以设置以下iptables规则进行包过滤。
  ```
  $ adb shell
  $ su
  # iptables -A OUTPUT -m owner --uid-owner 10012 -j CONNMARK --set-mark 10012
  # iptables -A INPUT -m connmark --mark 10012 -j NFLOG --nflog-group 10012
  # iptables -A OUTPUT -m connmark --mark 10012 -j NFLOG --nflog-group 10012
  ```
  此时,已经设置好了iptables的过滤规则，只需要启动tcpdump抓包，并对应用进行一系列操作，即可以在特定的NFLOG消息池中捕获到指定应用的流量。
  ```
  $ adb shell
  $ su
  # /data/local/tcpdump -i nflog:10246 -w /sdcard/fbdata.pcap
  ```
## 注意
  在使用tcpdump从NFLOG消息池中抓取应用数据包的时候，其中的数据包会首先被转发到一个叫"NFLOG:标号"的虚拟网卡上。当使用tcpdump的-i参数指定在该虚拟网卡上进行抓包时，我们所捕获到的数据包其链路层的头部为NFLOG的Linux内锅网络过滤器的日志头，而非正常的以太网头部。但是其应用层、网络层和传输层的都不均是正常的。因此，如果有特殊要求则需要对所得数据包的链路层头部进行替换。
  
参考链接：<br>
http://ipset.netfilter.org/iptables-extensions.man.html <br>
https://blog.csdn.net/jmh1996/article/details/106011155
  
  
