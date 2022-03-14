#!/bin/bash

# Run a container open5gs-dbctl client to insert user in core Database

docker run -ti --rm --net open5gs-and-srslte_default openverso/open5gs-dbctl:0.9.1 open5gs-dbctl --db_uri=mongodb://mongo/open5gs add 901700000000001 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA

