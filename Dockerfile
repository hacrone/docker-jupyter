FROM jupyter/datascience-notebook

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
    apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales; \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen; \
    locale-gen en_US.UTF-8; \
    pip install yapf jupyternotify tqdm; \
    # Install OpenJDK 11
    curl -LfsSo /tmp/openjdk.tar.gz "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.9%2B11.1/OpenJDK11U-jdk_x64_linux_hotspot_11.0.9_11.tar.gz"; \
    echo "a3c52b73a76bed0f113604165eb4f2020b767e188704d8cc0bfc8bc4eb596712 */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz; \
    # Install IJava
    cd /home/jovyan; \
    curl -L https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip > ijava-kernel.zip; \
    unzip ijava-kernel.zip -d ijava-kernel; \
    cd ijava-kernel; \
    python3 install.py --sys-prefix; \
    pip install jupyter_contrib-nbextensions RISE; \
    jupyter-nbextension install rise --py --system; \
    jupyter-nbextension enable rise --py --system; \
    jupyter contrib nbextension install --system; \
    jupyter nbextension enable hide_input/main; \
    # Install NPM, iJavascript & iTypescript
    apt-get install -y nodejs npm libzmq3-dev; \
    npm install -g tslab js-beautify; \
    tslab install --python=python3; \
    # Install bash kernel and all bash tools for development
    pip install bash_kernel; \
    apt-get install jq; \
    python3 -m bash_kernel.install; \
    # Clean up
    rm -rf /var/lib/apt/lists/*; \
    apt-get clean; \
    rm /home/jovyan/ijava-kernel.zip; \
    rm -rf /home/jovyan/ijava-kernel

ENV JAVA_VERSION=jdk-11.0.9+11 \
    JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"
