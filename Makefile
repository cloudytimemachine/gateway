.DEFAULT_GOAL := all

# secrets:
# 	kubectl create secret generic gateway-tls --from-file=config/certs --dry-run -o yaml > deploy/gateway-tls.secret.yml

configmap:
	kubectl create configmap gateway-config --from-file=config/ --dry-run -o yaml > deploy/gateway.configmap.yml
	kubectl create configmap gateway-upstreams --from-file=config/upstreams --dry-run -o yaml > deploy/gateway-upstreams.configmap.yml

clean:
	rm deploy/gateway.configmap.yml deploy/gateway-upstreams.configmap.yml deploy/gateway-tls.secret.yml || true

all: clean  configmap #secrets
