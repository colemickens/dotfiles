source <(azure --completion)
source az.completion.sh &>/dev/null

alias az_acsdevtest="az account set --subscription=c1089427-83d3-4286-9f35-5af546a6eb67"
alias az_acstest="az account set --subscription=8ecadfc9-d1a3-4ea4-b844-0d9f87e4d7c8"
alias az_anthonysub="az account set --subscription=b52fce95-de5f-4b37-afca-db203a5d0b6a"
alias az_linuxdevtest="az account set --subscription=27b750cd-ed43-42fd-9044-8d75e124ae55"
alias az_kubetesting="az account set --subscription=6f368760-9ad2-4aef-8ff1-fb038d2e75bf"
alias az_redhat="az account set --subscription=1075fe32-a1d3-4f14-b907-31c0539a91d1"
alias az_corpdev="az account set --subscription=c9802e4f-0860-43a1-b3ed-37d3ae8cdf92"

az_cleanup() {(
	pattern="${1:-"colemick"}"
	list="$(\
		az group list \
			--output tsv \
			--query "[?tags.colemickpermanent != 'true' && contains(name, '${pattern}') && properties.provisioningState != 'Deleting'].name")"

	printf "${list}" | parallel 'printf "Will delete: %s\n" {}'
	printf "Are you sure? [y/N] "
	read -r response
	if [[ "${response:l}" =~ ^(yes|y)$ ]]; then
		printf "${list}" | parallel 'printf "Deleting %s\n" {} && az group delete --no-wait --yes --name {}'
	fi
)}

_dumplocation() {
  location=$1
  az vm list-usage --location=$location \
    | jq -r ".[] | [\"$location\", .name.localizedValue, \" \", .limit, .currentValue] | @tsv"
}

az_dumplocation() {
	if [[ -z "${1}" ]]; then
		az account list-locations --query "[].name" | jq -r '.[]' \
			| while read x; do _dumplocation $x; done
	else
		_dumplocation "${1}"
	fi
}
