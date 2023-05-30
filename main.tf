provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = "my-app-namespace"
  }
}

resource "kubernetes_deployment" "app_deployment" {
  metadata {
    name      = "my-app-deployment"
    namespace = kubernetes_namespace.app_namespace.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "python-webapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "python-webapp"
        }
      }

      spec {
        container {
          image = "liyakatahmed/python-terraform-kubernetes:latest"
          name  = "python-webapp"

          port {
            container_port = 8000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app_service" {
  metadata {
    name      = "my-app-service"
    namespace = kubernetes_namespace.app_namespace.metadata.0.name
  }

  spec {
    selector = {
      app = "python-webapp"
    }

    port {
      protocol   = "TCP"
      port       = 80
      target_port = 8000
    }

    type = "NodePort"
  }
}