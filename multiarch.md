https://github.com/docker/buildx#building-multi-platform-images

docker run --privileged --rm tonistiigi/binfmt --install all
docker buildx create --use
docker buildx install
