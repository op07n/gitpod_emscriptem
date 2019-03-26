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



# entrypoint
# # # COPY entrypoint.sh /entrypoint.sh
# # RUN chmod 755 /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]

# default COMMAND
# CMD ["/bin/bash"]


# Setting env
SHELL ["/bin/bash", "-c"]
RUN source /opt/emsdk/emsdk-portable/emsdk_env.sh \ 
  && echo "PATH=$PATH">>~/env.txt \
  && echo "EMSDK=$EMSDK">>~/env.txt \
  && echo "EM_CONFIG=$EM_CONFIG">>~/env.txt \
  && echo "EMSCRIPTEN=$EMSCRIPTEN">>~/env.txt
ENV BASH_ENV ~/env.txt
RUN cat ~/env.txt>>/root/.bashrc

WORKDIR /home/gitpod_emscriptem

COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD /bin/bash

WORKDIR /src
