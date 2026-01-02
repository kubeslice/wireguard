@Library('ml-library@enterprise-ml-release-ut') _
dockerImagePipeline(
  script: this,
  services: ['wireguard-server.alpine','wireguard-client.alpine'],
  dockerfiles: ['server-wireguard.dockerfile','client-wireguard.dockerfile'],
  buildArgumentsList: [
    [ENV: 'production', PLATFORM: 'linux/arm64,linux/amd64'],
    [ENV: 'production', PLATFORM: 'linux/arm64,linux/amd64']
]
  
)
