# GoldiLocks
How to guess the right size for your Kubernetes Pods?

Have you ever wondered what the right size for your Kubernetes Pods is? Or Did you often overcommit the resources for your Pod and then were surprised to see the cloud costs at the end of the month? This is the most common scenario that happens with most Kubernetes resources. What is the best way to find out the resources for our workloads then? Does it mean that we will always have to overcommit the resources or always go by guess? No, not always. Goldilocks is here to help. Goldilocks is a utility that can help you identify a starting point for resource requests and limits. By using the Kubernetes vertical-pod-autoscaler (opens new window) in recommendation mode, we can see a suggestion for resource requests on each of our apps. This tool creates a VPA for each workload in a namespace and then queries them for information.

Full Article Published here https://pavan1999-kumar.medium.com/how-to-guess-the-right-size-for-your-kubernetes-pods-9c88686fec
