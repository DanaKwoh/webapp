project_id          = "cloudcomputing-415019"
source_image_family = "centos-stream-8"
zone                = "us-central1-a"
ssh_username        = "centos"
image_name          = "custom-image"
image_description   = "Custom image based on CentOS Stream 8."
image_family        = "centos-stream-8"
network             = "default"
tags                = ["http-server"]
credentials_file    = "credentials.json"

source      = "app_artifact.zip"
destination = "/tmp/webapp.zip"