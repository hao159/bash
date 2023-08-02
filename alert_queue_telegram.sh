#!/bin/bash

# define the telegram configs
USERID="id user telegram"
KEY="api key bot"

TIMEOUT="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"


DATE_EXEC="$(date "+%d %b %Y %H:%M")"

# define the tubes array
# [<host>:<port>@<tube_name>=<threshold>]
declare -A tubes=(
    ["127.0.0.1:11300@tube_name1"]=10
    ["127.0.0.1:11300@tube_name2"]=2
    ["127.0.0.2:11300@tube_name3"]=20
)

for key in "${!tubes[@]}"; do
	# extract the host, port, tube name, and threshold from the key
	host_port_tube=(${key//@/ })
	host_port=(${host_port_tube[0]//:/ })
	host=${host_port[0]}
	port=${host_port[1]}
	tube=${host_port_tube[1]}
	threshold=${tubes[$key]}

	stats=$({ echo "stats-tube $tube"; sleep 1;} | telnet $host $port)

 	if [[ "$stats" != *"OK"* && "$stats" != *"NOT_FOUND"* ]]; then
		#got an error in connection
		message2="[ 🔴 Warning - <code>${DATE_EXEC}</code>] <b>[Connection refused] in the:</b> <code>${host}:${port}</code> Please check Beanstalkd!"
    		#send alert message to telegram
   		#...
    		curl -s --max-time $TIMEOUT -d "chat_id=$USERID&parse_mode=HTML&disable_web_page_preview=1&text=$message2" $URL > /dev/null
      		# next loop
		continue
	fi

	current_jobs_ready=$(echo "$stats" | awk '/current-jobs-ready:/ {print $2}')

	if (( current_jobs_ready > threshold )); then
    		message2="[ ⚠️ Alert - <code>${DATE_EXEC}</code>] <b>The number of jobs-ready in the:</b> <code>'${key}'</code>: <code>${current_jobs_ready}</code> tube has exceeded the threshold of <code>${threshold}</code>"
    		#send alert message to telegram
   		#...
    		curl -s --max-time $TIMEOUT -d "chat_id=$USERID&parse_mode=HTML&disable_web_page_preview=1&text=$message2" $URL > /dev/null
	fi
done
