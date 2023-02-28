locals {
  /*
    Map of trusted issuer configuration containing the following attributes :
      * issuer = uri of the issuer
      * attributes = Maps attributes from external identity (in jwt claim) to google attributes
      * condition = Minimum recommended condition for identity federation
  */
  trusted_issuer_templates = {
    azure = {
      issuer = "https://sts.windows.net/%s"
      attributes = {
        "google.subject" = "assertion.sub"
        "google.groups" = "assertion.groups"
      }
    }
    bitbucket = {
      issuer = "https://api.bitbucket.org/2.0/workspaces/%s/pipelines-config/identity/oidc"
      allowed_audiences = ["ari:cloud:bitbucket::workspace/%s"]
      attributes = {
        "google.subject" = "assertion.sub"
        "attribute.workspace_uuid" = "assertion.workspaceUuid"
        "attribute.repository" = "assertion.repositoryUuid"
        "attribute.git_ref" = "assertion.branchName"
      }
      condition = "assertion.workspaceUuid=='%s'"
    }
    circleci = {
      issuer = "https://oidc.circleci.com/org/%s"
      attributes = {
        "google.subject" = "assertion.sub"
        "attribute.project_id" = "assertion['oidc.circleci.com/project-id']"
        "attribute.org_id" = "assertion.aud"
      }
      allowed_audiences = ["%s"]
      condition = "assertion.aud=='%s'"
    }
    github = {
      issuer = "https://token.actions.githubusercontent.com"
      attributes = {
        "google.subject" = "assertion.sub"
        "attribute.actor" = "assertion.actor"
        "attribute.repository" = "assertion.repository"
        "attribute.owner" = "assertion.repository_owner"
        "attribute.git_ref" = "assertion.ref"
      }
      condition = "assertion.repository_owner=='%s'"
    }
    gitlab = {
      issuer = "https://gitlab.com/"
      allowed_audiences = ["https://gitlab.com"]
      attributes = {
        "google.subject" = "assertion.sub"
        "attribute.namespace" = "assertion.namespace_path"
        "attribute.project_id" = "assertion.project_id"
      }
      condition = "assertion.namespace_id=='%s'"
    }
    terraform-cloud = {
      issuer = "https://app.terraform.io"
      attributes = {
        "google.subject" = "assertion.sub"
        "attribute.organization" = "assertion.terraform_organization_id"
        "attribute.workspace_id" = "assertion.terraform_workspace_id"
        "attribute.workspace_name" = "assertion.terraform_workspace_name"
      }
      condition = "assertion.terraform_organization_id=='%s'"
    }

  }
}