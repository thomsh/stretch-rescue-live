# /etc/profile.d/serial-console.sh

rsz() {
    if [[ -t 0 && $# -eq 0 ]];then
        local IFS='[;' escape geometry x y
        echo -ne '\e7\e[r\e[999;999H\e[6n\e8'
        read -sd R escape geometry
        x=${geometry##*;} y=${geometry%%;*}
        if [[ ${COLUMNS} -eq ${x} && ${LINES} -eq ${y} ]];then
            :
        else
            stty cols ${x} rows ${y}
        fi
    else
        print 'Usage: rsz'
    fi
}

case $(tty) in
    /dev/ttyS*) rsz ;;
    /dev/hvc*)  rsz ;;
esac
