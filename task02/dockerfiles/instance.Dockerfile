FROM stargazer-base-task02

WORKDIR /app

# Check out latest commit
RUN LATEST_COMMIT=$(git rev-list -n 1 HEAD) && git checkout $LATEST_COMMIT

# Apply basetoinstance patch
RUN \
  --mount=type=bind,source=patches/basetoinstance.patch,target=/tmp/basetoinstance.patch \
    if grep -q '^diff' /tmp/basetoinstance.patch 2>/dev/null; then \
        git apply --whitespace=fix /tmp/basetoinstance.patch; \
    else \
        echo "basetoinstance.patch is empty or has no diffs, skipping..."; \
    fi

ENTRYPOINT ["/bin/bash"]
