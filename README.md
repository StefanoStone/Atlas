# Atlas
A Python bridge (IPC - stream sockets) for Pharo, allowing Pharo to use Python libraries , mix with Python code and vice versa

## How to use

This fork of Atlas executes the socket server in a docker container when the image starts. As this will be running in a container, a socket between the host and the container is created. This allows the host to communicate with the container via the socket.

For Linux/MacOS users the socket is created and mounted directly to the host using `volumes: - /var/run/docker.sock:/var/run/docker.sock` in the docker-compose.yaml. 
      
For Windows users, the default way to mount the socket only works if you're using WSL2-based Docker (Windows Subsystem for Linux). Otherwise, it won’t work because Windows doesn’t have a native `/var/run/docker.sock` like Linux/macOS.

### Alternative for Windows (Non-WSL2) - Not tested
If you need to communicate with Docker from inside a container on Windows, you can use the TCP socket instead:

1. Enable Docker Engine API on TCP (Windows Host)

    - Open Docker Desktop settings.
    - Go to Settings > General.
    - Enable "Expose daemon on tcp://localhost:4000 without TLS".

2. Use the TCP Socket Instead of /var/run/docker.sock
    - Instead of mounting /var/run/docker.sock, you can connect using tcp://host.docker.internal:4000 in your container.

This will require you to also edit the source code of the Atlas library to use the TCP socket instead of the Unix socket.