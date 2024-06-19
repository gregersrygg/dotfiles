FROM zephyrprojectrtos/zephyr-build:v0.26.13

USER root
RUN apt-get update && apt-get install -y ruby

USER user
