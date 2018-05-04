# php-ldap
Example of adding additional options to the OpenLdap configuration in the Red Hat provided PHP 7.0.x image.

This example will append the following options to /etc/openldap/ldap.conf in the generated container.
~~~
TLS_REQCERT     allow
~~~

Two methods are presented in this example.  
- One method uses a Dockerfile based build to create an intermmediate image that extends the [PHP 7.0.x image](https://access.redhat.com/containers/#/registry.access.redhat.com/rhscl/php-70-rhel7) provided by Red Hat.
- The other method uses an S2I based build to incoporate the ldap changes directly into the target container by supplying a [modified version of the assemble script](https://github.com/travisrogers05/php-ldap/blob/master/.s2i/bin/assemble#L11-#L12) in the source repository.


Files in this repository:
- Dockerfile - Used to copy the modified script into a container
- buildconfig.yml - Used to define a build for a modified container
- imagestream.yml - Used to define a imagestream for a modified container
- template.yml - Used to create an example pod
- index.php - Example page


Steps for producing the modified container:

For using a Dockerfile to create an intermmediate image:

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
4.  Now use the resulting output container, imagestream or imagestreamtag as the base image for your PHP application.  The example name is php-ldap.  Modify this to your liking.



For using an S2I based build to incoporate changes into a resulting image to use:

1.  Save the [template](https://github.com/travisrogers05/php-ldap/blob/master/template.yml) into your project.
~~~
oc create -f https://raw.githubusercontent.com/travisrogers05/php-ldap/master/template.yml
~~~  



## Testing the new container

**NOTE:** If you're using the Dockerfile method to create an intermmediate image, you will want to modify the template.yml to incorporate the intermmediate image by changing the [FROM imagestream tag](https://github.com/travisrogers05/php-ldap/blob/master/template.yml#L61) to an appropriate value.  The default would be [php-ldap:1.0](https://github.com/travisrogers05/php-ldap/blob/master/buildconfig.yml#L24).

~~~
$ oc process php-ldap | oc create -f -

$ oc get pods

$ oc exec cakephp-mysql-example-1-5mh5r -- cat /etc/openldap/ldap.conf

~~~