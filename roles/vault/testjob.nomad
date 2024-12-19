job "hello-world" {
        datacenters = ["kbtu"]
        type = "batch"
  group "example" {

    vault {
        policies = ["nomad-server"]
    }
    
    task "raw_exec" {
      driver = "raw_exec"

      config {
        command = "echo"
        args    = ["${myvar}"]
      }

      template {
        destination = "secrets/envfile"
        env         = true
        data = <<EOF
myvar={{with secret "secret/mysecrets"}}{{ .Data.hello }}{{ end }} 
EOF
      }

      resources {
        cpu    = 100
        memory = 16
      }
    }
  }
}