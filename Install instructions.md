# what i've done

Fixed the lenght of Primary Key of `proxies_priv` db to avoid key length error

Needed to enclose db password in ' in the `/etc/mysql/koha-common.cnf` file

Create user with password and pr
```sql
CREATE USER 'koha_catalog'@'%' IDENTIFIED BY '~u2si.p}$Cu0fBpJ';
GRANT ALL PRIVILEGES ON koha_theorangelibrary.* TO 'koha_catalog'@'%';
FLUSH PRIVILEGES;
```

Needed to set the db host manually in `/etc/koha/sites/theorangelibrary/koha-conf.xml`

Mysql file
```conf
[client]
user=koha_catalog
password='~u2si.p}$Cu0fBpJ'
host=mariadb
```
Test mysql default file with `--print-defaults`

Also added a symlink to `/etc/mysql/koha-common.cnf` in `/etc/mysql/mariadb.conf.d/`
`ln -s /etc/mysql/koha-common.cnf /etc/mysql/mariadb.conf.d/koha.cnf`


NEXT
WHY IS IT BEING KILLED? 
Cannot connect through web, I think the underlying server is not running
```
==> /var/log/koha/theorangelibrary/worker-error.log <==
20250729 05:25:43 theorangelibrary-koha-worker-long_tasks: client (pid 3761) killed by signal 15, stopping
20250729 05:44:22 theorangelibrary-koha-worker: client (pid 4117) killed by signal 15, stopping
20250729 05:44:22 theorangelibrary-koha-worker-long_tasks: client (pid 4120) killed by signal 15, stopping
20250729 05:46:39 theorangelibrary-koha-worker: client (pid 5909) killed by signal 15, stopping
20250729 05:46:39 theorangelibrary-koha-worker-long_tasks: client (pid 5914) killed by signal 15, stopping
20250729 05:49:07 theorangelibrary-koha-worker: client (pid 6449) killed by signal 15, stopping
20250729 05:49:07 theorangelibrary-koha-worker-long_tasks: client (pid 6465) killed by signal 15, stopping
20250729 05:57:07 theorangelibrary-koha-worker: client (pid 6873) killed by signal 15, respawning
20250729 05:57:11 theorangelibrary-koha-worker: client (pid 7061) killed by signal 15, respawning
20250729 05:57:30 theorangelibrary-koha-worker: client (pid 7075) killed by signal 15, respawning
```
Might be due to this error in `/var/log/apache2/error.log`
```
[Tue Jul 29 06:06:33.680284 2025] [mpm_itk:warn] [pid 7373:tid 7373] (itkmpm: pid=7373 uid=33, gid=33) itk_post_perdir_config(): setgid(1000): Operation not permitted
[Tue Jul 29 06:06:33.680396 2025] [mpm_itk:warn] [pid 7373:tid 7373] (itkmpm: pid=7373 uid=33, gid=33) itk_post_perdir_config(): setgid(1000): Operation not permitted
```
Add this to docker compose before running
```
services:
  koha:
    build: .
    cap_add:
      - SETGID
      - SETUID
```
Ensure to rebuild and re-create container so it is applied


```
# Set the domain name
sed -r s/myDNSname/theorangelibrary/gi /etc/koha/koha-sites.conf > new_config
mv new_config /etc/koha/koha-sites.conf

# Create the instance
koha-create --request-db --dbhost mariadb --database koha_theorangelibrary catalog

# Set the database pass to what it's supposed to be
sed -r "s/<pass>.+<\/pass>/<pass>~u2si.p}\$Cu0fBpJ<\/pass>/g" /etc/koha/sites/catalog/koha-conf.xml > new_config
mv new_config /etc/koha/sites/catalog/koha-conf.xml

# NOT a DNS, that is routed to the default apache2
echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf
sudo a2enconf fqdn

# Create database defaults file
echo "
[client]
user=koha_catalog
password='~u2si.p}\$Cu0fBpJ'
host=mariadb" > /etc/mysql/koha-common.cnf
ln -s /etc/mysql/koha-common.cnf /etc/mysql/mariadb.conf.d/koha.cnf

koha-create --populate-db catalog

chown catalog-koha:catalog-koha /var/log/koha/catalog/*

koha-plack --enable catalog
koha-plack --start catalog
service apache2 restart

a2ensite catalog

service memcached start

chown catalog-koha:catalog-koha /var/log/koha/catalog/*

service koha-common restart

koha-enable catalog

service apache2 start
```

Needed to update the /etc/apache2/sites-enabled/catalog.conf file manually to set the server name
Can probably be fixed if koha-sites is modified before running `koha-create`

Rebuilt zebra indexes using
```
koha-rebuild-zebra -f -v -b catalog
service koha-common restart
```


To hide certain books, I added 
```
itemnotes_nonpublic: [x.]
```
to `OpacHiddenItems` under OPAC admin, and `OpacHiddenItemsHidesRecord` to hide the book completely
if all items are hidden. This means that all items with books that has a _Non-public note_ set to 
`x.` are hidden from the users in OPAC. We can enable them to be visible for certain people.
