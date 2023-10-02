#!/usr/bin/env bash

printf "\n\n######## dashboard/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-battleships-dashboard}

oc project ${PROJECT} 2> /dev/null || oc new-project ${PROJECT}

LEADERBOARD_ROUTE=$(oc get route leaderboard -n battleships-leaderboard -o jsonpath='{.spec.host}')
DASHBOARD_SCORING_SERVER=scoring-service.battleships-scoring.svc.cluster.local
REPLAY_SERVER=scoring-service.battleships-scoring.svc.cluster.local

# Apply knative triggers in backend to forward score updates to the game server
oc process -f "${DIR}/template.yml" \
-p LEADERBOARD_SERVER="${LEADERBOARD_ROUTE}" \
-p STATS_SERVER="${LEADERBOARD_ROUTE}" \
-p REPLAY_SERVER="${DASHBOARD_REPLAY_SERVER}" \
-p RANK_SERVER="${DASHBOARD_SCORING_SERVER}" | oc create -n $PROJECT -f -