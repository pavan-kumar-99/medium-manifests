FROM centos
RUN mkdir actions-runner && cd actions-runner
RUN yum install jq -y 
ENV RUNNER_ALLOW_RUNASROOT=true
WORKDIR /home/centos/actions-runner
RUN curl -o actions-runner-linux-x64-2.284.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.284.0/actions-runner-linux-x64-2.284.0.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.284.0.tar.gz
RUN ./bin/installdependencies.sh
