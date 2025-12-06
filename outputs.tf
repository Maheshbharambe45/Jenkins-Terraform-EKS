output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids of control plane."
  value       = module.eks.cluster_security_group_id
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
