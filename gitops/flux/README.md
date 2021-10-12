# gitops/flux

This directory of the repo has files for deploying flux, flagger, ambassador,
and linkerd to a local k3d cluster.

## Other providers

* Civo
  * you can use this command to start a cluster on civo: `civo k8s create 
   flux-gitops --size g3.k3s.small --nodes 3 --version 1.21.2+k3s1 
   --remove-applications=Traefik`