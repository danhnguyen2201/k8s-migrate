#!/bin/sh
clear
# read file .kubeigrone
nsIgnore=$(cat .kubeignore | grep ns:)
cfmIgnore==$(cat .kubeignore | grep cfm:)
crdIgnore==$(cat .kubeignore | grep crd:)
backupFolder="namespaces"
function checkIgnoreNamespace() {
  if [[ $nsIgnore == *"ns:$ns"* ]]; then
    false
  else
    true
  fi
}
function checkIgnoreConfigMap() {
  if [[ $cfmIgnore == *"cfm:$configmap"* ]]; then
    false
  else
    true
  fi
}
function checkIgnoreCrd() {
  if [[ $crdIgnore =~ *"crd:$crd"* ]]; then
    false
  else
    true
  fi
}

function backupDeployments() {
  echo "|--- Starting backup deployments"
  rm -rf ./$backupFolder/$ns/deployments && mkdir -p ./$backupFolder/$ns/deployments
   for deployment in $(kubectl get deployments -n $ns --no-headers | cut -d " " -f1); do
       kubectl get deployments $deployment -n $ns -o yaml > ./$backupFolder/$ns/deployments/$deployment.yaml
       echo "|------ Save ./$backupFolder/$ns/deployments/$deployment.yaml"
    done
  echo "|--- Finish backup deployments!"
}

function backupCrds() {
  echo "|--- Starting backup crds"
  rm -rf ./$backupFolder/$ns/crds && mkdir -p ./$backupFolder/$ns/crds
   for crd in $(kubectl get crds -n $ns --no-headers | cut -d " " -f1); do
     if checkIgnoreCrd $crd; then
       kubectl get crds $crd -n $ns -o yaml > ./$backupFolder/$ns/crds/$crd.yaml
       echo "|------ Save ./$backupFolder/$ns/crds/$crd.yaml"
      fi
    done
  echo "|--- Finish backup crds!"
}

function backupServices() {
  echo "|--- Starting backup services"
  rm -rf ./$backupFolder/$ns/services && mkdir -p ./$backupFolder/$ns/services
   for service in $(kubectl get services -n $ns --no-headers | cut -d " " -f1); do
       kubectl get services $service -n $ns -o yaml > ./$backupFolder/$ns/services/$service.yaml
       echo "|------ Save ./$backupFolder/$ns/services/$service.yaml"
    done
  echo "|--- Finish backup services!"
}

function backupSecrets() {
  echo "|--- Starting backup secrets"
  rm -rf ./$backupFolder/$ns/secrets && mkdir -p ./$backupFolder/$ns/secrets
  for secret in $(kubectl get secrets -n $ns --no-headers | cut -d " " -f1); do
       kubectl get secrets $secret -n $ns -o yaml > ./$backupFolder/$ns/secrets/$secret.yaml
       echo "|------ Save ./$backupFolder/$ns/secrets/$secret.yaml"
  done
  echo "|--- Finish backup secrets!"
}

function backupReplicaSets() {
  echo "|--- Starting backup replicasets"
  rm -rf ./$backupFolder/$ns/replicasets && mkdir -p ./$backupFolder/$ns/replicasets
  for replicaset in $(kubectl get replicasets -n $ns --no-headers | cut -d " " -f1); do
       kubectl get replicasets $replicaset -n $ns -o yaml > ./$backupFolder/$ns/replicasets/$replicaset.yaml
       echo "|------ Save ./$backupFolder/$ns/replicasets/$replicaset.yaml"
  done
  echo "|--- Finish backup replicasets!"
}

function backupStatefulSets() {
  echo "|--- Starting backup statefulSets"
  rm -rf ./$backupFolder/$ns/statefulSets && mkdir -p ./$backupFolder/$ns/statefulSets
  for statefulset in $(kubectl get statefulsets -n $ns --no-headers | cut -d " " -f1); do
       kubectl get statefulsets $statefulset -n $ns -o yaml > ./$backupFolder/$ns/statefulSets/$statefulset.yaml
       echo "|------ Save ./$backupFolder/$ns/statefulSets/$statefulset.yaml"
  done
  echo "|--- Finish backup statefulSets!"
}

function backupConfigmaps() {
  echo "|--- Starting backup configmaps"
  rm -rf ./$backupFolder/$ns/configmaps && mkdir -p ./$backupFolder/$ns/configmaps
  for configmap in $(kubectl get configmaps -n $ns --no-headers | cut -d " " -f1); do
    if checkIgnoreConfigMap $configmap; then
      kubectl get configmaps $configmap -n $ns -o yaml > ./$backupFolder/$ns/configmaps/$configmap.yaml
      echo "|------ Save ./$backupFolder/$ns/configmaps/$configmap.yaml"
    fi
  done
  echo "|--- Finish backup configmaps!"
}

function backupCronjobs() {
  echo "|--- Starting backup cronjob"
  rm -rf ./$backupFolder/$ns/cronjobs && mkdir -p ./$backupFolder/$ns/cronjobs
  for cronjob in $(kubectl get cronjobs -n $ns --no-headers | cut -d " " -f1); do
      kubectl get cronjobs $cronjob -n $ns -o yaml > ./$backupFolder/$ns/cronjobs/$cronjob.yaml
      echo "|------ Save ./$backupFolder/$ns/cronjobs/$cronjob.yaml"
  done
  echo "|--- Finish backup cronjobs!"
}

function backupNamespace() {
    echo "Starting backup namespace:[$ns] parts... "
    rm -rf $backupFolder/$ns && mkdir -p $backupFolder/$ns
    kubectl get ns $ns -o yaml > $backupFolder/$ns/namespace.yaml
#    backupCrds $ns
#    backupDeployments $ns
#    backupServices $ns
#    backupConfigmaps $ns
#    backupSecrets $ns
#    backupReplicaSets $ns
#    backupStatefulSets $ns
    backupCronjobs $ns
    echo "Finish backup namespace:[$ns]!"
}

function running() {
    echo "Starting backup all namespaces..."
    mkdir $backupFolder
    for ns in $(kubectl get ns --no-headers | cut -d " " -f1); do
      if checkIgnoreNamespace $ns; then
       backupNamespace $ns
      fi
    done
}

echo "recreate backup folder: ./$backupFolder"
rm -rf $backupFolder
running
