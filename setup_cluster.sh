printf "\n\n######## open image registry ########\n"

oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge

HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
podman login -u kubeadmin -p $(oc whoami -t) $HOST
printf "Logged into OCP Registry at $HOST"


printf "\n\n######## tag worker nodes ########\n"
oc label nodes -l node-role.kubernetes.io/worker demo.role=kafka 


printf "\n\n######## Deploy data grid ########\n"
make datagrid
printf "\n\n######## Deploy serverless  ########\n"
make serverless
printf "\n\n######## Deploy backend functions ########\n"
make backend
printf "\n\n######## Deploy ai########\n"
make ai
printf "\n\n######## Deploy kafka forwarder ########\n"
make kafka-forwarder
printf "\n\n######## Deploy frontend ########\n"
make frontend

printf "\n\n######## Deploy frontend ########\n"
make kafka-streams
printf "\n\n######## Deploy dashboard ########\n"
make dashboard 
