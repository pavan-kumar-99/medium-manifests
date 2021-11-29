FROM centos
RUN mkdir actions-runner && cd actions-runner
RUN yum install jq -y 
ENV RUNNER_ALLOW_RUNASROOT=true
WORKDIR /home/centos/actions-runner
RUN echo "Downloading latest runner ..."
RUN latest_version_label=$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.tag_name')
RUN runner_file="actions-runner-${runner_plat}-x64-${latest_version}.tar.gz"
RUN runner_url="https://github.com/actions/runner/releases/download/${latest_version_label}/${runner_file}"
RUN curl -O -L ${runner_url}
RUN tar xzf "./${runner_file}"
RUN ./bin/installdependencies.sh
