# Install
```bash
cd /app
cp koha-sites.conf /etc/koha/koha-sites.conf 

# rm /etc/mysql/koha-common.cnf 
# cp koha-mysql.conf  /etc/mysql/koha-common.cnf

cp apache-ports.conf /etc/apache2/ports.conf 

a2enmod rewrite cgi headers proxy_http
service apache2 restart

# koha-create --create-db theorangelibrary
# koha-create --use-db --passwd /app/passwd --defaultsql /app/koha-backup.sql theorangelibrary
koha-create --use-db --database koha_theorangelibrary --defaultsql /app/koha-backup.sql theorangelibrary


koha-plack --enable theorangelibrary
koha-plack --start theorangelibrary

# koha-create --request-db theorangelibrary --dbhost mysqlhost --passwdfile /app/passwd
```
Install db as described in `...-request.txt` and `init.sql`
```bash
koha-create --populate-db theorangelibrary --dbhost mysqlhost
koha-enable theorangelibrary
```

// STUCK AT STARTING THE LIBRARY/OPENING THE PAGE. GETTING 500
// THINK THE DATABASE IS NOT CONNECTED
```BASH
root@352b188e3e0e:/app# tail /var/log/koha/theorangelibrary/worker-output.log 
Attempt to call undefined import method with arguments ("GetAuthorisedValues") via package "C4::Koha" (Perhaps you forgot to load the package?) at /usr/share/koha/lib/Koha/ILL/Request/Logger.pm line 23.
Attempt to call undefined import method with arguments ("CanBookBeIssued" ...) via package "C4::Circulation" (Perhaps you forgot to load the package?) at /usr/share/koha/lib/Koha/ILL/Request.pm line 49.
Attempt to call undefined import method with arguments ("GetPreparedLetter") via package "C4::Letters" (Perhaps you forgot to load the package?) at /usr/share/koha/lib/C4/Members.pm line 29.

Connection to the memcached servers '127.0.0.1:11211' failed. Are the unix socket permissions set properly? Is the host reachable?
If you ignore this warning, you will face performance issues
Cannot connect to broker (Failed to connect: Error connecting to localhost:61613: Cannot assign requested address at /usr/share/perl5/Net/Stomp.pm line 27.; giving up at /usr/share/perl5/Net/Stomp.pm line 27.
) at /usr/share/koha/lib/Koha/BackgroundJob.pm line 100.
Cannot connect to the message broker, the jobs will be processed anyway at /usr/share/koha/bin/workers/background_jobs_worker.pl line 100.
DBIx::Class::Storage::DBI::catch {...} (): DBI Connection failed: DBI connect('database=koha_theorangelibrary;host=mysqlhost;port=3306','koha_theorangelibrary',...) failed: Authentication plugin 'caching_sha2_password' reported error: Authentication requires secure connection. at /usr/share/koha/lib/Koha/Database.pm line 75. at /usr/share/koha/lib/Koha/Database.pm line 125
```

Why is auth not ok?
