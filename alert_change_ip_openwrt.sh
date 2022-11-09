#!/bin/sh                                                                                                                                                                                                 
                                                                                                                                                                                                          
USERID=""                                                                                                                                                                                       
KEY=""                                                                                                                                                      
                                                                                                                                                                                                          
TIMEOUT="10"                                                                                                                                                                                              
URL="https://api.telegram.org/bot$KEY/sendMessage"                                                                                                                                                        
DATE_EXEC="$(date "+%d %b %Y %H:%M")"                                                                                                                                                                     
TMPFILE='/tmp/ipinfo.txt'                                                                                                                                                                                 
                                                                                                                                                                                                          
if [ -f "$TMPFILE" ];then                                                                                                                                                                                 
        OLD_IP=$(cat $TMPFILE)                                                                                                                                                                            
else                                                                                                                                                                                                      
        OLD_IP=""                                                                                                                                                                                         
fi                                                                                                                                                                                                        
                                                                                                                                                                                                          
NEW_IP=$(ifstatus wan |  jsonfilter -e '@["ipv4-address"][0].address')                                                                                                                                    
                                                                                                                                                                                                          
echo $NEW_IP > $TMPFILE                                                                                                                                                                                   
                                                                                                                                                                                                          
if [ "$NEW_IP" = "$OLD_IP" ]; then                                                                                                                                                                        
        echo ""                                                                                                                                                                                           
else                                                                                                                                                                                                      
        TEXT="$DATE_EXEC: ....[Detected] change ip from $OLD_IP to $NEW_IP"                                                                                                                               
        curl -s --max-time $TIMEOUT -d "chat_id=$USERID&disable_web_page_preview=1&text=$TEXT" $URL > /dev/null                                                                                           
fi                             
