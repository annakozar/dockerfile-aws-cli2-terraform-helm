
FROM amazonlinux:2 as installer
RUN yum update -y
RUN yum install -y unzip tar gzip
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscli-exe-linux-x86_64.zip
RUN unzip awscli-exe-linux-x86_64.zip
RUN ./aws/install --bin-dir /aws-cli-bin/
RUN curl "https://releases.hashicorp.com/terraform/1.6.4/terraform_1.6.4_linux_amd64.zip" -o terraform.zip
RUN unzip terraform.zip
RUN curl https://get.helm.sh/helm-v3.13.2-linux-amd64.tar.gz -o helm.tar.gz
RUN tar -zxvf helm.tar.gz
FROM amazonlinux:2
COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /aws-cli-bin/ /usr/local/bin/
COPY --from=installer terraform /usr/bin/
COPY --from=installer linux-amd64/helm /usr/local/bin/helm
RUN yum update -y
RUN yum install -y less groff jq
RUN yum clean all
COPY .aws/ /root/.aws/
ENTRYPOINT []
