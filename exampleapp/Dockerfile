# Build stage
FROM golang:1.21 AS build
ENV CGO_ENABLED=0 GOOS=linux 
WORKDIR /wrkspc
COPY main.go .
RUN go build -a -installsuffix cgo -o app main.go

# Final stage
FROM scratch
WORKDIR /
COPY --from=build /wrkspc/app .
EXPOSE 8080
CMD ["./app"]
