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

## Setup

In order to start this API locally, first configure the
following environment variables:

```
export DB_USERNAME=# Postgresql Databse Username
export DB_PASSWORD=# Postgresql Password
export REDIS_URL=# url to your redis, i.e., redis://localhost:6379/1
export TRIMET_API_KEY=# Can be obtained from Trimet's Website
```

## Starting the API Locally

Once setup is completed, use the foreman start command
to start the server, rails admin, and the scheduled Sidekiq
jobs:
```BASH
foreman start
```
