# Geoserver Docker Image

## Building 
Run the build
```bash
docker build -t geodock:1.0 ./
```

## Running
Geoserver comes with an *admin* account, password *geoserver*. You can change this automatically by creating a file *.env* and putting in the following:
```bash
ADMIN_PASS=new_password
```
Substituting *new_password* for your new password.

Then run docker like this:
```bash
docker run -d -p 8080:8080 --name geodock --net=host \
  --env-file .env/local.sh geodock:1.0
```
Point your browser to *http://localhost:8080/geoserver/web* and you should see the Geoserver welcome page

## Logging into the container
```bash
docker exec -t -i geodock /bin/bash
```

## Stopping and cleaning up
```bash
docker stop geodock
docker system prune -a
```

## Running in OpenShift
```bash
oc new-app --name=invasivesbci-geoserver-dev \
--env-file=.env/dev.sh https://github.com/popkinj/geodock.git
```

## Cleaning up Openshift
```bash
oc get all --selector app=invasivesbci-geoserver-dev
# If everything found can be deleted
oc delete all --selector app=invasivesbci-geoserver-dev
```
