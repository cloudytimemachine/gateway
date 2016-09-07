# cluster-proxy

This service is used to expose user-facing APIs/websites to the outside world with a TLS-terminating proxy. This public service will be accessible to the internet via a LBaaS (e.g. Elastic Load Balancer).

Under the hood, we're using the vanilla nginx:1.9 Docker image and configuring it using
Kubernetes [ConfigMaps](http://kubernetes.io/docs/user-guide/configmap/) and [Secrets](http://kubernetes.io/docs/user-guide/secrets/).

## Configuration

There are two configmaps and one secret that are generated for use with cluster-proxy.

* cluster-proxy-config.configmap.yml
  * Any file within the top-level `config` directory is inserted (not subdirectories!)
  * This is for modifying the core nginx system

* cluster-proxy-upstreams.configmap.yml
  * Any file within config/upstreams is inserted
  * This is for exposing upstream services (other services in your cluster - e.g. `api` or `website`)
  * If your upstream services need to be secured using TLS, add those credentials to `certs` directory

* cluster-proxy-tls.secret.yml
  * Any file within config/certs is inserted
  * This is for providing the TLS credentials for any upstream services you need to secure
  * Refere

Once those three files have been created in your kubernetes cluster, you can
create the `cluster-proxy.deployment.yml` and `cluster-proxy.svc.yml`


## Helpful Commands

* `make` - Cleans the `deploy` directory, creates all of the necessary kubernetes files and puts them in `deploy`

* `make create` - Generates kubernetes files and then creates them within your current kubectl context using kubectl

* `make apply` - Generates kubernetes files and then updates your current context using `kubectl apply`

* `make remote-clean` - Deletes all cluster-proxy files from your current kubectl context

* `make clean` - Wipes out the `deploy` directory

* `make clean-all` - Deletes all remote cluster-proxy files, then wipes the `deploy` directory

* `make print-service` - Prints the current cluster-proxy HostPort port and minikube ip

* `make minikube` - Switches to the minikube context, flushes cluster-proxy from it, builds, and deploys

## Quick start

Start minikube

```
minikube start
```

Get the IP of your minikube instance

```
minikube ip
```

Edit /etc/hosts to point `cluster-proxy.reactiveops.com` to your the minikube ip

Launch cluster proxy

```
make minikube
```

Open your browser to the cluster-proxy nodePort service
```
open https://cluster-proxy.reactiveops.com:$(kubectl get svc cluster-proxy -o json | jq .spec.ports[1].nodePort)
```
