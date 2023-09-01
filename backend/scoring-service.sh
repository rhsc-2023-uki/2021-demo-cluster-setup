oc project battleships-scoring 2> /dev/null || oc new-project battleships-scoring

oc new-app quay.io/uksummit2023/2023-scoring-service:latest --name="scoring-service" --as-deployment-config=true --env="QUARKUS_INFINISPAN_CLIENT_SERVER_LIST=datagrid.datagrid.svc.cluster.local:11222" --env="QUARKUS_HTTP_CORS=true"
oc apply -f backend/scoring-route-secure.yaml
