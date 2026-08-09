# Parranda

`Parranda` hosts agents and agent-related tools, such as skills and commands.

The core philosophy of this project is to run agents in **isolation mode** for safety and reproducibility.

This approach was inspired by community discussions about running OpenCode in isolated environments:
[Reddit comment](https://www.reddit.com/r/opencodeCLI/comments/1qbtyql/comment/nzd7mmt/)

The name is inspired by the Canary Islands tradition of people gathering to create music together. In that spirit, this repository is a "parranda" of AI agents and tools collaborating toward the common good.

## OpenCode Sandboxed via Docker (Legacy)

Dockerized environment for `opencode` with persistent OpenCode state. Skills and `AGENTS.md` are also tracked in Git; see `.gitignore`.

Both skills and `AGENTS.md` are general-purpose: any OpenCode session loads `AGENTS.md` and can use the configured skills.


### Build The Image

Run from the project root:

```sh
make opencode
```

### Run

```sh
# Move to the root of the project you want to work on.
cd <my-awesome-project>

# Run opencode by referencing the location of the Parranda project.
make -C "<your-parranda-project-directory>" run-opencode PROJECT_PATH="$PWD"
```

> NOTE: Unless you set OPENCODE_HOME_DIR, the default location is the directory where /opencode/run.sh is located. All persisted OpenCode data will be stored there.

```sh
OPENCODE_HOME_DIR="<host-location>" make -C "<your-parranda-project-directory>" run-opencode PROJECT_PATH="$PWD"
```
