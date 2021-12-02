#!/bin/bash

create_volume() {
    local VOL_NAME=${1}

    local VOL_INSPECTED=$(podman volume inspect "${VOL_NAME}" -f "{{.Name}}" 2> /dev/null)

    # volume inspect will match partial names - here we check that it was not found (first condition) or that the found name does not match (i.e. maw-postgres and maw-postgres-backup)
    # fortunately we do not have a case where there are more than 2 with the same prefix (fingers will remain crossed)
    if [ $? -ne 0 ] | [ "${VOL_INSPECTED}" != "${VOL_NAME}" ]; then
        echo "    - creating volume: ${VOL_NAME}"
        podman volume create "${VOL_NAME}"

        return 0
    fi

    return 1
}

create_volume_solr() {
    local VOL_NAME=${1}

    create_volume ${VOL_NAME}

    if [ $? -eq 1 ]; then
        return
    fi

    echo "    - copying multimedia-categories core config to volume"

    # copy solr config+db from current system to volume, then configure permissions for container
    SOLR_VOL_MOUNT_POINT=$(podman volume inspect "${VOL_NAME}" | python3 -c "import sys, json; print(json.load(sys.stdin)[0]['Mountpoint'])")
    SOLR_VOL_MOUNT_ROOT=$(dirname "${SOLR_VOL_MOUNT_POINT}")

    cp -R ./multimedia-categories "${SOLR_VOL_MOUNT_POINT}"
    chcon -R unconfined_u:object_r:container_file_t:s0 "${SOLR_VOL_MOUNT_POINT}"
    podman unshare chown -R 8983:8983 "${SOLR_VOL_MOUNT_ROOT}"

    echo "    - volume created - please be sure to run the indexer so there are some documents to find"
}

create_volume_solr maw-dev-solr

echo
echo
echo "** you can access Solr at http://localhost:8983 **"
echo
echo

podman run -it --rm -v maw-dev-solr:/var/solr/data:rw,z -p 8983:8983 solr
