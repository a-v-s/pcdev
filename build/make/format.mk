
.PHONY: format
format:
	clang-format -i $(CXX_SRC)
	clang-format -i $(CXX_HEADERS)
