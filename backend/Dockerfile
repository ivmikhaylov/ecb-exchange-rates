FROM golang:1.18.0-alpine3.15 AS build

RUN mkdir /src
WORKDIR /src

COPY . .
RUN go build -o server .

FROM alpine:3.15

COPY --from=build /src/server /server
CMD ["/server"]
