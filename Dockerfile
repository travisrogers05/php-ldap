FROM registry.access.redhat.com/rhscl/php-70-rhel7:latest
USER root
RUN echo "TLS_REQCERT     allow" >> /etc/openldap/ldap.conf
USER 1001