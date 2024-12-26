#!/usr/bin/env sh

curl -sL -H 'Accept: application/vnd.pypi.simple.v1+json' \
  'https://pypi.org/simple/platformio/' \
| jq --raw-output '.versions | .[]' > allversions.txt
