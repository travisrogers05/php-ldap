# php-ldap
Example of adding additional options to the OpenLdap configuration in the Red Hat provided PHP 7.0.x image.

This example will append the following options to /etc/openldap/ldap.conf in the generated container.
~~~
TLS_REQCERT     allow
~~~

The resulting container is derived from image [registry.access.redhat.com/rhscl/php-70-rhel7](https://access.redhat.com/containers/#/registry.access.redhat.com/rhscl/php-70-rhel7).


Files in this repository:
- Dockerfile - Used to copy the modified script into a container
- buildconfig.yml - Used to define a build for a modified container
- imagestream.yml - Used to define a imagestream for a modified container


Steps for producing the modified container:

1.  Save the [buildconfig](https://github.com/travisrogers05/php-ldap/blob/master/buildconfig.yml) and [imagestream](https://github.com/travisrogers05/php-ldap/blob/master/imagestream.yml) and make any changes to the files that you wish.
2.  Create the buildconfig and imagestream in your Openshift project.
~~~
oc create -f buildconfig.yml
oc create -f imagestream.yml
~~~  
3.  Run the build.  This will create a version of [registry.access.redhat.com/rhscl/php-70-rhel7:latest](https://access.redhat.com/containers/#/registry.access.redhat.com/rhscl/php-70-rhel7) that contains a modified `/etc/openldap/ldap.conf` file.  This container will be named [php-ldap:1.0](https://github.com/travisrogers05/php-ldap/blob/master/buildconfig.yml#L24) by default.
~~~
oc start-build php-ldap
~~~
4.  Now use the resulting output container, imagestream or imagestreamtag as the input for your PHP application.  The example name is php-ldap.  Modify this to your liking.


## Testing the new container

The following commands use a modified version of the [php cake example template](https://github.com/travisrogers05/php-ldap/blob/master/cakephp-mysql-example-ldap.yml) to incorporate this modified PHP 7.0 container in an example application.  The template has been modified to use the [new container imagestream](https://github.com/travisrogers05/php-ldap/blob/master/cakephp-mysql-example-ldap.yml#L97).

~~~
$ oc create -f https://raw.githubusercontent.com/travisrogers05/php-ldap/master/cakephp-mysql-example-ldap.yml
$ oc process cakephp-mysql-example-ldap | oc create -f -
secret "cakephp-mysql-example" created
service "cakephp-mysql-example" created
route "cakephp-mysql-example" created
imagestream "cakephp-mysql-example" created
buildconfig "cakephp-mysql-example" created
deploymentconfig "cakephp-mysql-example" created
service "mysql" created
deploymentconfig "mysql" created

$ oc get pods
NAME                            READY     STATUS      RESTARTS   AGE
cakephp-mysql-example-1-5mh5r   1/1       Running     0          6m
cakephp-mysql-example-1-build   0/1       Completed   0          9m
mysql-1-n265p                   1/1       Running     0          8m
php-ldap-1-build                0/1       Completed   0          23m

$ oc exec cakephp-mysql-example-1-5mh5r -- cat /etc/openldap/ldap.conf
#
# LDAP Defaults
#

# See ldap.conf(5) for details
# This file should be world readable but not world writable.

#BASE	dc=example,dc=com
#URI	ldap://ldap.example.com ldap://ldap-master.example.com:666

#SIZELIMIT	12
#TIMELIMIT	15
#DEREF		never

TLS_CACERTDIR	/etc/openldap/certs

# Turning this off breaks GSSAPI used with krb5 when rdns = false
SASL_NOCANON	on
TLS_REQCERT     allow
~~~