source <(azure --completion)
source az.completion.sh &>/dev/null

az_anthony () { az account set --subscription=$(az account list --all --query "[?contains(name, 'Anthony')] | [0].id" --output tsv); az account show; }
az_acsdev () { az account set --subscription=$(az account list --all --query "[?contains(name, 'Container Service - Development')] | [0].id" --output tsv); az account show; }
az_acstest () { az account set --subscription=$(az account list --all --query "[?contains(name, 'Container Service - Test')] | [0].id" --output tsv); az account show; } 

az_cleanup () {(
	pattern="${1:-"colemick"}"
	list="$(\
		az group list \
			--output tsv \
			--query "[?tags.colemickpermanent != 'true' && contains(name, '${pattern}') && properties.provisioningState != 'Deleting'].name")"

	if which parallel; then
		printf "${list}" | parallel 'printf "Will delete: %s\n" {}'
	else
		echo "Will delete ${list}"
	fi
	printf "Are you sure? [y/N] "
	read -r response
	if [[ "${response:l}" =~ ^(yes|y)$ ]]; then
		if which parallel ; then
			printf "${list}" | parallel 'printf "Deleting %s\n" {} && az group delete --no-wait --yes --name {}'
		else
			echo "${list}"| while IFS= read -r line ; do az group delete --no-wait --yes --name "${line}"; done
		fi
	fi
)}

_dumplocation () {
  location=$1
  az vm list-usage --location=$location \
    | jq -r ".[] | [\"$location\", .name.localizedValue, \" \", .limit, .currentValue] | @tsv"
}

az_dumplocation () {
	if [[ -z "${1}" ]]; then
		az account list-locations --query "[].name" | jq -r '.[]' \
			| while read x; do _dumplocation $x; done
	else
		_dumplocation "${1}"
	fi
}
