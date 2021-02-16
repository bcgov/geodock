# Geoserver needs a bit of time to get ready
sleep 120

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
# environment variables into the json
sed -i s/fake_server/$DB_HOST/ json/create-invasives-store.json 
sed -i s/fake_port/$DB_PORT/ json/create-invasives-store.json 
sed -i s/fake_database/$DB_DATABASE/ json/create-invasives-store.json 
sed -i s/fake_user/$DB_USER/ json/create-invasives-store.json 
sed -i s/fake_password/$DB_PASSWORD/ json/create-invasives-store.json 

# Create Invasives data store
curl -X POST \
  --header 'Content-Type: application/json' \
  -d "@json/create-invasives-store.json" \
  -L "http://admin:$ADMIN_PASS@localhost:8080/geoserver/rest/workspaces/invasives/datastores"

############# BCGW WMS Proxy Layers #############
# Create NRD Layer
curl -X POST \
  --header 'Content-Type: application/json' \
  -d "@json/create-nrd-layer.json" \
  -L "http://admin:$ADMIN_PASS@localhost:8080/geoserver/rest/workspaces/invasives/wmsstores/BCGW/wmslayers/"

# Create Well Layer
curl -X POST \
  --header 'Content-Type: application/json' \
  -d "@json/create-well-layer.json" \
  -L "http://admin:$ADMIN_PASS@localhost:8080/geoserver/rest/workspaces/invasives/wmsstores/BCGW/wmslayers/"

# Create Streams Layer
curl -X POST \
  --header 'Content-Type: application/json' \
  -d "@json/create-fwa-layer.json" \
  -L "http://admin:$ADMIN_PASS@localhost:8080/geoserver/rest/workspaces/invasives/wmsstores/BCGW/wmslayers/"
#################################################

# Create RISO Layer
curl -X POST \
  --header 'Content-Type: application/json' \
  -d "@json/create-riso-layer.json" \
  -L "http://admin:$ADMIN_PASS@localhost:8080/geoserver/rest/workspaces/invasives/datastores/Invasives/featuretypes/"

# Create IPMA Layer
curl -X POST \
  --header 'Content-Type: application/json' \
  -d "@json/create-ipma-layer.json" \
  -L "http://admin:$ADMIN_PASS@localhost:8080/geoserver/rest/workspaces/invasives/datastores/Invasives/featuretypes/"

touch data_dir/www/success
