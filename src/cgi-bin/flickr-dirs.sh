#!/bin/bash
echo "Content-Type: application/json"
echo
echo

urldecode() {
    echo $1 | sed -e 's/%21/!/g' -e 's/%23/#/g' -e 's/%24/$/g' -e 's/%26/\&/g' -e "s/%27/'/g" -e 's/%28/(/g' -e 's/%29/)/g' -e 's#%2F#/#g'
}

saveIFS=$IFS
IFS='=&'
tmp=($QUERY_STRING)
IFS=$saveIFS

declare -A params
for ((i=0; i<${#tmp[@]}; i+=2))
do
    params[${tmp[i]}]=$(urldecode ${tmp[i+1]})
done

BASE=${params["where"]}
if [ "${BASE: -1}" == "/" ]; then
    BASE="${BASE}foo.html"
fi

echo "{ \"albums\": ["

IMGDIR=/var/www/html
if [ ! -d $IMGDIR ]; then
  IMGDIR=/var/www/lighttpd
fi
dirs=(${IMGDIR}$(dirname ${BASE})/*)
N=${#dirs[@]}

#echo "$(date)" > /tmp/fr
#echo "$BASE" >> /tmp/fr
#echo "where = "  ${params["where"]} >> /tmp/fr
#for ((i=0; i<$N; i++)); do
  #echo ${dirs[$i]} >> /tmp/fr
#done

COUNT=0
TOTAL=0
for ((i=0; i<$N; i++)); do
    if [ ! -d "${dirs[$i]}" ]; then
      continue;
    fi
  
    if [ $COUNT -gt 0 ];  then
      echo -n ","
    fi
    TN=$(shuf -en 1 "${dirs[$i]}"/.tn/* | sed -e "s#^/var/www/lighttpd##" -e "s#^/var/www/html##")
    DIR=$(echo "${dirs[$i]}" | sed -e "s#^/var/www/lighttpd##" -e"s#^/var/www/html##")
    DIR_TOTAL=$(find "${dirs[$i]}" -maxdepth 1 -type f | egrep -c "*.jpg|*.png")
    NAME=$(basename "${dirs[$i]}")
    echo -n "{ \"path\": \"${DIR}\", \"name\": \"${NAME}\", \"total\": ${DIR_TOTAL}, \"thumbpath\": \"${TN}\" }"

    ((COUNT++))
    ((TOTAL += $DIR_TOTAL))
done
echo -n "  ], \"count\": $COUNT, \"total_imgs\": $TOTAL }"
