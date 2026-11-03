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

## OpenCode Sandboxed via Bwrap

### Run

Run from the project directory:

```sh
export PARRANDA=<your-parranda-project-directory>
make -C "$PARRANDA" run-wrapped PROJECT="$PWD"
```

Standalone mode allows multiple sandboxes to run simultaneously. See [OpenCode’s background service documentation](https://opencode.ai/v2/docs/cli#background-service).

### Host bindings

stateful data explnation as sanbxoed envinrment

#### User data

Sandbox data persists under `$HOME/.local/share/opencode/sandbox/home` on the host, defined by `OC_HOST_SANDBOX_HOME` in `wrapped/run.sh`. The database is stored at `$OC_HOST_SANDBOX_HOME/.local/share/opencode/opencode.db`.

#### Harness

Skills, agents, commands, plugins, `opencode.jsonc`, and `AGENTS.md` are mounted from the host. They can be edited on the host, but not by the agent.

The Plan agent can only write to its designated plan directory. The project's `plans/` directory is mounted at `~/.opencode/plan` inside the sandbox, so plans are saved directly in the project.

#### Read-only host mirror strategy

The host’s `/usr`, `/bin`, `/lib`, and `/lib64` directories are mounted read-only, making host-installed binaries available inside the sandbox for testing.

### Project-specific dependencies

Some projects require additional software, such as openFrameworks. Pass its location when running `make`, bind any dependency paths not already available inside the sandbox, and provide the required environment variables.

For example:

```sh
# openFrameworks is mounted read-only at /home/sandbox/openFrameworks and exposed inside the sandbox through OF_ROOT.
#
make -C "$PARRANDA" run-wrapped \
  PROJECT="$PWD" \
  OPEN_FRAMEWORKS=/path/to/openFrameworks
```

### Plugins

A script in Parranda writes `permission-suggestion.json` to the working project directory, making its suggestions easy to copy and paste.

### Scripts

**opencode-usage**

Reports token usage and recorded costs from locally stored OpenCode sessions, grouped by provider.

```sh
opencode-usage                          # All recorded sessions
opencode-usage --today                  # Today, using the local timezone
opencode-usage --by-model --by-project  # Additional breakdowns
opencode-usage --json                   # Raw statistics as JSON
```

Recorded costs may differ from actual provider billing.
