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

echo "{ \"images\": ["

## FIX MME
IMGDIR=/var/www/html
if [ ! -d $IMGDIR ]; then
  IMGDIR=/var/www/lighttpd
fi
files=(${IMGDIR}$(dirname ${BASE})/*.jpg)
N=${#files[@]}

OFFSET=${params["offset"]}
if [ -z $OFFSET ]; then
  OFFSET=0
fi
COUNT=${params["count"]}
if [ -z $COUNT ]; then
    COUNT=$(($N - $OFFSET))
else
  if [ $COUNT -gt $N ]; then
    COUNT=$(($N - $OFFSET))
  fi
fi
M=$(($COUNT+$OFFSET))
if [ $M -gt $N ]; then
  M=$N
fi

for ((i=$OFFSET; i<$M; i++)); do
    if [ $i -gt $OFFSET ];  then
      echo -n ","
    fi
    IMG=$(echo ${files[$i]} | sed -e "s#^/var/www/lighttpd##" -e"s#^/var/www/html##")
    echo -n "{ \"path\": \"${IMG}\", \"thumbpath\": \"$(dirname $IMG)/.tn/$(basename $IMG)\" }"
done
echo "  ], \"offset\": $OFFSET, \"count\": $COUNT, \"total\": $N }"
