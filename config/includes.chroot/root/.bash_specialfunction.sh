#!/bin/bash
function cpufreq.check () {
    dd if=/dev/zero bs=1M count=100 2>&1|openssl rc4 -k blah |cat - >> /dev/null 2>&1
    dd if=/dev/zero bs=1M count=100 2>&1|openssl rc4 -k blah |cat - >> /dev/null 2>&1 &
    cpufreq-info |grep "current CPU frequency is"
}

function makepassphrase_old () {
 echo "Enter you passphrase, (display is disable),mode echo -n, default hash is whirlpool"
 read -s TMPPASS
 echo -n "${TMPPASS}"|openssl whirlpool
 TMPPASS=""
 unset TMPPASS
}
function makepassphrase () {
 echo "Enter you passphrase, (display is disable) mode = echo -n 'yourpass' |openssl whirlpool -binary |base64 -w 0"
 read -s TMPPASS
 echo -n "${TMPPASS}" |openssl whirlpool -binary |base64 -w 0
 TMPPASS=""
 unset TMPPASS
 echo ""
}

function fullupgrade () {
    apt-get update
    apt-get upgrade
    apt-get dist-upgrade
}

function sshgateway() { ssh -l root $(ip route |grep default |awk '{print $3}'|head -n 1) $@ ; }

function ssh_tmux() { ssh -t "$1" tmux a || ssh -t "$1" tmux; }

function netlisten () {
    netstat -nlapute |grep LISTEN |awk '{print $1,$4,$5,$6,$9}'|column -t;
}

function reverse_from_fqdn () {
    dig +short -x $(dig +short "${1}")
}

function urldecode () {
	python -c "import sys, urllib as ul; \
		print ul.unquote_plus('$@')"
}
