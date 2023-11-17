/**
* Solution temporaire, à remplacer avec Vault
*/
resource "kubernetes_secret" "github_packages_secret" {
  metadata {
    name      = "github-packages-secret"
    namespace = "default"
  }

	type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode(
     {
        "auths": {
                "ghcr.io": {
                        "auth": "anVzdGluLmxlY2FzOmdocF91NlZ5NmJmNEc3aUVWY3FBSFBxekRYWGlHVWFra0IzcmlhNUw="
                }
        }
			}
    )
  }
}
