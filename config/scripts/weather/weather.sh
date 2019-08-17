#!/bin/bash



dir=~/.i3/scripts/weather/weather.json
location=$1


#Get a file with Galicia weather info. The info refreses every 10 min
curl -L http://servizos.meteogalicia.gal/rss/observacion/observacionConcellos.action > $dir


# Get location info from weather file

#field=$(awk -F} -v MYPATTERN="Santiago de Compostela" '$0 ~ MYPATTERN { 
field=$(awk -F} -v MYPATTERN="$location" '$0 ~ MYPATTERN { 
    for (i=1;i<=NF;i++) {
        if ($i ~ MYPATTERN) { print i }
    }
}' $dir)


#Get temperature from weather file
temp=$(cat $dir | cut -d "}" -f$field | egrep -o '"temperatura":.{,4}' | cut -d ":" -f2) 

#Get sky status code from weather file
sky=$(cat $dir | cut -d "}" -f$field | egrep -o '"icoEstadoCeo":[0-9]{,4}' | cut -d ":" -f2) 


# Display an icon depending on the weather
# Codes available in 
# http://www.meteogalicia.gal/datosred/infoweb/meteo/docs/rss/JSON_estado_actual_gl.pdf
#
# Code -9999 (sad guy) for uknown sky state


if [ $sky -lt 0 ]
then 
	icon="\uf5b3"
elif [ $sky -lt 104 ]
then 
	icon="\uf185"
elif [ $sky -lt 105 ]
then 
	icon="\uf0c2"
elif [ $sky -lt 112 ]
then 
	icon="\uf0e9"
elif [ $sky -lt 202 ]
then 
	icon="\uf186"
elif [ $sky -lt 212 ]
then 
	icon="\uf0e9"
fi

#Different output color according to temperature

if (( $(echo "$temp > 35" | bc -l) ))
then 
	echo -e '<span foreground="#dd2f08">'$icon$temp'</span>'
elif (( $(echo "$temp > 30" | bc -l) ))
then
	echo -e '<span foreground="#e29c04">'$icon$temp'</span>'
elif (( $(echo "$temp > 25" | bc -l) ))
then
	echo -e '<span foreground="#e2df04">'$icon$temp'</span>'
elif (( $(echo "$temp > 20" | bc -l) ))
then
	echo -e '<span foreground="#b2e204">'$icon$temp'</span>'
elif (( $(echo "$temp > 15" | bc -l) ))
then
	echo -e '<span foreground="#0486e2">'$icon$temp'</span>'
elif (( $(echo "$temp > 10" | bc -l) ))
then
	echo -e '<span foreground="#04a0e2">'$icon$temp'</span>'
elif (( $(echo "$temp > 5" | bc -l) ))
then
	echo -e '<span foreground="#34b7ef">'$icon$temp'</span>'
else
	echo -e '<span foreground="#61d8e2">'$icon$temp'</span>'
fi
	
##################################################
#     Display info
##################################################

