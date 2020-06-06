#!/bin/bash
IID_FILE=image.iid
TAG=$(date +%Y%m%d%H%M%S)

buildah bud -f Containerfile -t maw-solr --iidfile "${IID_FILE}"
IID=$(cat "${IID_FILE}")
buildah push --creds "${DH_USER}:${DH_PASS}" "${IID}" docker://aerisg222/maw-solr:"${TAG}"
buildah push --creds "${DH_USER}:${DH_PASS}" "${IID}" docker://aerisg222/maw-solr:latest
