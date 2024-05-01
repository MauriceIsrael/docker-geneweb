#!/usr/bin/env bash

set -e

function startPortal()
{
    # Start GeneWeb
    /opt/geneweb/gwd.sh -lang ${LANGUAGE} -p 2317 
}

function ensureBackupPathExists()
{
    if [[ ! -d backup ]]; then
        mkdir -p backup
    fi
}

function ensureImportPathExists()
{
    if [[ ! -d import ]]; then
        mkdir -p import
    fi
    #copy AnnieRose DB
    cp /tmp/DB/AnnieRose.gw /opt/geneweb/import/AnnieRose.gw
}

function startSetup()
{
    pushd ${HOME} 1> /dev/null

        if [[ -n "${HOST_IP}" ]]; then
           echo "${HOST_IP}" > ${HOME}/gw/only.txt
        fi

        ensureBackupPathExists
        ensureImportPathExists

        #DEFAULT_CONFIG="${HOME}/default.gwf"
        #if [[ ! -f ${DEFAULT_CONFIG} ]]; then
        #    cp /opt/geneweb/default.gwf ${DEFAULT_CONFIG}
        #fi

        #-only opt/geneweb/gw/only.txt

        /opt/geneweb/gwsetup.sh -p 2316 -lang ${LANGUAGE} -bindir /opt/geneweb/gw/  | tee -a ${HOME}/gwsetup.log

    popd 1> /dev/null
}

function runBackup()
{
    # Run the backup of all GWB databases
    backup.sh
}

case "$1" in
        start-portal)
            startPortal
            ;;

        start-setup)
            startSetup
            ;;

        start-all)
            startSetup &
            startPortal
            ;;

        backup)
            runBackup
            ;;

        *)
            echo $"Usage: $0 {start-portal|start-setup|start-all|backup}"
            exit 1

esac
