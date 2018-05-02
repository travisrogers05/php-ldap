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


