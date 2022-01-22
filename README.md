[![Test](https://github.com/KEINOS/gh-action-hash-for-cache/actions/workflows/basic_func_test.yml/badge.svg)](https://github.com/KEINOS/gh-action-hash-for-cache/actions/workflows/basic_func_test.yml)
[![linux-mac-win](https://github.com/KEINOS/gh-action-hash-for-cache/actions/workflows/platform_test.yml/badge.svg)](https://github.com/KEINOS/gh-action-hash-for-cache/actions/workflows/platform_test.yml)

# GitHub Actions to Generate Hash for Caching on Linux, macOS, and Windows runners

[This GitHub Action](https://github.com/KEINOS/gh-action-hash-for-cache):

- **Simply generates a hash of the given entry**.
  - If the content of the entry is changed, a different hash will be obtained.
  - Useful to generate a key or ID for caching.
- Works on Linux, macOS, and Windows runners.
- Aims to be a helper action for "[actions/cache@v2](https://github.com/marketplace/actions/cache)".
- It is also possible to specify a time-limited variant.

## Usage

Basic format of the workflow step.

```yaml
jobs:
  <job_name>:

    strategy:
      matrix:
        platform: [ubuntu-latest, macos-latest, windows-latest]

    runs-on: ${{ matrix.platform }}

    steps:
      - name: <name of the step to display>
        uses: KEINOS/gh-action-hash-for-cache@main
        id: <ID to call the hash from other steps>
        with:
          path: |
            <path to target file1>
            <path to target file2>
          variant: <a string>
```

- Exposed variables: `steps.<id>.outputs.hash`

## Example

### On File Change

In this example, if "composer.json" or "composer.lock" is changed, the hash will be changed.

```yaml
- name: Get a hash key from two files
  id: hash-now-dont-you-cry
  uses: KEINOS/gh-action-hash-for-cache@main
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

### On Variant Change

In this example, if "go.mod" or "go.sum" is modified **or the value of "variant" is changed**, the hash will be changed.

```yaml
- name: Get hash key
  id: hash-now-dont-you-cry
  uses: KEINOS/gh-action-hash-for-cache@main
  with:
    path: |
      ./go.mod
      ./go.sum
    variant: "v1.0.0"

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
  uses: KEINOS/gh-action-hash-for-cache@main
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
