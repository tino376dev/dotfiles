# vscode server
export def main [] {print "run a vscode server on localhost"}

# serve vscode mounting some default dirs
export def serve [
    --image: string@code-server-image-list = "localhost/code-server-nushell:latest-bookworm" # container image to run
    --network: string@podman-network-list = "podman" # nework bridge
    --port: int = 8080 # host port
    --expose = false # expose using ngrok
] {
    let host_work = $in
    let host_code_config = $env.XDG_DATA_HOME | path join "vscode"
    let host_code_server_config = $env.XDG_DATA_HOME | path join "vscode-server"
    let host_nu_config = $env.XDG_CONFIG_HOME | path join "nushell"
    let host_secrets = $env.HOME | path join ".secrets"
    let host_ssh = $env.HOME | path join ".ssh"
    let client_work = "/root/work"
    let client_code_config = "/root/.vscode-insiders"
    let client_code_server_config = "/root/.vscode-server-insiders"
    let client_nu_config = "/root/.config/nushell"
    let client_secrets = "/root/.secrets"
    let client_ssh = "/root/.ssh"
    podman stop $"vscode-server-($port)" --ignore
    podman run -it --rm --name $"vscode-server-($port)" --network $network -v $"($host_work):($client_work):z" -v $"($host_code_config):($client_code_config):z" -v $"($host_code_server_config):($client_code_server_config):z" -v $"($host_nu_config):($client_nu_config):z" -v $"($host_secrets):($client_secrets):z" -v $"($host_ssh):($client_ssh):z" -p $"($port):8080" $image
     # serve using ngrok
    if $expose {
        podman stop vscode-server-ngrok --ignore
        podman run --rm -it --name vscode-server-ngrok --env-file ~/.secrets/ngrok.txt ngrok/ngrok:latest http --url=informally-sunny-sunbird.ngrok-free.app --oauth google --oauth-allow-email=forest.reider@gmail.com host.containers.internal:8080
    }
}

def code-server-image-list [] {
    podman image list --filter reference=code-server* | from ssv | insert image {|it| $"($it.REPOSITORY):($it.TAG)"} | get image | sort
}

def podman-network-list [] {["podman", "host"]}
