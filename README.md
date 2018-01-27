# ODK2-Sync-Endpoint-OpenLMIS-Scripts

 - consul - scripts to register Sync Endpoint to OpenLMIS
 - sync-endpoint - copy of [sync-endpoint-default-setup](https://github.com/opendatakit/sync-endpoint-default-setup) modified to work better with OpenLMIS

## Prerequisites

 - Same as [sync-endpoint-default-setup](https://github.com/opendatakit/sync-endpoint-default-setup)

## Usage

**note:** This document assumes that your OpenLMIS services are managed by [Docker Compose scripts provided by OpenLMIS](https://github.com/OpenLMIS/openlmis-ref-distro).

1. Create a Docker network for Sync Endpoint and OpenLMIS
    1. `docker network create --driver overlay --attachable sync-endpoint-openlmis-network`
2. Modify OpenLMIS's `docker-compose.yml`
    1. Update the `networks` section to include the network created above
    ```YAML
    networks:
      sync-endpoint:
        external:
          name: sync-endpoint-openlmis-network
    ```
    2. Update the `nginx` service to join the new network
    ```YAML
    nginx:
      networks:
        - default
        - sync-endpoint
    ```
3. Launch OpenLMIS services as usual
4. Launch Sync Endpoint (and all supporting services)
    1. Configure them as usual (refer to [sync-endpoint-default-setup](https://github.com/opendatakit/sync-endpoint-default-setup) for detail)
    2. In the directory `sync-endpoint` execute `docker stack deploy -c docker-compose.yml sync-openlmis`  
    **note:** The provided `docker-compose.yml` is the same as the standard configuration provided by [sync-endpoint-default-setup](https://github.com/opendatakit/sync-endpoint-default-setup) but without the `web-ui` and `nginx` components. 
5. Verify that both OpenLMIS and Sync Endpoint are available
6. Register Sync Endpoint to OpenLMIS
    1. Find OpenLMIS's Consul client address and port
    2. Build the registration image `docker build --pull -t odk/openlmis-consul-reg consul`
    3. 
    ```sh
    docker run \
        -e CONSUL_HOST=<ip address> \
        -e CONSUL_PORT=<port> \
        -e SERVICE_NAME=sync \
        --network sync-endpoint-openlmis-network \
        odk/openlmis-consul-reg
    ```
7. Now Sync Endpoint should be available under `/odktables` at the same address as your OpenLMIS server 
