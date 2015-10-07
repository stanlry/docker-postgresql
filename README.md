Docker PostgreSQL Image
====
PostgreSQL image

Build
---
```bash
docker build -t [name]:[tag]
```
Run
---
```bash
docker run --d -p 5432:5432 -v [target volume]:/var/lib/postgresql --name [name] [image name]:[tag]
```

References
---
* [sameersbn/docker-postgresql](https://github.com/sameersbn/docker-postgresql)
* [official postgresql image](https://github.com/docker-library/postgres)