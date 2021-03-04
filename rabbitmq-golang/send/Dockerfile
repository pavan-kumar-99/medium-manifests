#Build Container
FROM golang:alpine AS build
ADD . /app
RUN cd /app && go build -o send 


#Deploy Container
FROM alpine 
WORKDIR /send 
COPY --from=build /app /send 
EXPOSE 8080
ENTRYPOINT ./send

