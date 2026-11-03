Project for running agents in isolation mode. When executing sandboxed environment followings folders are binded:

- ./agents
- ./commands
- ./plugings
- ./skills

Sanboxed environments configuration and setup:

- Currently only sandbox/bwrap is used
- sandbox/docker is legacy so ignore this configuration
- for fully details about sandboxed environment look at the script wrapped/run.sh script
- wrapped/AGENTS.md and wrapped/opencode.jsonc are files for the config root sandboxed environment shared by all the agents
