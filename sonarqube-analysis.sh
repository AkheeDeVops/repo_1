#!/bin/sh

scannerHome=$1

# Run SonarQube Scanner
${scannerHome}/bin/sonar-scanner \
  -Dsonar.projectKey=${SONARQUBE_PROJECT_KEY} \
  -Dsonar.sources=${SONARQUBE_SOURCES} \
  -Dsonar.host.url=${SONARQUBE_URL} \
  -Dsonar.login=${SONARQUBE_TOKEN}
