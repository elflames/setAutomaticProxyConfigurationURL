#!/bin/sh
####################################################################################################
#
# More information: http://macmule.com/2011/09/09/how-to-change-the-automatic-proxy-configuration-url-in-system-preferences-via-a-script/
#
# GitRepo: https://github.com/macmule/setAutomaticProxyConfigurationURL
#
# License: http://macmule.com/license/
#
####################################################################################################

# HARDCODED VALUES ARE SET HERE
autoProxyURL=""

# CHECK TO SEE IF A VALUE WAS PASSED FOR $4, AND IF SO, ASSIGN IT
if [ "$4" != "" ] && [ "$autoProxyURL" == "" ]; then
	autoProxyURL=$4
fi

# Detects all network hardware & creates services for all installed network hardware
/usr/sbin/networksetup -detectnewhardware

IFS=$'\n'

	#Loops through the list of network services
	for i in $(networksetup -listallnetworkservices | tail +2 );
	do
	
		# Get a list of all services beginning 'Ether' 'Air' or 'VPN' or 'Wi-Fi'
		# If your service names are different to the below, you'll need to change the criteria
		if [[ "$i" =~ 'Ether' ]] || [[ "$i" =~ 'Air' ]] || [[ "$i" =~ 'VPN' ]] || [[ "$i" =~ 'Wi-Fi' ]] ; then
			autoProxyURLLocal=`/usr/sbin/networksetup -getautoproxyurl "$i" | head -1 | cut -c 6-`
		
			# Echo's the name of any matching services & the autoproxyURL's set
			echo "$i Proxy set to $autoProxyURLLocal"
		
			# If the value returned of $autoProxyURLLocal does not match the value of $autoProxyURL for the interface $i, change it.
			if [[ $autoProxyURLLocal != $autoProxyURL ]]; then
				networksetup -setautoproxyurl $i $autoProxyURL
				echo "Set proxy for $i to $autoProxyURL"
			fi
		fi
		
	done
	
echo "Proxies All Present And Correct..."

unset IFS
