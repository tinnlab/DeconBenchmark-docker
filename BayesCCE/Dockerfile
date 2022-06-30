ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

ARG MATLAB_RELEASE=r2020b

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates  \
    libasound2  \
    libatk1.0-0 \
    libc6 \
    libcairo-gobject2 \
    libcairo2 \
    libcrypt1 \
    libcups2 \
    libdbus-1-3 \
    libfontconfig1 \
    libgdk-pixbuf2.0-0 \
    libgstreamer-plugins-base1.0-0 \
    libgstreamer1.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpam0g \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libpangoft2-1.0-0 \
    libpython2.7 \
    libpython3.8 \
    libselinux1 \
    libsm6 \
    libsndfile1 \
    libtcl8.6 \
    libuuid1 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxft2 \
    libxi6 \
    libxinerama1 \
    libxrandr2 \
    libxrender1 \
    libxt6 \
    libxtst6 \
    libxxf86vm1 \
    locales \
    locales-all \
    procps \
    sudo \
    unzip \
    wget \
    xkb-data \
    zlib1g && \
    apt-get clean &&  \
    apt-get -y autoremove

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
    apt-get install --no-install-recommends --yes \
        wget \
        unzip \
        ca-certificates && \
    apt-get clean && apt-get autoremove

# Install mpm dependencies
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
    apt-get install --no-install-recommends --yes \
        wget \
        unzip \
        ca-certificates && \
    apt-get clean && apt-get autoremove

# Run mpm to install MATLAB in the target location and delete the mpm installation afterwards
RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm && \
    chmod +x mpm && \
    ./mpm install \
        --release=${MATLAB_RELEASE} \
        --destination=/opt/matlab \
        --products MATLAB Optimization_Toolbox Global_Optimization_Toolbox Statistics_and_Machine_Learning_Toolbox Parallel_Computing_Toolbox&& \
    rm -f mpm /tmp/mathworks_root.log && \
    ln -s /opt/matlab/bin/matlab /usr/local/bin/matlab

# Add "matlab" user and grant sudo permission.
RUN adduser --shell /bin/bash --disabled-password --gecos "" matlab && \
    echo "matlab ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/matlab && \
    chmod 0440 /etc/sudoers.d/matlab

RUN apt-get install -y --no-install-recommends git && \
    apt-get clean
RUN pip3 install --no-cache-dir git+https://github.com/ericsuh/dirichlet.git

ARG LICENSE_SERVER
ENV MLM_LICENSE_FILE=$LICENSE_SERVER

ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=MATLAB:DOCKERFILE:V1

# Set user and work directory
# USER matlab

COPY BayesCCE /code/source
COPY run.sh /code/

CMD ["/bin/sh", "/code/run.sh"]