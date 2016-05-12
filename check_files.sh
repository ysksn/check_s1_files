#!/bin/bash

OUT_FILE=/Users/y-kabuto/Desktop/out
APP_PATH=/Users/y-kabuto/apps/check_s1_files
DIR_PATH=${APP_PATH}/dir
TMP_PATH=${APP_PATH}/tmp
TMP_OLD=${TMP_PATH}/old
TMP_NEW=${TMP_PATH}/new
TMP_TO_SORT=${TMP_PATH}/sort

mv $TMP_NEW $TMP_OLD
: > $TMP_TO_SORT

ls $DIR_PATH |
while read DEPTH
do
  case $DEPTH in
    [0-9]) MAX_DEPTH="$DEPTH" ;;
    *)     MAX_DEPTH='99' ;;
  esac

  for CHECKED_DIR in `cat $DIR_PATH/$DEPTH`
  do
    find $CHECKED_DIR -maxdepth $MAX_DEPTH -type f | xargs ls -l >> $TMP_TO_SORT
  done
done

cat $TMP_TO_SORT | sort | uniq > $TMP_NEW
echo "executed at `date`\n" >> $OUT_FILE
diff -W 1000 -y $TMP_OLD $TMP_NEW | grep "|" | sed -e "s/^.*\s\(.*\)\s\(.*\)\s\(.*\)\s\(.*\)$/\4 updated at \1\/\2 \3/" >> $OUT_FILE
echo "----------------------------------------------------------------------------------------------------------------" >> $OUT_FILE
