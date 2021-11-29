FROM centos
RUN mkdir actions-runner && cd actions-runner
RUN yum install jq -y 
ENV RUNNER_ALLOW_RUNASROOT=true
WORKDIR /home/centos/actions-runner
COPY install-latest-runner.sh /home/centos/actions-runner
RUN echo "Downloading latest runner ..."
RUN chmod +x install-latest-runner.sh 
RUN ./install-latest-runner.sh 
RUN ./bin/installdependencies.sh
