FROM deltares/delft3d4:4.03.00
ADD run_docker.sh /data/run_docker.sh
RUN chmod +x /data/run_docker.sh
