# openshift-router-307
OpenShift 3 Router 307 test

Build Docker Image:
-------------------
Test service that returns site under maintenance message to show the
interactions with the OpenShift 3.0 router.

To build the docker image, run ```make```:

    $  make   #  or make build


Usage with docker:
------------------
Ensure you build the docker image as mentioned above.
To run the test server with docker, run ```make run```:

    $  make run


Usage with OpenShift 3:
-----------------------
Ensure you build the docker image as mentioned above.
To run the test server with OpenShift 3, use:

    $  oc create -f openshift/dc.json
    $  oc create -f openshift/secure-service.json
    $  oc create -f openshift/insecure-service.json


Testing routes on OpenShift 3:
------------------------------
Ensure you build the docker image and add the maintenance-test deployment
config and service to OpenShift 3 as mentioned in the build and usage
sections above.

    $  podname=$(oc get pods | grep maintenance | awk '{ print $1 }')
    $  podip=$(oc get pods ${podname} -o json | grep "podIP" | cut -f 4 -d '"')
    $  curl -vvv -H "Host: maintenance.test"  http://${podip}:8080
    $  for routetype in edge reencrypt passthrough; do
         curl -vvv -H "Host: ${routetype}.maintenance.test"  \
	      -k https://${podip}:8443
       done

    $  # Add the different flavor routes.
    $  for f in openshift/*route.json ; do
         oc create -f "$f";
       done

    $  oc get routes

    $  #  Check unsecured route (http only).
    $  curl --resolve maintenance.test:80:127.0.0.1 -vvv  \
            -k http://maintenance.test

    $  #  Check other routes ...
    $  for routetype in edge reencrypt passthrough; do
         curl --resolve "${routetype}.maintenance.test:443:127.0.0.1"  \
	      -vvv -k https://${routetype}.maintenance.test
       done
