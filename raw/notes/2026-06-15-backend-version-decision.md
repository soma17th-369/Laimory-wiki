---
source_type: notes
title: Backend version decision - Spring Boot and Java
captured_at: 2026-06-15
status: raw-decision-note
---

# Backend Version Decision - Spring Boot and Java

## Context

The team needed to decide the backend framework and Java versions for the Laimory project.

Initial candidates discussed:

- Spring Boot 4.0.x + Java 25
- Spring Boot 3.5.x + Java 25
- Spring Boot 3.5.x + Java 21

The project is a job portfolio project, but the available development period is limited. Fast implementation and avoiding environment-related stress are important.

## Decision Criteria

The team prioritized:

1. Fast development within a short schedule
2. Low environment setup and compatibility risk
3. Easy troubleshooting from existing examples and references
4. Stable compatibility with common libraries, build tools, CI, Docker, and test tools
5. Enough modernity to be defensible in a portfolio

Latest-version appeal was considered useful, but less important than finishing a polished product.

## Candidate Comparison

### Spring Boot 4.0.x + Java 25

Pros:

- Most modern stack among the candidates
- Uses the latest Spring/Jakarta generation
- Strong portfolio message if the team wants to emphasize newest technology adoption

Cons:

- Spring Boot 4.0.x is a major version line
- More chance of friction with examples, third-party libraries, security configuration, ORM behavior, JSON handling, and testing tools
- More time may be spent resolving environment or compatibility issues

Assessment:

This is attractive for a newest-stack portfolio, but it does not fit the team's current priority of reducing development risk.

### Spring Boot 3.5.x + Java 25

Pros:

- Keeps Spring Boot on the latest stable 3.x line
- Uses Java 25, the newest Java LTS line
- Good balance between modernity and Spring ecosystem stability

Cons:

- Java 25 still requires checking build tool, CI, Docker image, test tool, and annotation processor compatibility
- Some additional environment verification may be needed compared with Java 21

Assessment:

This is a reasonable balanced option, but Java 25 adds toolchain verification cost. Given the short development period, the team judged that this extra modernity is not worth the possible setup friction.

### Spring Boot 3.5.x + Java 21

Pros:

- Spring Boot 3.5.x is a current stable 3.x line
- Java 21 is an LTS version and has been available long enough to be broadly supported
- Strong compatibility with common Spring examples, libraries, CI environments, Docker images, test tools, and build tools
- Lowest environment risk among the three candidates
- Lets the team spend more time on product quality, architecture, testing, deployment, and portfolio polish

Cons:

- Less "latest stack" appeal than Java 25 or Spring Boot 4.0.x

Assessment:

This option best matches the team's real constraint: short development time and the need to avoid environment stress.

## Final Decision

Final backend version decision:

- Spring Boot 3.5.x
- Java 21
- MySQL 8.4 LTS

## Rationale

The team considers an LTS version that has been out for more than half a year to be sufficiently stable in principle. However, the team's project-specific criteria matter more than abstract version freshness.

Because development time is limited, the team chose the option with the lowest expected environment and compatibility risk. Spring Boot 3.5.x + Java 21 is modern enough for a portfolio while being more predictable than the Java 25 and Spring Boot 4.0.x alternatives.

The decision favors completion quality over newest-version appeal.

## Team-Facing Summary

We chose Spring Boot 3.5.x and Java 21 because the project has a short development timeline and needs a stable, low-friction environment. Java 21 is an LTS release with broad ecosystem support, and Spring Boot 3.5.x gives us a current stable 3.x Spring line without the extra compatibility risk of the Spring Boot 4 major version. Although Java 25 and Spring Boot 4.0.x are attractive for latest-stack appeal, we judged that reducing setup and compatibility risk is more important for this portfolio project.
