# consul-101
Easy start with Consul by Hashicorp

consul agent -server -data-dir=/tmp/consul -node aws -client=0.0.0.0 -bind=0.0.0.0 -datacenter=us-east-1 -bootstrap-expect=1 -ui -config-dir=/tmp/consul
