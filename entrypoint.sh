#!/bin/sh

ip=$(grep fly-local-6pn /etc/hosts | cut -f 1)
export RELEASE_DISTRIBUTION=name
export RELEASE_NODE=$FLY_APP_NAME@$ip
export ELIXIR_ERL_OPTIONS="-proto_dist inet6_tcp"
exec $@