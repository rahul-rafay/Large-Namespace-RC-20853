#!/bin/bash
PROJECT_NAME_PREFIX=$1
START=1
END=$2
NS_START=1
NS_PREFIX=$3
GROUP_NAME=$4
NS_END=100
NS_LIST1=""
NS_LIST2=""
echo "START-------" `date`

echo "creating group with name" $GROUP_NAME
./rctl create group $GROUP_NAME
for i in $(eval echo "{$START..$END}")
do
   PROJECT_NAME="$PROJECT_NAME_PREFIX""-"$i
   ./rctl create project $PROJECT_NAME
   ./rctl config set project $PROJECT_NAME
   ./rctl config show
   if [ "$i" -ge 11 ]; then
    NS_END=50
   fi
   for z in $(eval echo "{$NS_START..$NS_END}")
    do
      NS_NAME="$PROJECT_NAME_PREFIX""-"$i"-""$NS_PREFIX""-"$z
      # rctl already print the ns name echo $NS_NAME
      ./rctl create ns $NS_NAME
      sleep 1
      if [ "$z" -le $((NS_END/2)) ]; then
       NS_LIST1+="$NS_NAME,"
      else
       NS_LIST2+="$NS_NAME,"
      fi
    done
    NS_LIST1=${NS_LIST1%,}
    NS_LIST2=${NS_LIST2%,}
    #./rctl get ns
    echo "--group" $GROUP_NAME "--associateproject" $PROJECT_NAME "--roles NAMESPACE_ADMIN --namespaces "  $NS_LIST1
    echo "--group" $GROUP_NAME "--associateproject" $PROJECT_NAME "--roles NAMESPACE_READ_ONLY --namespaces "  $NS_LIST2
    ./rctl create groupassociation $GROUP_NAME --associateproject $PROJECT_NAME --roles NAMESPACE_ADMIN --namespaces $NS_LIST1
    ./rctl create groupassociation $GROUP_NAME --associateproject $PROJECT_NAME --roles NAMESPACE_READ_ONLY --namespaces $NS_LIST2
    NS_LIST1=""
    NS_LIST2=""
    sleep 2
done
echo "END-------" `date`
#Command: ./<file> just-test-project 2 just-test-ns grp-3
