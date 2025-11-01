#!/bin/bash
H="8.8.8.8" L=100 M=3 F=0
printf "--- Ping %s (>%d мс: warning; %d  error) ---\n" "$H" "$L" "$M"

for ((;;)); do
    T=$(ping -c1 -W1 "$H" 2>/dev/null | awk '/time=/{print $7}' | cut -d= -f2)
    if [ $? -eq 0 ] && [ -n "$T" ]; then
        TI=${T%.*}
        [ $F -ge $M ] && printf "%s GOOD: %s (%s мс)\n" "$(date +%T)" "$H" "$T"
        F=0
        [ "$TI" -gt "$L" ] && printf "%s BIG PAUSE: %s мс > %d мс\n" "$(date +%T)" "$T" "$L"
    else
        ((F++))
        [ $F -eq $M ] && printf "%s ERROR: %s no access(%d )\n" "$(date +%T)" "$H" "$M"
    fi
    sleep 1
done
