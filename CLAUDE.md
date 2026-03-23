# Global Rules

- Never add "Generated with Claude Code", "Co-Authored-By: Claude", or any AI attribution signatures to commits, PRs, or any output

## Projects

All local repositories live under `~/code/` (the `code` folder in the user's home directory on any machine).

A full project catalog is maintained at `projects/projects.yaml` (in this repo).
- Contains all project groups, descriptions, and git origin URLs
- To clone a project: read `projects.yaml`, find the origin URL, and `git clone` into `~/code/<group>/<repo>`
