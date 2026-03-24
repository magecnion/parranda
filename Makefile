.PHONY: base opencode

base:
	@echo "Building base images"
	docker build --progress=plain -t agent-base -f base/Dockerfile base

opencode: base
	@echo "Building opencode image"
	docker build --build-arg CACHE_BUST=$$(date +%s) --progress=plain -t kopencode -f kopencode/Dockerfile kopencode

claudecode: base
	@echo "Building claudecode image"
	docker build --progress=plain -t claudecode -f claudecode/Dockerfile claudecode
