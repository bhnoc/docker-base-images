#note: these files must remain with Unix line endings
FROM ghcr.io/bhnoc/rocky9:latest

EXPOSE 80
EXPOSE 443

VOLUME ["/var/www/config","/var/www/letencrypt"]

RUN dnf -y install epel-release && dnf -y install http://rpms.remirepo.net/enterprise/remi-release-9.rpm
RUN dnf -y install dnf-utils
RUN dnf -y module reset php
RUN dnf -y module install php:remi-8.2
RUN dnf update
RUN dnf -y install php php-cli php-gd php-mysqlnd php-mbstring php-json php-common php-dba php-dbg php-devel php-embedded php-enchant php-bcmath php-gmp php-intl php-ldap php-odbc php-pdo php-opcache php-pear php-pgsql php-process php-snmp php-soap php-xml php-opcache

RUN dnf install -y httpd perl-DBD-MySQL git make zip unzip mod_ssl

RUN sed -i 's/SSLCertificateFile.*/SSLCertificateFile \/etc\/ssl\/live\/cert\.pem/g' /etc/httpd/conf.d/ssl.conf
RUN sed -i 's/SSLCertificateKeyFile.*/SSLCertificateKeyFile \/etc\/ssl\/live\/privkey\.pem/g' /etc/httpd/conf.d/ssl.conf
RUN sed -i 's/\(LoadModule\ mpm_event_module\ modules\/mod_mpm_event\.so\)/\#\1/g' /etc/httpd/conf.modules.d/00-mpm.conf
RUN sed -i 's/\#\(LoadModule\ mpm_prefork_module\ modules\/mod_mpm_prefork\.so\)/\1/g' /etc/httpd/conf.modules.d/00-mpm.conf

RUN  mkdir -p /etc/httpd/vhosts.d

RUN  echo "IncludeOptional vhosts.d/*.conf" >> /etc/httpd/conf/httpd.conf
RUN  echo 'Header always set Access-Control-Allow-Origin "*"' >> /etc/httpd/conf.d/access-control.conf
RUN  echo 'Header always set Access-Control-Allow-Headers "x-requested-with, Content-Type, origin, authorization, accept, client-security-token, access-control-allow-origin, access-control-allow-headers, access-control-allow-methods"' >> /etc/httpd/conf.d/access-control.conf
RUN  echo 'Header always set Access-Control-Allow-Methods "GET, POST, DELETE, PUT, PATCH, OPTIONS"' >> /etc/httpd/conf.d/access-control.conf

RUN  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/sbin --filename=composer

RUN  chown -R root:apache /run/httpd
RUN  chmod 0710 /run/httpd

RUN mkdir -p /var/www/html/logs
RUN mkdir -p /var/www/config
RUN chown -R apache:apache /var/www/html/
RUN chmod -R g+w /var/www/html/
RUN chmod -R g+s /var/www/html/
RUN cd /etc/httpd/vhosts.d && ln -nsf /var/www/config/httpd.conf

RUN mkdir -p /etc/ssl
RUN chown -R apache:apache /etc/ssl
RUN chmod -R g+w /etc/ssl
RUN chmod -R g+s /etc/ssl

RUN cd /etc/httpd/conf.d && rm welcome.conf && rm ssl.conf
COPY ssl.conf /etc/httpd/conf.d/ssl.conf

COPY start-up.sh start-up.sh

CMD ["/start-up.sh"]
