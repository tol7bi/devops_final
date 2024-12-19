job "hello-world" {
  datacenters = ["kbtu"]
  type        = "batch"
  group "example" {
    task "docker" {
      driver = "docker"

      config {
        image = "hello-world"
      }

      resources {
        cpu    = 100
        memory = 16
      }
    }

    task "raw_exec" {
      driver = "raw_exec"

      config {
        command = "echo"
        args    = ["Hello, World!"]
      }

      resources {
        cpu    = 100
        memory = 16
      }
    }
  }
}