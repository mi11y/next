# Next - A Transit API for PDX

Next is an API that provides transit related data from the Portland, OR area. Data comes from multiple sources including
free-roaming scooters, free-roaming bikes, the metro area's transit system, and drive times.

## Data Sources

This API obtains it's data from the following sources

<div align="center">
    <a href="https://developer.trimet.org">
        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Trimet_logo.svg/320px-Trimet_logo.svg.png">
    </a>
    <a href="https://developer.trimet.org">
        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/Portland_Streetcar_logo.svg/320px-Portland_Streetcar_logo.svg.png">
    </a>
    <a href="https://mds.bird.co/gbfs/portland/gbfs.json">
        <img src="https://upload.wikimedia.org/wikipedia/en/thumb/e/ec/Bird_%28company%29_logo.svg/296px-Bird_%28company%29_logo.svg.png"
             height="80" width="120" >
    </a>
    <a href="https://www.biketownpdx.com/system-data">
        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Biketown_logo.svg/799px-Biketown_logo.svg.png"
             height="60" width="300">
    </a>
    <a href="https://gbfs.spin.pm/api/gbfs/v1/portland/gbfs.json">
        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/SpinLogomark-Orange.png/320px-SpinLogomark-Orange.png"
             height="73" width="320">
    </a>
    <a href="https://gbfs.spin.pm/api/gbfs/v1/portland/gbfs.json">
        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Lime_Logos-wiki-01.svg/320px-Lime_Logos-wiki-01.svg.png"
             height="80" width="222">
    </a>
    <a href="https://api-lb.micromobility.com/ptl/gbfs/en/free_bike_status.json">
        <img src="https://assets-global.website-files.com/5ea823e1cf6ee17f763dcc39/5ea825e6e815478d9817266a_BOLT-logo-Yellow-Higher%20Res-p-500.png"
             height="80" width="222">
    </a>
    <a href="https://tripcheck.com">
        <img src="https://upload.wikimedia.org/wikipedia/en/thumb/f/fa/Oregon_Department_of_Transportation_%28logo%29.svg/320px-Oregon_Department_of_Transportation_%28logo%29.svg.png"
             >
    </a>
</div>

## Output

At a top level, the returned data from this API is structured like this:
```JSON
{
  "bike_shares": { ... },
  "trimet_stops": { ... },
  "share_stations": { ... },
  "drive_times": [ ... ],
}
```

Setup and Run
---

1. Install Docker and Docker compose. This app lives inside containers now.
2. In order to start this API locally, first configure the following environment variables:
```bash
export $POSTGRES_USER= # Postgresql Databse Username
export $POSTGRES_PASSWORD= # Postgresql Password
export $POSTGRES_DB= # Postgresql Database Name
export $TRIMET_API_KEY= # Can be obtained from Trimet's Website
```
3. To start for development, you can first run `docker-compose -f docker-compose.dev.yml up -d` to start all the
services and the rails app itself. **It may take some time for bundler to install the needed gems!** 

Run a `docker-compose ps` to see them running:
```
NAME                COMMAND                  SERVICE             STATUS              PORTS
next_postgres_1     "docker-entrypoint.s…"   postgres            running             0.0.0.0:5432->5432/tcp, :::5432->5432/tcp
next_redis_1        "docker-entrypoint.s…"   redis               running             0.0.0.0:6379->6379/tcp, :::6379->6379/tcp
next_web_1          "entrypoint.sh bash …"   web                 running             0.0.0.0:3000->3000/tcp, :::3000->3000/tcp
```
4. Bash into the running `next_web_1` container with `./bash_into_next.sh` or by
running `docker exec -it next_web_1 bash`.
5. Once inside the container, `cd /src/` and start the rails app and the sidekiq jobs with `foreman start`.

Thats it! The `src/` director is mounted as a volume inside the container, so you can make edits to the source
and see them affect the API immediately!

Setup and Run Tests
---
Follow steps 1 through 4 from above, and then:
3. Run `rspec` inside the `src/` directory and watch the output!