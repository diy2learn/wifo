.PHONY: auth_url

REPO_URL:=https://github.com/diy2learn/your_repo_name.git_template
# run: make REPO_URL=your_https_git_link init_git
# GITHUBPAT: required environment variable

#============CI services=================
PKG=wifo

HOST=127.0.0.1

TEST_PATH=./tests/

SRC_PATH=./$(PKG)

ENVIRON=prod


# ----------------- shortcuts for jenkins pipeline -------------------------- #

install-sdist:sdist

	pip install dist/*.tar.gz

	install-bdist: bdist

	pip install dist/*.whl

sdist:

	python setup.py sdist

bdist:

	python setup.py bdist_wheel

publish: bdist

	twine upload -r $(ENVIRON) dist/*.whl

lint:

	python setup.py flake8

test: clean-pyc clean-pycache

	tox

doc:

	cp NEWS.rst docs/

	python setup.py build_sphinx

# -------------------- shortcuts for local dev ----------------------------- #

venv:

	python -V

	python -m venv venv

clean-pyc:

	find . -name '*.pyc' -exec rm --force {} +

	find . -name '*.pyo' -exec rm --force {} +

clean-build:

	rm --force --recursive build/

	rm --force --recursive dist/

	rm --force --recursive *.egg-info

clean-pycache:

	find . -name __pycache__ -delete

clean: clean-pyc clean-build clean-pycache


install-deps:

	pip install -r requirements.txt

install: install-deps

	pip install . --no-dependencies

develop: install-deps

	pip install -e . --no-dependencies

isort:

	sh -c "isort --skip-glob=.tox --recursive ."

format: isort

	black --line-length 120 .

test-integration:

	pytest --ignore=tests --capture=no --no-cov tests/integration

jenkins: lint test bdist sdist clean


#===========Implementation of repo initializationt============
check-%:
	@:$(if $(value $*),,$(error $* is undefined))

check_url-%:
	@export $*=$(value $*); \
	if ! [[ $$REPO_URL =~ ^https://.+git$$ ]]; then \
		echo " $* is non conform: $(value $*)"; \
		exit 1; \
	fi


auth_url:| check-GITHUBPAT check_url-REPO_URL
	@export REPO_URL=$(REPO_URL); \
	PAT_URL="$${REPO_URL:0:8}$(GITHUBPAT)@$${REPO_URL:8}"; \
	echo PAT_URL is $$PAT_URL  

init_git: check-GITHUBPAT check_url-REPO_URL
	@export REPO_URL=$(REPO_URL); \
	export PAT_URL="$${REPO_URL:0:8}$(GITHUBPAT)@$${REPO_URL:8}"; \
	echo PAT_URL is $$PAT_URL; \
	if ! git rev-parse --is-inside-work-tree; then \
		git init && \
		git add . && \
		git commit -m "init repo from template" && \
		git remote add origin $$PAT_URL && \
		git push -f origin master; \
	else \
		echo "git initialized. skip"; \
	fi
refs:
	@echo func to check input var: https://stackoverflow.com/questions/10858261/abort-makefile-if-variable-not-set

