SRC_DIR   := ./src
TEST_DIR  := ./tests
OUT_DIR   := ./dist
SRC_FILES := $(shell find $(SRC_DIR) -type f -name *.py)
TEST_FILES:= $(shell find $(TEST_DIR) -type f -name *.py)
OUT_FILES := $(patsubst $(SRC_DIR)/%.py,$(OUT_DIR)/%.py,$(SRC_FILES))

all: lint copy

copy: $(OUT_FILES)

lint: .lint

test: copy
	@PYTHONPATH=$(OUT_DIR) python -m unittest discover -v --start $(TEST_DIR) --pattern *.py

clean:
	rm -rf $(OUT_DIR)

.PHONY: copy test lint

$(OUT_DIR):
	mkdir -pv $@

.lint: $(SRC_FILES) $(TEST_FILES)
	@mkdir -pv `dirname $@`
	pycodestyle --max-line-length=110 --show-source --show-pep8 --count $?
	pylint --disable=missing-docstring,too-few-public-methods --errors-only $?
	@date > $@

$(OUT_DIR)/%.py: $(SRC_DIR)/%.py $(OUT_DIR)
	@mkdir -pv `dirname $@`
	@cp -v $< $@
