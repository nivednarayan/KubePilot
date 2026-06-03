# ADR-003: Kyverno over OPA Gatekeeper for policy enforcement

## Decision
Use Kyverno as the policy engine instead of OPA Gatekeeper.

## Reasoning
Kyverno policies are written in YAML — the same language used 
for everything else in Kubernetes. This means you can write, 
read, and understand policies without learning a separate 
language. OPA Gatekeeper requires writing policies in Rego, 
a purpose-built query language that has a steep learning curve. 
For a project where the goal is to enforce sensible security 
defaults — no root containers, required resource limits, 
required probes — Kyverno's YAML-based approach is faster 
to implement and easier to reason about.

## Tradeoffs
OPA Gatekeeper is more powerful and flexible for complex 
policy logic. Rego can express conditions that would be 
difficult to write in Kyverno's pattern-based approach. 
For an enterprise platform with complex compliance 
requirements, OPA would be the stronger choice.
