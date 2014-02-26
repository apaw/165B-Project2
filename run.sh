#!/bin/bash

echo "Processing XML..."
java -cp saxon9he.jar net.sf.saxon.Query mondial-to-postgres.xq > output
echo "Cleaning Up..."
sed -e 's/<?xml version="1.0" encoding="UTF-8"?>/ /g' < output > output1
sed '1i\BEGIN;' < output1 > output2
sed '$a\COMMIT;' < output2 > outputs.sql
rm -f output output1 output2
echo "Done."
