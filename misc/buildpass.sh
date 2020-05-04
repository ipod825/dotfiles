#!/usr/bin/env bash

input="pass.csv"

EnterPassword(){
pass insert $1 > /dev/null << EOF
$2
$2
EOF
}

while IFS= read -r line
do
    if [[ ! $line =~ ^# ]] && [[ ! $line =~ ^[:space:]*$ ]]; then
        line=${line/,/\/}
        domain=$(cut -d "," -f 1 <<< $line)
        pass=$(cut -d "," -f 2 <<< $line)
        EnterPassword $domain $pass
    fi
done < "$input"
