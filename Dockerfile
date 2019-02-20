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
	supervisor

# ----- Install shibboleth ----- #
RUN yum -y install \
        shibboleth \
        opensaml-schemas \
        xmltooling-schemas \
		xmltooling-schemas \
		opensaml-bin \
		libxmltooling-devel \
		libsaml-devel

# Fix the library path for shibboleth (https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPLinuxRH6)
ENV LD_LIBRARY_PATH=/opt/shibboleth/lib64

# Copy Supervisor ini files
ADD ./supervisord.d/supervisord.conf /etc/supervisord.conf
ADD ./supervisord.d/* /etc/supervisord.d/


CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
