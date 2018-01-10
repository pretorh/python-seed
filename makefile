SRC_DIR   := ./src
OUT_DIR   := ./out
SRC_FILES := $(shell find ./src -type f -name *.py)
OUT_FILES := $(patsubst $(SRC_DIR)/%.py,$(OUT_DIR)/%.py,$(SRC_FILES))

all: lint copy

copy: $(OUT_FILES)

lint: $(OUT_DIR)/lint

test: copy
	@PYTHONPATH=$(OUT_DIR)/app python -m unittest discover -v --start $(OUT_DIR)/test --pattern *.py

clean:
	rm -rf $(OUT_DIR)

.PHONY: copy test pycodestyle pylint

$(OUT_DIR):
	mkdir -pv $@

$(OUT_DIR)/lint: $(SRC_FILES)
	@mkdir -pv `dirname $@`
	pycodestyle --max-line-length=110 --show-source --show-pep8 --count $?
	pylint --disable=missing-docstring,too-few-public-methods --errors-only $?
	@touch $@

$(OUT_DIR)/%.py: $(SRC_DIR)/%.py $(OUT_DIR)
	@mkdir -pv `dirname $@`
	@cp -v $< $@
