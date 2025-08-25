@Library('jenkins-library@opensource-release-multiarch') _
dockerImagePipeline(
  script: this,
  services: ['wireguard-server.alpine','wireguard-client.alpine'],
  dockerfiles: ['server-wireguard.dockerfile','client-wireguard.dockerfile'],
  buildArgumentsList: [
    [ENV: 'production', PLATFORM: 'linux/arm64,linux/amd64'],
    [ENV: 'production', PLATFORM: 'linux/arm64,linux/amd64']
]
  
)
