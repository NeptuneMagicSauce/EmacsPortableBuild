cd "$(dirname $0)"
docker buildx build --output type=local,dest=output .
