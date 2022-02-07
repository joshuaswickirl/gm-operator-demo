Grey Matter Demo
================

Fibonacci with Grey Matter on k3d.

```sh
export GREYMATTER_REGISTRY_USERNAME=''
export GREYMATTER_REGISTRY_PASSWORD=''

bash setup.sh $GREYMATTER_REGISTRY_USERNAME $GREYMATTER_REGISTRY_PASSWORD

curl http://localhost:10808/services/fibonacci-deployment/
> Alive
curl http://localhost:10808/services/fibonacci-deployment/fibonacci/3
> 2
```
