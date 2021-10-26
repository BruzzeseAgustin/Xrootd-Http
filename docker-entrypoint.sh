
#!/bin/bash

# /etc/init.d/globus-gridftp-server start > /var/log/griftp-server.log

./renew_proxy.sh &

/etc/init.d/globus-gridftp-sshftp reconfigure

echo "[include]
files = /etc/supervisord.d/*.conf

[program:gridftp-server]
command=/etc/init.d/globus-gridftp-server start
startsecs=0
stopwaitsecs=10
user=root 
redirect_stderr=true
redirect stdout=true
stdout_logfile=/var/log/gridftp-server
autostart=false

[program:xrootd-standalone]
# command=xrootd -c /etc/xrootd/xrootd-standalone.cfg -k fifo -n standalone -k 10 -s /var/run/xrootd/xrootd-standalone.pid -l /var/log/xrootd/xrootd.log
command=xrootd -R datatrans -n rucio -c /etc/xrootd/xrdrucio.cfg -s /var/run/xrootd/xrootd-standalone.pid -l /var/log/xrootd/xrootd.log
user=datatrans
autorestart=true

[program:http-standalone]
# command=xrootd -c /etc/xrootd/xrootd-standalone.cfg -k fifo -n standalone -k 10 -s /var/run/xrootd/xrootd-standalone.pid -l /var/log/xrootd/xrootd.log
command=xrootd -R datatrans -n rucio -c /etc/xrootd/httprucio.cfg -s /var/run/xrootd/http-standalone.pid -l /var/log/xrootd/http.log -n http
user=datatrans
autorestart=true" >> /etc/supervisord.conf

/usr/bin/supervisord -c /etc/supervisord.conf -n &&

# /etc/init.d/globus-gridftp-server start
# supervisorctl start gridftp-server

supervisorctl start xrootd-standalone
supervisorctl start http-standalone

# keep container running
tail -f /dev/null

