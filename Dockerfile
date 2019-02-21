FROM cern/cc7-base:20180516

# ----- Set environment and language ----- #
ENV DEBIAN_FRONTEND noninteractive
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8



# ----- Install httpd and related mods ----- #
RUN yum -y install epel-release

RUN yum -y install \
	httpd \
	mod_ssl \
	supervisor\
	vim \
	less \
	sssd

# ----- Install shibboleth ----- #
RUN yum -y install \
        shibboleth \
        opensaml-schemas \
        xmltooling-schemas \
		xmltooling-schemas \
		opensaml-bin \
		libxmltooling-devel \
		libsaml-devel

RUN yum -y install \ 	php \ 	rh-php71*
RUN ln -s /opt/rh/httpd24/root/etc/httpd/modules/librh-php71-php7.so /etc/httpd/modules/libphp7.so
ADD 10-php.conf /etc/httpd/conf.modules.d/10-php.conf

RUN yum -y install \
         nscd \ 
         nss-pam-ldapd \
         openldap-clients

# Fix the library path for shibboleth (https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPLinuxRH6)
ENV LD_LIBRARY_PATH=/opt/shibboleth/lib64

RUN sed -i 's|DocumentRoot "/var/www/html"|DocumentRoot "/var/www/html/cernbox"|g' /etc/httpd/conf/httpd.conf

# Change apache config
ADD shib.conf /etc/httpd/conf.d/
ADD ssl.conf /etc/httpd/conf.d/
ADD httpd.conf /etc/httpd/conf/
ADD ns*.conf /etc/
ADD sssd.conf /etc/sssd/

ADD ./supervisord.d/sssd_foreground.sh /usr/sbin/sssd_foreground.sh 
RUN chmod +x /usr/sbin/sssd_foreground.sh

# Copy Supervisor ini files
ADD ./supervisord.d/supervisord.conf /etc/supervisord.conf
ADD ./supervisord.d/* /etc/supervisord.d/


CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
