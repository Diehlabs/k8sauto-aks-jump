data "terraform_remote_state" "core" {
  backend = "remote"
  config = {
    organization = "Diehlabs"
    workspaces = {
      name = "k8sauto-core-azure"
    }
  }
}

data "terraform_remote_state" "aks" {
  backend = "remote"
  config = {
    organization = "Diehlabs"
    workspaces = {
      name = "k8sauto-aks"
    }
  }
}
