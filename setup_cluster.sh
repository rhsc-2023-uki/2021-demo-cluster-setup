printf "\n\n######## ai/deploy ########\n"

oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge

HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
podman login -u kubeadmin -p $(oc whoami -t) $HOST
printf "Logged into OCP Registry at $HOST"
