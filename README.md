# MultiStage DockerBuild

Multistage builds feature in Dockerfiles enables you to create smaller container images with better caching and a smaller security footprint. With multi-stage builds, you use multiple FROM statements in your Dockerfile. Each FROM instruction can use a different base, and each of them begins a new stage of the build. You can selectively copy artifacts from one stage to another, leaving behind everything you don't want in the final image.

<img width="1789" alt="image" src="https://user-images.githubusercontent.com/34813177/192954635-c66faf37-1c63-4a24-88ba-befc84788f3a.png">


Full Article Published
https://pavan1999-kumar.medium.com/how-i-reduced-the-size-of-my-docker-image-by-95-520a05439300
