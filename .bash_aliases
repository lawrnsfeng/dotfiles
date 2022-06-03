virtual() {
  source ~/law-env/"$@"/bin/activate;
}

relic() {
  cd ~/law-personal;
}

secret() {
  cd ~/law-secret;
}

xo() {
  xdg-open "$@";
}

weather()
{
  curl wttr.in
}

warp()
{
    warp-cli register
    warp-cli connect
    curl https://www.cloudflare.com/cdn-cgi/trace/
}

unwarp()
{
    warp-cli disconnect
    warp-cli delete
}

remotesync()
{
    pem_file=$1
    src_path=$2
    dst_path=$3
    username=$4
    hostname=$5
    rsync -avzP -e "ssh -i $pem_file" $username@$hostname:$src_path $dst_path;
}

restart_docker(){
    sudo systemctl stop docker docker.socket docker.service
    sudo rm -rf /var/lib/docker/containers
    sudo systemctl start docker docker.socket docker.service
}

kind_ls_images() {
    docker exec -it kind-control-plane crictl images
}

k_delete_all() {
    kubectl delete "$(kubectl api-resources --namespaced=true --verbs=delete -o name | tr "\n" "," | sed -e 's/,$//')" --all
}

