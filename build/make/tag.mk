GIT_BRANCH   = $(shell git describe --all   | cut -d'/' -f 2)
GIT_COMMIT      = $(shell git describe --dirty --always --tags)

CXXFLAGS += -DGIT_BRANCH="\"$(GIT_BRANCH)\""
CXXFLAGS += -DGIT_COMMIT="\"$(GIT_COMMIT)\""    

CFLAGS += -DGIT_BRANCH="\"$(GIT_BRANCH)\""
CFLAGS += -DGIT_COMMIT="\"$(GIT_COMMIT)\""    

$(info GIT_BRANCH: $(GIT_BRANCH))
$(info GIT_COMMIT: $(GIT_COMMIT))
