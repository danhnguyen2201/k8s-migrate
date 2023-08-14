#!/bin/sh
clear

nsIgnore1=$(kubectl get namespace --no-headers | cut -d " " -f1)

# check namespace
function getnamespace() {
  if [[ $nsIgnore1 == *"$ns"* ]]; then
    false
  else
    true
  fi
}


function restorenamespace() {
	echo "Starting restore all namespaces..."
		for ns in $(ls -l ./namespaces | cut -d " " -f9); do
			if getnamespace $nsIgnore; then
				echo "tên namespace co trong thu muc: $ns"
				echo "namespace khong ton tai khi getnamespace: $ns"
				kubectl apply -f ./namespaces/$ns/namespace.yaml
				echo "dang restore lai namespace: $ns"
			 fi
		 done
	echo "|--- Finish check namespace!"
}



function restoreConfigmaps() {
  echo "Starting restore all configmaps  ..."
   for ns in $(ls -l ./namespaces | cut -d " " -f9); do
       for ns1 in $(ls ./namespaces/$ns/configmaps/ | cut -d " " -f1); do
			echo " dang trong qua trinh restore"
			kubectl apply -f ./namespaces/$ns/configmaps/$ns1
		done
	done
  echo "|--- Finish configmaps!"
}

function restoreSecret() {
  echo "Starting restore all secrets  ..."
   for ns in $(ls -l ./namespaces | cut -d " " -f9); do
       for ns1 in $(ls ./namespaces/$ns/secrets/ | cut -d " " -f1); do
	      echo " dang trong qua trinh restore"
          kubectl apply -f ./namespaces/$ns/secrets/$ns1
		done
    done
  echo "|--- Finish secrets!"
}


function restoreServices() {
  echo "Starting restore all services  ..."
   for ns in $(ls -l ./namespaces | cut -d " " -f9); do
       for ns1 in $(ls ./namespaces/$ns/services/ | cut -d " " -f1); do
	      echo " dang trong qua trinh restore"
          kubectl apply -f ./namespaces/$ns/services/$ns1
		done
    done
  echo "|--- Finish services!"
}


function restoreDeployments() {
  echo "Starting restore all deployment  ..."
   for ns in $(ls -l ./namespaces | cut -d " " -f9); do
       for ns1 in $(ls ./namespaces/$ns/deployments/ | cut -d " " -f1); do
	      echo " dang trong qua trinh restore"
          kubectl apply -f ./namespaces/$ns/deployments/$ns1
		done
    done
  echo "|--- Finish deployment!"
}

function restoreReplicasets() {
  echo "Starting restore all Replicasets  ..."
   for ns in $(ls -l ./namespaces | cut -d " " -f9); do
       for ns1 in $(ls ./namespaces/$ns/replicasets/ | cut -d " " -f1); do
			echo " dang trong qua trinh restore"
			kubectl apply -f ./namespaces/$ns/replicasets/$ns1
		done
    done
  echo "|--- Finish deployment!"
}


function restoreStatefulSets() {
  echo "Starting restore all statefulSets  ..."
   for ns in $(ls -l ./namespaces | cut -d " " -f9); do
       for ns1 in $(ls ./namespaces/$ns/statefulSets/ | cut -d " " -f1); do
			echo " dang trong qua trinh restore"
			kubectl apply -f ./namespaces/$ns/statefulSets/$ns1
		done
    done
  echo "|--- Finish deployment!"
}

function restoreservice() {
   restorenamespace  $ns
   restoreConfigmaps $ns
   restoreSecret $ns
   restoreServices $ns
   restoreDeployments $ns
   restoreReplicasets $ns
   restoreStatefulSets $ns
}
restoreservice


