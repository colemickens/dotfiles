k8s_proxy() {
	set -x
	command kubectl proxy --port 9090
}

kubu() {
	kubectl run -it --image=buildpack-deps:xenial-curl --restart=Never xenial-$RANDOM
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

k8s_dashboard_latest() {
	kubectl --namespace=kube-system set image \
		deployment/kubernetes-dashboard \
		"kubernetes-dashboard=docker.io/kubernetesdashboarddev/kubernetes-dashboard-amd64:head"

	kubectl --namespace=kube-system rollout status \
		deployment/kubernetes-dashboard

	kubectl --namespace=kube-system delete pod kubernetes-dashboard
}

source <(kubectl completion zsh)

alias k="kubectl"
compdef k=kubectl
