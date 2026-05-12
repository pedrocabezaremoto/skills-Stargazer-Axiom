FROM <base-image>
###############################################
# REPO SETUP
###############################################
# DO NOT MODIFY THIS SECTION (Exception: Additional git config or repo structure commands may be added if required)
WORKDIR /app
RUN LATEST_COMMIT=$(git rev-list -n 1 HEAD) && git checkout $LATEST_COMMIT
RUN --mount=type=bind,source=patches/basetoinstance.patch,target=/tmp/basetoinstance.patch \
    if grep -q '^diff' /tmp/basetoinstance.patch 2>/dev/null; then \
        git apply --whitespace=fix /tmp/basetoinstance.patch; \
    else \
        echo "basetoinstance.patch is empty or has no diffs, skipping..."; \
    fi
    
###############################################
# PROJECT DEPENDENCIES AND CONFIGURATION
###############################################
# Install any project dependencies here. 
# Normally this is fine to leave empty, but in rare cases, 
# you may have to install the same dependencies as in the base dockerfile
