#!/bin/bash
# encoding: utf-8

#C_ICAP_USER=c-icap
#C_ICAP_DIR=/usr/local/c-icap

su - $C_ICAP_USER -c "${C_ICAP_DIR}/bin/c-icap -D -d 10 -f ${C_ICAP_DIR}/etc_copy/c-icap.conf"


#SQUID_USER=squid
#SQUID_DIR=/usr/local/squid

su - $squid_USER -c "${SQUID_DIR}/sbin/squid -d 10 -f ${SQUID_DIR}/etc_copy/squid.conf"
