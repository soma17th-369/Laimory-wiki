# LLM Wiki Reference

Source: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
Author: Andrej Karpathy
Created: 2026-04-04

## Why This File Exists

This note is a local reference for the operating pattern described in the original gist. It is not intended to be a full mirror of the source text. It captures the core ideas that govern this vault.

## Core Idea

Typical document QA workflows use retrieval over raw files at question time. The LLM Wiki pattern is different: the LLM incrementally builds and maintains a persistent markdown wiki that sits between the user and the raw source set.

Instead of rediscovering knowledge from scratch on every question, the LLM integrates new sources into an existing interlinked wiki. The wiki becomes a compounding artifact that gets richer as more material is ingested and more questions are asked.

## Architecture

The original pattern describes three layers:

1. Raw sources: immutable source material.
2. Wiki: markdown pages maintained by the LLM.
3. Schema: an instruction file that teaches the LLM how to operate on the repository.

For this vault, `AGENTS.md` is the schema layer.

## Operations

### Ingest

When a new source appears, the LLM should read it, summarize it, integrate it into the wiki, update relevant pages, and log the work.

### Query

Questions should be answered against the maintained wiki first. Valuable answers can themselves be stored back into the wiki as durable artifacts.

### Lint

The wiki should be periodically checked for contradictions, stale claims, orphan pages, missing links, and important gaps.

## Navigation Files

The pattern emphasizes two special files:

- `index.md`: content-oriented catalog of the wiki
- `log.md`: chronological history of operations

These reduce the need for heavier retrieval infrastructure at small to medium scale.

## Obsidian Fit

The original gist explicitly frames Obsidian as a strong environment for this pattern:

- Obsidian is the browsing and editing interface.
- The wiki is the markdown codebase.
- The LLM acts as the maintainer of that codebase.

## Local Interpretation For This Vault

This vault adopts the pattern in a work-focused form:

- the human curates inputs into `raw/`
- the LLM maintains `wiki/`
- `wiki/sources/` is always created first on ingest
- topic, entity, and briefing pages accumulate synthesis over time

## How To Use This Reference

Use this file when you need to remember why the vault is structured this way or how the LLM Wiki model differs from retrieval-over-raw-files workflows.

Do not treat this note itself as a replacement for source ingest. If a future task depends on quoting or synthesizing the gist as source material, prefer the original gist or an explicitly ingested source page derived from it.

## Link Back

Always prefer the original source for exact wording and full context:

https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
