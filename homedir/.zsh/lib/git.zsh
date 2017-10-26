pullpr() {
    out=$( curl -s https://api.github.com/repos/kubernetes/kubernetes/pulls/$1 )
    owner=$( echo $out | jq -r '.head.repo.owner.login' )
    remote=$( echo $out | jq -r '.head.repo.clone_url' )

    ref=$( echo $out | jq -r '.head.ref' )

    if [ "$( git remote | grep $owner )" == "" ]; then
        git remote add $owner $remote
    fi

    git fetch $owner $ref
    git checkout $owner/$ref
}
