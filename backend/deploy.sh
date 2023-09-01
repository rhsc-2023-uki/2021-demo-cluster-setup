#!/usr/bin/env bash

printf "\n\n######## backend/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc project battleships-backend 2> /dev/null || oc new-project battleships-backend

printf "Creating broker..."
oc apply -f $DIR/broker.yaml

printf "Creating triggers..."
oc apply -f $DIR/trigger-attack.yaml
oc apply -f $DIR/trigger-bonus.yaml
oc apply -f $DIR/trigger-match-end.yaml
oc apply -f $DIR/trigger-match-start.yaml

printf "Creating functions"
kn service create attack --image quay.io/uksummit2023/2023-backend-attack:latest --env SCORINGSERVICE=http://scoring-service.battleships-scoring.svc.cluster.local:8080/ --env WATCHMAN=http://watchman.battleships-backend.svc.cluster.local:8080/watch --env CARRIER_SCORE=100 --env DESTROYER_SCORE=250 --env SUBMARINE_SCORE=150 --env BATTLESHIP_SCORE=200 --env HIT_SCORE=5 --env PRODMODE=production --env NAMESPACE=battleships-backend --env BROKER=default
kn service create bonus --image quay.io/uksummit2023/2023-backend-bonus --env SCORINGSERVICE=http://scoring-service.battleships-scoring.svc.cluster.local:8080/ --env WATCHMAN=http://watchman.battleships-backend.svc.cluster.local:8080/watch --env BONUS_SCORE=1 --env PRODMODE=production  --env NAMESPACE=battleships-backend --env BROKER=default
kn service create matchend --image quay.io/uksummit2023/2023-backend-matchend --env SCORINGSERVICE=http://scoring-service.battleships-scoring.svc.cluster.local:8080/ --env WATCHMAN=http://watchman.battleships-backend.svc.cluster.local:8080/watch --env PRODMODE=production --env WIN_SCORE=200
kn service create matchstart --image quay.io/uksummit2023/2023-backend-matchstart  --env SCORINGSERVICE=http://scoring-service.battleships-scoring.svc.cluster.local:8080/ --env WATCHMAN=http://watchman.battleships-backend.svc.cluster.local:8080/watch --env PRODMODE=production
kn service update attack --scale-min=15
kn service update bonus --scale-min=5
kn service update matchend --scale-min=5
kn service update matchstart --scale-min=10



