# git-tag-action

GitHub action that adds a lightweight git tag to the current workflow commit.

**Note:** If a tag with the same name already exists, it is replaced.

## Environment Variables

* **GITHUB_TOKEN (required)** - Required for permission to tag the repository.
* **TAG (required)** - Name of the tag to be added.
* **COMMIT_SHA (optional)** - Commit SHA to be tagged (defaults to commit that triggered the action).

## Example usage

```yaml
uses: NebraLtd/git-tag-action@master
env:
  TAG: v1.2.3
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
