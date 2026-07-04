# Provider Journey: Why This Project Ended Up Local

Most portfolio projects don't document the dead ends. This one does,
because the process of hitting and adapting to real infrastructure
constraints is itself relevant experience.

## Attempt 1: AWS EKS

Original design: a managed EKS cluster with Terraform, VPC, IRSA, ArgoCD,
and full observability. Technically solid, but the EKS control plane alone
runs ~$73/month with no free tier — not sustainable for an unpaid portfolio
project. AWS also changed its free tier structure in July 2025: new accounts
now get $200 in credits valid for 6 months, not the old 12-month free EC2
allowance, so even the free-tier version of this design would eventually
incur real charges.

## Attempt 2: Oracle Cloud (Always Free ARM tier)

Oracle's Always Free tier includes genuinely permanent ARM compute (2 OCPU/
12GB as of mid-2026, previously 4 OCPU/24GB). This looked like the ideal
fit: real, permanent, free infrastructure. In practice, Oracle's signup
verification repeatedly failed with "Error Processing Transaction" — a
well-documented issue affecting users with entirely valid cards, going back
years, with no reliable fix. After trying multiple troubleshooting steps
(card settings, address matching, browser changes), the account could not
be created.

**Lesson**: a platform's advertised free tier is only useful if you can
actually get an account provisioned. Verification friction is a real
infrastructure constraint, not a footnote.

## Attempt 3: Google Cloud

Google's Always Free tier includes one permanent `e2-micro` instance.
Signup got further than Oracle's, but hit a billing-account activation
requirement: a genuine one-time $10 prepayment tied to fraud-prevention
checks for certain account/payment-method combinations. Unlike Oracle's
opaque failure, this one was at least explainable and had a clear
resolution path — but it meant "$0, no payment ever" wasn't achievable
through Google either without accepting a (refundable, credited) charge.

## Decision: go local

Rather than keep spending time on cloud-provider signup flows, the project
pivoted to a local Kubernetes cluster (`kind`), keeping the same
Terraform-driven approach but removing every external dependency. This
achieves the original goal — a genuinely free, IaC-provisioned Kubernetes
platform — without betting the timeline on a third-party verification
process outside my control.

## Why this is worth including in a portfolio

Anyone can follow a tutorial when everything works on the first try. Fewer
people can show they hit real friction, diagnosed why, and adapted the
approach without abandoning the underlying goal. That's a more accurate
preview of actual infrastructure work than a clean, uninterrupted success
story would be.
