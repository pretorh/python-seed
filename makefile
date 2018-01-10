SRC_DIR   := ./src
OUT_DIR   := ./out
SRC_FILES := $(shell find ./src -type f -name *.py)
OUT_FILES := $(patsubst $(SRC_DIR)/%.py,$(OUT_DIR)/%.py,$(SRC_FILES))

all: copy

copy: $(OUT_FILES)

test: copy
	python -m unittest discover --start $(OUT_DIR)/test --pattern *.py

clean:
	rm -rf $(OUT_DIR)

.PHONY: copy test

$(OUT_DIR):
	mkdir -pv $@

$(OUT_DIR)/%.py: $(SRC_DIR)/%.py $(OUT_DIR)
	@mkdir -pv `dirname $@`
	pycodestyle --max-line-length=110 --show-source --show-pep8 --count $<
	pylint --disable=missing-docstring,too-few-public-methods --errors-only $<
	@cp -v $< $@
