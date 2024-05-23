#!/bin/bash

#Output reference
print_ref() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo "Options:"
    echo "  -u, --users          Display list of users and their home directories sorted alphabetically."
    echo "  -p, --processes      Display list of running processes sorted by their ID."
    echo "  -h, --help           Display this help message and exit."
    echo "  -l PATH, --log PATH  Redirect output to a file at the specified PATH."
    echo "  -e PATH, --errors PATH Redirect errors to a file at the specified PATH."
    exit 0
}

#users and dirs
print_usr() {
    cat /etc/passwd | cut -d: -f1,6 | sort
}

#processes
print_pid() {
    ps -e --sort=pid
}

#pars
while getopts ":uphl:e:-:" opt; do
    case $opt in
        u | -u | -\-users)
            display_users
            ;;
        p | -p | -\-processes)
            display_processes
            ;;
        h | -h | -\-help)
            print_help
            ;;
        l | -l | -\-log)
            log_path=$OPTARG
            ;;
        e | -e | -\-errors)
            error_path=$OPTARG
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
        ?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

#errors
if [ -n "$log_path" ]; then
    exec > "$log_path"
fi

if [ -n "$error_path" ]; then
    exec 2> "$error_path"
fi

#empty args
if [ $# -eq 0 ]; then
    print_help
fi
