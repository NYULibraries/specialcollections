#!/bin/sh -ex
docker tag specialcollections nyulibraries/specialcollections:${CIRCLE_BRANCH//\//_}
docker tag specialcollections nyulibraries/specialcollections:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
docker tag specialcollections nyulibraries/specialcollections:latest
docker tag specialcollections_test nyulibraries/specialcollections_test:${CIRCLE_BRANCH//\//_}
docker tag specialcollections_test nyulibraries/specialcollections_test:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
docker tag specialcollections_test nyulibraries/specialcollections_test:latest
docker push nyulibraries/specialcollections:${CIRCLE_BRANCH//\//_}
docker push nyulibraries/specialcollections:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
docker push nyulibraries/specialcollections:latest
docker push nyulibraries/specialcollections_test:${CIRCLE_BRANCH//\//_}
docker push nyulibraries/specialcollections_test:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
docker push nyulibraries/specialcollections_test:latest
