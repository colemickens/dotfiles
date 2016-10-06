k8s_proxy() {
	set -x
	command kubectl proxy --port 9090
}

k8s_proxy_public() {
	set -x
	command kubectl proxy --address=0.0.0.0 --accept-hosts='.+' --port 9090
}

k8s_registry() {
	set -x
	REGISTRY_POD_NAME="$(kubectl get pods --selector=k8s-app=kube-registry --namespace=kube-system --output=jsonpath="{.items[0].metadata.name}")"
	command kubectl port-forward --namespace=kube-system ${REGISTRY_POD_NAME} 5000
}

source <(kubectl completion zsh)

alias k="kubectl"
compdef k=kubectl
