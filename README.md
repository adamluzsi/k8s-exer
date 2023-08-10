# K8S Exercise

## Setup

### Make sure you have the k3d image repository in your host file:

> /etc/hosts

```text
127.0.0.1    k3d-img-registry.localhost
```

### Source the environment file

```sh
. .envrc
```

Alternatively, you can use `direnv` to do that for you.

```sh
direnv allow
```

### run the provision script 

```sh
provision up
```

### Push the example app to your local k3s cluster

```sh
./exampleapp/release.sh
```

## etc



kubectl run mynginx --image k3d-oper-registry:7001/mynginx:v0.1
