#!/bin/bash

echo "Processing XML..."
java -cp saxon9he.jar net.sf.saxon.Query mondial-to-postgres.xq > output
echo "Cleaning Up..."
sed -e 's/<?xml version="1.0" encoding="UTF-8"?>/ /g' < output > output1
sed -e 's/europe/Europe/g' < output1 > output2
sed -e 's/asia/Asia/g' < output2 > output
sed -e 's/africa/Africa/g' < output > output1
sed -e 's/australia/Australia\/Oceania/g' < output1 > output2
sed -e 's/america/America/g' < output2 > output
awk ''!'x[$0]++' output > output1 
sed '1i\BEGIN;' < output1 > output2
sed '$a\COMMIT;' < output2 > outputs.sql
rm -f output output1 output2
echo "Done."
