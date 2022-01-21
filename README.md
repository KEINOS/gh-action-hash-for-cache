[![Local Test](https://github.com/KEINOS/gh-action-hash-for-cache/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/KEINOS/gh-action-hash-for-cache/actions/workflows/test.yml "View status on GitHub")

# Hash Generator for Caching

[This GitHub Action](https://github.com/KEINOS/gh-action-hash-for-cache) is a helper action for "[actions/cache@v2](https://github.com/marketplace/actions/cache)".
**It simply generates a hash of the given entry**, which is useful as a cache key.

If the content of the entry is changed, a different hash will be obtained.
It is also possible to specify a time-limited variant.

## Basic format of the step

```yaml
    - name: <name of the step to display>
      uses: keinos/hash-for-cache@v1
      id: <ID to call the hash from other steps>
      with:
        path: |
          <path to target file1>
          <path to target file2>
        variant: <a string>
```

- Exposed variables: `steps.<id>.outputs.hash`

## Example

### Basic usage

In this example, if "composer.json" or "composer.lock" is changed, the hash will be changed.

```yaml
- id: hash-now-dont-you-cry
  uses: keinos/hash-for-cache@v1
  with:
    path: |
      ./composer.json
      ./composer.lock

- name: Activate caching
  id: cache
  uses: actions/cache@v2
  with:
    path: /path/target/dir/to/cache/and/restore
    key: ${{ steps.hash-now-dont-you-cry.outputs.hash }}
```

### Time-limitation using variant

In this example, if "go.mod" or "go.sum" is modified **or the month is changed**, the hash will be changed.

- Note that the "TZ" (time zone) can be changed to suit your country.

```yaml
- name: Get hash key
  id: hash-now-dont-you-cry
  uses: keinos/hash-for-cache@v1
  with:
    path: |
      ./go.mod
      ./go.sum
    variant: $(TZ=UTC-9 date '+%Y%m')

- name: Activate caching
  id: cache
  uses: actions/cache@v2
  with:
    path: /path/target/dir/to/cache/and/restore
    key: ${{ steps.hash-now-dont-you-cry.outputs.hash }}
```
