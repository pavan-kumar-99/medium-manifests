#Build Container
FROM golang:alpine AS build
ADD . /app
RUN cd /app && go build -o receive 


#Deploy Container
FROM alpine 
WORKDIR /receive 
COPY --from=build /app /receive 
ENTRYPOINT ./receive

