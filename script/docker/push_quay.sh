#!/bin/sh -ex
docker tag specialcollections quay.io/nyulibraries/specialcollections:${CIRCLE_BRANCH//\//_}
docker tag specialcollections quay.io/nyulibraries/specialcollections:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
docker tag specialcollections quay.io/nyulibraries/specialcollections:latest
docker tag specialcollections_test quay.io/nyulibraries/specialcollections_test:${CIRCLE_BRANCH//\//_}
docker tag specialcollections_test quay.io/nyulibraries/specialcollections_test:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
docker tag specialcollections_test quay.io/nyulibraries/specialcollections_test:latest
docker push quay.io/nyulibraries/specialcollections:${CIRCLE_BRANCH//\//_}
docker push quay.io/nyulibraries/specialcollections:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
docker push quay.io/nyulibraries/specialcollections:latest
docker push quay.io/nyulibraries/specialcollections_test:${CIRCLE_BRANCH//\//_}
docker push quay.io/nyulibraries/specialcollections_test:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
docker push quay.io/nyulibraries/specialcollections_test:latest
