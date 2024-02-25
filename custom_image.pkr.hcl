packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = ">= 1.0.0"
    }
  }
}

variable "project_id" {
  type        = string
  description = "The GCP project ID."
}
variable "source_image_family" {
  type        = string
  description = "The source image family for the GCP instance."
}
variable "zone" {
  type        = string
  description = "The GCP zone where the instance will be created."
}
variable "ssh_username" {
  type        = string
  description = "Username for SSH access."
}
variable "image_name" {
  type        = string
  description = "The name of the output custom image."
}
variable "image_description" {
  type        = string
  description = "Description for the custom image."
}
variable "image_family" {
  type        = string
  description = "The family of the custom image."
}
variable "network" {
  type        = string
  description = "The network where the GCP instance will be connected."
}
variable "tags" {
  type        = list(string)
  description = "A list of tags to apply to the instance."
}
variable "credentials_file" {
  type        = string
  description = "Path to the GCP credentials file."
}
variable "source" {
  type        = string
  description = "Source file or directory for file provisioner."
}
variable "destination" {
  type        = string
  description = "Destination path for file provisioner."
}




source "googlecompute" "centos_stream_8" {
  project_id          = var.project_id
  source_image_family = var.source_image_family
  zone                = var.zone
  ssh_username        = var.ssh_username
  image_name          = var.image_name
  image_description   = var.image_description
  image_family        = var.image_family
  network             = var.network
  tags                = var.tags
  credentials_file    = var.credentials_file
}


build {
  sources = ["source.googlecompute.centos_stream_8"]
  
  # Provisioner to delete the existing image if it exists
  provisioner "shell" {
    inline = [
      "if gcloud compute images describe ${var.image_name} --project ${var.project_id} &> /dev/null; then",
      "  echo 'Image exists, deleting...'",
      "  gcloud compute images delete ${var.image_name} --quiet",
      "else",
      "  echo 'Image does not exist, continuing...'",
      "fi"
    ]
  }

  provisioner "file" {
    source      = var.source
    destination = var.destination # Destination folder in the image
  }

  provisioner "shell" {
    inline = [
      "set -e", // Exit immediately if any command fails
      # Create non-login user and group
      "sudo groupadd -f csye6225",
      "sudo useradd -r -s /usr/sbin/nologin -g csye6225 csye6225",

      # Install unzip package
      "sudo yum install -y unzip",

      # Change ownership of the copied application folder
      "sudo mkdir -p /opt/csye6225",
      "sudo chown -R csye6225:csye6225 /opt/csye6225",

      # Unzip application artifacts: app_artifact.zip
      "sudo unzip -o ${var.destination} -d /opt/csye6225",

      # Copy and configure systemd service
      "sudo cp /opt/csye6225/webapp.service /etc/systemd/system/webapp.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable webapp.service",
    ]
  }
}
