kubectl_proxy() { (set -x; command kubectl proxy --address=0.0.0.0 --accept-hosts='.+' --port 9090) }

kubectl_registry_tunnel() {(
	set -x;
	REGISTRY_POD_NAME="$(kubectl get pods --namespace=kube-system -o json | jq -r '.items | map(select(contains ({"metadata":{"labels":{"k8s-app":"kube-registry"}}}))) | .[0].metadata.name')"
	command kubectl port-forward --namespace=kube-system ${REGISTRY_POD_NAME} 5000
)}

kubens() { command kubectl config set-context "$(kubectl config current-context)" --namespace="$1" }

kctl() { command kubectl "$@" --all-namespaces }
