resource "kubernetes_ingress_v1" "example" {
  metadata {
    name = "example-ingress"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.example.metadata.0.name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
