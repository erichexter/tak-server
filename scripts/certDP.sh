#!/bin/bash
# Makes an ATAK / iTAK friendly data package containing CA, user cert, user key
if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Need an IP and a user eg. ./certDP.sh 192.168.0.2 user1"
    exit
fi

IP=$1
USER=$2
ID=$(uuidgen)

# server.pref

echo "<?xml version='1.0' encoding='ASCII' standalone='yes'?>" > server.pref
echo "<preferences>" >> server.pref
echo "  <preference version=\"1\" name=\"cot_streams\">" >> server.pref
echo "    <entry key=\"count\" class=\"class java.lang.Integer\">1</entry>" >> server.pref
echo "    <entry key=\"description0\" class=\"class java.lang.String\">TAK Server $IP</entry>" >> server.pref
echo "    <entry key=\"enabled0\" class=\"class java.lang.Boolean\">true</entry>" >> server.pref
echo "    <entry key=\"connectString0\" class=\"class java.lang.String\">$IP:8089:ssl</entry>" >> server.pref
echo "  </preference>" >> server.pref
echo "  <preference version=\"1\" name=\"com.atakmap.app_preferences\">" >> server.pref
echo "    <entry key=\"displayServerConnectionWidget\" class=\"class java.lang.Boolean\">true</entry>" >> server.pref
echo "    <entry key=\"caLocation\" class=\"class java.lang.String\">cert/takserver.p12</entry>" >> server.pref
echo "    <entry key=\"caPassword\" class=\"class java.lang.String\">atakatak</entry>" >> server.pref
echo "    <entry key=\"certificateLocation\" class=\"class java.lang.String\">cert/$USER.p12</entry>" >> server.pref
echo "    <entry key=\"clientPassword\" class=\"class java.lang.String\">atakatak</entry>" >> server.pref
echo "  </preference>" >> server.pref
echo "</preferences>" >> server.pref


# manifest.xml

echo "<MissionPackageManifest version=\"2\">" > manifest.xml
echo "  <Configuration>" >> manifest.xml
echo "    <Parameter name=\"uid\" value=\"$ID\"/>" >> manifest.xml
echo "    <Parameter name=\"name\" value=\"$USER DP\"/>" >> manifest.xml
echo "    <Parameter name=\"onReceiveDelete\" value=\"true\"/>" >> manifest.xml
echo "  </Configuration>" >> manifest.xml
echo "  <Contents>" >> manifest.xml
echo "    <Content ignore=\"false\" zipEntry=\"server.pref\"/>" >> manifest.xml
echo "    <Content ignore=\"false\" zipEntry=\"takserver.p12\"/>" >> manifest.xml
echo "    <Content ignore=\"false\" zipEntry=\"$USER.p12\"/>" >> manifest.xml
echo "  </Contents>" >> manifest.xml
echo "</MissionPackageManifest>" >> manifest.xml
mkdir MANIFEST
cp ./manifest.xml ./MANIFEST/manifest.xml
zip -j tak/certs/files/$USER-$IP-itak.dp.zip manifest.xml server.pref tak/certs/files/takserver.p12 tak/certs/files/$USER.p12
zip -j tak/certs/files/$USER-$IP-atak.dp.zip server.pref tak/certs/files/takserver.p12 tak/certs/files/$USER.p12
zip -p tak/certs/files/$USER-$IP-atak.dp.zip ./MANIFEST/manifest.xml
rm ./MANIFEST/manifest.xml
rmdir ./MANIFEST
echo "-------------------------------------------------------------"
echo "Created certificate data package for $USER @ $IP as tak/certs/files/$USER-$IP-itak.dp.zip"
