#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#title           :setup.sh
#description     :Installation of the nesseary tools
#author          :Stefan Baumgartner
#company         :StoreHost
#date            :06.08.2018
#version         :1.00
#usage           :bash setup.sh
#notes           :Please modify only if you know what you do
########################################################################
########################################################################
# Developed by Store-Host                                              #
# 				                                                       #
# Web: https://www.store-host.com                                      #
# 	This script is distributed in the hope that it will be useful,     #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of     #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the      #
#   GNU General Public License for more details.                       #
########################################################################
########################################################################
#   Variables                                                          #
########################################################################
_fist_use=0
_date=$(date +%C-%B) 						# Erstellt das Datum des Tages
_destination="DESITNATION-PATH"				# Empferntes Verzeichnis
_current_1="PATH-1"							# Zu Packende Verzeichnis 1
_current_2="PATH-2"							# Zu Packende Verzeichnis 2
_current_3="PATH-3"							# Zu Packende Verzeichnis 3
_current_1_fin=${_current_1////\-}			# Manipulation des Backslash 1
_current_2_fin=${_current_2////\-}			# Manipulation des Backslash 2
_current_3_fin=${_current_3////\-}			# Manipulation des Backslash 3
_scp_server="IP-ADDRESS" 					# FQDN oder IP Adresse Backupserver
_scp_username="USERNAME"					# Passwort des Users
_scp_password="PASSWORD"					# FTP Passwort
_scp_transferlimit="800000"					# max 100Mbit/s Übertragungsrate

########################################################################
#	Installation von der nötigen Paketen
if [ $_fist_use = "1" ]; then
   apt-get install sshpass zip -y -f > /dev/null
fi
########################################################################
#	Erstellen von einem Zip Archive
echo "Navigiere zum Verzeichniss: $_current_1"
cd $_current_1
echo "erstelle Zip Archive"
zip -r -q BU$_current_1_fin$_date.zip $_current_1 
mv BU$_current_1_fin$_date.zip /tmp/BU$_current_1_fin$_date.zip
########
echo "Navigiere zum Verzeichniss: $_current_2"
cd $_current_2
echo "erstelle Zip Archive"
zip -r -q BU$_current_2_fin$_date.zip $_current_2
mv BU$_current_2_fin$_date.zip /tmp/BU$_current_2_fin$_date.zip
########
echo "Navigiere zum Verzeichniss: $_current_3"
cd $_current_3
echo "erstelle Zip Archive"
zip -r -q BU$_current_3_fin$_date.zip $_current_3
mv BU$_current_3_fin$_date.zip /tmp/BU$_current_3_fin$_date.zip
########################################################################
#	Senden an Backupserver
echo "Transferiere zu Backupsystem"
cd /tmp/
######## Dir 1
sshpass -p $_scp_password scp -l $_scp_transferlimit BU$_current_1_fin$_date.zip \
   $_scp_username@$_scp_server:$_destination
######## Dir 2
sshpass -p $_scp_password scp -l $_scp_transferlimit BU$_current_2_fin$_date.zip \
   $_scp_username@$_scp_server:$_destination
######## Dir 3
sshpass -p $_scp_password scp -l $_scp_transferlimit BU$_current_3_fin$_date.zip \
   $_scp_username@$_scp_server:$_destination

   
######## Calculate Size
_size1=$(ls -lah BU$_current_1BU$_current_1_fin$_date.zip | awk -F " " {'print $5'})
_size2=$(ls -lah BU$_current_2BU$_current_2_fin$_date.zip | awk -F " " {'print $5'})
_size3=$(ls -lah BU$_current_3BU$_current_3_fin$_date.zip | awk -F " " {'print $5'})
 cat <<EOF >>/var/log/sh-backup.log
Backup$_current_1_fin$_date.zip = $_size1
Backup$_current_2_fin$_date.zip = $_size2
Backup$_current_3_fin$_date.zip = $_size3
EOF
echo "Raeume etwas auf..."
rm  BU$_current_1_fin$_date.zip
rm  BU$_current_2_fin$_date.zip
rm  BU$_current_3_fin$_date.zip
echo "Log wurde unter /var/log/sh-backup.log gespeichert"