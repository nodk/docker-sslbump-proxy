#!/bin/bash
# encoding: utf-8

C_ICAP_USER=c-icap
#C_ICAP_DIR=/usr/local/c-icap


chown -R ${C_ICAP_USER}:${C_ICAP_USER} $C_ICAP_DIR
cp $C_ICAP_DIR/etc/c-icap.conf $C_ICAP_DIR/etc_copy/c-icap.conf
echo "#===added c_icap config===" >> $C_ICAP_DIR/etc_copy/c-icap.conf
echo "User $C_ICAP_USER" >> $C_ICAP_DIR/etc_copy/c-icap.conf
echo "Group $C_ICAP_USER" >> $C_ICAP_DIR/etc_copy/c-icap.conf
echo "PidFile $C_ICAP_DIR/var/run/c-icap/c-icap.pid" >> $C_ICAP_DIR/etc_copy/c-icap.conf
echo "CommandsSocket $C_ICAP_DIR/var/run/c-icap/c-icap.ctl" >> $C_ICAP_DIR/etc_copy/c-icap.conf
#echo "Service xss srv_xss.so" >> $C_ICAP_DIR/etc_copy/c-icap.conf
cat $C_ICAP_DIR/etc_copy/c-icap.conf | grep added\ config -A1000 #fflush()
echo "#===added c_icap config==="


SQUID_USER=squid
#SQUID_DIR=/usr/local/squid

mkdir -p $SQUID_DIR/ssl
mkdir -p $SQUID_DIR/var/cache/squid
openssl req -new -newkey rsa:2048 -nodes -days 3650 -x509 -keyout $SQUID_DIR/ssl/myCA.pem -out $SQUID_DIR/ssl/myCA.crt \
 -subj "/C=JP/ST=Ikebukuro/L=Tokyo/O=Dollers/OU=Dollers Co.,Ltd./CN=squid.local"
openssl x509 -in $SQUID_DIR/ssl/myCA.crt -outform DER -out $SQUID_DIR/ssl/myCA.der
$SQUID_DIR/libexec/security_file_certgen -c -s $SQUID_DIR/var/lib/ssl_db -M 4MB
chown 700 $SQUID_DIR/ssl/myCA.pem
chown -R ${SQUID_USER}:${SQUID_USER} $SQUID_DIR
cp $SQUID_DIR/etc/squid.conf $SQUID_DIR/etc_copy/squid.conf
echo "#====added squid config===" >> $SQUID_DIR/etc_copy/squid.conf
echo "cache_effective_user $SQUID_USER" >> $SQUID_DIR/etc_copy/squid.conf
echo "cache_effective_group $SQUID_USER" >> $SQUID_DIR/etc_copy/squid.conf
echo "always_direct allow all" >> $SQUID_DIR/etc_copy/squid.conf
echo "icap_service_failure_limit -1" >> $SQUID_DIR/etc_copy/squid.conf
echo "ssl_bump bump all" >> $SQUID_DIR/etc_copy/squid.conf
echo "sslproxy_cert_error allow all" >> $SQUID_DIR/etc_copy/squid.conf
sed "/^http_port 3128$/d" -i $SQUID_DIR/etc_copy/squid.conf
sed "s/^http_access allow localnet$/http_access allow all/" -i $SQUID_DIR/etc_copy/squid.conf
echo "http_port 3128 ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB cert=$SQUID_DIR/ssl/myCA.crt key=$SQUID_DIR/ssl/myCA.pem" >> $SQUID_DIR/etc_copy/squid.conf
echo "sslcrtd_program $SQUID_DIR/libexec/security_file_certgen -s $SQUID_DIR/var/lib/ssl_db -M 4MB" >> $SQUID_DIR/etc_copy/squid.conf
echo "icap_enable on" >> $SQUID_DIR/etc_copy/squid.conf
echo "icap_preview_enable on" >> $SQUID_DIR/etc_copy/squid.conf
echo "icap_preview_size 1024" >> $SQUID_DIR/etc_copy/squid.conf
echo "icap_206_enable on" >> $SQUID_DIR/etc_copy/squid.conf
echo "icap_persistent_connections on" >> $SQUID_DIR/etc_copy/squid.conf
echo "adaptation_send_client_ip off" >> $SQUID_DIR/etc_copy/squid.conf
echo "adaptation_send_username off" >> $SQUID_DIR/etc_copy/squid.conf
echo "icap_service srv_echo_req reqmod_precache icap://127.0.0.1:1344/echo"  >> $SQUID_DIR/etc_copy/squid.conf
echo "icap_service srv_echo_resp respmod_precache icap://127.0.0.1:1344/echo" >> $SQUID_DIR/etc_copy/squid.conf
#echo "adaptation_service_set svc_echo_req_set srv_echo_req" >> $SQUID_DIR/etc_copy/squid.conf
#echo "adaptation_service_set svc_echo_resp_set srv_echo_resp">> $SQUID_DIR/etc_copy/squid.conf
echo "adaptation_service_chain svc_echo_req_chain srv_echo_req" >> $SQUID_DIR/etc_copy/squid.conf
echo "adaptation_service_chain svc_echo_resp_chain srv_echo_resp">> $SQUID_DIR/etc_copy/squid.conf
echo "adaptation_access svc_echo_req_chain allow all">> $SQUID_DIR/etc_copy/squid.conf
echo "adaptation_access svc_echo_resp_chain allow all">> $SQUID_DIR/etc_copy/squid.conf
cat $SQUID_DIR/etc_copy/squid.conf | grep added\ config -A1000 #fflush()
echo "#===added squid config==="

bash
