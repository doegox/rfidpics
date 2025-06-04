JS_DIR = js
CSS_DIR = css

JS_MIN = $(JS_DIR)/scripts.min.js
CSS_MIN = $(CSS_DIR)/styles.min.css

JS_MIN_FILES := $(sort $(patsubst %.js, %.min.js, $(filter-out %.min.js, $(wildcard $(JS_DIR)/*.js))))
CSS_MIN_FILES := $(sort $(patsubst %.css, %.min.css, $(filter-out %.min.css, $(wildcard $(CSS_DIR)/*.css))))

JS_COMPILER := java -jar bin/closure-compiler.jar --warning_level QUIET
CSS_COMPILER := java -jar bin/yui-compressor.jar --type css

DEBUG ?= 0

.PHONY: all clean

all: $(JS_MIN) $(CSS_MIN)

ifeq ($(DEBUG),0)
%.min.js: %.js
	@echo "    JS     " $@
	@$(JS_COMPILER) --js $< --js_output_file $@
else
%.min.js: %.js
	@echo "    JS     " $@
	@cat $< > $@
endif

%.min.css: %.css
	@echo "    CSS    " $@
	@$(CSS_COMPILER) -o $@ $<

$(JS_MIN): $(JS_MIN_FILES)
	@echo "    CAT    " $@
	@cat $^ > $@

$(CSS_MIN): $(CSS_MIN_FILES)
	@echo "    CAT    " $@
	@cat $^ > $@

clean:
	@echo "    RM     " $(JS_MIN) $(JS_MIN_FILES) $(CSS_MIN) $(CSS_MIN_FILES)
	@rm -fv $(JS_MIN) $(JS_MIN_FILES) $(CSS_MIN) $(CSS_MIN_FILES)
