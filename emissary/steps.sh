#!/bin/env bash
source ../demo-magic.sh
k3d cluster delete emissary > /dev/null 2>&1 || true
k3d cluster create emissary -p "8080:80@loadbalancer" -p "8443:443@loadbalancer"  --k3s-server-arg '--no-deploy=traefik' > /dev/null 2>&1

pe "helm repo add datawire https://www.getambassador.io"
wait
clear

pe "kubectl create namespace ambassador && helm install ambassador --namespace ambassador datawire/ambassador --set replicaCount=1 --set service.type=ClusterIP && kubectl -n ambassador wait --for condition=available --timeout=90s deploy -lproduct=aes"
wait
clear

pe "curl -sL https://run.linkerd.io/install | sh"
wait
clear

pe "export PATH=\$PATH:\$HOME/.linkerd2/bin"
clear

pe "linkerd version"
wait
clear

pe "linkerd check --pre"
wait
clear

pe "linkerd install | kubectl apply -f - && linkerd check"
wait
clear

pe "linkerd viz install | kubectl apply -f - && linkerd viz check"
wait
clear

pe "kubectl get deploy -n ambassador ambassador -o yaml | linkerd inject  --skip-inbound-ports \"80,443\" --ingress - | kubectl apply -f -"
wait
clear

pe "bat -l yaml linkerd-module.yaml"
wait
clear

pe "kubectl apply -f linkerd-module.yaml"
wait
clear

pe "curl -sL https://run.linkerd.io/emojivoto.yml | linkerd inject - | kubectl apply -f -"
wait
clear

pe "bat -l yaml emojivote.yaml"
wait
clear

pe "kubectl apply -f emojivote.yaml"
wait
clear

p 'fin'
wait