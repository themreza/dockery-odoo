#!/usr/bin/env bash

# This file is sourced.
# It requires base_path as first argument
# or ODOO_BASEPATH in the environment.

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; BOLD='\033[1m'; ULINE='\033[4m'; NC='\033[0m';



if [[ $# == 2 ]]; then
    patches_dir=${1}
    base_path=${2}
else
    echo -e "${RED}Usage: apply-patches <patches.d> <basepath>${NC}."
fi

rPatch () {
    echo -e "${GREEN}${1}${NC} <- ${2}"
    eval "curl ${2} | git apply --unsafe-paths --directory=${1} && echo";
}
fPatch () {
    echo -e "${GREEN}${1}${NC} <- ${2}"
    eval "git apply --unsafe-paths --directory=${1} ${2} && echo";
}

echo -e "\nApplying patches to ${base_path} ...\n"


function apply_patches_in() {
    # Change windows style to linux style
    fn=${2//\'/}

    # Is it a file at all?
    if [[ -f $fn ]]; then
        [ "${fn##*.}" == "empty" ] && return # skip git keep file
        [ "${fn##*.}" == "gitkeep" ] && return # skip git keep file

        # Verify RELBASE specification in first line (must be first line)
        read -r firstline < "$fn"
        echo -e "\n${YELLOW}${BOLD}${ULINE}File: ${fn}${NC}\n"

        if [ "${fn##*.}" != "patch" ] && [ "${fn##*.}" != "url" ]; then
            echo -e "${RED}Patch files must end in '*.url' or '*.patch'.${NC}"
        fi

        if [ "${firstline:0:8}" != 'RELBASE:' ]; then
            echo -e "${RED}First line MUST specify string 'RELBASE: *'${NC}\n"
            exit 1
        else
            dir="${firstline##RELBASE:}"
            dir=$(echo "${dir}" | xargs)  # Strip whitespaces
            dir="${base_path}/${dir}"
        fi

        # If it's an .url file with one or m more urls in it.
        if [ "${fn##*.}" == "url" ]; then
            regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
            while IFS='' read -r line || [[ -n "$line" ]];
                do
                    [ -z "$line" ] && continue # skip empty line
                    [ "${line:0:1}" = '#' ]  && continue # skip commented line
                    if [[ $line =~ $regex ]]; then
                        rPatch "${dir}" "${line}"
                    fi
                done < "$fn"
        elif [ "${fn##*.}" == "patch" ]; then
            fPatch "${dir}" "${fn}"
        fi
        echo -e "${YELLOW}${BOLD}---${NC}\n"

    else
        echo -e "\n${RED}File not found: $fn${NC}"
    fi
}


for fn in $(find "${patches_dir}" -maxdepth 1 -mindepth 1 -xtype f | sort | xargs realpath --no-symlinks);
do
    :
    apply_patches_in "${base_path}" "${fn}"
done
