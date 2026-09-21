# Parranda

read-only host mirror strategy

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
make -C "./sandbox/docker" opencode
```

### Run

```sh
# Move to the root of the project you want to work on.
cd <my-awesome-project>

# Run opencode by referencing the location of the Parranda project.
make -C "<your-parranda-project-directory>/sandbox/docker" run-opencode PROJECT_PATH="$PWD"
```

**NOTE**: Unless you set `OPENCODE_HOME_DIR`, the default location is the directory where `/opencode/run.sh` is located. All persisted OpenCode data will be stored there:

```sh
OPENCODE_HOME_DIR="<host-location>" make -C "<your-parranda-project-directory>" run-opencode PROJECT_PATH="$PWD"
```

as you can see there might be project that requires specific software (as openFrameworks) so that we have to provide the bwrap sandbox the place where the deps instalation is by passing when make run + bind the path with the deps (if it is in different usual paths) and provide the env vars needed

## OpenCode Sandboxed via Bwrap

export PARRANDA=<your-parranda-project-directory>
make -C "$PARRANDA" run-wrapped PROJECT="$PWD"

en el host hay un OC_SANDBOX_HOME donde se van a persistir cosas (TODO)

se bindea opencode config: skills, agents, commands, opencode.json y AGENTS.md
se puede modificar desde el host pero el agent no puede modificarlo

because /usr /bin /lib and /lib64 are binded in wrapped environment it has access to all the binaries installed in the host, easier for testing

# Plugins

he creado un script que escribe permission-suggestion.json en el "working-dir", es decir, en el projecto en cuestion en el que se esta trabajando, para copiar y pegar, aunque el script está en parranda
