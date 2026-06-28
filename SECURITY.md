# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in hermes-mimo, please report it responsibly.

**Do NOT open a public GitHub issue for security vulnerabilities.**

Instead, please open a private security advisory on [GitHub](https://github.com/larrymou/hermes-mimo/security/advisories/new).

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

## Response Timeline

- **Acknowledgment:** Within 48 hours
- **Initial assessment:** Within 1 week
- **Fix or mitigation:** Depends on severity

## Scope

This security policy applies to:
- The SKILL.md orchestration guide
- Test scripts in `/tests`
- Package configuration

This does NOT apply to:
- MiMo Code itself (report to [XiaomiMiMo/MiMo-Code](https://github.com/XiaomiMiMo/MiMo-Code))
- Hermes Agent (report to [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent))

## Best Practices

When using this skill:
- Never commit API keys or secrets
- Use environment variables for credentials
- Review commands before executing in production
- Use `--dangerously-skip-permissions` only in isolated environments
