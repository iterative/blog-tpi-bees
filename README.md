
# Build & run docker
**Build**
```bash
docker build . -t mkhalusova/bees
```

**Run**
```
docker run \
  --name bees \
  --mount type=bind,source="$(pwd)"/data,target=/app/data \
  mkhalusova/bees
```

Connect to running container
```
docker exec -ti bees /bin/bash
```