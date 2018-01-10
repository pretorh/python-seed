SRC_DIR   := ./src
TEST_DIR  := ./tests
SRC_FILES := $(shell find $(SRC_DIR) -type f -name *.py)
TEST_FILES:= $(shell find $(TEST_DIR) -type f -name *.py)

all: lint test

lint: .lint

test:
	@PYTHONPATH=$(SRC_DIR) python -m unittest discover -v --start $(TEST_DIR) --pattern *.py

clean:
	rm -f **/*.pyc
	rm -f .lint

.PHONY: test lint

.lint: $(SRC_FILES) $(TEST_FILES)
	@mkdir -pv `dirname $@`
	pycodestyle --max-line-length=110 --show-source --show-pep8 --count $?
	pylint --disable=missing-docstring,too-few-public-methods --errors-only $?
	@date > $@
