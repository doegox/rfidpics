JS_DIR = js
CSS_DIR = css

JS_MIN = $(JS_DIR)/scripts.min.js
CSS_MIN = $(CSS_DIR)/styles.min.css

JS_MIN_FILES := $(sort $(patsubst %.js, %.min.js, $(filter-out %.min.js, $(wildcard $(JS_DIR)/*.js))))
CSS_MIN_FILES := $(sort $(patsubst %.css, %.min.css, $(filter-out %.min.css, $(wildcard $(CSS_DIR)/*.css))))

JS_COMPILER := java -jar bin/closure-compiler.jar --warning_level QUIET
CSS_COMPILER := java -jar bin/yui-compressor.jar --type css

DEBUG ?= 0

.PHONY: all deploy clean

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

include ../deployment-config.mk

SSH_OPTS := -q -o ControlMaster=auto -o ControlPath=.ssh-deployment.sock

deploy: all
	@echo "    SSH     $(WEB_SERVER)"
	@ssh $(SSH_OPTS) -Nf $(WEB_SERVER)
	
	@echo "    RSYNC   . $(WEB_SERVER):$(HTDOCS_PATH)"
	@ssh -t $(SSH_OPTS) $(WEB_SERVER) "sudo -u $(HTDOCS_USER) -v"
	@rsync -aizm --delete-excluded --exclude=.ssh-deployment.sock --exclude=Makefile --exclude=*.swp \
		--exclude=bin/ --include=scripts.min.js --include=styles.min.css \
		--exclude=*.js --exclude=*.css --rsh="ssh $(SSH_OPTS)" \
		--rsync-path="sudo -n -u $(HTDOCS_USER) rsync" \
		. "$(WEB_SERVER):$(HTDOCS_PATH)" 
	
	@echo "    CHOWN   $(HTDOCS_USER):$(HTDOCS_USER) $(WEB_SERVER):$(HTDOCS_PATH)"
	@ssh -t $(SSH_OPTS) $(WEB_SERVER) "sudo chown -R $(HTDOCS_USER):$(HTDOCS_USER) '$(HTDOCS_PATH)'"
	
	@echo "    CHMOD   750/640 $(WEB_SERVER):$(HTDOCS_PATH)"
	@ssh -t $(SSH_OPTS) $(WEB_SERVER) "sudo find '$(HTDOCS_PATH)' -type f -exec chmod 640 {} \;; \
					sudo find '$(HTDOCS_PATH)' -type d -exec chmod 750 {} \;;"
	
	@echo "    SSH     $(WEB_SERVER)"
	@ssh -O exit $(SSH_OPTS) $(WEB_SERVER)
