FROM ghcr.io/bhnoc/python3:latest
RUN dnf -y update && \
        dnf -y install findutils

RUN dnf install curl gcc openssl-devel bzip2-devel libffi-devel zlib-devel wget make passwd -y 

RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/Denver /etc/localtime

RUN dnf install -y dnf-utils
RUN dnf install -y cronie && crond -V
RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
RUN dnf -y install vault
RUN dnf -y install vault
RUN dnf -y install curl

#Vault Setup
RUN usermod -u 1000 vault
RUN groupmod -g 1001 vault
RUN dnf reinstall vault -y
RUN mkdir -p /opt/vault/data
RUN mkdir /etc/vault
RUN touch /etc/vault/config.hcl
RUN chown -R vault:vault /opt/vault
RUN echo "export PATH=$PATH:/opt/vault/bin" >> ~/.bashrc
RUN echo "export VAULT_ADDR=https://vault.bhnoc.org:8200" >> ~/.bashrc
RUN echo "export VAULT_SKIP_VERIFY=false"
RUN mkdir -p /home/vault
RUN chown -R vault:vault /home/vault
RUN chown -R vault:vault /opt/env/
COPY build/start-up.sh /home/vault/start-up.sh
RUN chown vault:vault /home/vault/start-up.sh
RUN chmod +x /home/vault/start-up.sh
COPY . /opt/env/live/.
RUN source /opt/env/live/bin/activate && pip install -r /opt/env/live/app/requirements.txt
USER vault:vault
RUN echo "export VAULT_ADDR=https://vault.bhnoc.org:8200" >> /home/vault/.bashrc
RUN echo "export PATH=$PATH:/opt/vault/bin" >> /home/vault/.bashrc
CMD ["/home/vault/start-up.sh"]
