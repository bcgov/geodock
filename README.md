# Geoserver Docker Image

## Building 
Run the build
```bash
docker build -t geodock:1.0 ./
```

## Running
Geoserver comes with an *admin* account, password *geoserver*. You can change this automatically by creating a file *.env/local.sh* and putting in the following:
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
--env-file=.env/dev.sh https://github.com/bcgov/geodock.git
oc expose svc/invasivesbci-geoserver-dev
```

## Cleaning up Openshift
```bash
oc get all --selector app=invasivesbci-geoserver-dev
# If everything found can be deleted
oc delete all --selector app=invasivesbci-geoserver-dev
```

## Configuring
The general workflow is as follows:
- Use the Geoserver GUI to configure and add services. 
- Use the API to extract the JSON representation of the configuration. 
- Save this JSON in the _/JSON_ directory
- Add a command within the config script that sends this JSON to the API on POD initiation

### Example Configuration Workflow
Request to harvest the JSON for a Layer:
```bash
curl \
  --header 'Content-Type: application/json' \
  -L "http://admin:$ADMIN_PASS@localhost:8080/geoserver/rest/workspaces/invasives/datastores/Invasives/featuretypes/aggregate_tenures.json"
```

Save the output in _json/create-aggregate-layer.json_ then use the following command, or put it in the _config.sh_ file as follows:
```bash
curl -X POST \
  --header 'Content-Type: application/json' \
  -d "@json/create-aggregate-layer.json" \
  -L "http://admin:$ADMIN_PASS@localhost:8080/geoserver/rest/workspaces/invasives/datastores/Invasives/featuretypes/"
```
