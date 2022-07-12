
variable "folders_map_1" {
  default = [
    {
      name   = "prod"
      parent = "organizations/85112035544"
    },
    {
      name   = "dev"
      parent = "organizations/85112035544"
    },
    {
      name   = "stage"
      parent = "organizations/85112035544"
    },
  ]
}

variable "folders_map_2" {
  default = [
    {
      name   = "python",
      parent = "prod",
    },
    {
      name   = "bash",
      parent = "prod",
    },
    {
      name   = "python",
      parent = "dev"
    },
    {
      name   = "java",
      parent = "dev"
    },
    {
      name   = "python",
      parent = "stage"
    },
    {
      parent = "prod",
      name   = "AWS"
    }
  ]
}

variable "folders_map_3" {
  default = [
    {
      name   = "env",
      parent = "stage/python",
    },
    {
      name   = "lib",
      parent = "prod/python",
    },
    {
      name   = "docker",
      parent = "dev/python"
    },
    {
      name   = "build",
      parent = "dev/java"
    },
    {
      parent = "dev/java",
      name   = "lib"
    },
    {
      name   = "lib",
      parent = "dev/python"
    },
    {
      name   = "modules",
      parent = "stage/python"
    },
    {
      name   = "scripts",
      parent = "prod/bash"
    },
    {
      parent = "prod/python"
      name   = "env"
    },
    {
      parent = "prod/python"
      name   = "system"
    },
    {
      parent = "prod/python"
      name   = "modules"
    },
    {
      parent = "prod/AWS",
      name   = "terraform"
    },
  ]
}
