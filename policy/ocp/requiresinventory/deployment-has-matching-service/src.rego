package ocp.requiresinventory.deployment_has_matching_service

import data.lib.konstraint

# @title Deployment has a matching Service
#
# All Deployments should have matching Service, via 'spec.template.metadata.labels'.
# Deployments without a Service are not accessible and should be questioned as to why.
#
# @kinds apps/Deployment
violation[msg] {
  konstraint.is_deployment

  deployment := konstraint.object

  not deployment_labels_matches_service_selector(deployment, data.inventory.namespace[deployment.metadata.namespace])

  msg := konstraint.format(sprintf("%s/%s does not have a v1:Service or its selector labels dont match. See: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#service-and-replicationcontroller", [deployment.kind, deployment.metadata.name]))
}

deployment_labels_matches_service_selector(deployment, manifests) {
  cached := manifests["v1"]["Service"]
  current := cached[_]

  deployment.spec.template.metadata.labels == current.spec.selector
}