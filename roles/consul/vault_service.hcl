service {
    name = "vault"
    id = "vault"
    tags = ["primary"]

    check = {
        http = "http://127.0.0.1:8200/v1/sys/health"
        method = "GET"
        interval = "5s"
       
    }
}