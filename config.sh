# Change the admin account password
curl -X PUT \
  --header 'Content-Type: application/json' \
  -d "{\"newPassword\": \"$ADMIN_PASS\"}" \
  -L "http://admin:geoserver@localhost:8080/geoserver/rest/security/self/password"

# Geoserver needs a bit to register the new password
sleep 5

# Create a new workspace called invasives
curl -X POST \
  --header 'Content-Type: application/json' \
  -d "{\"workspace\":{ \"name\":\"invasives\" }}" \
  -L "http://admin:$ADMIN_PASS@localhost:8080/geoserver/rest/workspaces"

# Make invasives the default workspace
curl -X PUT \
  --header 'Content-Type: application/json' \
  -d "{\"workspace\":{ \"name\":\"invasives\" }}" \
  -L "http://admin:$ADMIN_PASS@localhost:8080/geoserver/rest/workspaces/default"

# Create BCGW data store
curl -X POST \
  --header 'Content-Type: application/json' \
  -d "@json/create-bcgw-store.json" \
  -L "http://admin:$ADMIN_PASS@localhost:8080/geoserver/rest/workspaces/invasives/wmsstores"

# To connect to the database we have to load the credentials from 
# envirnment variables into the json


# Create Invasives data store
curl -X POST \
  --header 'Content-Type: application/json' \
  -d "@json/create-invasives-store.json" \
  -L "http://admin:$ADMIN_PASS@localhost:8080/geoserver/rest/workspaces/invasives/datastores"
