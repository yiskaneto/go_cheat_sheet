# syntax=docker/dockerfile:1

###########################
## STAGE 1
###########################

# golang:1.20.3-alpine (Apr 4, 2023 at 12:57 pm)
FROM golang:1.22.4-alpine AS build
ARG USERNAME=apprunner

RUN adduser \
--disabled-password \
--gecos "" \
--home "/home/${USERNAME}" \
--shell "/sbin/nologin" \
${USERNAME}

WORKDIR /src
ADD src/ /src
RUN chown -R ${USERNAME}:${USERNAME} /src
USER ${USERNAME}

# download Go modules, dependencies and compile
RUN go mod tidy && go mod verify && CGO_ENABLED=0 GOOS=linux go build -o go-db-writter
RUN ls -laht

###########################
## STAGE 2
###########################

# For full static static apps use scratch, this will reduce the attack surface.
# FROM scratch
FROM golang:1.21.8-alpine3.19 AS final
## For more dinaymic app use the latest version of alpine, remember to update to apply any available patches.
# FROM alpine@sha256:b6ca290b6b4cdcca5b3db3ffa338ee0285c11744b4a6abaa9627746ee3291d8d
# RUN apk update --no-cache && apk upgrade --no-cache

WORKDIR /app

COPY --from=build /src/go-db-writter /app/go-db-writter

COPY --from=build /src/views/index.html /app/views/index.html

COPY --from=build /etc/passwd /etc/passwd

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

USER apprunner

EXPOSE 8081

ENTRYPOINT ["./go-db-writter"]

# Trigger action
