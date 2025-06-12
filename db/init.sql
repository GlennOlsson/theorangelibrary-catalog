CREATE DATABASE koha_theorangelibrary;

CREATE USER 'koha_theorangelibrary'@'%' IDENTIFIED BY 'T0X)sC0D5kRd}s1?';
-- CREATE USER 'koha_theorangelibrary'@'%' IDENTIFIED WITH mysql_native_password BY 'T0X)sC0D5kRd}s1?';

GRANT ALL ON koha_theorangelibrary.* TO 'koha_theorangelibrary'@'%';


CHANGE REPLICATION SOURCE to GET_SOURCE_PUBLIC_KEY =1;


ALTER USER 'koha_theorangelibrary'@'%' IDENTIFIED WITH mysql_native_password BY 'T0X)sC0D5kRd}s1?';

