ARG BASE_IMAGE=arm64v8/python:3

FROM ${BASE_IMAGE}
ARG BASE_IMAGE

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./app /code/app

ENV PYTHONPATH "${PYTHONPATH}:/code/app"

RUN apt-get update && \
    apt-get install -y \
    iputils-ping && \
    rm -rf /var/lib/apt/lists/*
    
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    openssh-server \
    net-tools \
    gdb \
    rsync \
    git \
    nano \
    && rm -rf /var/lib/apt/lists/*
    
RUN mkdir /var/run/sshd && \
    echo 'root:hetisjeboy' | chpasswd && \
    sed -i 's|#PermitRootLogin prohibit-password|PermitRootLogin yes|' /etc/ssh/sshd_config && \
    sed -i 's|#PasswordAuthentication yes|PasswordAuthentication yes|' /etc/ssh/sshd_config && \
    sed -i 's|#PermitUserEnvironment no|PermitUserEnvironment yes|' /etc/ssh/sshd_config

RUN mkdir -p /code/scripts
COPY scripts/on-start.sh /root/

#ENTRYPOINT ["/root/on-start.sh"]

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
