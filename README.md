# Notes

## Use of `pre-commit` Python package vs native `.git/hooks`
* Design: `.git` should contain only local repo-specific config, and thus `git` ignores it
* Versioning: YAML config is intended to live outside `.git` and be versioned as normal
* Security: not secure or polite to share code that will automatically run without explicit end-user opt-in

## Use of `detect-secrets`
* [Repo](https://github.com/Yelp/detect-secrets)
* Goals:
  * Take a baseline of the code and enumerate secrets already in code base
  * List any _existing_ secrets, for migration out on yor schedule instead of blocking all commits until this is fixed
  * Prevent committing _new_ secrets
  * Detect when the above protection is intentionally bypassed
  