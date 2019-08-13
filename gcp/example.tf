provider "google" {
	credentials = "${file("devops-practice-247821-005171c93906.json")}"	# api token for service account
	project = "devops-practice-247821"
	region = "${var.region}"
}
resource "google_compute_instance" "app"{
	name		="softserve-task-gcp"
	zone		="${var.region}-a"
	machine_type	="${var.machine_small}"
	boot_disk{
		initialize_params {
			image	= "${var.image_ubuntu_1604}"
		}
	}
	metadata = {
		ssh-keys = "terraform:${file("~/.ssh/terraform.pub")})"			# public ssh key that attached ONLY for this instance
	}
	network_interface {
		network = "default"
		access_config {}
	}
	tags		=["terraform"]
	connection {
		host= "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
		type= "ssh"
		user="terraform"
		agent = false
		private_key = "${file("~/.ssh/terraform")}"
	}
	#provisioner "file" {
	#	source= "files/hello.html"
	#	destination = "/home/terraform/hello.html"
	#}
	provisioner "file" {
		source= "devops-practice-247821-005171c93906.json"
		destination= "/home/terraform/devops-practice-247821-005171c93906.json" 
	}
	provisioner "remote-exec" {
		script = "files/deploy.sh"
	}
# ...
}
resource "google_compute_firewall" "firewall_terraform" {
	name= "allow-terraform-default"
	network = "default"
	allow {
		protocol = "tcp"
		ports= ["9292", "80", "8080", "443"]
	}
	source_ranges = ["${var.host}"]
	target_tags = ["terraform"]
}
