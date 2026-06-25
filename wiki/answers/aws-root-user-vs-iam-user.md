---
title: AWS root user vs IAM user
kind: answer
status: active
updated: 2026-06-20
tags: [aws, iam, security, root-user, least-privilege]
---

# AWS root user vs IAM user

## Scope

This answer explains why day-to-day AWS work should not be performed with the AWS account root user.

The modern AWS recommendation is slightly stronger than "use an IAM user instead of root." For human users, AWS generally recommends federated access with temporary credentials, preferably through IAM Identity Center. IAM users with long-term credentials are still valid for specific cases, but they are not the best default for people or workloads.

## Current Answer

The AWS account root user has complete access to all AWS services and resources in the account. It is the account owner identity, not a normal working identity. AWS strongly recommends using it only for tasks that require root-level permissions.

The core reasons are:

- Blast radius: if root is compromised, the attacker gets complete account control, including billing-sensitive and account-level actions.
- Least privilege: IAM identities and roles can be scoped to the minimum permissions needed for a task; root cannot be meaningfully scoped in the same way inside the account.
- Credential risk: root credentials and root access keys are long-lived and highly privileged, so leaks are severe. AWS specifically recommends not creating root access keys.
- Audit and accountability: separate IAM identities, IAM Identity Center users, and roles make it clearer who did what. Shared root use collapses accountability into one identity.
- Recovery and emergency design: root should be kept as a break-glass identity for rare account-level tasks, not mixed into daily operations.
- Operational safety: daily work involves mistakes. With scoped permissions, mistakes are constrained. With root, mistakes can affect the whole account.

For a new or small account, the practical model is:

1. Secure the root user with a strong unique password and MFA.
2. Do not create root access keys; delete them if they exist.
3. Create an administrative working identity.
4. For ongoing human access, prefer IAM Identity Center or role-based temporary credentials.
5. Use least-privilege IAM policies for daily developer/operator work.
6. Keep root only for root-required tasks such as certain account settings, closing standalone accounts, restoring IAM administrator access, enabling IAM billing access, and a few special service/account operations.
7. Monitor and alert on root sign-in or root credential usage.

## Important Nuance

"Use IAM user" is a common beginner-friendly phrasing, but the best current AWS guidance is:

- Humans: prefer IAM Identity Center/federation with temporary credentials.
- AWS workloads: prefer IAM roles and temporary credentials.
- IAM users: use only when a use case really requires long-term credentials.
- Root user: secure, monitor, avoid daily use, and use only for root-required tasks.

## Linked Evidence

- AWS IAM documentation says root has complete access and AWS strongly recommends not using root for everyday tasks.
- AWS root user best practices recommend accessing root only for tasks that require root, enabling MFA, avoiding root access keys, using group email/recovery controls, and monitoring root usage.
- AWS IAM security best practices recommend human users use federation with temporary credentials and centralized access through IAM Identity Center.
- AWS Well-Architected Security Pillar treats using root for daily activities and long-lived credentials as anti-patterns and recommends least privilege.
- AWS Security Blog explains the same beginner flow: protect the root account, use IAM users/groups/roles for daily access, and do not use root access keys.

## Related Pages

- [[2026-06-21-notes-vpc-ssm-endpoint-cost]]: AWS CLI work in this account currently runs as the root identity, which conflicts with this guidance.

## References

- [AWS account root user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html)
- [Root user best practices for your AWS account](https://docs.aws.amazon.com/IAM/latest/UserGuide/root-user-best-practices.html)
- [Security best practices in IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [AWS security credentials](https://docs.aws.amazon.com/IAM/latest/UserGuide/security-creds.html)
- [AWS Well-Architected Security Pillar: Define access requirements](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/sec_permissions_define.html)
- [AWS Well-Architected Security Pillar: Grant least privilege access](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/sec_permissions_least_privileges.html)
- [AWS Security Blog: Follow Security Best Practices as You Configure Your AWS Resources](https://aws.amazon.com/blogs/security/getting-started-follow-security-best-practices-as-you-configure-your-aws-resources/)
- [AWS Security Blog: Receive notifications when root access keys are used](https://aws.amazon.com/blogs/security/how-to-receive-notifications-when-your-aws-accounts-root-access-keys-are-used/)
