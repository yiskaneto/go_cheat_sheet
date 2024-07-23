# APP_NAME

Repository description

## Docker build

```bash
docker build -t CHANGE_ME:CHANGE_ME -f Dockerfile.multistage .
```

## Run Application

```bash
docker run --rm --read-only -p 8081:8081 CHANGE_ME:CHANGE_ME
```

## Local Development

1. Setup Postgres:
    `make`

1. To make hot reloads while developing we'll need a Go package called Air:

   ```bash
   cd src/ ; go get github.com/air-verse/air
   ```

1. Start the proggram by running:

   ```bash
   cd src/
   Load the required environment variables here
   go get github.com/air-verse/air ; go run github.com/air-verse/air
   ```
