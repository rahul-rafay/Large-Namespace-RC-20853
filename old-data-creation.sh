#!/bin/bash
PROJECT_NAME_PREFIX=$1
START=1
END=$2
NS_START=1
NS_PREFIX=$3
GROUP_NAME=$4
NS_END=200
NS_LIST=""
echo "START-------" `date`

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
      echo $NS_NAME
      ./rctl create ns $NS_NAME
      NS_LIST+="$NS_NAME,"
    done
    NS_LIST=${NS_LIST%,}
    #./rctl get ns
    echo "--associateproject" $PROJECT_NAME "--namespaces "  $NS_LIST
    ./rctl create groupassociation $GROUP_NAME --associateproject $PROJECT_NAME --roles NAMESPACE_ADMIN --namespaces $NS_LIST
    NS_LIST=""
    sleep 2
done
echo "END-------" `date`
#Command: ./<file> just-test-project 2 just-test-ns grp-3
