# Task 4 — Controlled Ransomware Recovery

## Objective

Use a controlled technical exercise to recover an encrypted training archive without treating ransom payment as the recovery mechanism.

## Method

A Python script using the `zipfile` module was used against the supplied encrypted training archive. The supplied `rockyou.txt` wordlist was tested against the archive in the simulation environment.

## Result

The training archive password recovered during the exercise was:

**`SPONGEBOB`**

## Security Context

This was an authorized, bounded training exercise using a provided archive and wordlist. It was not an attempt to access a third-party system or recover credentials from a real victim.

## Incident-Response Relevance

The exercise demonstrates:

- Python scripting.
- Archive handling.
- Controlled password testing.
- Technical recovery thinking.
- The importance of having recovery options available during ransomware incidents.

## Scope

All activity documented here was performed within the Forage virtual job simulation environment.
