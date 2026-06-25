---
title: AWS Organizations and Identity Center account model
kind: answer
status: active
updated: 2026-06-20
tags: [aws, organizations, iam-identity-center, accounts, permissions]
---

# AWS Organizations and Identity Center account model

## Scope

This answer explains how AWS Organizations management accounts, member accounts, IAM Identity Center users, permission sets, and resources relate to each other.

## Current Answer

An AWS account is a container for AWS resources such as EC2, RDS, S3, VPCs, and Lambda. It is different from a user.

In an AWS Organizations setup:

- The management account owns and controls the organization.
- Member accounts are separate AWS accounts under the organization.
- Resources should usually live in member accounts, not the management account.
- IAM Identity Center users are workforce identities, not AWS accounts.
- A permission set is a template for permissions.
- Assigning a user or group plus a permission set to an AWS account creates Identity Center-managed IAM roles in that target account.
- The user signs in through the AWS access portal and chooses which account and role to use.

Example:

```text
Management account
- AWS Organizations
- IAM Identity Center
- Billing and account administration

Member account: laimory-dev
- EC2-dev
- RDS-dev
- S3-dev

Member account: laimory-staging
- EC2-staging
- RDS-staging

IAM Identity Center users
- suhyun
- teammate
```

If `suhyun` is assigned `AdministratorAccess` to `laimory-dev`, she can enter `laimory-dev` and access its EC2 resources. If she is also assigned access to `laimory-staging`, the portal will show both accounts or roles.

If `teammate` is assigned only to `laimory-dev`, they can access `laimory-dev` resources but not `laimory-staging` resources.

Separate dev accounts do not automatically access each other's EC2 instances. Access is granted by assigning Identity Center users/groups to each target AWS account with permission sets, or by explicitly configuring cross-account permissions/networking.

## Practical Model For A Small Team

Do not create one AWS account per human just because there are multiple people.

Usually:

```text
Human identities:
- suhyun
- teammate

AWS accounts:
- management
- laimory-dev
- later: laimory-prod, laimory-staging, sandbox, etc.
```

Each person can be assigned to one or more AWS accounts:

```text
suhyun -> laimory-dev -> AdministratorAccess
suhyun -> laimory-prod -> ReadOnlyAccess or limited admin
teammate -> laimory-dev -> DeveloperAccess
teammate -> laimory-prod -> no access, unless needed
```

This is why multi-account AWS does not mean "everyone gets a separate AWS account that stores their identity." The accounts are resource and control boundaries. Identity Center users are identities that can be granted entry into those boundaries.

## Existing Resources In The Management Account

If the management account already contains many workload resources, do not migrate impulsively just to satisfy the ideal account model. Existing EC2 instances, VPCs, security groups, IAM roles, S3 buckets, load balancers, DNS records, and databases are account-scoped resources or have account-scoped permissions. There is usually no one-click "move this environment to another AWS account" operation.

Practical recommendation:

1. Keep the existing resources running in the current account for now.
2. Enable IAM Identity Center and give each human their own access identity.
3. Stop using the root user for daily work.
4. Treat the current account as a transitional workload-plus-management account.
5. Create a new member account such as `laimory-dev-v2` only when the team has time to rebuild or migrate deliberately.
6. Put new major environments, especially production, in separate member accounts.

Typical migration shape:

- EC2: create AMIs or rebuild from infrastructure/configuration, then launch in the target account.
- S3: use replication, batch copy, or sync into a bucket owned by the target account.
- VPC/security groups: recreate the network layout in the target account.
- IAM roles: recreate roles and policies; role ARNs will change.
- DNS/load balancers/databases: migrate with a cutover plan instead of moving blindly.

For a student or early team project, it can be reasonable to keep the current account as the active dev account and simply make access safer. The stricter multi-account structure can be adopted for the next environment or before production.

## Alternative When The Current Account Already Has Workloads

If IAM Identity Center or AWS Organizations has not yet been enabled in the current resource-heavy account, another practical path is:

1. Create a new, mostly empty AWS account to become the organization management account.
2. Create the AWS Organization from that new empty account.
3. Invite the existing resource-heavy AWS account into the organization.
4. After accepting the invitation, treat the existing account as a member workload account such as `laimory-dev`.
5. Enable IAM Identity Center from the management account and assign users/groups to the existing member account.

This avoids migrating existing EC2, S3, VPC, security group, and IAM resources just to separate management from workloads. The tradeoff is that billing responsibility moves to the management account after the existing account joins the organization, and invited accounts do not automatically get `OrganizationAccountAccessRole` unless it is created manually.

## Related Pages

- [[2026-06-21-notes-vpc-ssm-endpoint-cost]]: the existing resource-heavy account whose VPC/SSM resources would move under this model.

## References

- [AWS Organizations terminology and concepts](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_getting-started_concepts.html)
- [IAM Identity Center: Single sign-on access to AWS accounts](https://docs.aws.amazon.com/singlesignon/latest/userguide/useraccess.html)
- [IAM Identity Center: Manage AWS accounts with permission sets](https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetsconcept.html)
- [AWS Organizations: Best practices for the management account](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_best-practices_mgmt-acct.html)
- [AWS Organizations: Managing account invitations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_invites.html)
- [AWS Organizations: Accessing member accounts](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html)
- [Amazon EC2: Share an AMI with specific AWS accounts](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/sharingamis-explicit.html)
- [Amazon S3: Configuring replication for buckets in different accounts](https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-walkthrough-2.html)
