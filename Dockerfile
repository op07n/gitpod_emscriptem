FROM gitpod/workspace-full-vnc

#  https://github.com/TechStark/emscripten-docker/blob/develop/Dockerfile
#  https://github.com/rnixik/emsdk-docker/blob/master/Dockerfile

# environment variable
ENV EMSDK_NAME sdk-1.37.35-64bit

# update the repository sources list
RUN apt-get update

# download emsdk
RUN cd /tmp \
    && curl -Ok https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz \
    && tar zxf emsdk-portable.tar.gz \
    && rm emsdk-portable.tar.gz \
    && mv emsdk-portable /emsdk

# update emsdk
RUN cd /emsdk \
    && ./emsdk update \
    && ./emsdk install ${EMSDK_NAME} \
    && ./emsdk activate ${EMSDK_NAME}

# clean packages
RUN apt-get clean\
    && apt-get autoclean\
    && apt-get autoremove\
    && rm -rf /var/lib/apt/lists/*

# Alternative approach to change $PATH
ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/emsdk/emscripten/incoming"

WORKDIR /home/gitpod_emscriptem

# entrypoint
# # # COPY entrypoint.sh /entrypoint.sh
# # RUN chmod 755 /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]

# default COMMAND
# CMD ["/bin/bash"]
