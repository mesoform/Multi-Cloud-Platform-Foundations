project_id = "project-id"
workload_identity_pool = {
  cicd = {
    providers = {
      bitbucket = {
        attribute_mapping = {
          "google.subject" = "assertion.sub"
          "attribute.tid"  = "assertion.tid"
        }
        owner = "companyWorkspace"
        oidc  = {
          issuer = "bitbucket"
        }
      }
      cicd = {}
      github = {
        attribute_condition = "assertion.repository_owner=='companyOrg' && assertion.ref=='refs/head/main'"
        attribute_mapping   = {
          "google.subject"  = "overwrite.sub"
          "attribute.actor" = "assertion.actor"
          "attribute.aud"   = "assertion.aud"
        }
#        owner = "companyOrg"
        oidc  = {
          issuer = "github"
        }
      }
      gitlab = {
        owner = "companyGroup"
        oidc = {
          issuer = "gitlab"
        }
      }
      unknown = {
        attribute_mapping = {
          "google.subject" = "assertion.sub"
          "attribute.tid"  = "assertion.tid"
        }
        oidc = {
          issuer = "https://unknown.issuer"
        }
      }
    }
  }
  azure = {
    providers = {
      app_1 = {
        owner = "tenantID"
        oidc = {
          issuer = "azure"
          allowed_audiences = [
            "api://application1Id"
          ]
        }
      }
    }
  }
}