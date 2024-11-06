#!/bin/bash

# Activate service account and set the project
gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS" || {
    echo "Failed to activate service account."
    exit 1
}

gcloud config set project "$GCP_PROJECT_ID" || {
    echo "Failed to set GCP project."
    exit 1
}

# Configure Docker to use the gcloud credential helper
gcloud auth configure-docker "${ARTIFACTORY_REGISTRY_URL}" || {
    echo "Failed to configure Docker with gcloud."
    exit 1
}

# Get the image tag from the arguments
IMAGE_TAG="$1"  # This should be 'login:latest'
FULL_IMAGE_NAME="${ARTIFACTORY_REGISTRY_URL}/${GCP_PROJECT_ID}/myartifactory/${IMAGE_TAG}"

# Check if the image exists locally
if [[ "$(docker images -q "${IMAGE_TAG}" 2> /dev/null)" == "" ]]; then
    echo "Image ${IMAGE_TAG} does not exist locally. Aborting."
    exit 1
fi

# Optionally remove the existing image with the same tag
docker rmi "${FULL_IMAGE_NAME}" || {
    echo "No existing image found for ${FULL_IMAGE_NAME}, proceeding with tagging."
}

# Tag the image for pushing
docker tag "${IMAGE_TAG}" "${FULL_IMAGE_NAME}" || {
    echo "Failed to tag image ${IMAGE_TAG} as ${FULL_IMAGE_NAME}."
    exit 1
}

# Push the image
docker push "${FULL_IMAGE_NAME}" || {
    echo "Failed to push image ${FULL_IMAGE_NAME}."
    exit 1
}

echo "Pushed image: ${FULL_IMAGE_NAME}"
