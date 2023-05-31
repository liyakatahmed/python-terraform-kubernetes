provider "kubernetes" {
  config_path = "~/../../cygwin64/home/Liyakat/.kube/config" 
  # Default config_path = "~/.kube/config" but somehow during minikube installation ".kube" folder got placed in the above config_path.
}

resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = "python-webapp-namespace"
  }
}

resource "kubernetes_deployment" "app_deployment" {
  metadata {
    name      = "python-webapp-deployment"
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
    name      = "python-webapp-service"
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