FROM centos
RUN mkdir actions-runner && cd actions-runner
RUN yum install jq -y 
ENV RUNNER_ALLOW_RUNASROOT=true
WORKDIR /home/centos/actions-runner
RUN echo "Downloading latest runner ..."
RUN export latest_version_label=$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.tag_name') && latest_version=$(echo ${latest_version_label:1}) && export runner_file="actions-runner-${runner_plat}-x64-${latest_version}.tar.gz" && export runner_url="https://github.com/actions/runner/releases/download/${latest_version_label}/${runner_file}" && curl -O -L ${runner_url} && tar xzf "./${runner_file}"
RUN ./bin/installdependencies.sh
