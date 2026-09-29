module "naming" {
  source  = "codectl/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "regions" {
  source  = "codectl/locations/azure"
  version = "~> 1.0"

  location = {
    primary = "westeurope"
  }
}

module "rg" {
  source  = "codectl/rg/azure"
  version = "~> 1.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = module.regions.location.primary.name
    }
  }
}

module "public_ip" {
  source  = "codectl/pip/azure"
  version = "~> 1.0"

  public_ips = {
    pub1 = {
      name                = module.naming.public_ip.name_unique
      location            = module.rg.groups.demo.location
      resource_group_name = module.rg.groups.demo.name
      public_ip_prefix_id = module.prefixes.public_ip_prefixes.pub1.id
      zones               = ["1", "2", "3"]
    }
  }
}

module "prefixes" {
  source  = "codectl/pip/azure//modules/prefixes"
  version = "~> 1.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location

  public_ip_prefixes = {
    pub1 = {
      name          = module.naming.public_ip_prefix.name_unique
      prefix_length = 31
      zones         = ["1", "2", "3"]
    }
  }
}
