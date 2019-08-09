#!/bin/bash

NODE=${1-cluster_node1_1}
docker exec -it ${NODE} bash
