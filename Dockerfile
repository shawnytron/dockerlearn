FROM osrf/ros:humble-desktop-full

RUN apt-get update \
&& apt-get install -y nano \ 
&& rm -rf /var/lib/apt/lists/*

COPY config /site_config/

# Create a non-root user
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

#USER ros
#anything instruction in here will be under user

#USER root 
#going back to root: any instrution under here will be under root for example install

#which ever the laster user is set using user instruction is the default user used 
#when container is run 

# Set up sudo
RUN apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && rm -rf /var/lib/apt/lists/*

#program for testing devices 
RUN apt-get update \
&& apt-get install -y \
evtest \
jstest-gtk \
python3-serial \
&& rm -rf /var/lib/apt/lists/*

#add usr inside container to dialout 
RUN usermod -aG dialout ${USERNAME}

COPY entrypoint.sh /entrypoint.sh  
COPY bashrc /home/${USERNAME}/.bashrc

ENTRYPOINT ["/bin/bash", "/entrypoint.sh" ]

CMD ["bash"]