CREATE DATABASE koha_theorangelibrary;

CREATE USER 'koha_theorangelibrary'@'%' IDENTIFIED BY 'password';

GRANT ALL ON koha_theorangelibrary.* TO 'koha_theorangelibrary'@'%';

CHANGE REPLICATION SOURCE to GET_SOURCE_PUBLIC_KEY =1;


ALTER USER 'koha_theorangelibrary'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
