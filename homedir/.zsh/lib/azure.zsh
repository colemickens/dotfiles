### some random script
### TODO: move it back here
export PATH=$PATH:$HOME/code/colemickens/azure-toolkit/helpers

azure_env_reset() {
	declare -a azureenvvars
	azureenvvars=($(env | awk -F "=" '{print $1}' | grep "^AZURE_.*"))
	for e in "${azureenvvars[@]}" ; do
		unset "${e}"
	done
}

azure_env_personal() {
	azure_env_reset
	export AZURE_TENANT_ID="13de0a15-b5db-44b9-b682-b4ba82afbd29"
	export AZURE_SUBSCRIPTION_ID="aff271ee-e9be-4441-b9bb-42f5af4cbaeb"
	export AZURE_CLIENT_ID="20f97fda-60b5-4557-9100-947b9db06ec0"
	export AZURE_CLIENT_SECRET="$(cat $HOME/code/colemickens/secrets/azure/azkubeci__client_secret)"
	export AZURE_AUTH_METHOD="client_secret"
	azure account set "${AZURE_SUBSCRIPTION_ID}"
}

azure_env_work_cs() {
	azure_env_reset
	export AZURE_TENANT_ID="72f988bf-86f1-41af-91ab-2d7cd011db47"
	export AZURE_SUBSCRIPTION_ID="27b750cd-ed43-42fd-9044-8d75e124ae55"
	export AZURE_CLIENT_ID="dad4f1ea-8934-4532-a42c-1de2d62d73b2"
	export AZURE_CLIENT_SECRET="$(cat $HOME/code/colemickens/secrets/azure/colemick-azkubeci__client_secret)"
	export AZURE_AUTH_METHOD="client_secret"
	export AZURE_RESOURCE_GROUP="kube-deploy-sandbox"
	azure account set "${AZURE_SUBSCRIPTION_ID}"
}

azure_env_work_nix() {
	azure_env_reset
	export AZURE_TENANT_ID="72f988bf-86f1-41af-91ab-2d7cd011db47"
	export AZURE_SUBSCRIPTION_ID="27b750cd-ed43-42fd-9044-8d75e124ae55"
	export AZURE_CLIENT_ID="d829416c-7142-4de5-a5ad-bae9719f7b7d"
	export AZURE_SERVICE_PRINCIPAL="${AZURE_CLIENT_ID}"
	export AZURE_CLIENT_SECRET="$(cat $HOME/code/colemickens/secrets/azure/colemick-nixops-client__client_secret)"
	export AZURE_PASSWORD="${AZURE_CLIENT_SECRET}"
	export AZURE_AUTHORITY_URL="https://login.microsoftonline.com/${AZURE_TENANT_ID}"
	azure account set "${AZURE_SUBSCRIPTION_ID}"
}

azure_cleanup() {
	$HOME/code/colemickens/azure-helpers/azure_cleanup.sh "$@"
}
