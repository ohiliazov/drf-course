FROM ubuntu:latest
LABEL authors="oleksandr.hiliazov"

ENTRYPOINT ["top", "-b"]
