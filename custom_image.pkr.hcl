packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = ">= 1.0.0"
    }
  }
}


source "googlecompute" "centos_stream_8" {
  project_id          = "cloudcomputing-415019"
  source_image_family = "centos-stream-8"
  zone                = "us-central1-a"
  ssh_username        = "centos"
  image_name          = "custom-image"
  image_description   = "Custom image based on CentOS Stream 8."
  image_family        = "centos-stream-8"
  network             = "default"
  tags                = ["http-server"]
  credentials         = var.credentials_gcp


build {
  sources = ["source.googlecompute.centos_stream_8"]

  provisioner "file" {
    source      = "webapp.jar"
    destination = "/app/webapp.jar"
  }

  provisioner "file" {
    source      = "config/"
    destination = "/app/config/"
  }

  provisioner "shell" {
    inline = [
      # Create local user csye6225
      "sudo useradd -r -s /usr/sbin/nologin -g csye6225 csye6225",
      # Install application dependencies and set up the application
      "sudo chown -R csye6225:csye6225 /app/",
      # Add systemd service file and configure it
      "sudo cp /app/config/systemd-service-file.service /etc/systemd/system/",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable systemd-service-file.service"
    ]
  }
}


