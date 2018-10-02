#!/bin/sh -ex

for image_name in findingaids findingaids_staging findingaids_production findingaids_test
do
  docker tag $image_name nyulibraries/$image_name:${CIRCLE_BRANCH//\//_}
  docker tag $image_name nyulibraries/$image_name:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
  docker tag $image_name nyulibraries/$image_name:latest
done

docker login -u "$DOCKER_USERNAME" --password "$DOCKER_PASSWORD"

for image_name in findingaids findingaids_staging findingaids_production findingaids_test
do
  docker push nyulibraries/$image_name:${CIRCLE_BRANCH//\//_}
  docker push nyulibraries/$image_name:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
  docker push nyulibraries/$image_name:latest
done
