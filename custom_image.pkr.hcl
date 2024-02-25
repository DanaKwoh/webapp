packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = ">= 1.0.0"
    }
  }
}

variable "credentials_file_path" {
  type    = string
  default = "credentials.json"  # Set a default value
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
  credentials_file    = var.credentials_file_path
}

build {
  sources = ["source.googlecompute.centos_stream_8"]

  provisioner "file" {
    source      = "webapp.zip"
    destination = "/tmp/webapp.zip"
  }

  # provisioner "file" {
  #   source      = "config/"
  #   destination = "/app/config/"
  # }

  provisioner "shell" {
    inline = [
      # Update and install necessary packages
      "sudo apt-get update",
      "sudo apt-get install -y nodejs npm",

      # Create non-login user and group
      "sudo groupadd -f csye6225",
      "sudo useradd -r -s /usr/sbin/nologin -g csye6225 csye6225",

      # Unzip application artifacts
      "sudo mkdir -p /app",
      "sudo unzip /tmp/webapp.zip -d /app",
      "sudo chown -R csye6225:csye6225 /app",

      # Install application dependencies
      "cd /app && sudo npm install",

      # Copy and configure systemd service
      "sudo cp /app/webapp.service /etc/systemd/system/webapp.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable webapp.service",
      
    ]
  }
}


