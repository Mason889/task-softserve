variable "host" {
        default = "0.0.0.0/0"
}
variable "machine_small" {
        description = "Small GCP machine: 1 CPU and 1.7GB RAM"
        default = "g1-small"
}
variable "region" {
        description = "Default region for future instances"
        default = "us-central1"
}
variable "image_ubuntu_1604" {
        default = "ubuntu-1604-xenial-v20190628"
}



