# publishGadget.sh {gadgetName} -password {password}

source ./setupEnv.sh

TEMP_ENTITY_FILE=$0___temp-entity.xml

cat > $TEMP_ENTITY_FILE <<EOF
<entity xmlns="">
  <url>$FSCT_FEED_BASE/PrivateGadgetSpec/$1</url>
</entity>
EOF

./insertEntry.sh PrivateGadget $TEMP_ENTITY_FILE $2 $3
rm -f $TEMP_ENTITY_FILE
