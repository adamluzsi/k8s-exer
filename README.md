
# You can now use the registry like this (example):
# 1. create a new cluster that uses this registry
k3d cluster create --registry-use k3d-oper-registry:7001

# 2. tag an existing local image to be pushed to the registry
docker tag nginx:latest k3d-oper-registry:7001/mynginx:v0.1

# 3. push that image to the registry
docker push k3d-oper-registry:7001/mynginx:v0.1

# 4. run a pod that uses this image
kubectl run mynginx --image k3d-oper-registry:7001/mynginx:v0.1

